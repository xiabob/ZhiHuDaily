//
//  GetCommentBriefInfos.swift
//  ZhiHuDaily
//
//  Created by xiabob on 17/3/23.
//  Copyright © 2017年 xiabob. All rights reserved.
//

import UIKit
import SwiftyJSON

class GetNewsExtraInfos: XBAPIBaseManager, ManagerProtocol {
    var newsID = 0
    var model: NewsExtraModel?
    
    var path: String {
        return "/story-extra/\(newsID)"
    }
    
    func parseResponseData(_ data: AnyObject) {
        let extraJson = JSON(data)
        if extraJson.dictionaryValue.values.count == 4 {
            errorCode = Error(code: .success, errorMessage: "")
            model = NewsExtraModel(from: extraJson)
        } else {
            errorCode = Error(code: .httpError, errorMessage: "网络异常")
            model = nil
        }
    }
}
