//
//  PAActivity.m
//  Pagantis
//
//  Created by Alberto Gimeno Brieba on 2/28/14.
//  Copyright (c) 2014 Pagantis - TPS. All rights reserved.
//

#import "PAActivity.h"
#import "NSDictionary+SanityChecks.h"
#import "PAUtils.h"

@implementation PAActivity

+ (PAActivity*)activityWithDictionary:(NSDictionary*)dict {
    PAActivity *activity = [[PAActivity alloc] init];
    activity.ownerType = [dict stringForKey:@"owner_type"];
    activity.activityType = [dict stringForKey:@"activity_type"];
    activity.createdAt = [[PAUtils dateFormatter] dateFromString:[dict stringForKey:@"created_at"]];
    activity.identifier = [dict stringForKey:@"id"];
    activity.ownerIdentifier = [dict stringForKey:@"owner_id"];
    return activity;
}

@end
