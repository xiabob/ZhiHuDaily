//
//  NSString+XBAppVersion.h
//  XBUtils
//
//  Created by xiabob on 16/10/26.
//  Copyright © 2016年 xiabob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (XBAppVersion)

/// version a > version b, eg: 2.1.0 > 1.0.1
- (BOOL)xb_greaterThan:(NSString *)otherVersion;

/// version a < version b, eg: 1.1.0 < 1.9.0
- (BOOL)xb_lessThan:(NSString *)otherVersion;

/// version a = version b, eg: 1.1.0 = 1.1.0
- (BOOL)xb_same:(NSString *)otherVersion;

@end
