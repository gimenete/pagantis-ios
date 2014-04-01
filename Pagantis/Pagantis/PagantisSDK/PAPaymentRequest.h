//
//  PAPaymentRequest.h
//  Pagantis
//
//  Created by Alberto Gimeno Brieba on 4/1/14.
//  Copyright (c) 2014 Pagantis - TPS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PAPaymentRequest : NSObject

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, assign) NSInteger amount;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *orderIdentifier;
@property (nonatomic, strong) NSString *customFields;
@property (nonatomic, assign) BOOL livemode;
@property (nonatomic, strong) NSArray *activities;

+ (PAPaymentRequest*)paymentRequestWithDictionary:(NSDictionary*)response;

@end
