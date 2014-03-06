//
//  PAAppDelegate.m
//  Pagantis
//
//  Created by Alberto Gimeno Brieba on 2/24/14.
//  Copyright (c) 2014 Pagantis - TPS. All rights reserved.
//

#import "PAAppDelegate.h"
#import "PAPagantis.h"
#import "PAHomeViewController.h"

@implementation PAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[PAPagantis sharedInstance] setApiKey:@"xxxx"];
    [[PAPagantis sharedInstance] setAccountId:@"xxxx"];
    [[PAPagantis sharedInstance] setSignatureKey:@"xxxx"];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    PAHomeViewController *vc = [[PAHomeViewController alloc] init];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nc;
    [self.window makeKeyAndVisible];
    
    /*
    PACreateCustomerRequest *customerRequest = [[PACreateCustomerRequest alloc] init];
    customerRequest.name = @"John Snow";
    customerRequest.email = @"john@example.com";
    customerRequest.reference = @"ref_john";
    [[PAPagantis sharedInstance] createCustomer:customerRequest completion:^(NSError *error, PACustomer *customer) {
        
        if (error) {
            NSLog(@"error %@", error);
            return;
        }
        
        NSLog(@"name %@", customer.name);
        NSLog(@"email %@", customer.email);
        NSLog(@"reference %@", customer.reference);
        NSLog(@"id %@", customer.identifier);
        
    }];
     */
    
    /*
    [[PAPagantis sharedInstance] findCustomers:1 completion:^(NSError *error, NSArray *customers) {
        
        if (error) {
            NSLog(@"error %@", error);
            return;
        }
        
        for (PACustomer *customer in customers) {
            NSLog(@"---------");
            NSLog(@"name %@", customer.name);
            NSLog(@"email %@", customer.email);
            NSLog(@"reference %@", customer.reference);
            NSLog(@"id %@", customer.identifier);
        }

    }];
     */
    
    /*
    [[PAPagantis sharedInstance] findCustomerWithIdentifier:@"cus_c252e8ab8b20811ffd6cfbbd0c11af69" completion:^(NSError *error, PACustomer *customer) {
        
        if (error) {
            NSLog(@"error %@", error);
            return;
        }
        
        NSLog(@"name %@", customer.name);
        NSLog(@"email %@", customer.email);
        NSLog(@"reference %@", customer.reference);
        NSLog(@"id %@", customer.identifier);
    }];
     */
    
    /*
    PACreatePlanRequest *planRequest = [[PACreatePlanRequest alloc] init];
    planRequest.name = @"Bronze plan";
    planRequest.amount = 4999;
    planRequest.currency = @"EUR";
    planRequest.periodLong = 1;
    planRequest.periodCycle = @"month";
    [[PAPagantis sharedInstance] createPlan:planRequest completion:^(NSError *error, PAPlan *plan) {
        
        if (error) {
            NSLog(@"error %@", error);
            return;
        }
        
        NSLog(@"name %@", plan.name);
        NSLog(@"id %@", plan.identifier);
        
    }];
     */
    
    /*
    [[PAPagantis sharedInstance] findPlans:1 completion:^(NSError *error, NSArray *objects) {
        if (error) {
            NSLog(@"error %@", error);
            return;
        }
        
        for (PAPlan *plan in objects) {
            NSLog(@"----------");
            NSLog(@"name %@", plan.name);
            NSLog(@"id %@", plan.identifier);
        }
    }];
     */
    
    /*
    [[PAPagantis sharedInstance] findPlanWithIdentifier:@"pla_a422185ba306983fb8c259ac35c40929" completion:^(NSError *error, PAPlan *plan) {
        if (error) {
            NSLog(@"error %@", error);
            return;
        }
        
        NSLog(@"name %@", plan.name);
        NSLog(@"id %@", plan.identifier);
    }];
     */
    
    /*
    [[PAPagantis sharedInstance] findCharges:1 completion:^(NSError *error, NSArray *charges) {
        if (error) {
            NSLog(@"error %@", error);
            return;
        }
        
        NSLog(@"objects %d", charges.count);
        for (PACharge *charge in charges) {
            NSLog(@"charge %@ %@", charge.orderDescription, charge.identifier);
        }
    }];
     */
    
    /*
    [[PAPagantis sharedInstance] findChargeWithIdentifier:@"cha_f54899832a0d1f1a4eb6be78aa63755c" completion:^(NSError *error, PACharge *charge) {
        if (error) {
            NSLog(@"error %@", error);
            return;
        }
        
        NSLog(@"amount %zd", charge.amount);
        NSLog(@"refunded %@", charge.refunded?@"yes":@"no");
        for (PARefund *refund in charge.refunds) {
            NSLog(@"refund %zd", refund.amount);
        }
    }];
     */
    
    /*
    PACreateRefundRequest *refund = [[PACreateRefundRequest alloc] init];
    refund.chargeIdentifier = @"cha_f54899832a0d1f1a4eb6be78aa63755c";
    refund.amount = 10;
    [[PAPagantis sharedInstance] refundCharge:refund completion:^(NSError *error, PACharge *charge) {
        if (error) {
            NSLog(@"error %@", error);
            return;
        }
        
        NSLog(@"objects %@", charge.refunds);
    }];
     */
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
