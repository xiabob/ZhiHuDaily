//
//  NSNull+Safe.h
//  XBUtils
//
// get from https://github.com/nicklockwood/NullSafe
//
//  Created by xiabob on 17/3/3.
//  Copyright © 2017年 xiabob. All rights reserved.
//
// 主要处理json解析出现的null问题，避免null对象调用某些方法发生了崩溃
// 最好还是在解析阶段使用VerifyValue宏替换掉NSNull
//
// 当然如果嫌麻烦，你不需要使用VerifyValue，NSNull的分类已经处理null对象可能的crash情况
//

#define Macro_RemoveNull(value)\
({  id tmp;\
    if ([value isKindOfClass:[NSNull class]])\
        tmp = nil;\
    else\
        tmp = value;\
    tmp;\
})

#import <Foundation/Foundation.h>

@interface NSNull (Safe)

@end
