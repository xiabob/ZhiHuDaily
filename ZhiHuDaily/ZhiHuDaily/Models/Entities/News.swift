//
//  News.swift
//  ZhiHuDaily
//
//  Created by 夏名 on 17/3/17.
//  Copyright © 2017年 xiabob. All rights reserved.
//

import UIKit
import SwiftyJSON

class News: NSObject {
    ///消息id
    var newsID = 0
    var title = ""
    var imageUrl = ""
    var type = 0
    ///消息对应的日期，格式“20170318”
    var date = ""
    ///消息内容是否包含多张图
    var isMultipic = false
    ///消息是否被点击过
    var isRead = false
    ///消息展示的类型，0表示普通消息，1表示是首页轮播展示的消息
    var showType = 0
    
    override init() {
        super.init()
    }
}


//MARK: - normal news
extension News {
    ///初始化普通消息
    convenience init(from normalNewsDic: JSON, dateString: String) {
        self.init()
        update(from: normalNewsDic, dateString: dateString)
    }
    
    func update(from normalNewsDic: JSON, dateString: String) {
//        "title": "江南春天的野菜，比肉还好吃",
//        "ga_prefix": "031811",
//        "images": ["https:\/\/pic4.zhimg.com\/v2-9c84eed31774aaf43a987963fcd959cb.jpg"],
//        "multipic": true,
//        "type": 0,
//        "id": 9293223
        
        newsID = normalNewsDic["id"].intValue
        title = normalNewsDic["title"].stringValue
        imageUrl = normalNewsDic["images"].arrayValue.map({ (value) -> String in
            return value.stringValue
        }).first ?? ""
        type = normalNewsDic["type"].intValue
        date = dateString
        isMultipic = normalNewsDic["multipic"].boolValue
        showType = 0
    }
}


//MARK: - top banner news
extension News {
    ///初始化首页banner消息
    convenience init(from topNewsDic: JSON) {
        self.init()
        update(from: topNewsDic)
    }
    
    func update(from topNewsDic: JSON) {
//        "image": "https:\/\/pic4.zhimg.com\/v2-c1e691ec67f95d372b87c0afbdc7bde3.jpg",
//        "type": 0,
//        "id": 9288368,
//        "ga_prefix": "031810",
//        "title": "中国有哪些好看的科幻小说选集？"
        
        newsID = topNewsDic["id"].intValue
        title = topNewsDic["title"].stringValue
        imageUrl = topNewsDic["image"].stringValue
        type = topNewsDic["type"].intValue
        date = ""
        isMultipic = false
        showType = 1
    }
}
