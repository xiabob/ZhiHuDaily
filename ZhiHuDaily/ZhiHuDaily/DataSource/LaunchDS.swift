//
//  LaunchDS.swift
//  ZhiHuDaily
//
//  Created by xiabob on 17/3/17.
//  Copyright © 2017年 xiabob. All rights reserved.
//

import UIKit
import SwiftyJSON

class LaunchDS: XBAPIBaseManager, ManagerProtocol {
    var model: LaunchModel?
    
    
    // /7/prefetch-launch-images/1080*1920
    var apiVersion: String {return "7"}
    
    var path: String {
        return "/prefetch-launch-images/1080*1776"
    }
    
    var shouldCache: Bool {return true}
    
    func parseResponseData(_ data: AnyObject) {
        let json = JSON(data)
        model = LaunchModel(from: json["creatives"].arrayValue.first)
    }
}
