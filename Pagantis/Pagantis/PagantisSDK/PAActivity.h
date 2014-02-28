//
//  PAActivity.h
//  Pagantis
//
//  Created by Alberto Gimeno Brieba on 2/28/14.
//  Copyright (c) 2014 Pagantis - TPS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PAActivity : NSObject

@property (nonatomic, strong) NSString *ownerType;
@property (nonatomic, strong) NSString *activityType;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *ownerIdentifier;
@property (nonatomic, strong) NSDate *createdAt;

+ (PAActivity*)activityWithDictionary:(NSDictionary*)dict;

@end
