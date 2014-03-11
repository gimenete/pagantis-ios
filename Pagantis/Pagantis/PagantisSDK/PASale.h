//
//  PASale.h
//  Pagantis
//
//  Created by Alberto Gimeno Brieba on 2/28/14.
//  Copyright (c) 2014 Pagantis - TPS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PASale : NSObject

@property (nonatomic, assign) NSInteger amount;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *orderIdentifier;
@property (nonatomic, strong) NSString *operation;
@property (nonatomic, strong) NSString *ip;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSDate *createdAt;

+ (PASale*)saleWithDictionary:(NSDictionary*)dict;

@end
