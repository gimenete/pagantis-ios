//
//  NSDictionary+SanityChecks.h
//  Pagantis
//
//  Created by Alberto Gimeno Brieba on 2/24/14.
//  Copyright (c) 2014 Pagantis - TPS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (SanityChecks)

- (NSString*)stringForKey:(id)key;

- (NSNumber*)numberForKey:(id)key;

- (NSDictionary*)dictionaryForKey:(id)key;

- (NSArray*)arrayForKey:(id)key;

@end
