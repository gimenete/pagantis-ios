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

@interface PAPagantis ()

@property (nonatomic, strong) NSString *theApiKey;

@end

@implementation PAPagantis

/* Internal methods */

- (NSError*)errorFromRequestOperation:(AFHTTPRequestOperation*)operation withError:(NSError*)error {
    // TODO: parse response body for a more detailed error message
    return error;
}

- (NSError*)errorWithMessage:(NSString*)message {
    return [NSError errorWithDomain:@"com.pagantis"
                               code:400
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

/* charges */

- (void)findChargeWithIdentifier:(NSString*)identifier completion:(ChargeCompletionBlock)completion {
    
}

- (void)findCharges:(NSInteger)page completion:(ArrayCompletionBlock)completion {
    
}


/* customers */

- (void)createCustomerWithName:(NSString*)name email:(NSString*)email reference:(NSString*)reference completion:(CustomerCompletionBlock)completion {
    
    AFHTTPRequestOperationManager *manager = [self manager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:email     forKey:@"customer[email]"];
    [parameters setObject:name      forKey:@"customer[name]"];
    [parameters setObject:reference forKey:@"customer[reference]"];
    
    NSString *urlString = [self urlWithPath:@"/customers"];
    AFHTTPRequestOperation *operation = [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (completion) {
            if (![responseObject isKindOfClass:[NSDictionary class]]) {
                completion([self errorWithMessage:@"Unexpected server response"], nil);
                return;
            }
            
            NSDictionary *dict = (NSDictionary*)responseObject;
            NSDictionary *response = [dict dictionaryForKey:@"response"];
            
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
    
}

- (void)findCustomers:(NSInteger)page completion:(ArrayCompletionBlock)completion {
    
}

/* plans */

- (void)findPlanWithIdentifier:(NSString*)identifier completion:(PlanCompletionBlock)completion {
    
}

- (void)findPlans:(NSInteger)page completion:(ArrayCompletionBlock)completion {
    
}

@end
