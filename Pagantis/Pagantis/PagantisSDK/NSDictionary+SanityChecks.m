//
//  NSDictionary+SanityChecks.m
//  Pagantis
//
//  Created by Alberto Gimeno Brieba on 2/24/14.
//  Copyright (c) 2014 Pagantis - TPS. All rights reserved.
//

#import "NSDictionary+SanityChecks.h"

@implementation NSDictionary (SanityChecks)

- (NSString*)stringForKey:(id)key {
    id value = [self objectForKey:key];
    if (![value isKindOfClass:[NSString class]]) {
        return nil;
    }
    return (NSString*)value;
}

- (NSNumber*)numberForKey:(id)key {
    id value = [self objectForKey:key];
    if (![value isKindOfClass:[NSNumber class]]) {
        return nil;
    }
    return (NSNumber*)value;
}

- (NSDictionary*)dictionaryForKey:(id)key {
    id value = [self objectForKey:key];
    if (![value isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return (NSDictionary*)value;
}

- (NSArray*)arrayForKey:(id)key {
    id value = [self objectForKey:key];
    if (![value isKindOfClass:[NSArray class]]) {
        return nil;
    }
    return (NSArray*)value;
}

@end
