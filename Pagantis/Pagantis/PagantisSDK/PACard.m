//
//  PACard.m
//  Pagantis
//
//  Created by Alberto Gimeno Brieba on 2/24/14.
//  Copyright (c) 2014 Pagantis - TPS. All rights reserved.
//

#import "PACard.h"
#import "NSDictionary+SanityChecks.h"

@implementation PACard

+ (PACard*)cardWithDictionary:(NSDictionary*)dict {
    PACard *card = [[PACard alloc] init];
    card.brand = [dict stringForKey:@"brand"];
    card.cardType = [dict stringForKey:@"card_type"];
    card.last4 = [dict stringForKey:@"last4"];
    card.expirationMonth = [dict numberForKey:@"expiration_year"].integerValue;
    card.expirationYear = [dict numberForKey:@"expiration_month"].integerValue;
    card.cvcCheck = [dict stringForKey:@"cvc_check"];
    card.identifier = [dict stringForKey:@"id"];
    return card;
}

@end
