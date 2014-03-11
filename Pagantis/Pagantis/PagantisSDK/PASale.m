//
//  PASale.m
//  Pagantis
//
//  Created by Alberto Gimeno Brieba on 2/28/14.
//  Copyright (c) 2014 Pagantis - TPS. All rights reserved.
//

#import "PASale.h"
#import "NSDictionary+SanityChecks.h"
#import "PAUtils.h"

@implementation PASale

+ (PASale*)saleWithDictionary:(NSDictionary*)dict {
    PASale *sale = [[PASale alloc] init];
    sale.amount = [dict numberForKey:@"amount"].integerValue;
    sale.status = [dict stringForKey:@"status"];
    sale.orderIdentifier = [dict stringForKey:@"order_id"];
    sale.operation = [dict stringForKey:@"operation"];
    sale.ip = [dict stringForKey:@"ip"];
    sale.currency = [dict stringForKey:@"currency"];
    sale.identifier = [dict stringForKey:@"id"];
    sale.createdAt = [[PAUtils dateFormatter] dateFromString:[dict stringForKey:@"amount"]];
    return sale;
}

@end
