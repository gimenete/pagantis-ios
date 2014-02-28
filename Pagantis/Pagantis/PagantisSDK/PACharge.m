//
//  PACharge.m
//  Pagantis
//
//  Created by Alberto Gimeno Brieba on 2/24/14.
//  Copyright (c) 2014 Pagantis - TPS. All rights reserved.
//

#import "PACharge.h"
#import "NSDictionary+SanityChecks.h"
#import "PAUtils.h"

@implementation PACharge

+ (PACharge*)chargeWithDictionary:(NSDictionary*)response {
    PACharge *charge = [[PACharge alloc] init];
    charge.identifier = [response stringForKey:@"id"];
    charge.livemode = [response numberForKey:@"livemode"].boolValue;
    charge.amount = [response numberForKey:@"amount"].integerValue;
    charge.currency = [response stringForKey:@"currency"];
    charge.refunded = [response numberForKey:@"refunded"].boolValue;
    charge.captured = [response numberForKey:@"captured"].boolValue;
    charge.authorizationCode = [response stringForKey:@"authorization_code"];
    charge.orderIdentifier = [response stringForKey:@"order_id"];
    charge.orderDescription = [response stringForKey:@"description"];
    charge.amountInEur = [response numberForKey:@"amount_in_eur"].integerValue;
    charge.exchangeRateEur = [response numberForKey:@"exchange_rate_eur"];
    charge.createdAt = [[PAUtils dateFormatter] dateFromString:[response stringForKey:@"created_at"]];
    charge.errorCode = [response stringForKey:@"error_code"];
    charge.errorMessage = [response stringForKey:@"error_message"];
    
    NSDictionary *customer = [response dictionaryForKey:@"customer"];
    if (customer) {
        charge.customer = [PACustomer customerWithDictionary:customer];
    }
    NSDictionary *card = [response dictionaryForKey:@"card"];
    if (card) {
        charge.card = [PACard cardWithDictionary:card];
    }
    NSDictionary *sale = [response dictionaryForKey:@"sale"];
    if (sale) {
        charge.sale = [PASale saleWithDictionary:sale];
    }
    // TODO: subscription
    NSArray *activities = [response arrayForKey:@"activities"];
    if (activities) {
        NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:activities.count];
        for (NSDictionary *dict in activities) {
            if ([dict isKindOfClass:[NSDictionary class]]) {
                PAActivity *activity = [PAActivity activityWithDictionary:dict];
                [arr addObject:activity];
            }
        }
        charge.activities = arr;
    }
    NSArray *refunds = [response arrayForKey:@"refunds"];
    if (refunds) {
        NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:refunds.count];
        for (NSDictionary *dict in refunds) {
            if ([dict isKindOfClass:[NSDictionary class]]) {
                PARefund *refund = [PARefund refundWithDictionary:dict];
                [arr addObject:refund];
            }
        }
        charge.refunds = arr;
    }
    return charge;
}

@end
