//
//  Theme.swift
//  ZhiHuDaily
//
//  Created by xiabob on 17/3/22.
//  Copyright © 2017年 xiabob. All rights reserved.
//

import UIKit
import RealmSwift

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
}


//MARK: - Realm
extension Theme {
    override class func primaryKey() -> String? {
        return "themeID"
    }
}
