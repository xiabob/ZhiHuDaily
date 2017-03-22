//
//  EditorModel.swift
//  ZhiHuDaily
//
//  Created by xiabob on 17/3/22.
//  Copyright © 2017年 xiabob. All rights reserved.
//

import UIKit

class EditorModel: NSObject {
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
    
    init(from editor: Editor) {
        super.init()
        update(from: editor)
    }
    
    func update(from editor: Editor) {
        editorID = editor.editorID
        name = editor.name
        avatar = editor.avatar
        bio = editor.bio
        zhihuUrl = editor.zhihuUrl
    }
}
