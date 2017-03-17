//
//  XBAPIBaseManager.swift
//  XBAPIBaseManager_swift
//
//  Created by xiabob on 16/9/6.
//  Copyright © 2016年 xiabob. All rights reserved.
//

import Foundation
import Alamofire

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


//MARK: - XBAPIManagerDataSource

public protocol XBAPIManagerDataSource: NSObjectProtocol {
    ///你可以在这里设置请求的参数，一旦设置，就会以它为准
    func parametersForApi(_ api: XBAPIBaseManager) -> [String: AnyObject]?
    ///用于判断请求参数是否符合要求，默认情况下它是true，你不需要处理
    func isValidParameters(_ api: XBAPIBaseManager) -> Bool
}

extension XBAPIManagerDataSource {
    func isValidParameters(_ api: XBAPIBaseManager) -> Bool {return true}
}


//MARK: - XBAPIManagerCallBackDelegate

/**
 *  接口请求结束回调协议
 */
public protocol XBAPIManagerCallBackDelegate: NSObjectProtocol {
    func onManagerCallApiSuccess(_ manager: XBAPIBaseManager)
    func onManagerCallApiFailed(_ manager: XBAPIBaseManager)
    func onManagerCallCancled(_ manager: XBAPIBaseManager)
}


public typealias CompletionHandler = (_ manager: XBAPIBaseManager) -> Void

private var kXBLocalUserDefaultsName = "com.xiabob.apiManager.localCache"
private var kXBDefaultMaxLocalDataCount = 500

//MARK: - XBAPIBaseManager
open class XBAPIBaseManager: NSObject {
    //MARK: - Properties
    open weak var delegate: XBAPIManagerCallBackDelegate? //回调delegate
    open weak var dataSource: XBAPIManagerDataSource?     //dataSource
    
    open var errorCode = Error() //错误码
    open var rawResponseString: String? //返回的原始字符串数据
    open var requestUrlString = "" //接口请求的url字符串
    open var timeout: Double = 15 { //每个接口可以单独设置超时时间，默认是15秒
        didSet {
            manager.session.configuration.timeoutIntervalForRequest = timeout
        }
    }
    
    
    fileprivate weak var apiManager: ManagerProtocol? //遵循ManagerProtocol的子类
    fileprivate lazy var manager: SessionManager = { //Manager对象实例，执行具体的网络请求工作
        //https://objccn.io/issue-5-4/
        let manager: SessionManager = SessionManager.default
        let _ = manager.session.configuration.httpAdditionalHeaders?.updateValue("application/json; charset=UTF-8", forKey: "Accept")
        let _ = manager.session.configuration.httpAdditionalHeaders?.updateValue("application/json; charset=UTF-8", forKey: "Content-Type")
        manager.session.configuration.timeoutIntervalForRequest = self.timeout
        return manager
    }()
    fileprivate var taskTable = Dictionary<String, URLSessionTask>() //请求表
    fileprivate var currentRequest: Request? //当前请求
    fileprivate var completionHandler: CompletionHandler? //请求结束回调closure对象
    fileprivate lazy var userDefaults: UserDefaults? = { //用于缓存到本地
        let userDefaults = UserDefaults(suiteName: kXBLocalUserDefaultsName)
        if userDefaults?.dictionaryRepresentation().keys.count > kXBDefaultMaxLocalDataCount {
            userDefaults?.removePersistentDomain(forName: kXBLocalUserDefaultsName)
        }
        return userDefaults
    }()
    
    fileprivate var parseQueue = DispatchQueue(label: "com.xiabob.apiManager.parseData", attributes: DispatchQueue.Attributes.concurrent)
    
    //MARK: -  lifecycle
    override init() {
        super.init()
        
        if self is ManagerProtocol {
            self.apiManager = self as? ManagerProtocol
            if let apiManager = apiManager {
                requestUrlString = apiManager.baseUrl + apiManager.path
            }
        } else {
            fatalError("child class must confirm ManagerProtocol!")
        }
    }
    
    convenience init(delegate: XBAPIManagerCallBackDelegate) {
        self.init()
        self.delegate = delegate
    }
    
    deinit {
        cancleRequests()
    }
    
    //MARK: - load data
    
    open func loadData() {
        executeHttpRequest()
    }
    
    open func loadData(_ completionHandler: @escaping CompletionHandler) {
        self.completionHandler = completionHandler
        loadData()
    }
    
    open func loadDataFromLocal() {
        guard let apiManager = apiManager else {return}
        if apiManager.shouldCache {
            guard let data = getDataFromLocal() else {return callOnManagerCallApiSuccess()} //只是没有数据
            handleRespnseData(data)
        } else {
            errorCode.code = .loadLocalError
            callOnManagerCallApiFailed()
        }
    }
    
    open func loadDataFromLocal(_ completionHandler: @escaping CompletionHandler) {
        self.completionHandler = completionHandler
        loadDataFromLocal()
    }
    
    //MARK: - cancle operation
    
    open func cancleRequests() {
        for request in taskTable.values {
            request.cancel()
        }
        taskTable.removeAll()
    }
    
    open func cancleCurrentRequest() {
        if let currentRequest = currentRequest  {
            currentRequest.cancel()
            taskTable.removeValue(forKey: String(describing: currentRequest.task?.taskIdentifier))
        }
    }
    
    //MARK: - private method
    fileprivate func executeHttpRequest() {
        guard let apiManager = apiManager else {return}
        //dataSource中设置参数其优先级更高
        let parameters = dataSource?.parametersForApi(self) ?? apiManager.parameters
        //判断设置的参数是否是有效地，没有dataSource或者没设置isValidParameters方法，默认都是有效地参数
        if (dataSource?.isValidParameters(self) ?? true) == false {
            return onParametersIsError()
        }
        
        //转换为Alamofire的method
        let method = getMethod(apiManager.requestType)
        
        currentRequest = manager.request(requestUrlString,
                        method: method,
                        parameters: parameters,
                        encoding: URLEncoding.default,
                        headers: nil).responseData(completionHandler: { (response: DataResponse<Data>) in
            self.taskTable.removeValue(forKey: String(describing: self.currentRequest?.task?.taskIdentifier))
            
            if let data = response.result.value {
                if apiManager.shouldCache {self.saveDataToLocal(data)}
                self.handleRespnseData(data)
            } else {
                var thisError: NSError?
                if let error = response.result.error {
                    thisError = error as NSError
                    debugPrint(error)
                }
                self.handleError(thisError)
            }
        })
        
        taskTable.updateValue(currentRequest!.task!, forKey: String(describing: currentRequest?.task?.taskIdentifier))
    }
    
    fileprivate func handleRespnseData(_ data: Data) {
        guard let apiManager = apiManager else {return}
        
        rawResponseString = String(data: data, encoding: String.Encoding.utf8)
        
        var result: AnyObject = data as AnyObject
        if apiManager.isJsonData {
            do {
                result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            } catch {
                return onParseDataFail() //json数据解析出错
            }
        }
        
        parseQueue.async {
            //子线程中解析
            apiManager.parseResponseData(result)
            DispatchQueue.main.async(execute: { //解析完成，回到主线程
                self.onCompleteParseData()
            })
        }
    }
    
    fileprivate func handleError(_ error: NSError?) {
        //取消请求特殊处理
        if error?.code == NSURLErrorCancelled {
            errorCode.code = .cancle
            return callOnManagerCallCancled()
        }
        
        if error?.code >= 500 && error?.code < 600 {
            errorCode.code = .serverError
            errorCode.message = error?.description
        } else if error?.code == -1004 {
            errorCode.code = .noNetWork
            errorCode.message = "无法连接到服务器"
        } else if error?.code == -1009 {
            errorCode.code = .noNetWork
            errorCode.message = "网络异常"
        } else {
            errorCode.code = .httpError
            errorCode.message = error?.description
        }
        callOnManagerCallApiFailed()
    }
    
    fileprivate func getMethod(_ requestType: RequestType) -> HTTPMethod {
        switch requestType {
        case .get:
            return .get
        case .post:
            return .post
        }
    }
    
    //MARK: - local cache
    
    fileprivate func saveDataToLocal(_ data: Data) {
        userDefaults?.set(data, forKey: requestUrlString)
        userDefaults?.synchronize()
    }
    
    fileprivate func getDataFromLocal() -> Data? {
        return userDefaults?.object(forKey: requestUrlString) as? Data
    }
    
    open func deleteLocalCache() {
        userDefaults?.removePersistentDomain(forName: kXBLocalUserDefaultsName)
    }
    
    //MARK:- 接口解析结束回调
    
    fileprivate func onCompleteParseData() {
        if errorCode.code == .success {
            callOnManagerCallApiSuccess()
        } else {
            callOnManagerCallApiFailed()
        }
    }
    
    fileprivate func onParseDataFail() {
        errorCode.code = .parseError
        errorCode.message = "解析json数据出错"
        callOnManagerCallApiFailed()
    }
    
    fileprivate func onParametersIsError() {
        errorCode.code = .parametersError
        errorCode.message = "请求的参数出错"
        callOnManagerCallApiFailed()
    }
    
    fileprivate func callOnManagerCallApiSuccess() {
        delegate?.onManagerCallApiSuccess(self)
        if let completionHandler = completionHandler {
            completionHandler(self)
        }
    }
    
    fileprivate func callOnManagerCallApiFailed() {
        delegate?.onManagerCallApiFailed(self)
        if let completionHandler = completionHandler {
            completionHandler(self)
        }
    }
    
    fileprivate func callOnManagerCallCancled() {
        delegate?.onManagerCallCancled(self)
        if let completionHandler = completionHandler {
            completionHandler(self)
        }
    }
}
