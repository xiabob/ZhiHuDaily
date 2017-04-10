//
//  Theme.swift
//  ZhiHuDaily
//
//  Created by xiabob on 17/3/22.
//  Copyright © 2017年 xiabob. All rights reserved.
//

import UIKit
import RealmSwift
import Realm
import SwiftyJSON

/// 日报的主题
class Theme: Object, RLMObjectHelperProtocol {
//    color : 颜色，作用未知
//    thumbnail : 供显示的图片地址
//    description : 主题日报的介绍
//    id : 该主题日报的编号
//    name : 供显示的主题日报名称
    
    ///该主题日报的编号
    dynamic var themeID = 0
    
    ///供显示的主题日报名称
    dynamic var name = ""
    
    ///背景缩略图url
    dynamic var thumbnail = ""
    
    ///主题日报的介绍
    dynamic var themeDescription = ""
    
    ///颜色，作用未知
    dynamic var themeColor = 0
    
    ///是否订阅关注了该主题
    dynamic var isSubscribed = false
    
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
}


//MARK: - Realm
extension Theme {
    override class func primaryKey() -> String? {
        return "themeID"
    }
}



extension Theme {
    convenience init(from themeDic: JSON) {
        self.init()
        themeID = themeDic["id"].intValue
        update(from: themeDic)
    }
    
    func update(from themeDic: JSON) {
//        "color": 8307764,
//        "thumbnail": "http://pic4.zhimg.com/2c38a96e84b5cc8331a901920a87ea71.jpg",
//        "description": "内容由知乎用户推荐，海纳主题百万，趣味上天入地",
//        "id": 12,
//        "name": "用户推荐日报"
        
        themeColor = themeDic["color"].intValue
        thumbnail = themeDic["thumbnail"].stringValue
        themeDescription = themeDic["description"].stringValue
        name = themeDic["name"].stringValue
    }
}

