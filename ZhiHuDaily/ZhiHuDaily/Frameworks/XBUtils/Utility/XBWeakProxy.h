//
//  XBWeakProxy.h
//  XBUtils
//
//  Get from YYWebImageOperation
//
//  Created by xiabob on 16/8/23.
//  Copyright © 2016年 xiabob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XBWeakProxy : NSProxy

@property (nonatomic, weak, readonly) id target;

- (instancetype)initWithTarget:(id)target;
+ (instancetype)proxyWithTarget:(id)target;

@end
