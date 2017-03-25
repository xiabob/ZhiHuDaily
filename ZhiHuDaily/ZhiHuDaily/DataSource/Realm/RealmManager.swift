//
//  RealmManager.swift
//  ZhiHuDaily
//
//  Created by xiabob on 17/3/25.
//  Copyright © 2017年 xiabob. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class RealmManager: NSObject {
    
    lazy var defaultConfiguration: RLMRealmConfiguration = {
        let config: RLMRealmConfiguration = RLMRealmConfiguration.default()
        // 使用默认的目录，但是使用用户名来替换默认的文件名
        let pathComponent = "ZhiHuDaily"
        config.fileURL = config.fileURL?.deletingLastPathComponent().appendingPathComponent(pathComponent).appendingPathExtension("realm")
        return config
    }()
    
    ///创建当前线程环境下的RLMRealm对象
    var defaultRealm: RLMRealm? {
        do {
            let realm = try RLMRealm(configuration: self.defaultConfiguration)
            return realm
        } catch {
            return nil
        }
        
    }
    
    var defaultQueue = DispatchQueue(label: "com.midea.realm", attributes: DispatchQueue.Attributes.concurrent)

}
