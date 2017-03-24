//
//  NewsCommentBriefModel.swift
//  ZhiHuDaily
//
//  Created by xiabob on 17/3/23.
//  Copyright © 2017年 xiabob. All rights reserved.
//

import UIKit
import SwiftyJSON

class NewsExtraModel: NSObject {
    ///长评论总数
    var longCommentNumber = 0
    ///点赞总数
    var voteNumber = 0
    ///短评论总数
    var shortCommentNumber = 0
    ///评论总数
    var allCommentNumber = 0
    
    ///是否点赞
    var hasVoted = false
    
    ///是否收藏
    var hasCollect = false
    
    override init() {
        super.init()
    }
    
    convenience init(from briefDic: JSON) {
        self.init()
        update(from: briefDic)
    }
    
    func update(from briefDic: JSON) {
//        {"count":{"long_comments":3,"short_comments":14,"comments":17,"likes":117},"vote_status":0,"favorite":false}
        
        //    long_comments : 长评论总数
        //    popularity : 点赞总数
        //    short_comments : 短评论总数
        //    comments : 评论总数
        let countJson = briefDic["count"]
        longCommentNumber = countJson["long_comments"].intValue
        voteNumber = countJson["likes"].intValue
        shortCommentNumber = countJson["short_comments"].intValue
        allCommentNumber = countJson["comments"].intValue
        
        hasVoted = briefDic["vote_status"].boolValue
        hasCollect = briefDic["favorite"].boolValue
    }
}
