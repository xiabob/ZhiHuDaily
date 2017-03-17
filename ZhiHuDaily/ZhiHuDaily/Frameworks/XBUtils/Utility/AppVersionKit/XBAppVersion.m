//
//  XBAppVersion.m
//  XBUtils
//
//  Created by xiabob on 16/10/26.
//  Copyright © 2016年 xiabob. All rights reserved.
//

#import "XBAppVersion.h"

@implementation XBAppVersion

+ (NSString *)appVersion {
    NSDictionary *dic = [[NSBundle mainBundle] infoDictionary];
    if (dic) {
        return dic[@"CFBundleShortVersionString"] ?: @"";
    } else {
        return @"";
    }
}

+ (BOOL)greaterThan:(NSString *)otherVersion {
    return [[self appVersion] xb_greaterThan:otherVersion];
}

+ (BOOL)lessThan:(NSString *)otherVersion {
    return [[self appVersion] xb_lessThan:otherVersion];
}

+ (BOOL)same:(NSString *)otherVersion {
    return [[self appVersion] xb_same:otherVersion];
}

@end
