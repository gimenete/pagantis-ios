//
//  PASaleMakeRequest.h
//  Pagantis
//
//  Created by Alberto Gimeno Brieba on 2/27/14.
//  Copyright (c) 2014 Pagantis - TPS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PACreateChargeRequest : NSObject

@property (nonatomic, strong) NSString *orderIdentifier;
@property (nonatomic, assign) NSInteger amount;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, strong) NSString *orderDescription;

@end
