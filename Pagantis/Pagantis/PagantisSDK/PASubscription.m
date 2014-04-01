//
//  PASubscription.m
//  Pagantis
//
//  Created by Alberto Gimeno Brieba on 4/1/14.
//  Copyright (c) 2014 Pagantis - TPS. All rights reserved.
//

#import "PASubscription.h"
#import "PAUtils.h"
#import "PACustomer.h"
#import "PAPlan.h"
#import "PACharge.h"
#import "NSDictionary+SanityChecks.h"

@implementation PASubscription

+ (PASubscription*)subscriptionWithDictionary:(NSDictionary*)response {
    PASubscription *subscription = [[PASubscription alloc] init];
    subscription.status = [response stringForKey:@"status"];
    subscription.nextCharge = [[PAUtils dateFormatter] dateFromString:[response stringForKey:@"next_charge"]];
    subscription.livemode = [response numberForKey:@"livemode"].boolValue;
    subscription.identifier = [response stringForKey:@"id"];
    subscription.createdAt = [[PAUtils dateFormatter] dateFromString:[response stringForKey:@"created_at"]];
    
    subscription.customer = [PACustomer customerWithDictionary:[response dictionaryForKey:@"customer"]];
    subscription.plan = [PAPlan planWithDictionary:[response dictionaryForKey:@"plan"]];
    subscription.card = [PACard cardWithDictionary:[response dictionaryForKey:@"card"]];
    
    {
        NSArray *charges = [response arrayForKey:@"charges"];
        NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:charges.count];
        for (NSDictionary *charge in charges) {
            if ([charge isKindOfClass:[NSDictionary class]]) {
                [arr addObject:[PACharge chargeWithDictionary:charge]];
            }
        }
        subscription.charges = arr;
    }
    
    {
        NSArray *activities = [response arrayForKey:@"activities"];
        NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:activities.count];
        for (NSDictionary *activity in activities) {
            if ([activity isKindOfClass:[NSDictionary class]]) {
                [arr addObject:[PAActivity activityWithDictionary:activity]];
            }
        }
        subscription.activities = arr;
    }
    
    return subscription;
}

@end
