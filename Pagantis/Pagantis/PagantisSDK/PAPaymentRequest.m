//
//  PAPaymentRequest.m
//  Pagantis
//
//  Created by Alberto Gimeno Brieba on 4/1/14.
//  Copyright (c) 2014 Pagantis - TPS. All rights reserved.
//

#import "PAPaymentRequest.h"
#import "PAActivity.h"
#import "NSDictionary+SanityChecks.h"

@implementation PAPaymentRequest

+ (PAPaymentRequest*)paymentRequestWithDictionary:(NSDictionary*)response {
    PAPaymentRequest *paymentRequest = [[PAPaymentRequest alloc] init];
    paymentRequest.identifier = [response stringForKey:@"id"];
    paymentRequest.status = [response stringForKey:@"status"];
    paymentRequest.livemode = [response numberForKey:@"livemode"].boolValue;
    paymentRequest.currency = [response stringForKey:@"currency"];
    paymentRequest.orderIdentifier = [response stringForKey:@"order_id"];
    paymentRequest.customFields = [response stringForKey:@"custom_fields"];
    
    {
        NSArray *activities = [response arrayForKey:@"activities"];
        NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:activities.count];
        for (NSDictionary *activity in activities) {
            if ([activity isKindOfClass:[NSDictionary class]]) {
                [arr addObject:[PAActivity activityWithDictionary:activity]];
            }
        }
        paymentRequest.activities = arr;
    }

    return paymentRequest;
}

@end
