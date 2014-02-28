//
//  PACard.h
//  Pagantis
//
//  Created by Alberto Gimeno Brieba on 2/24/14.
//  Copyright (c) 2014 Pagantis - TPS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PACard : NSObject

@property (nonatomic, strong) NSString *brand;
@property (nonatomic, strong) NSString *cardType;
@property (nonatomic, strong) NSString *last4;
@property (nonatomic, assign) NSInteger expirationYear;
@property (nonatomic, assign) NSInteger expirationMonth;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *cvcCheck;
@property (nonatomic, strong) NSString *identifier;

+ (PACard*)cardWithDictionary:(NSDictionary*)dict;

@end
