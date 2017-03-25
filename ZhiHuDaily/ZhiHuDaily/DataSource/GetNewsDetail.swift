//
//  GetNewsDetail.swift
//  ZhiHuDaily
//
//  Created by xiabob on 17/3/22.
//  Copyright © 2017年 xiabob. All rights reserved.
//

import UIKit
import SwiftyJSON

class GetNewsDetail: XBAPIBaseManager, ManagerProtocol {
    var newsID = 0
    var model: NewsModel?
    
    var path: String {
        return "/news/\(newsID)"
    }
    
    var useCustomLoadFromLocal: Bool {return true}
    
    func customLoadFromLocal() {
        guard let realm = RealmManager.shared.defaultRealm else {return}
        guard let news = realm.object(ofType: News.self, forPrimaryKey: newsID) else {return}
        model = NewsModel(from: news)
    }
    
    func parseResponseData(_ data: AnyObject) {
        let detailJson = JSON(data)
        if detailJson.dictionaryValue.values.count < 6 {
            errorCode = Error(code: .httpError, errorMessage: "网络异常")
            model = nil
        } else {
            errorCode = Error(code: .success, errorMessage: "")
            
            let realm = RealmManager.shared.defaultRealm
            try? realm?.write({ 
                let newsID = detailJson["id"].intValue
                let existNews = realm?.object(ofType: News.self, forPrimaryKey: newsID)
                if let existNews = existNews { //存在则更新
                    existNews.update(detailNewsDic: detailJson)
                    model = NewsModel(from: existNews)
                } else {
                    let news = News(detailNewsDic: detailJson)
                    realm?.add(news)
                    model = NewsModel(from: news)
                }
            })
        }
    }
}
