//
//  PACreatePlanRequest.h
//  Pagantis
//
//  Created by Alberto Gimeno Brieba on 2/28/14.
//  Copyright (c) 2014 Pagantis - TPS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PACreatePlanRequest : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger amount;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, assign) NSInteger periodLong;
@property (nonatomic, strong) NSString *periodCycle;

@end
