//
//  PAPagantis.m
//  Pagantis
//
//  Created by Alberto Gimeno Brieba on 2/24/14.
//  Copyright (c) 2014 Pagantis - TPS. All rights reserved.
//

#import "PAPagantis.h"
#import <AFNetworking.h>
#import "NSDictionary+SanityChecks.h"
#import "PAUtils.h"

@interface PAPagantis ()

@property (nonatomic, strong) NSString *theApiKey;
@property (nonatomic, strong) NSString *theSignatureKey;
@property (nonatomic, strong) NSString *theAccountId;

@end

@implementation PAPagantis

/* Internal methods */

- (NSError*)errorFromRequestOperation:(AFHTTPRequestOperation*)operation withError:(NSError*)error {
    NSData *data = operation.responseData;
    if (data) {
        id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        if (result && [result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary*)result;
            NSString *error = [dict stringForKey:@"error"];
            NSString *errorDescription = [dict stringForKey:@"error_description"];
            if (error && errorDescription) {
                return [self errorWithMessage:[NSString stringWithFormat:@"%@: %@", error, errorDescription]];
            } else if (error) {
                return [self errorWithMessage:error];
            }
        }
    }
    return error;
}

- (NSError*)errorWithMessage:(NSString*)message {
    return [NSError errorWithDomain:@"com.pagantis"
                               code:4000
                           userInfo:@{ NSLocalizedDescriptionKey: message }];
}

- (AFHTTPRequestOperationManager*)manager {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *authorization = [@"Bearer " stringByAppendingString:self.theApiKey];
    [manager.requestSerializer setValue:authorization forHTTPHeaderField:@"Authorization"];
    return manager;
}

- (NSString*)urlWithPath:(NSString*)path {
    return [@"https://psp.pagantis.com/api/1" stringByAppendingString:path];
}

- (NSDictionary*)findResponseDictionary:(id)responseObject {
    if (![responseObject isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    NSDictionary *dict = (NSDictionary*)responseObject;
    return [dict dictionaryForKey:@"response"];
}

- (NSArray*)findResponseArray:(id)responseObject {
    if (![responseObject isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    NSDictionary *dict = (NSDictionary*)responseObject;
    return [dict arrayForKey:@"response"];
}

/* shared instance */

+ (PAPagantis*)sharedInstance {
    static PAPagantis *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[PAPagantis alloc] init];
    });
    return instance;
}

/* API keys */

- (void)setApiKey:(NSString*)apiKey {
    self.theApiKey = apiKey;
}

- (void)setSignatureKey:(NSString*)signatureKey {
    self.theSignatureKey = signatureKey;
}

- (void)setAccountId:(NSString*)accountId {
    self.theAccountId = accountId;
}

/* charges */

- (PAWebViewController *)webViewControllerToCreateCharge:(PACreateChargeRequest *)chargeRequest progress:(WebViewControllerProgressBlock)progress completion:(WebViewControllerCompletionBlock)completion {
    
    NSString *orderIdentifier = chargeRequest.orderIdentifier;
    if (!orderIdentifier) {
        orderIdentifier = [PAUtils nonce];
    }
    NSString *amount = [NSString stringWithFormat:@"%zd", chargeRequest.amount];
    NSString *currency = chargeRequest.currency;
    NSString *description = chargeRequest.orderDescription;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"SHA1"                 forKey:@"auth_method"];
    [params setObject:orderIdentifier         forKey:@"order_id"];
    [params setObject:amount                  forKey:@"amount"];
    [params setObject:currency                forKey:@"currency"];
    [params setObject:description             forKey:@"description"];
    [params setObject:@"http://localhost/ok"  forKey:@"ok_url"];
    [params setObject:@"http://localhost/nok" forKey:@"nok_url"];
    [params setObject:self.theAccountId       forKey:@"account_id"];
    
    NSMutableString *baseString = [[NSMutableString alloc] initWithString:@"e369441d71db8f91"];
    [baseString appendString:[params stringForKey:@"account_id"]];
    [baseString appendString:[params stringForKey:@"order_id"]];
    [baseString appendString:[params stringForKey:@"amount"]];
    [baseString appendString:[params stringForKey:@"currency"]];
    [baseString appendString:[params stringForKey:@"auth_method"]];
    [baseString appendString:[params stringForKey:@"ok_url"]];
    [baseString appendString:[params stringForKey:@"nok_url"]];
    
    NSData *signatureData = [PAUtils sha1:[baseString dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *signature = [PAUtils hexString:signatureData];
    [params setObject:signature forKey:@"signature"];
    
    PAWebViewController *vc = [[PAWebViewController alloc] initWithParams:params];
    vc.progressBlock = progress;
    vc.completionBlock = completion;
    return vc;
}

- (void)findChargeWithIdentifier:(NSString*)identifier completion:(ChargeCompletionBlock)completion {
    
    AFHTTPRequestOperationManager *manager = [self manager];
    
    NSString *urlString = [self urlWithPath:[@"/charges/" stringByAppendingString:identifier]];
    AFHTTPRequestOperation *operation = [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (completion) {
            NSDictionary *response = [self findResponseDictionary:responseObject];
            if (!response) {
                completion([self errorWithMessage:@"Unexpected server response"], nil);
                return;
            }
            
            PACharge *charge = [PACharge chargeWithDictionary:response];
            completion(nil, charge);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion([self errorFromRequestOperation:operation withError:error], nil);
        }
    }];
    operation.responseSerializer = [[AFJSONResponseSerializer alloc] init];
    [operation start];
    
}

- (void)findCharges:(NSInteger)page completion:(ArrayCompletionBlock)completion {
    
    AFHTTPRequestOperationManager *manager = [self manager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    
    NSString *urlString = [self urlWithPath:@"/charges"];
    AFHTTPRequestOperation *operation = [manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (completion) {
            NSArray *response = [self findResponseArray:responseObject];
            if (!response) {
                completion([self errorWithMessage:@"Unexpected server response"], nil);
                return;
            }
            
            NSMutableArray *objects = [[NSMutableArray alloc] initWithCapacity:response.count];
            for (NSDictionary *dict in response) {
                PACharge *charge = [PACharge chargeWithDictionary:dict];
                [objects addObject:charge];
            }
            completion(nil, objects);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion([self errorFromRequestOperation:operation withError:error], nil);
        }
    }];
    operation.responseSerializer = [[AFJSONResponseSerializer alloc] init];
    [operation start];
}

- (void)refundCharge:(PACreateRefundRequest*)refundRequest completion:(ChargeCompletionBlock)completion {
    NSString *identifier = refundRequest.chargeIdentifier;
    
    AFHTTPRequestOperationManager *manager = [self manager];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSString stringWithFormat:@"%zd", refundRequest.amount] forKey:@"amount"];
    
    NSString *urlString = [self urlWithPath:[NSString stringWithFormat:@"/charges/%@/refunds", identifier]];
    AFHTTPRequestOperation *operation = [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (completion) {
            NSDictionary *response = [self findResponseDictionary:responseObject];
            if (!response) {
                completion([self errorWithMessage:@"Unexpected server response"], nil);
                return;
            }
            
            PACharge *charge = [PACharge chargeWithDictionary:response];
            completion(nil, charge);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion([self errorFromRequestOperation:operation withError:error], nil);
        }
    }];
    operation.responseSerializer = [[AFJSONResponseSerializer alloc] init];
    [operation start];
}


/* customers */

- (void)createCustomer:(PACreateCustomerRequest*)customerRequest completion:(CustomerCompletionBlock)completion {
    
    AFHTTPRequestOperationManager *manager = [self manager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:customerRequest.email     forKey:@"customer[email]"];
    [parameters setObject:customerRequest.name      forKey:@"customer[name]"];
    [parameters setObject:customerRequest.reference forKey:@"customer[reference]"];
    
    NSString *urlString = [self urlWithPath:@"/customers"];
    AFHTTPRequestOperation *operation = [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (completion) {
            NSDictionary *response = [self findResponseDictionary:responseObject];
            if (!response) {
                completion([self errorWithMessage:@"Unexpected server response"], nil);
                return;
            }
            
            PACustomer *customer = [PACustomer customerWithDictionary:response];
            completion(nil, customer);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion([self errorFromRequestOperation:operation withError:error], nil);
        }
    }];
    operation.responseSerializer = [[AFJSONResponseSerializer alloc] init];
    [operation start];
}

- (void)findCustomerWithIdentifier:(NSString*)identifier completion:(CustomerCompletionBlock)completion {
    
    AFHTTPRequestOperationManager *manager = [self manager];
    
    NSString *urlString = [self urlWithPath:[@"/customers/" stringByAppendingString:identifier]];
    AFHTTPRequestOperation *operation = [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (completion) {
            NSDictionary *response = [self findResponseDictionary:responseObject];
            if (!response) {
                completion([self errorWithMessage:@"Unexpected server response"], nil);
                return;
            }
            
            PACustomer *customer = [PACustomer customerWithDictionary:response];
            completion(nil, customer);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion([self errorFromRequestOperation:operation withError:error], nil);
        }
    }];
    operation.responseSerializer = [[AFJSONResponseSerializer alloc] init];
    [operation start];
}

- (void)findCustomers:(NSInteger)page completion:(ArrayCompletionBlock)completion {
    
    AFHTTPRequestOperationManager *manager = [self manager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    
    NSString *urlString = [self urlWithPath:@"/customers"];
    AFHTTPRequestOperation *operation = [manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (completion) {
            NSArray *response = [self findResponseArray:responseObject];
            if (!response) {
                completion([self errorWithMessage:@"Unexpected server response"], nil);
                return;
            }
            
            NSMutableArray *objects = [[NSMutableArray alloc] initWithCapacity:response.count];
            for (NSDictionary *dict in response) {
                PACustomer *customer = [PACustomer customerWithDictionary:dict];
                [objects addObject:customer];
            }
            completion(nil, objects);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion([self errorFromRequestOperation:operation withError:error], nil);
        }
    }];
    operation.responseSerializer = [[AFJSONResponseSerializer alloc] init];
    [operation start];

}

/* plans */

- (void)createPlan:(PACreatePlanRequest*)planRequest completion:(PlanCompletionBlock)completion; {
    
    AFHTTPRequestOperationManager *manager = [self manager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:planRequest.amount]     forKey:@"plan[amount]"];
    [parameters setObject:planRequest.currency                                forKey:@"plan[currency]"];
    [parameters setObject:planRequest.name                                    forKey:@"plan[name]"];
    [parameters setObject:[NSNumber numberWithInteger:planRequest.periodLong] forKey:@"plan[period_long]"];
    [parameters setObject:planRequest.periodCycle                             forKey:@"plan[period_cycle]"];
    
    NSString *urlString = [self urlWithPath:@"/plans"];
    AFHTTPRequestOperation *operation = [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (completion) {
            NSDictionary *response = [self findResponseDictionary:responseObject];
            if (!response) {
                completion([self errorWithMessage:@"Unexpected server response"], nil);
                return;
            }
            
            PAPlan *plan = [PAPlan planWithDictionary:response];
            completion(nil, plan);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion([self errorFromRequestOperation:operation withError:error], nil);
        }
    }];
    operation.responseSerializer = [[AFJSONResponseSerializer alloc] init];
    [operation start];
}

- (void)findPlanWithIdentifier:(NSString*)identifier completion:(PlanCompletionBlock)completion {
    
    AFHTTPRequestOperationManager *manager = [self manager];
    
    NSString *urlString = [self urlWithPath:[@"/plans/" stringByAppendingString:identifier]];
    AFHTTPRequestOperation *operation = [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (completion) {
            NSDictionary *response = [self findResponseDictionary:responseObject];
            if (!response) {
                completion([self errorWithMessage:@"Unexpected server response"], nil);
                return;
            }
            
            PAPlan *plan = [PAPlan planWithDictionary:response];
            completion(nil, plan);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion([self errorFromRequestOperation:operation withError:error], nil);
        }
    }];
    operation.responseSerializer = [[AFJSONResponseSerializer alloc] init];
    [operation start];
}

- (void)findPlans:(NSInteger)page completion:(ArrayCompletionBlock)completion {
    
    AFHTTPRequestOperationManager *manager = [self manager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    
    NSString *urlString = [self urlWithPath:@"/plans"];
    AFHTTPRequestOperation *operation = [manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (completion) {
            NSArray *response = [self findResponseArray:responseObject];
            if (!response) {
                completion([self errorWithMessage:@"Unexpected server response"], nil);
                return;
            }
            
            NSMutableArray *objects = [[NSMutableArray alloc] initWithCapacity:response.count];
            for (NSDictionary *dict in response) {
                PAPlan *plan = [PAPlan planWithDictionary:dict];
                [objects addObject:plan];
            }
            completion(nil, objects);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion([self errorFromRequestOperation:operation withError:error], nil);
        }
    }];
    operation.responseSerializer = [[AFJSONResponseSerializer alloc] init];
    [operation start];
}

/* cards */

- (PAWebViewController *)webViewControllerToTokenizeCard:(PATokenizeCardRequest *)tokenizeRequest progress:(WebViewControllerProgressBlock)progress completion:(WebViewControllerCompletionBlock)completion {
    
    NSString *orderIdentifier = tokenizeRequest.orderIdentifier;
    if (!orderIdentifier) {
        orderIdentifier = [PAUtils nonce];
    }
    NSString *userIdentifier = tokenizeRequest.userIdentifier;
    if (!userIdentifier) {
        userIdentifier = [PAUtils nonce];
    }
    NSString *amount = [NSString stringWithFormat:@"%zd", tokenizeRequest.amount];
    NSString *currency = tokenizeRequest.currency;
    NSString *description = tokenizeRequest.orderDescription;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"TOKEN"                forKey:@"transaction_type"];
    [params setObject:@"SHA1"                 forKey:@"auth_method"];
    [params setObject:orderIdentifier         forKey:@"order_id"];
    [params setObject:userIdentifier          forKey:@"user_id"];
    [params setObject:amount                  forKey:@"amount"];
    [params setObject:currency                forKey:@"currency"];
    [params setObject:description             forKey:@"description"];
    [params setObject:@"http://localhost/ok"  forKey:@"ok_url"];
    [params setObject:@"http://localhost/nok" forKey:@"nok_url"];
    [params setObject:self.theAccountId       forKey:@"account_id"];
    
    NSMutableString *baseString = [[NSMutableString alloc] initWithString:@"e369441d71db8f91"];
    [baseString appendString:[params stringForKey:@"account_id"]];
    [baseString appendString:[params stringForKey:@"order_id"]];
    [baseString appendString:[params stringForKey:@"amount"]];
    [baseString appendString:[params stringForKey:@"currency"]];
    [baseString appendString:[params stringForKey:@"auth_method"]];
    [baseString appendString:[params stringForKey:@"ok_url"]];
    [baseString appendString:[params stringForKey:@"nok_url"]];
    
    NSData *signatureData = [PAUtils sha1:[baseString dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *signature = [PAUtils hexString:signatureData];
    [params setObject:signature forKey:@"signature"];
    
    PAWebViewController *vc = [[PAWebViewController alloc] initWithParams:params];
    vc.progressBlock = progress;
    vc.completionBlock = completion;
    return vc;
}

/* subscriptions */

- (PAWebViewController *)webViewControllerToCreateSubscription:(PACreateSubscriptionRequest *)subscriptionRequest
                                                      progress:(WebViewControllerProgressBlock)progress
                                                    completion:(WebViewControllerCompletionBlock)completion {
    
    NSString *orderIdentifier = subscriptionRequest.orderIdentifier;
    if (!orderIdentifier) {
        orderIdentifier = [PAUtils nonce];
    }
    NSString *userIdentifier = subscriptionRequest.userIdentifier;
    if (!userIdentifier) {
        userIdentifier = [PAUtils nonce];
    }
    NSString *planIdentifier = subscriptionRequest.planIdentifier;
    if (!planIdentifier) {
        // TODO: error
    }
    NSString *amount = [NSString stringWithFormat:@"%zd", subscriptionRequest.amount];
    NSString *currency = subscriptionRequest.currency;
    NSString *description = subscriptionRequest.orderDescription;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"SUBSCRIPTION"         forKey:@"operation"];
    [params setObject:@"SHA1"                 forKey:@"auth_method"];
    [params setObject:orderIdentifier         forKey:@"order_id"];
    [params setObject:userIdentifier          forKey:@"user_id"];
    [params setObject:planIdentifier          forKey:@"plan_id"];
    [params setObject:amount                  forKey:@"amount"];
    [params setObject:currency                forKey:@"currency"];
    [params setObject:description             forKey:@"description"];
    [params setObject:@"http://localhost/ok"  forKey:@"ok_url"];
    [params setObject:@"http://localhost/nok" forKey:@"nok_url"];
    [params setObject:self.theAccountId       forKey:@"account_id"];
    
    NSMutableString *baseString = [[NSMutableString alloc] initWithString:@"e369441d71db8f91"];
    [baseString appendString:[params stringForKey:@"account_id"]];
    [baseString appendString:[params stringForKey:@"order_id"]];
    [baseString appendString:[params stringForKey:@"amount"]];
    [baseString appendString:[params stringForKey:@"currency"]];
    [baseString appendString:[params stringForKey:@"auth_method"]];
    [baseString appendString:[params stringForKey:@"ok_url"]];
    [baseString appendString:[params stringForKey:@"nok_url"]];
    
    NSData *signatureData = [PAUtils sha1:[baseString dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *signature = [PAUtils hexString:signatureData];
    [params setObject:signature forKey:@"signature"];
    
    PAWebViewController *vc = [[PAWebViewController alloc] initWithParams:params];
    vc.progressBlock = progress;
    vc.completionBlock = completion;
    return vc;
}

- (void)findSubscriptions:(NSInteger)page completion:(ArrayCompletionBlock)completion {
    AFHTTPRequestOperationManager *manager = [self manager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    
    NSString *urlString = [self urlWithPath:@"/subscriptions"];
    AFHTTPRequestOperation *operation = [manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (completion) {
            NSArray *response = [self findResponseArray:responseObject];
            if (!response) {
                completion([self errorWithMessage:@"Unexpected server response"], nil);
                return;
            }
            
            NSMutableArray *objects = [[NSMutableArray alloc] initWithCapacity:response.count];
            for (NSDictionary *dict in response) {
                PASubscription *subscription = [PASubscription subscriptionWithDictionary:dict];
                [objects addObject:subscription];
            }
            completion(nil, objects);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion([self errorFromRequestOperation:operation withError:error], nil);
        }
    }];
    operation.responseSerializer = [[AFJSONResponseSerializer alloc] init];
    [operation start];
}

- (void)findSubscriptionWithIdentifier:(NSString*)identifier completion:(SubscriptionCompletionBlock)completion {
    AFHTTPRequestOperationManager *manager = [self manager];
    
    NSString *urlString = [self urlWithPath:[@"/subscriptions/" stringByAppendingString:identifier]];
    AFHTTPRequestOperation *operation = [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (completion) {
            NSDictionary *response = [self findResponseDictionary:responseObject];
            if (!response) {
                completion([self errorWithMessage:@"Unexpected server response"], nil);
                return;
            }
            
            PASubscription *subscription = [PASubscription subscriptionWithDictionary:response];
            completion(nil, subscription);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion([self errorFromRequestOperation:operation withError:error], nil);
        }
    }];
    operation.responseSerializer = [[AFJSONResponseSerializer alloc] init];
    [operation start];
}

/* payment requests */

- (void)createPaymentRequest:(PACreatePaymentRequest*)paymentRequest completion:(PaymentRequestCompletionBlock)completion {
    AFHTTPRequestOperationManager *manager = [self manager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:paymentRequest.orderIdentifier forKey:@"payment_request[order_id]"];
    [parameters setObject:[NSString stringWithFormat:@"%zd", paymentRequest.amount] forKey:@"payment_request[amount]"];
    [parameters setObject:paymentRequest.currency forKey:@"payment_request[currency]"];
    [parameters setObject:paymentRequest.okURL forKey:@"payment_request[ok_url]"];
    [parameters setObject:paymentRequest.nokURL forKey:@"payment_request[nok_url]"];
    
    // TODO: custom fields
    
    NSString *urlString = [self urlWithPath:@"/payment_requests"];
    AFHTTPRequestOperation *operation = [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (completion) {
            NSDictionary *response = [self findResponseDictionary:responseObject];
            if (!response) {
                completion([self errorWithMessage:@"Unexpected server response"], nil);
                return;
            }
            
            PAPaymentRequest *payment = [PAPaymentRequest paymentRequestWithDictionary:response];
            completion(nil, payment);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion([self errorFromRequestOperation:operation withError:error], nil);
        }
    }];
    operation.responseSerializer = [[AFJSONResponseSerializer alloc] init];
    [operation start];
}

- (void)findPaymentRequests:(NSInteger)page completion:(ArrayCompletionBlock)completion {
    AFHTTPRequestOperationManager *manager = [self manager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    
    NSString *urlString = [self urlWithPath:@"/payment_requests"];
    AFHTTPRequestOperation *operation = [manager GET:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (completion) {
            NSArray *response = [self findResponseArray:responseObject];
            if (!response) {
                completion([self errorWithMessage:@"Unexpected server response"], nil);
                return;
            }
            
            NSMutableArray *objects = [[NSMutableArray alloc] initWithCapacity:response.count];
            for (NSDictionary *dict in response) {
                PAPaymentRequest *paymentRequest = [PAPaymentRequest paymentRequestWithDictionary:dict];
                [objects addObject:paymentRequest];
            }
            completion(nil, objects);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion([self errorFromRequestOperation:operation withError:error], nil);
        }
    }];
    operation.responseSerializer = [[AFJSONResponseSerializer alloc] init];
    [operation start];
}

- (void)findPaymentRequestWithIdentifier:(NSString*)identifier completion:(PaymentRequestCompletionBlock)completion {
    AFHTTPRequestOperationManager *manager = [self manager];
    
    NSString *urlString = [self urlWithPath:[@"/payment_requests/" stringByAppendingString:identifier]];
    AFHTTPRequestOperation *operation = [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (completion) {
            NSDictionary *response = [self findResponseDictionary:responseObject];
            if (!response) {
                completion([self errorWithMessage:@"Unexpected server response"], nil);
                return;
            }
            
            PAPaymentRequest *paymentRequest = [PAPaymentRequest paymentRequestWithDictionary:response];
            completion(nil, paymentRequest);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion([self errorFromRequestOperation:operation withError:error], nil);
        }
    }];
    operation.responseSerializer = [[AFJSONResponseSerializer alloc] init];
    [operation start];
}

- (void)cancelPaymentRequestWithIdentifier:(NSString*)identifier completion:(PaymentRequestCompletionBlock)completion {
    AFHTTPRequestOperationManager *manager = [self manager];
    
    NSString *urlString = [self urlWithPath:[@"/payment_requests/" stringByAppendingString:identifier]];
    AFHTTPRequestOperation *operation = [manager DELETE:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (completion) {
            NSDictionary *response = [self findResponseDictionary:responseObject];
            if (!response) {
                completion([self errorWithMessage:@"Unexpected server response"], nil);
                return;
            }
            
            PAPaymentRequest *paymentRequest = [PAPaymentRequest paymentRequestWithDictionary:response];
            completion(nil, paymentRequest);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion([self errorFromRequestOperation:operation withError:error], nil);
        }
    }];
    operation.responseSerializer = [[AFJSONResponseSerializer alloc] init];
    [operation start];
}


@end
