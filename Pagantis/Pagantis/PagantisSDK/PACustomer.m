//
//  PACustomer.m
//  Pagantis
//
//  Created by Alberto Gimeno Brieba on 2/24/14.
//  Copyright (c) 2014 Pagantis - TPS. All rights reserved.
//

#import "PACustomer.h"
#import "NSDictionary+SanityChecks.h"
#import "PAUtils.h"

@implementation PACustomer

+ (PACustomer*)customerWithDictionary:(NSDictionary*)dictionary {
    PACustomer *customer = [[PACustomer alloc] init];
    customer.email       = [dictionary stringForKey:@"email"];
    customer.identifier  = [dictionary stringForKey:@"id"];
    customer.name        = [dictionary stringForKey:@"name"];
    customer.reference   = [dictionary stringForKey:@"reference"];
    customer.createdAt   = [[PAUtils dateFormatter] dateFromString:[dictionary stringForKey:@"created_at"]];
    
    return customer;
}

@end
