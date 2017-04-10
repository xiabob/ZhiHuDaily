//
//  XBAPILocalCache.swift
//  XBAPIBaseManager_swift
//
//  Created by xiabob on 17/4/6.
//  Copyright © 2017年 xiabob. All rights reserved.
//

import Foundation


protocol XBAPILocalCache: NSObjectProtocol {
    ///将数据缓存到本地，key是请求的url
    func saveDataToLocal(for key: String, data: Data)
    ///从本地加载缓存数据，key是请求的url
    func getDataFromLocal(from key: String) -> Data?
    ///清除本地缓存
    func clearLocalCache()
}

extension XBAPILocalCache {
    func saveDataToLocal(for key: String, data: Data){}
    func clearLocalCache(){}
}


private var kXBLocalUserDefaultsName = "com.xiabob.apiManager.localCache"
private var kXBDefaultMaxLocalDataCount = 500

class XBAPIDefaultLocalCache: NSObject, XBAPILocalCache {
    static let shared = XBAPIDefaultLocalCache()
    private override init() {super.init()}

    fileprivate lazy var userDefaults: UserDefaults? = { //用于缓存到本地
        let userDefaults = UserDefaults(suiteName: kXBLocalUserDefaultsName)
        if userDefaults?.dictionaryRepresentation().keys.count ?? 0 > kXBDefaultMaxLocalDataCount {
            userDefaults?.removePersistentDomain(forName: kXBLocalUserDefaultsName)
        }
        return userDefaults
    }()
    
    func saveDataToLocal(for key: String, data: Data) {
        userDefaults?.set(data, forKey: key)
        userDefaults?.synchronize()
    }
    
    func getDataFromLocal(from key: String) -> Data? {
        return userDefaults?.object(forKey: key) as? Data
    }
    
    func clearLocalCache() {
        userDefaults?.removePersistentDomain(forName: kXBLocalUserDefaultsName)
    }
}
