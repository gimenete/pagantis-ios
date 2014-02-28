//
//  PACreateRefundRequest.h
//  Pagantis
//
//  Created by Alberto Gimeno Brieba on 2/28/14.
//  Copyright (c) 2014 Pagantis - TPS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PACreateRefundRequest : NSObject

@property (nonatomic, strong) NSString *chargeIdentifier;
@property (nonatomic, assign) NSInteger amount;

@end
