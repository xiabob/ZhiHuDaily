//
//  LaunchModel.swift
//  ZhiHuDaily
//
//  Created by xiabob on 17/3/17.
//  Copyright © 2017年 xiabob. All rights reserved.
//

import UIKit
import SwiftyJSON

class LaunchModel: NSObject {
    //base
    var url = ""
    var startTime: TimeInterval = 0
    var impressionTracks: [String] = []
    var type = 0
    var launchID = ""
    
    //extend
    var isValid = false
    
    
    init(from jsonDic: JSON?) {
        super.init()
        self.update(from: jsonDic)
    }
    
    func update(from jsonDic: JSON?) {
        guard let jsonDic = jsonDic else {return}
        
        url = jsonDic["url"].stringValue
        startTime = jsonDic["start_time"].doubleValue
        impressionTracks = jsonDic["impression_tracks"].arrayValue.map({ (value) -> String in
            return value.stringValue
        })
        type = jsonDic["type"].intValue
        launchID = jsonDic["id"].stringValue
        
        filterLaunchModel()
    }
    
    func filterLaunchModel() {
        if url.isEmpty || Date().timeIntervalSince1970 < startTime {
            isValid = false
        } else {
            isValid = true
        }
    }
}
