//
//  XBAPIChain.swift
//  XBAPIBaseManager_swift
//
//  Created by xiabob on 16/12/1.
//  Copyright © 2016年 xiabob. All rights reserved.
//

import Foundation

/**
    chain.load(api1).next(api2).next(api3)，则api执行顺序是api1->api2->api3

 */
open class XBAPIChain: NSObject {
    
    private lazy var chainQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "xb.api.queue"
        queue.maxConcurrentOperationCount = 1  //相当于串行队列，default是OperationQueue.defaultMaxConcurrentOperationCount
        return queue
    }()
    
    open func load(api: XBAPIBaseManager, completionHandler: @escaping CompletionHandler) -> XBAPIChain {
        let blockOperation = BlockOperation { 
            let sem = DispatchSemaphore(value: 0)
            api.loadData({ (manager) in
                completionHandler(manager)
                sem.signal()
            })
            
            let _ = sem.wait(timeout: .distantFuture)
        }

        chainQueue.addOperation(blockOperation)
        
        return self
    }
    
    open func next(api: XBAPIBaseManager, completionHandler: @escaping CompletionHandler) -> XBAPIChain {
        let blockOperation = BlockOperation {
            let sem = DispatchSemaphore(value: 0)
            api.loadData({ (manager) in
                completionHandler(manager)
                sem.signal()
            })
            
            let _ = sem.wait(timeout: .distantFuture)
        }

        chainQueue.addOperation(blockOperation)
        
        return self
    }
    
    ///取消之后所有的API调用（包括现在执行的）
    open func cancleAPIs() {
        chainQueue.cancelAllOperations()
    }
    
}
