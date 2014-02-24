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

@interface PACharge : NSObject

@property (nonatomic, strong) NSNumber *livemode;
@property (nonatomic, strong) NSNumber *paid;
@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, strong) NSNumber *refunded;
@property (nonatomic, strong) NSNumber *captured;
@property (nonatomic, strong) NSString *authorizationCode;
// TODO: errorCode, errorMessage
@property (nonatomic, strong) NSString *orderIdentifier;
@property (nonatomic, strong) NSString *chargeDescription;
@property (nonatomic, strong) NSDate *createdAt;

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *subscription;

@property (nonatomic, strong) PACard *card;
@property (nonatomic, strong) PACustomer *customer;

@end
