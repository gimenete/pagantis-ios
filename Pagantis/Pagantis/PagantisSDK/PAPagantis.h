//
//  PAPagantis.h
//  Pagantis
//
//  Created by Alberto Gimeno Brieba on 2/24/14.
//  Copyright (c) 2014 Pagantis - TPS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PACustomer.h"
#import "PACard.h"
#import "PAPlan.h"
#import "PACharge.h"

typedef void(^CustomerCompletionBlock)(NSError *error, PACustomer *customer);
typedef void(^CardCompletionBlock)(NSError *error, PACustomer *card);
typedef void(^ChargeCompletionBlock)(NSError *error, PACharge *charge);
typedef void(^PlanCompletionBlock)(NSError *error, PAPlan *plan);
typedef void(^ArrayCompletionBlock)(NSError *error, NSArray *objects);

@interface PAPagantis : NSObject

+ (PAPagantis*)sharedInstance;

/* api keys */

- (void)setApiKey:(NSString*)apiKey;

/* charges */

- (void)findChargeWithIdentifier:(NSString*)identifier completion:(ChargeCompletionBlock)completion;

- (void)findCharges:(NSInteger)page completion:(ArrayCompletionBlock)completion;


/* customers */

- (void)createCustomerWithName:(NSString*)name email:(NSString*)email reference:(NSString*)reference completion:(CustomerCompletionBlock)completion;

- (void)findCustomerWithIdentifier:(NSString*)identifier completion:(CustomerCompletionBlock)completion;

- (void)findCustomers:(NSInteger)page completion:(ArrayCompletionBlock)completion;

/* plans */

- (void)findPlanWithIdentifier:(NSString*)identifier completion:(PlanCompletionBlock)completion;

- (void)findPlans:(NSInteger)page completion:(ArrayCompletionBlock)completion;

@end
