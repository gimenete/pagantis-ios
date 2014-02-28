//
//  PARefund.m
//  Pagantis
//
//  Created by Alberto Gimeno Brieba on 2/28/14.
//  Copyright (c) 2014 Pagantis - TPS. All rights reserved.
//

#import "PARefund.h"
#import "NSDictionary+SanityChecks.h"
#import "PAUtils.h"

@implementation PARefund

+ (PARefund*)refundWithDictionary:(NSDictionary*)dict {
    PARefund *refund = [[PARefund alloc] init];
    refund.amount = [dict numberForKey:@"amount"].integerValue;
    refund.createdAt = [[PAUtils dateFormatter] dateFromString:[dict stringForKey:@"created_at"]];
    refund.currency = [dict stringForKey:@"currency"];
    refund.identifier = [dict stringForKey:@"id"];
    refund.transactionCode = [dict stringForKey:@"transaction_code"];
    return refund;
}

@end
