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
    
    func parseResponseData(_ data: AnyObject) {
        let detailJson = JSON(data)
        if detailJson.dictionaryValue.values.count < 6 {
            errorCode = Error(code: .httpError, errorMessage: "网络异常")
            model = nil
        } else {
            errorCode = Error(code: .success, errorMessage: "")
            let news = News(detailNewsDic: detailJson)
            model = NewsModel(from: news)
        }
    }
}
