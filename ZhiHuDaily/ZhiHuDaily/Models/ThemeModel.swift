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
    
    ///颜色，作用未知
    var themeColor = 0
    
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
        themeDescription = theme.themeDescription
        themeColor = theme.themeColor
    }
}
