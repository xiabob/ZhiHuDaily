//
//  GetLatestNews.swift
//  ZhiHuDaily
//
//  Created by 夏名 on 17/3/18.
//  Copyright © 2017年 xiabob. All rights reserved.
//

import UIKit
import SwiftyJSON

class GetLatestNews: XBAPIBaseManager, ManagerProtocol {
    var normalNewsModel: [NewsModel] = []
    var topBannerNewsModel: [NewsModel] = []
    
    var path: String {
        return "/news/latest"
    }
    
    func parseResponseData(_ data: AnyObject) {
        let json = JSON(data)
        
        let date = json["date"].stringValue
        
        let normalStories = json["stories"].arrayValue
        var normalNews: [News] = []
        for newsDic in normalStories {
            let news = News(from: newsDic, dateString: date)
            normalNews.append(news)
        }
        normalNewsModel = normalNews.map({ (news) -> NewsModel in
            return NewsModel(from: news)
        })
        
        let topStories = json["top_stories"].arrayValue
        var topNews: [News] = []
        for newsDic in topStories {
            let news = News(from: newsDic)
            topNews.append(news)
        }
        topBannerNewsModel = topNews.map({ (news) -> NewsModel in
            return NewsModel(from: news)
        })
    }
}
