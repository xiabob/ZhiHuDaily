//
//  GetLatestNews.swift
//  ZhiHuDaily
//
//  Created by 夏名 on 17/3/18.
//  Copyright © 2017年 xiabob. All rights reserved.
//

import UIKit
import SwiftyJSON

class GetLatestNews: XBAPIBaseManager, ManagerProtocol, XBAPILocalCache {
    var normalNewsModel: [NewsModel] = []
    var topBannerNewsModel: [NewsModel] = []
    
    var path: String {
        return "/news/latest"
    }
    
    var shouldCache: Bool {return true}
    
    func getDataFromLocal(from key: String) -> Data? {
        customLoadFromLocal()
        return nil
    }
    
    func customLoadFromLocal() {
        guard let realm = RealmManager.shared.defaultRealm else {return}
        
        let currentDate = Date().string(format: .custom("yyyyMMdd"))
        let normalNews = News.fetchNews(from: realm, withDate: currentDate)
        normalNewsModel = normalNews.map({ (news) -> NewsModel in
            return NewsModel(from: news)
        })
    }
    
    func parseResponseData(_ data: AnyObject) {
        let json = JSON(data)
        
        let date = json["date"].stringValue
        
        let normalStories = json["stories"].arrayValue
        var normalNews: [News] = []
        let realm = RealmManager.shared.defaultRealm
        //write transaction 不能嵌套，会阻塞当前线程
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
            
            let topStories = json["top_stories"].arrayValue
            var topNews: [News] = []
            for newsDic in topStories {
                let newsID = newsDic["id"].intValue
                let existNews = realm?.object(ofType: News.self, forPrimaryKey: newsID)
                if let existNews = existNews {
                    existNews.update(from: newsDic)
                    topNews.append(existNews)
                } else {
                    let news = News(from: newsDic)
                    realm?.add(news)
                    topNews.append(news)
                }
            }
            topBannerNewsModel = topNews.map({ (news) -> NewsModel in
                return NewsModel(from: news)
            })
        })
    }
}
