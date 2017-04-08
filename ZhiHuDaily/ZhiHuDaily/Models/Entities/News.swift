//
//  News.swift
//  ZhiHuDaily
//
//  Created by 夏名 on 17/3/17.
//  Copyright © 2017年 xiabob. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift
import Realm

class News: Object, RLMObjectHelperProtocol {
    //baisc
    
    ///消息id
    dynamic var newsID = 0
    ///标题
    dynamic var title = ""
    ///列表中展示的图片
    dynamic var imageUrl = ""
    dynamic var type = 0
    ///消息对应的日期，格式“20170318”
    dynamic var date = ""
    ///消息内容是否包含多张图
    dynamic var isMultipic = false
    ///消息是否被点击过
    dynamic var isRead = false
    ///消息展示的类型，0表示普通消息，1表示是首页轮播展示的消息
    dynamic var showType = 0
    
    //detail var
    
    ///HTML 格式的新闻
    dynamic var body = ""
    ///图片的内容提供方
    dynamic var imageSource = ""
    ///文章浏览界面中使用的大图
    dynamic var detailImageUrl = ""
    ///供在线查看内容与分享至 SNS 用的 URL
    dynamic var shareUrl = ""
    ///供手机端使用的js内容
    dynamic var js = ""
    ///供手机端使用的css内容
    dynamic var css = ""
    ///这篇文章的推荐者，原始字符串信息
    dynamic var recommenders = ""
    ///栏目的信息，原始字符串信息
    dynamic var theme = ""
    
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
extension News {
    override class func primaryKey() -> String? {
        return "newsID"
    }
    
    override static func ignoredProperties() -> [String] {
        //设置为临时属性
        return ["recommenders", "theme"]
    }
    
    class func fetchNews(from realm: Realm, withDate date: String) -> [News] {
        return getEntities(from: realm, withPredicate: NSPredicate(format: "date = %@", date), using: [SortDescriptor(keyPath: "newsID", ascending: false)])
//        return getEntities(from: realm, withPredicate: NSPredicate(format: "date = %@", date))
    }
}


//MARK: - normal news
extension News {
    ///初始化普通消息
    convenience init(from normalNewsDic: JSON, dateString: String) {
        self.init()
        //主键不能重复设置
        newsID = normalNewsDic["id"].intValue
        update(from: normalNewsDic, dateString: dateString)
    }
    
    func update(from normalNewsDic: JSON, dateString: String) {
//        "title": "江南春天的野菜，比肉还好吃",
//        "ga_prefix": "031811",
//        "images": ["https:\/\/pic4.zhimg.com\/v2-9c84eed31774aaf43a987963fcd959cb.jpg"],
//        "multipic": true,
//        "type": 0,
//        "id": 9293223
        
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
        newsID = topNewsDic["id"].intValue
        update(from: topNewsDic)
    }
    
    func update(from topNewsDic: JSON) {
//        "image": "https:\/\/pic4.zhimg.com\/v2-c1e691ec67f95d372b87c0afbdc7bde3.jpg",
//        "type": 0,
//        "id": 9288368,
//        "ga_prefix": "031810",
//        "title": "中国有哪些好看的科幻小说选集？"
        
        title = topNewsDic["title"].stringValue
        imageUrl = topNewsDic["image"].stringValue
        type = topNewsDic["type"].intValue
        date = ""
        isMultipic = false
        showType = 1
    }
}


//MARK: - news detail

extension News {
    convenience init(detailNewsDic: JSON) {
        self.init()
        newsID = detailNewsDic["id"].intValue
        update(detailNewsDic: detailNewsDic)
    }
    
    func update(detailNewsDic: JSON) {
//        body: "<div class="main-wrap content-wrap">...</div>",
//        image_source: "Yestone.com 版权图片库",
//        title: "深夜惊奇 · 朋友圈错觉",
//        image: "http://pic3.zhimg.com/2d41a1d1ebf37fb699795e78db76b5c2.jpg",
//        share_url: "http://daily.zhihu.com/story/4772126",
//        js: [ ],
//        recommenders": [
//        { "avatar": "http://pic2.zhimg.com/fcb7039c1_m.jpg" },
//        { "avatar": "http://pic1.zhimg.com/29191527c_m.jpg" },
//        { "avatar": "http://pic4.zhimg.com/e6637a38d22475432c76e6c9e46336fb_m.jpg" },
//        { "avatar": "http://pic1.zhimg.com/bd751e76463e94aa10c7ed2529738314_m.jpg" },
//        { "avatar": "http://pic1.zhimg.com/4766e0648_m.jpg" }
//        ],
//        ga_prefix: "050615",
//        section": {
//        "thumbnail": "http://pic4.zhimg.com/6a1ddebda9e8899811c4c169b92c35b3.jpg",
//        "id": 1,
//        "name": "深夜惊奇"
//    },
//    type: 0,
//    id: 4772126,
//    css: [
//    "http://news.at.zhihu.com/css/news_qa.auto.css?v=1edab"
//    ]
        isRead = true
        
        body = detailNewsDic["body"].stringValue
        imageSource = detailNewsDic["image_source"].stringValue
        title = detailNewsDic["title"].stringValue
        detailImageUrl = detailNewsDic["image"].stringValue
        shareUrl = detailNewsDic["share_url"].stringValue
        js = detailNewsDic["js"].arrayValue.map({ (value) -> String in
            return value.stringValue
        }).first ?? ""
        
        let recommenderArray = detailNewsDic["recommenders"].arrayValue.map({ (value) -> String in
            return value["avatar"].stringValue
        })
        recommenders = NSArray(array: recommenderArray).jsonRepresentation() ?? ""
        
        if let themeDic = detailNewsDic["section"].dictionaryObject {
            theme = NSDictionary(dictionary: themeDic).jsonRepresentation() ?? ""
        }
        
        type = detailNewsDic["type"].intValue
        
        css = detailNewsDic["css"].arrayValue.map({ (value) -> String in
            return value.stringValue
        }).first ?? ""
    }
}
