//
//  RealmManager.swift
//  ZhiHuDaily
//
//  Created by xiabob on 17/3/25.
//  Copyright © 2017年 xiabob. All rights reserved.
//

import UIKit
import RealmSwift

//https://realm.io/cn/docs/swift/latest/
class RealmManager: NSObject {
    
    static let shared = RealmManager()
    fileprivate override init() {}
    
    fileprivate lazy var defaultConfiguration: Realm.Configuration = {
        //在默认的数据库配置基础上修改，得到新的配置，如果你需要修改默认的配置，你还需要手动设置“Realm.Configuration.defaultConfiguration = config”
        var config = Realm.Configuration.defaultConfiguration
        // 修改realm文件的地址，使用默认的目录，但是使用ZhiHuDaily来替换默认的文件名
        let pathComponent = "ZhiHuDaily"
        config.fileURL = config.fileURL?.deletingLastPathComponent().appendingPathComponent(pathComponent).appendingPathExtension("realm")
        
        //修改schemaVersion、migrationBlock，用于数据库迁移操作
        config.schemaVersion = 1
        config.migrationBlock = { (migration, oldSchemaVersion) in
            if (oldSchemaVersion < 1) {
                //什么都不要做！Realm 会自行检测新增和需要移除的属性，然后自动更新硬盘上的数据库架构
                //当然你可以在这里设置新添加的属性（如果有的话）的值
            }
        }
        
        return config
    }()
    
    ///创建当前线程环境下的RLMRealm对象
    var defaultRealm: Realm? {
        do {
            let realm = try Realm(configuration: defaultConfiguration)
            return realm
        } catch {
            return nil
        }
        
    }
    
    var defaultQueue = DispatchQueue(label: "com.ZhiHuDaily.realm", attributes: .concurrent)

}
