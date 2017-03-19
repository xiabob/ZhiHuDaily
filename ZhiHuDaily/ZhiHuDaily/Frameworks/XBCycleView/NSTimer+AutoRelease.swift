//
//  NSTimer+AutoRelease.swift
//  XBCycleView
//
//  Created by xiabob on 16/6/13.
//  Copyright © 2016年 xiabob. All rights reserved.
//

import Foundation

public typealias executeTimerClosure = ()->()

//将closure封装成一个对象
private class ClosureObject<T> {
    let closure: T?
    init (closure: T?) {
        self.closure = closure
    }
}

public extension Timer {
    public class func xb_scheduledTimerWithTimeInterval(_ timeInterval: TimeInterval,
                                                        isRepeat: Bool,
                                                        closure: executeTimerClosure?) -> Timer {
        let block = ClosureObject<executeTimerClosure>(closure: closure)
        let timer = Timer.scheduledTimer(timeInterval: timeInterval,
                                                           target: self,
                                                           selector: #selector(xb_executeTimerBlock),
                                                           userInfo: block,
                                                           repeats: isRepeat)
        return timer
    }
    
    public class func xb_scheduledTimerWithTimeInterval(_ timeInterval: TimeInterval,
                                                        closure: executeTimerClosure?) -> Timer {
        return xb_scheduledTimerWithTimeInterval(timeInterval,
                                                 isRepeat: false,
                                                 closure: closure)
    }
    
    class func xb_executeTimerBlock(_ timer: Timer) {
        if let block = timer.userInfo as? ClosureObject<executeTimerClosure> {
            if let closure = block.closure {
                closure()
            }
        }
    }
}
