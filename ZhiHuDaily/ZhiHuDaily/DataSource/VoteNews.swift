//
//  VoteNews.swift
//  ZhiHuDaily
//
//  Created by xiabob on 17/3/24.
//  Copyright © 2017年 xiabob. All rights reserved.
//

import UIKit

class VoteNews: XBAPIBaseManager, ManagerProtocol {
    var newsID = 0
    var hasVoted = false
    
    var apiVersion: String {return "7"}
    var requestType: RequestType {return .post}
    var path: String {
        return "/vote/stories"
    }
    
    var parameters: [String : AnyObject]? {
        //有问题
        let votedCode = hasVoted ? 0 : 1
        return ["0": "\(newsID)" as AnyObject,
                "1": "\(votedCode)" as AnyObject]
    }
}
