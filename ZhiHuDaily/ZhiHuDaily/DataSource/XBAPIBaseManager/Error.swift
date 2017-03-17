//
//  Error.swift
//  XBAPIBaseManager_swift
//
//  Created by xiabob on 16/9/6.
//  Copyright © 2016年 xiabob. All rights reserved.
//

import Foundation

public struct Error {
    public enum Code: Int {
        case success = 0 //请求成功，返回数据正确
        case fail //请求失败
        case parametersError //请求的参数错误
        case loadLocalError //加载本地缓存数据时出错
        case httpError //网络请求成功，返回出错
        case parseError //解析返回的数据出错
        case cancle //请求取消
        case timeout //请求超时
        case noNetWork //没有网络
        case serverError //服务器异常
    }
    
    /// 错误码
    public var code = Code.success
    /// 具体错误信息
    public var message: String?
    
    public init(code: Code = .success, errorMessage message: String? = nil) {
        self.code = code
        self.message = message
    }
}
