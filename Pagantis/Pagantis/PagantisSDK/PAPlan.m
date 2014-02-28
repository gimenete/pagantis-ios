//
//  PAPlan.m
//  Pagantis
//
//  Created by Alberto Gimeno Brieba on 2/24/14.
//  Copyright (c) 2014 Pagantis - TPS. All rights reserved.
//

#import "PAPlan.h"
#import "NSDictionary+SanityChecks.h"
#import "PAUtils.h"

@implementation PAPlan

+ (PAPlan*)planWithDictionary:(NSDictionary*)response {
    PAPlan *plan = [[PAPlan alloc] init];
    plan.amount = [response numberForKey:@"amount"].integerValue;
    plan.name = [response stringForKey:@"name"];
    plan.periodLong = [response numberForKey:@"period_long"].integerValue;
    plan.periodCycle = [response stringForKey:@"period_cycle"];
    plan.trialPeriodLong = [response numberForKey:@"trial_period_long"].integerValue;
    plan.trialPeriodCycle = [response stringForKey:@"trial_period_cycle"];
    plan.currency = [response stringForKey:@"currency"];
    plan.identifier = [response stringForKey:@"id"];
    plan.createdAt = [[PAUtils dateFormatter] dateFromString:[response stringForKey:@"created_at"]];
    return plan;
}

@end
