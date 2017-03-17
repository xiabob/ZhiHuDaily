//
//  XBAPIManagerProtocol.swift
//  XBAPIBaseManager_swift
//
//  Created by xiabob on 16/9/6.
//  Copyright © 2016年 xiabob. All rights reserved.
//

import Foundation

public enum RequestType: String {
    case get, post
}

public protocol ManagerProtocol: NSObjectProtocol {
    /// 比如https://itunes.apple.com部分
    var baseUrl: String {get}
    /// 比如/look部分
    var path: String {get}
    /// 请求的参数
    var parameters: [String: AnyObject]? {get}
    /// 接口请求的类型，GET、POST等
    var requestType: RequestType {get}
    /// 接口返回的是否是json数据，默认情况下是true
    var isJsonData: Bool {get}
    /// 是否将接口返回的数据缓存到本地，默认是false，不缓存
    var shouldCache: Bool {get}
    
    /**
     具体的解析操作是放在这里
     
     - parameter data: 接口请求返回的结果
     */
    func parseResponseData(_ data: AnyObject)
}

//默认实现
public extension ManagerProtocol {
    var baseUrl: String {return ""} //对于具体的APP而言，这个值一般是固定的
    var parameters: [String: AnyObject]? {return nil} //参数可有可无
    var requestType: RequestType {return .get} //默认是GET请求方式
    var isJsonData: Bool {return true} //默认是json数据
    var shouldCache: Bool {return false}
    
    func parseResponseData(_ data: AnyObject) { debugPrint("subclass not implement parseResponseData method, you should do this at other place") } //甚至解析操作都可以延后至其他地方（比如vc中）
}
