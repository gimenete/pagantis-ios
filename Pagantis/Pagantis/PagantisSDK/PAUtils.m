//
//  PAUtils.m
//  Pagantis
//
//  Created by Alberto Gimeno Brieba on 2/27/14.
//  Copyright (c) 2014 Pagantis - TPS. All rights reserved.
//

#import "PAUtils.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>

@implementation PAUtils

+ (NSString*)urlEncode:(NSString*)str {
	NSString* encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                           NULL,
                                                                                           (__bridge CFStringRef) str,
                                                                                           NULL,
                                                                                           (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                           kCFStringEncodingUTF8 );
	return encodedString;
}

+ (NSString*)urlDecode:(NSString*)str {
    NSString *result = [str stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}

+ (NSString*)queryString:(NSDictionary*)dict {
    NSMutableString* parameterString = [[NSMutableString alloc] init];
    for (NSString* key in dict.allKeys) {
        id value = [dict objectForKey:key];
        if ([value isKindOfClass:[NSArray class]]) {
            NSArray* arr = (NSArray*)value;
            for (NSObject* val in arr) {
                [parameterString appendFormat:@"&%@=%@", [PAUtils urlEncode:key], [PAUtils urlEncode:[val description]]];
            }
        } else {
            [parameterString appendFormat:@"&%@=%@", [PAUtils urlEncode:key], [PAUtils urlEncode:value]];
        }
    }
    if (parameterString.length > 0) {
        [parameterString deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    return [parameterString copy];
}

+ (NSDictionary*)parseQueryString:(NSString*)str {
    NSArray* components = [str componentsSeparatedByString:@"&"];
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithCapacity:components.count];
    for (NSString* component in components) {
        NSRange r = [component rangeOfString:@"="];
        if (r.location != NSNotFound) {
            NSString* key = [PAUtils urlDecode:[component substringToIndex:r.location]];
            NSString* value = [PAUtils urlDecode:[component substringFromIndex:r.location+r.length]];
            [dict setObject:value forKey:key];
        } else {
            [dict setObject:@"" forKey:[PAUtils urlDecode:component]];
        }
    }
    return dict;
}

+ (NSString*)hexString:(NSData*)data {
	NSMutableString *str = [NSMutableString stringWithCapacity:64];
	NSUInteger length = [data length];
	char *bytes = malloc(sizeof(char) * length);
    
	[data getBytes:bytes length:length];
    
	int i = 0;
    
	for (; i < length; i++) {
		[str appendFormat:@"%02.2hhx", bytes[i]];
	}
	free(bytes);
    
	return str;
}

+ (NSData *)sha1:(NSData *)rawData {
    CC_SHA1_CTX ctx;
    uint8_t * hashBytes = NULL;
    NSData * hash = nil;
    
    // Malloc a buffer to hold hash.
    hashBytes = malloc( CC_SHA1_DIGEST_LENGTH * sizeof(uint8_t) );
    memset((void *)hashBytes, 0x0, CC_SHA1_DIGEST_LENGTH);
    
    // Initialize the context.
    CC_SHA1_Init(&ctx);
    // Perform the hash.
    CC_SHA1_Update(&ctx, (void *)[rawData bytes], (int)[rawData length]);
    // Finalize the output.
    CC_SHA1_Final(hashBytes, &ctx);
    
    // Build up the SHA1 blob.
    hash = [NSData dataWithBytes:(const void *)hashBytes length:(NSUInteger)CC_SHA1_DIGEST_LENGTH];
    
    if (hashBytes) free(hashBytes);
    
    return hash;
}

+ (NSData*)hmacSha1:(NSData*)data withKey:(NSData*)key {
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, [key bytes], [key length], [data bytes], [data length], cHMAC);
    NSData *hmac = [[NSData alloc] initWithBytes:cHMAC
                                          length:sizeof(cHMAC)];
    return hmac;
}

+ (NSString*)nonce {
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    int random = arc4random() % 1000;
    NSData* data = [[NSString stringWithFormat:@"%f:%d", time, random] dataUsingEncoding:NSUTF8StringEncoding];
    NSData* output = [PAUtils sha1:data];
    return [PAUtils hexString:output];
}

+ (NSDateFormatter*)dateFormatter {
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // http://stackoverflow.com/questions/18682862/nsdateformatter-for-rails-4-0-created-at
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    });
    return dateFormatter;
}

@end