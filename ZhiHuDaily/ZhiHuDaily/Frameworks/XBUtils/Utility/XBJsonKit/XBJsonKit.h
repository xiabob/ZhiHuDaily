//
//  XBJsonKit.h
//  XBJsonKitDemo
//
//  Created by xiabob on 16/9/1.
//  Copyright © 2016年 xiabob. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark - NSObject
@interface NSObject (XBJson)

/**
 @brief Returns a string containing the receiver encoded in JSON.
 
 This method is added as a category on NSObject but is only actually
 supported for the following objects:
 @li NSDictionary
 @li NSArray
 */
- (nullable NSString *)jsonRepresentation;

@end


#pragma mark - NSString
@interface NSString (XBJson)

/**
 @brief Returns the NSDictionary or NSArray represented by the current string's JSON representation.
 
 Returns the dictionary or array represented in the receiver, or nil on error.
 
 Returns the NSDictionary or NSArray represented by the current string's JSON representation.
 */
- (nullable id)jsonValue;

@end


#pragma mark - NSData
@interface NSData (XBJson)

- (nullable id)jsonValue;  ///< Returns the dictionary or array represented in the receiver, or nil on error.

@end


#pragma mark - XBJsonKit
@interface XBJsonKit : NSObject

@end
