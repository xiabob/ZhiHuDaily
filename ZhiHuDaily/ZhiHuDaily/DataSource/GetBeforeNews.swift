//
//  GetBeforeNews.swift
//  ZhiHuDaily
//
//  Created by xiabob on 17/3/21.
//  Copyright © 2017年 xiabob. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftDate

class GetBeforeNews: XBAPIBaseManager, ManagerProtocol, XBAPILocalCache {
    var normalNewsModel: [NewsModel] = []
    var beforeDate = ""
    var currentDate = ""
    
    var path: String {
        return "/news/before/" + beforeDate
    }
    
    var shouldCache: Bool {return true}
    
    func customLoadFromLocal() {
        guard let realm = RealmManager.shared.defaultRealm else {return}
        
        var resultDate = Date()
        do {
            let date = try beforeDate.date(format: .custom("yyyyMMdd"))
            resultDate = date.absoluteDate - 1.day
        } catch {}
        currentDate = resultDate.string(format: .custom("yyyyMMdd"))
        
        let normalNews = News.fetchNews(from: realm, withDate: currentDate)
        normalNewsModel = normalNews.map({ (news) -> NewsModel in
            return NewsModel(from: news)
        })
    }
    
    func getDataFromLocal(from key: String) -> Data? {
        customLoadFromLocal()
        return nil
    }
    
    func parseResponseData(_ data: AnyObject) {
        let json = JSON(data)
        
        let date = json["date"].stringValue
        
        let normalStories = json["stories"].arrayValue
        var normalNews: [News] = []
        
        let realm = RealmManager.shared.defaultRealm
        try? realm?.write({ 
            for newsDic in normalStories {
                let newsID = newsDic["id"].intValue
                let existNews = realm?.object(ofType: News.self, forPrimaryKey: newsID)
                if let existNews = existNews { //存在则更新
                    existNews.update(from: newsDic, dateString: date)
                    normalNews.append(existNews)
                } else { //否则创建新的实体
                    let news = News(from: newsDic, dateString: date)
                    realm?.add(news)
                    normalNews.append(news)
                }
            }
            normalNewsModel = normalNews.map({ (news) -> NewsModel in
                return NewsModel(from: news)
            })
        })
    }
}
