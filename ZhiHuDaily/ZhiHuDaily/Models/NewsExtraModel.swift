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
    
    override init() {
        super.init()
    }
    
    convenience init(from commentBriefDic: JSON) {
        self.init()
        update(from: commentBriefDic)
    }
    
    func update(from commentBriefDic: JSON) {
        //    long_comments : 长评论总数
        //    popularity : 点赞总数
        //    short_comments : 短评论总数
        //    comments : 评论总数
        longCommentNumber = commentBriefDic["long_comments"].intValue
        voteNumber = commentBriefDic["popularity"].intValue
        shortCommentNumber = commentBriefDic["short_comments"].intValue
        allCommentNumber = commentBriefDic["comments"].intValue
    }
}
