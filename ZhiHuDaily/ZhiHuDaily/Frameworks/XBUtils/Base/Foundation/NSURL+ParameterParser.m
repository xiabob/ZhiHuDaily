//
//  NSURL+ParameterParser.m
//  XBUtils
//
//  Created by xiabob on 16/12/9.
//  Copyright © 2016年 xiabob. All rights reserved.
//

#import "NSURL+ParameterParser.h"

@implementation NSURL (ParameterParser)

/**
 *  解析Url参数并生成字典对象
 *
 *  @param encoding 编码格式
 *
 *  @return 参数字典对象
 */
- (NSDictionary *)parserParameterToDictionaryUsingEncoding:(NSStringEncoding)encoding {
    NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
    NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
    
    NSScanner* scanner;
    //<scheme>://<net_loc>/<path>;<params>?<query>#<fragment>，详见：http://www.ietf.org/rfc/rfc1808.txt
    if (self.parameterString && [self.parameterString length] > 0) {
        scanner = [[NSScanner alloc] initWithString:self.parameterString];
    }
    else scanner = [[NSScanner alloc] initWithString:self.query];
    
    while (![scanner isAtEnd]) {
        NSString* pairString = nil;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
        if (kvPair.count == 2) {
            NSString* key = [[kvPair objectAtIndex:0]
                             stringByReplacingPercentEscapesUsingEncoding:encoding];
            NSString* value = [[kvPair objectAtIndex:1]
                               stringByReplacingPercentEscapesUsingEncoding:encoding];
            [pairs setObject:value forKey:key];
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:pairs];
}

- (NSDictionary *)parserParameterToDictionary {
    return [self parserParameterToDictionaryUsingEncoding:NSUTF8StringEncoding];
}

@end
