//
//  NewsModel.swift
//  ZhiHuDaily
//
//  Created by 夏名 on 17/3/18.
//  Copyright © 2017年 xiabob. All rights reserved.
//

import UIKit
import SwiftDate

 ///消息展示的类型
enum NewsShowType: Int {
    ///普通消息
    case normal = 0
    ///首页轮播展示的消息
    case topBanner = 1
}

class NewsModel: NSObject {
    
    //MARK: - base
    
    ///消息id
    var newsID = 0
    var title = ""
    var imageUrl = ""
    var type = 0
    var rawDate = ""
    ///消息对应的日期，格式“03月17日 星期五”
    var date = ""
    ///消息内容是否包含多张图
    var isMultipic = false
    ///消息是否被点击过
    var isRead = false
    var showType = NewsShowType.normal
    
    //MARK: - detail
    ///HTML 格式的新闻
    var body = ""
    ///图片的内容提供方
    var imageSource = ""
    ///文章浏览界面中使用的大图
    var detailImageUrl = ""
    ///供在线查看内容与分享至 SNS 用的 URL
    var shareUrl = ""
    ///供手机端使用的js内容
    var js = ""
    ///供手机端使用的css内容
    var css = ""
    ///这篇文章的推荐者
    var recommenders: [EditorModel] = []
    ///栏目的信息
    var theme = ThemeModel()
    
    //MARK: - layout
    
    // for news cell
    var newsCellHeight: CGFloat = 90
    
    
    override init() {
        super.init()
    }

    convenience init(from news: News) {
        self.init()
        update(from: news)
    }
    
    func update(from news: News) {
        //basic
        newsID = news.newsID
        title  = news.title
        imageUrl = news.imageUrl
        type     = news.type
        rawDate  = news.date
        date     = getProcessedDate(dateString: news.date)
        isMultipic = news.isMultipic
        isRead = news.isRead
        showType = NewsShowType(rawValue: news.showType) ?? .normal
        
        //detail
        body = news.body
        imageSource = news.imageSource
        detailImageUrl = news.detailImageUrl
        shareUrl = news.shareUrl
        js = news.js
        css = news.css
        recommenders = news.recommenders.map({ (editor) -> EditorModel in
            return EditorModel(from: editor)
        })
        theme = ThemeModel(from: news.theme)
    }
    
    ///根据existModel来更新NewsModel的内容
    func update(by existModel: NewsModel?) {
        guard let existModel = existModel else {return}
        if newsID != existModel.newsID {return}
        
        title = existModel.title.isEmpty ? title : existModel.title
        imageUrl = existModel.imageUrl.isEmpty ? imageUrl : existModel.imageUrl
        type = existModel.type < 0 ? type : existModel.type
        rawDate = existModel.rawDate.isEmpty ? rawDate : existModel.rawDate
        date = existModel.date.isEmpty ? date : existModel.date
        isMultipic = existModel.isMultipic
        isRead = existModel.isRead
        showType = existModel.showType.rawValue < 0 ? showType : existModel.showType
        body = existModel.body.isEmpty ? body : existModel.body
        imageSource = existModel.imageSource.isEmpty ? imageSource : existModel.imageSource
        detailImageUrl = existModel.detailImageUrl.isEmpty ? detailImageUrl : existModel.detailImageUrl
        shareUrl = existModel.shareUrl.isEmpty ? shareUrl : existModel.shareUrl
        js = existModel.js.isEmpty ? js : existModel.js
        css = existModel.css.isEmpty ? css : existModel.css
        recommenders = existModel.recommenders
        theme = existModel.theme
    }
    
    fileprivate func getProcessedDate(dateString: String) -> String {
        var resultDate = Date()
        do {
            let date = try dateString.date(format: .custom("yyyyMMdd"))
            resultDate = date.absoluteDate
        } catch {}
        
        //03月17日 星期五
        return "\(resultDate.month)月\(resultDate.day)日 \(resultDate.weekdayName)"
        
    }
}

