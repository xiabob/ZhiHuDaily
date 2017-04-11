//
//  Editor.swift
//  ZhiHuDaily
//
//  Created by xiabob on 17/3/22.
//  Copyright © 2017年 xiabob. All rights reserved.
//

import UIKit
import RealmSwift
import Realm
import SwiftyJSON

///编辑，一般都是新闻的推荐者
class Editor: Object, RLMObjectHelperProtocol {
//    url : 主编的知乎用户主页
//    bio : 主编的个人简介
//    id : 数据库中的唯一表示符
//    avatar : 主编的头像
//    name : 主编的姓名
    
    ///用户id
    dynamic var editorID = 0
    ///用户名
    dynamic var name = ""
    ///用户头像url字符串
    dynamic var avatar = ""
    ///个人简介
    dynamic var bio = ""
    ///知乎用户主页url
    dynamic var zhihuUrl = ""
    
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
extension Editor {
    override class func primaryKey() -> String? {
        return "editorID"
    }
}


extension Editor {
    convenience init(from editorDic: JSON) {
        self.init()
        editorID = editorDic["id"].intValue
    }
    
    
    func update(from editorDic: JSON) {
//        url: "http://www.zhihu.com/people/wezeit",
//        bio: "微在 Wezeit 主编",
//        id: 70,
//        avatar: "http://pic4.zhimg.com/068311926_m.jpg",
//        name: "益康糯米"
        zhihuUrl = editorDic["url"].stringValue
        bio = editorDic["bio"].stringValue
        avatar = editorDic["avatar"].stringValue
        name = editorDic["name"].stringValue
    }
    
}
