//
//  NSURL+ParameterParser.h
//  XBUtils
//
//  Created by xiabob on 16/12/9.
//  Copyright © 2016年 xiabob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (ParameterParser)

/**
 *  解析Url参数并生成字典对象
 *
 *  @param encoding 编码格式
 *
 *  @return 参数字典对象
 */
- (NSDictionary *)parserParameterToDictionaryUsingEncoding:(NSStringEncoding)encoding;

/**
 *  解析Url参数并生成字典对象，默认采用NSUTF8StringEncoding编码格式
 */
- (NSDictionary *)parserParameterToDictionary;

@end
