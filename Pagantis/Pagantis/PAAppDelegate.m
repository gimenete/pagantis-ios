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
    
    [[PAPagantis sharedInstance] findSubscriptions:1 completion:^(NSError *error, NSArray *objects) {
        if (error) {
            NSLog(@"error %@", error);
            return;
        }
        
        NSLog(@"subscriptions %zd", objects.count);
        for (PASubscription *subscription in objects) {
            NSLog(@"identifier %@", subscription.identifier);
            NSLog(@"status %@", subscription.status);
            NSLog(@"customer %@ %@", subscription.customer.name, subscription.customer.email);
            NSLog(@"plan %@", subscription.plan.name);
            NSLog(@"");
        }
    }];
    
    /*
    PACreatePaymentRequest *paymentRequest = [[PACreatePaymentRequest alloc] init];
    paymentRequest.orderIdentifier = @"CPM1234";
    paymentRequest.amount = 1000;
    paymentRequest.currency = @"EUR";
    paymentRequest.okURL = @"http://example.com/ok";
    paymentRequest.nokURL = @"http://example.com/nok";
    [[PAPagantis sharedInstance] createPaymentRequest:paymentRequest completion:^(NSError *error, PAPaymentRequest *paymentRequest) {
        if (error) {
            NSLog(@"error %@", error);
            return;
        }
        
        NSLog(@"identifier %@", paymentRequest.identifier);
        NSLog(@"activities %zd", paymentRequest.activities.count);
        for (PAActivity *activity in paymentRequest.activities) {
            NSLog(@"activity %@", activity.activityType);
        }
    }];
    */
    
    /*
    [[PAPagantis sharedInstance] findPaymentRequestWithIdentifier:@"pay_2b99a09ee5bc2b22a75b8e87ce4813ee" completion:^(NSError *error, PAPaymentRequest *paymentRequest) {
        if (error) {
            NSLog(@"error %@", error);
            return;
        }
        
        NSLog(@"identifier %@", paymentRequest.identifier);
        NSLog(@"activities %zd", paymentRequest.activities.count);
        for (PAActivity *activity in paymentRequest.activities) {
            NSLog(@"activity %@", activity.activityType);
        }
    }];
     */
    
    /*
    [[PAPagantis sharedInstance] cancelPaymentRequestWithIdentifier:@"pay_2b99a09ee5bc2b22a75b8e87ce4813ee" completion:^(NSError *error, PAPaymentRequest *paymentRequest) {
        if (error) {
            NSLog(@"error %@", error);
            return;
        }
        
        NSLog(@"identifier %@", paymentRequest.identifier);
        NSLog(@"activities %zd", paymentRequest.activities.count);
        for (PAActivity *activity in paymentRequest.activities) {
            NSLog(@"activity %@", activity.activityType);
        }
    }];
     */

    /*
    [[PAPagantis sharedInstance] findPaymentRequests:1 completion:^(NSError *error, NSArray *objects) {
        if (error) {
            NSLog(@"error %@", error);
            return;
        }
        
        NSLog(@"payment requests %zd", objects.count);
        for (PAPaymentRequest *paymentRequest in objects) {
            NSLog(@"identifier %@", paymentRequest.identifier);
            NSLog(@"activities %zd", paymentRequest.activities.count);
            for (PAActivity *activity in paymentRequest.activities) {
                NSLog(@"activity %@", activity.activityType);
            }
            NSLog(@"");
        }
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
