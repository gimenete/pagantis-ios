//
//  PAPlan.h
//  Pagantis
//
//  Created by Alberto Gimeno Brieba on 2/24/14.
//  Copyright (c) 2014 Pagantis - TPS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PAPlan : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger amount;
@property (nonatomic, assign) NSInteger periodLong;
@property (nonatomic, strong) NSString *periodCycle;
@property (nonatomic, assign) NSInteger trialPeriodLong;
@property (nonatomic, strong) NSString *trialPeriodCycle;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSDate *createdAt;

+ (PAPlan*)planWithDictionary:(NSDictionary*)response;

@end
