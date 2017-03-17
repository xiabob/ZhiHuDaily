//
//  DataUtils.swift
//  ZhiHuDaily
//
//  Created by xiabob on 17/3/17.
//  Copyright © 2017年 xiabob. All rights reserved.
//

import Foundation

func dispatchMain(after duration: TimeInterval, completeBlock:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+duration) {
        completeBlock()
    }
}

