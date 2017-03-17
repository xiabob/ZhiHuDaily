//
//  XBFileHash.h
//  XBUtils
//
//  this file get from https://github.com/JoeKun/FileMD5Hash
//
//  可以方便快捷地计算大文件MD5、hash值
//
//  Created by xiabob on 16/10/31.
//  Copyright © 2016年 xiabob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XBFileHash : NSObject

+ (NSString *)md5HashOfFileAtPath:(NSString *)filePath;
+ (NSString *)sha1HashOfFileAtPath:(NSString *)filePath;
+ (NSString *)sha512HashOfFileAtPath:(NSString *)filePath;

@end
