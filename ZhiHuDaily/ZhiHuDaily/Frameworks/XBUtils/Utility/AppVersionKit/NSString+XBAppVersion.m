//
//  NSString+XBAppVersion.m
//  XBUtils
//
//  Created by xiabob on 16/10/26.
//  Copyright © 2016年 xiabob. All rights reserved.
//

#import "NSString+XBAppVersion.h"

@implementation NSString (XBAppVersion)

- (BOOL)xb_greaterThan:(NSString *)otherVersion {
    return ([self compare:otherVersion options:NSNumericSearch] == NSOrderedDescending);
}

- (BOOL)xb_lessThan:(NSString *)otherVersion {
    return ([self compare:otherVersion options:NSNumericSearch] == NSOrderedAscending);
}

- (BOOL)xb_same:(NSString *)otherVersion {
    return ([self compare:otherVersion options:NSNumericSearch] == NSOrderedSame);
}


@end
