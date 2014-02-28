//
//  PAUtils.h
//  Pagantis
//
//  Created by Alberto Gimeno Brieba on 2/27/14.
//  Copyright (c) 2014 Pagantis - TPS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PAUtils : NSObject

+ (NSString*)urlEncode:(NSString*)str;

+ (NSString*)urlDecode:(NSString*)str;

+ (NSString*)queryString:(NSDictionary*)dict;

+ (NSDictionary*)parseQueryString:(NSString*)str;

+ (NSString*)hexString:(NSData*)data;

+ (NSData *)sha1:(NSData *)rawData;

+ (NSData*)hmacSha1:(NSData*)data withKey:(NSData*)key;

+ (NSString*)nonce;

+ (NSDateFormatter*)dateFormatter;

@end
