//
//  PASubscription.h
//  Pagantis
//
//  Created by Alberto Gimeno Brieba on 4/1/14.
//  Copyright (c) 2014 Pagantis - TPS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PAPlan;
@class PACustomer;
@class PACard;

@interface PASubscription : NSObject

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSDate *nextCharge;
@property (nonatomic, assign) BOOL livemode;
@property (nonatomic, strong) PACustomer *customer;
@property (nonatomic, strong) PAPlan *plan;
@property (nonatomic, strong) PACard *card;
@property (nonatomic, strong) NSArray *activities;
@property (nonatomic, strong) NSArray *charges;
@property (nonatomic, strong) NSDate *createdAt;

+ (PASubscription*)subscriptionWithDictionary:(NSDictionary*)response;

@end
