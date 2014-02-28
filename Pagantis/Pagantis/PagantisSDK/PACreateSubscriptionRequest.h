//
//  PACreateSubscriptionRequest.h
//  Pagantis
//
//  Created by Alberto Gimeno Brieba on 2/28/14.
//  Copyright (c) 2014 Pagantis - TPS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PACreateSubscriptionRequest : NSObject

@property (nonatomic, strong) NSString *userIdentifier;
@property (nonatomic, strong) NSString *planIdentifier;
@property (nonatomic, strong) NSString *orderIdentifier;
@property (nonatomic, strong) NSString *orderDescription;
@property (nonatomic, assign) NSInteger amount;
@property (nonatomic, strong) NSString *currency;

@end
