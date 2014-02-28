//
//  PARefund.h
//  Pagantis
//
//  Created by Alberto Gimeno Brieba on 2/28/14.
//  Copyright (c) 2014 Pagantis - TPS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PARefund : NSObject

@property (nonatomic, assign) NSInteger amount;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *transactionCode;

+ (PARefund*)refundWithDictionary:(NSDictionary*)dict;

@end
