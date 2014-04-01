//
//  PACreatePaymentRequest.h
//  Pagantis
//
//  Created by Alberto Gimeno Brieba on 4/1/14.
//  Copyright (c) 2014 Pagantis - TPS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PACreatePaymentRequest : NSObject

@property (nonatomic, strong) NSString *orderIdentifier;
@property (nonatomic, assign) NSInteger amount;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, strong) NSString *okURL;
@property (nonatomic, strong) NSString *nokURL;
@property (nonatomic, strong) NSMutableDictionary *customFields;

@end
