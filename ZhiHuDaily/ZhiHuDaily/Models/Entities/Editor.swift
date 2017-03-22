//
//  Editor.swift
//  ZhiHuDaily
//
//  Created by xiabob on 17/3/22.
//  Copyright © 2017年 xiabob. All rights reserved.
//

import UIKit

///编辑，一般都是新闻的推荐者
class Editor: NSObject {
//    url : 主编的知乎用户主页
//    bio : 主编的个人简介
//    id : 数据库中的唯一表示符
//    avatar : 主编的头像
//    name : 主编的姓名
    
    ///用户id
    var editorID = 0
    ///用户名
    var name = ""
    ///用户头像url字符串
    var avatar = ""
    ///个人简介
    var bio = ""
    ///知乎用户主页url
    var zhihuUrl = ""
}
