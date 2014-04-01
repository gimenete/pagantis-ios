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
#import "PASubscription.h"
#import "PAPaymentRequest.h"
#import "PAWebViewController.h"
#import "PACreateChargeRequest.h"
#import "PATokenizeCardRequest.h"
#import "PACreateSubscriptionRequest.h"
#import "PACreateRefundRequest.h"
#import "PACreateCustomerRequest.h"
#import "PACreatePlanRequest.h"
#import "PACreatePaymentRequest.h"

typedef void(^CustomerCompletionBlock)(NSError *error, PACustomer *customer);
typedef void(^CardCompletionBlock)(NSError *error, PACustomer *card);
typedef void(^ChargeCompletionBlock)(NSError *error, PACharge *charge);
typedef void(^PlanCompletionBlock)(NSError *error, PAPlan *plan);
typedef void(^SubscriptionCompletionBlock)(NSError *error, PASubscription *subscription);
typedef void(^PaymentRequestCompletionBlock)(NSError *error, PAPaymentRequest *paymentRequest);
typedef void(^ArrayCompletionBlock)(NSError *error, NSArray *objects);

@interface PAPagantis : NSObject

+ (PAPagantis*)sharedInstance;

- (NSString*)urlWithPath:(NSString*)path;

/* api keys */

- (void)setApiKey:(NSString*)apiKey;

- (void)setSignatureKey:(NSString*)signatureKey;

- (void)setAccountId:(NSString*)accountId;

/* charges */

- (PAWebViewController *)webViewControllerToCreateCharge:(PACreateChargeRequest *)chargeRequest
                                                progress:(WebViewControllerProgressBlock)progress
                                              completion:(WebViewControllerCompletionBlock)completion;

- (void)findChargeWithIdentifier:(NSString*)identifier completion:(ChargeCompletionBlock)completion;

- (void)findCharges:(NSInteger)page completion:(ArrayCompletionBlock)completion;

- (void)refundCharge:(PACreateRefundRequest*)refundRequest completion:(ChargeCompletionBlock)completion;


/* customers */

- (void)createCustomer:(PACreateCustomerRequest*)customerRequest completion:(CustomerCompletionBlock)completion;

- (void)findCustomerWithIdentifier:(NSString*)identifier completion:(CustomerCompletionBlock)completion;

- (void)findCustomers:(NSInteger)page completion:(ArrayCompletionBlock)completion;

/* plans */

- (void)createPlan:(PACreatePlanRequest*)planRequest completion:(PlanCompletionBlock)completion;

- (void)findPlanWithIdentifier:(NSString*)identifier completion:(PlanCompletionBlock)completion;

- (void)findPlans:(NSInteger)page completion:(ArrayCompletionBlock)completion;

/* cards */

- (PAWebViewController *)webViewControllerToTokenizeCard:(PATokenizeCardRequest *)tokenizeRequest
                                                progress:(WebViewControllerProgressBlock)progress
                                              completion:(WebViewControllerCompletionBlock)completion;

/* subscriptions */

- (PAWebViewController *)webViewControllerToCreateSubscription:(PACreateSubscriptionRequest *)subscriptionRequest
                                                      progress:(WebViewControllerProgressBlock)progress
                                                    completion:(WebViewControllerCompletionBlock)completion;

- (void)findSubscriptions:(NSInteger)page completion:(ArrayCompletionBlock)completion;

- (void)findSubscriptionWithIdentifier:(NSString*)identifier completion:(SubscriptionCompletionBlock)completion;

/* payment requests */

- (void)createPaymentRequest:(PACreatePaymentRequest*)paymentRequest completion:(PaymentRequestCompletionBlock)completion;

- (void)findPaymentRequests:(NSInteger)page completion:(ArrayCompletionBlock)completion;

- (void)findPaymentRequestWithIdentifier:(NSString*)identifier completion:(PaymentRequestCompletionBlock)completion;

- (void)cancelPaymentRequestWithIdentifier:(NSString*)identifier completion:(PaymentRequestCompletionBlock)completion;

@end
