//
//  ThemeModel.swift
//  ZhiHuDaily
//
//  Created by xiabob on 17/3/22.
//  Copyright © 2017年 xiabob. All rights reserved.
//

import UIKit

class ThemeModel: NSObject {
    ///该主题日报的编号
    var themeID = 0
    
    ///供显示的主题日报名称
    var name = ""
    
    ///背景缩略图url
    var thumbnail = ""
    
    ///主题日报的介绍
    var themeDescription = ""
    
    ///该主题日报的背景图片（大图）
    var backgroundImage = ""
    
    ///颜色，作用未知
    var themeColor = 0
    
    ///是否订阅关注了该主题
    var isSubscribed = false
    
    var isSelected = false
    
    override init() {
        super.init()
    }
    
    convenience init(from theme: Theme) {
        self.init()
        update(from: theme)
    }
    
    func update(from theme: Theme) {
        themeID = theme.themeID
        name = theme.name
        thumbnail = theme.thumbnail
        backgroundImage = theme.backgroundImage
        themeDescription = theme.themeDescription
        themeColor = theme.themeColor
        isSubscribed = theme.isSubscribed
    }
    
    class func mainModel() -> ThemeModel {
        let model = ThemeModel()
        model.name = "首页"
        model.isSubscribed = true
        model.isSelected = true
        return model
    }
}
