//
//  XBJsonKit.m
//  XBJsonKitDemo
//
//  Created by xiabob on 16/9/1.
//  Copyright © 2016年 xiabob. All rights reserved.
//

#import "XBJsonKit.h"

#pragma mark - NSObject (XBJson)
@implementation NSObject (XBJson)

- (nullable NSString *)jsonRepresentation {
    @try {
        NSData *data = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
        return [self _getStringFromData:data];
    } @catch (NSException *exception) {
        return nil;
    }
    
    return nil;
}

- (nullable NSString *)_getStringFromData:(NSData *)data {
    //处理两种常见的编码格式
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (!string) {
        string = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    }
    
    return string;
}

@end


#pragma mark - NSString (XBJson)
@implementation NSString (XBJson)

- (nullable id)jsonValue {
    @try {
        NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
        if (!data) {
            data = [self dataUsingEncoding:NSASCIIStringEncoding];
        }
        
        return [NSJSONSerialization JSONObjectWithData:data
                                               options:NSJSONReadingAllowFragments
                                                 error:nil];
    } @catch (NSException *exception) {
        return nil;
    }
}

@end



#pragma mark - NSData (XBJson)
@implementation NSData (XBJson)

- (nullable id)jsonValue {
    @try {
        return [NSJSONSerialization JSONObjectWithData:self
                                               options:NSJSONReadingAllowFragments
                                                 error:nil];
    } @catch (NSException *exception) {
        return nil;
    }
}

@end



#pragma mark - XBJsonKit
@implementation XBJsonKit

@end
