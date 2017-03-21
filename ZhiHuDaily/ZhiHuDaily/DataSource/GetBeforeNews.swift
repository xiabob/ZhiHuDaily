//
//  GetBeforeNews.swift
//  ZhiHuDaily
//
//  Created by xiabob on 17/3/21.
//  Copyright © 2017年 xiabob. All rights reserved.
//

import UIKit
import SwiftyJSON

class GetBeforeNews: XBAPIBaseManager, ManagerProtocol {
    var normalNewsModel: [NewsModel] = []
    var beforeDate = ""
    
    var path: String {
        return "/news/before/" + beforeDate
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
    }
}
