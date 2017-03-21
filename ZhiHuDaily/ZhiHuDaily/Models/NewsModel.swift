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
    
    
    //MARK: - layout
    
    var newsCellHeight: CGFloat = 90

    init(from news: News) {
        super.init()
        update(from: news)
    }
    
    func update(from news: News) {
        newsID = news.newsID
        title  = news.title
        imageUrl = news.imageUrl
        type     = news.type
        rawDate  = news.date
        date     = getProcessedDate(dateString: news.date)
        isMultipic = news.isMultipic
        isRead = news.isRead
        showType = NewsShowType(rawValue: news.showType) ?? .normal
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
