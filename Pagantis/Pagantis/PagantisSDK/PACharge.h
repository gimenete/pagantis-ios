//
//  PACharge.h
//  Pagantis
//
//  Created by Alberto Gimeno Brieba on 2/24/14.
//  Copyright (c) 2014 Pagantis - TPS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PACard.h"
#import "PACustomer.h"
#import "PASale.h"
#import "PAActivity.h"
#import "PARefund.h"

@interface PACharge : NSObject

@property (nonatomic, assign) BOOL livemode;
@property (nonatomic, assign) BOOL paid;
@property (nonatomic, assign) NSInteger amount;
@property (nonatomic, assign) NSInteger amountInEur;
@property (nonatomic, strong) NSNumber *exchangeRateEur;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, assign) BOOL refunded;
@property (nonatomic, assign) BOOL captured;
@property (nonatomic, strong) NSString *authorizationCode;
@property (nonatomic, strong) NSString *errorCode;
@property (nonatomic, strong) NSString *errorMessage;
@property (nonatomic, strong) NSString *orderIdentifier;
@property (nonatomic, strong) NSString *orderDescription;
@property (nonatomic, strong) NSDate *createdAt;

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *subscription;

@property (nonatomic, strong) PACard *card;
@property (nonatomic, strong) PASale *sale;
@property (nonatomic, strong) PACustomer *customer;
@property (nonatomic, strong) NSArray *activities;
@property (nonatomic, strong) NSArray *refunds;

+ (PACharge*)chargeWithDictionary:(NSDictionary*)response;

@end
