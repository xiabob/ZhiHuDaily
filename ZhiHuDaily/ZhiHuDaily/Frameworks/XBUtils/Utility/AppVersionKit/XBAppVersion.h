//
//  XBAppVersion.h
//  XBUtils
//
//  Created by xiabob on 16/10/26.
//  Copyright © 2016年 xiabob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+XBAppVersion.h"

@interface XBAppVersion : NSObject

/// current app version, eg: 1.0.0
+ (NSString *)appVersion;

/// current version > other version
+ (BOOL)greaterThan:(NSString *)otherVersion;

/// current version < other version
+ (BOOL)lessThan:(NSString *)otherVersion;

/// current version = other version
+ (BOOL)same:(NSString *)otherVersion;

@end
