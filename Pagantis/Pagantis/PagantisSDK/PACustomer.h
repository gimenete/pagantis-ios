//
//  PACustomer.h
//  Pagantis
//
//  Created by Alberto Gimeno Brieba on 2/24/14.
//  Copyright (c) 2014 Pagantis - TPS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PACustomer : NSObject

@property (nonatomic, strong) NSString *reference;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSString *identifier;

+ (PACustomer*)customerWithDictionary:(NSDictionary*)dictionary;

@end
