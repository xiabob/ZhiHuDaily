//
//  GetShortComments.swift
//  ZhiHuDaily
//
//  Created by xiabob on 17/4/13.
//  Copyright © 2017年 xiabob. All rights reserved.
//

import UIKit

class GetShortComments: XBAPIBaseManager, ManagerProtocol {

    var newsId = 0
    
    var path: String {
        return "/story/\(newsId)/short-comments"
    }
}
