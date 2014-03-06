Pagantis iOS SDK
================

Installation
-------------

To install the SDK you can either download the source code of the latest release and copy the `PagantisSDK` folder to your project or install it using CocoaPods (coming soon). The minimal `Podfile` would be something like this:

    platform :ios, '6.0'
	pod 'PagantisSDK'
	
And then you run `pod install` in the command line an CocoaPods will download the latest SDK.


Configuration
-------------

First of all you need to configure the SDK. The best way to do that is in your `AppDelegate`. In the `- (BOOL)application:didFinishLaunchingWithOptions:` method.

	- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	    [[PAPagantis sharedInstance] setApiKey:@"xxxx"];
    	[[PAPagantis sharedInstance] setAccountId:@"xxxx"];
	    [[PAPagantis sharedInstance] setSignatureKey:@"xxx"];
	    
	    // Usual code here...
	}
	
You will find the parameters to configure the SDK in the [Configuration → API](https://bo.pagantis.com/api) section of the control panel.

Overview
--------

The SDK has a singleton object that you can always access anywhere using `[PAPagantis sharedInstance]`. You will need to import `#import "PAPagantis.h"` first.

Usually read-only operations can be done calling just one method in that singleton. For example retrieving the list of customers. Other operations, usually operations that modify data, require to create a `PA...Request` object. For example to create a customer you first create a `PACreateCustomerRequest` object, you configure it with the desired values and finally you call the `createCustomer:customerRequest completion:` method in the `PAPagantis` singleton.

Some operations at this moment for security reasons require to use a `UIViewController` that contains a `UIWebView` where the user puts his/her payment card information. The SDK provides methods to create these `UIViewController` in each case and the UI is minimal so you can configure how the screen is presented and dismissed.

The SDK offers a block-based API. Usually these blocks receive first an `NSError` that will be `nil` if everything went fine, and then more information about the operations such an `NSArray` of results or just a single object or a `BOOL` value indicating success or not. We are not using separate blocks for success and failure since many times there is shared code for both situations. For example if you want to hide an activity indicator or dismiss a `UIViewContorller` you need to do that in both cases.
        

Customers
---------

### Create a customer

To create a new customer you first create a `PACreateCustomerRequest` object, configure its values and then you call the `createCustomer:completion:` method. These are the parameters you can configure at this moment:

* `name` The name you want to give to this customer
* `email` The email address of this customer
* `reference` This is an identifier you should generate. It usually should be an internal reference in your databases so you can match this customer in the future with more data in your databases.

The completion block receives a `NSError` if something went wrong or `nil` if everything went fine, and a second object, a `PACustomer` object with the just created customer information. In this object you can get for example the `identifier` created by the backend.

Example:
    
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


### Finding customers

There is a simple method to find customers created previously. This method accepts one parameter that is the page number in the list of results. The completion block receives as first argument a `NSError` if something went wrong or `nil` otherwise. The second parameter is an `NSArray` of `PACustomer` objects.

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


### Find a customer by its identifier

If you wish to read the information of a customer and you know its identifier you can use this method. The only argument additionally to the completion block is the identifier of the customer. The completion block receives as first argument an `NSError` (that is `nil` if everything went fine) and as second argument it receives the `PACustomer` object containing the information of the desired customer.

Example:

    [[PAPagantis sharedInstance] findCustomerWithIdentifier:@"cus_c252e8ab8b20811aad6cfbbd0c00af69" completion:^(NSError *error, PACustomer *customer) {
        
        if (error) {
            NSLog(@"error %@", error);
            return;
        }
        
        NSLog(@"name %@", customer.name);
        NSLog(@"email %@", customer.email);
        NSLog(@"reference %@", customer.reference);
        NSLog(@"id %@", customer.identifier);
    }];

Plans
-----

### Create a plan

To create a plan you first create a `PACreatePlanRequest` object, fill it with the desired values and then call the `createPlan:completion:` method. The values you can configure are:

* `name` The name you want to give to this plan.
* `amount` The amount in cents that will be charged to the customer each cycle.
* `currency` The code of the currency in which you want to charge the customer
* `periodCycle` The unit in which the cycles are measured.
* `periodLong` The number of units of `periodCycle` that each cycle lasts.

Example:

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

### Find plans

To retrieve a list of plans you just call the `findPlans:completion:` method. The first argument is the page number of the results. In the completion block you will receive a `NSError` if something failed (`nil` otherwise) and a `NSArray` of `PAPlan` objects if the method succeed.

Example:

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

### Find a plan using its identifier

If you want to retrieve the information of a plan and you know its identifier you can call the `findPlanWithIdentifier:completion:` method passing the identifier as first argument. In the completion block you will receive a `PAPlan` object with the information of that plan or an `NSError` if something is not ok.

Example:

    [[PAPagantis sharedInstance] findPlanWithIdentifier:@"pla_b422185ba306983fd8c259ac35c40929" completion:^(NSError *error, PAPlan *plan) {
        if (error) {
            NSLog(@"error %@", error);
            return;
        }
        
        NSLog(@"name %@", plan.name);
        NSLog(@"id %@", plan.identifier);
    }];

Charges
-------

### Create a charge

To make a simple charge you first create a `PACreateChargeRequest` object and fill it with the desired. Then you call `webViewControllerToCreateCharge:progress:` that will give you a `PAWebViewController` to present to the user. You can read more about how to customize the `PAWebViewController` in another section of the documentation.

Example:

    PACreateChargeRequest *charge = [[PACreateChargeRequest alloc] init];
    charge.currency = @"EUR";
    charge.amount = 100;
    charge.orderDescription = @"Precio de alta";
    
    PAWebViewController *vc = [[PAPagantis sharedInstance] webViewControllerToCreateCharge:charge progress:^(PAWebViewController *webViewController, PAWebViewControllerProgress progress) {
        if (progress == PAWebViewControllerLoading) {
            NSLog(@"loading...");
        } else if (progress == PAWebViewControllerLoaded) {
            NSLog(@"loaded");
            [webViewController hideActivityIndicator];
        }
    } completion:^(BOOL success) {
        [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"completed %@", success?@"yes":@"no");
    }];
    
    [vc showActivityIndicator];
    [self.navigationController pushViewController:vc animated:YES];

### Finding charges:

To retrieve a list of charges you use the `findCharges:completion:` method. The first argument it receives is the page number of results. In the completion block you will receive a `NSError` if something went wrong (`nil` otherwise) and a `NSArray` of `PACharge` if the operation succeed.

Example:

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


### Find a charge by its identifier:

If you want to read the information about a charge and you know its identifier you can use this method. Just call `findChargeWithIdentifier:completion:` using the identifier you already know. In the completion block you will receive a `PACharge` object with the information of the charge or a `NSError` if something went wrong.

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

### Make a refund

You can refund a charge previously paid. You first create a `PACreateRefundRequest` object indicating the charge identifier and the amount you want to refund. The amount should be equal or lesser than the amount of the charge.

Example:

    PACreateRefundRequest *refund = [[PACreateRefundRequest alloc] init];
    refund.chargeIdentifier = @"cha_f54899832b0d2f1a4eb6be78aa63755c";
    refund.amount = 10;
    [[PAPagantis sharedInstance] refundCharge:refund completion:^(NSError *error, PACharge *charge) {
        if (error) {
            NSLog(@"error %@", error);
            return;
        }
        
        NSLog(@"objects %@", charge.refunds);
    }];


### Tokenize a card

At this moment to tokenize a card you always need to charge an amount of many. You can refund this charge inmediatly if you wish and in most cases the user won't even see the charge in their account movements.

This operation requires to present a `PAWebViewController`. But first of all you need to create a `PATokenizeCardRequest` with the details of the operation. You will define the `amount` of money that is going to be charged and in which `currency` and you need to put a description to the operation.

Example:

    PATokenizeCardRequest *tokenize = [[PATokenizeCardRequest alloc] init];
    tokenize.currency = @"EUR";
    tokenize.amount = 100;
    tokenize.orderDescription = @"Some useful description";
    
    PAWebViewController *vc = [[PAPagantis sharedInstance] webViewControllerToTokenizeCard:tokenize progress:^(PAWebViewController *webViewController, PAWebViewControllerProgress progress) {
        if (progress == PAWebViewControllerLoading) {
            NSLog(@"loading...");
        } else if (progress == PAWebViewControllerLoaded) {
            NSLog(@"loaded");
            [webViewController hideActivityIndicator];
        }
    } completion:^(BOOL success) {
        [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"completed %@", success?@"yes":@"no");
    }];
    
    [vc showActivityIndicator];
    [self.navigationController pushViewController:vc animated:YES];

Subscriptions
-------------

To subscribe a user to a subscription you first create a `PACreateSubscriptionRequest` object. You need to define a few parameters such as the identifier of the plan you are subscribing the user to, and then you call `webViewControllerToCreateSubscription:progress:`.

Example.

    PACreateSubscriptionRequest *subscription = [[PACreateSubscriptionRequest alloc] init];
    subscription.currency = @"EUR";
    subscription.amount = 100;
    subscription.orderDescription = @"Some useful description";
    subscription.planIdentifier = @"pla_a422185ba306983fc8c259ac35c40919";
    
    PAWebViewController *vc = [[PAPagantis sharedInstance] webViewControllerToCreateSubscription:subscription progress:^(PAWebViewController *webViewController, PAWebViewControllerProgress progress) {
        if (progress == PAWebViewControllerLoading) {
            NSLog(@"loading...");
        } else if (progress == PAWebViewControllerLoaded) {
            NSLog(@"loaded");
            [webViewController hideActivityIndicator];
        }
    } completion:^(BOOL success) {
        [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"completed %@", success?@"yes":@"no");
    }];
    
    [vc showActivityIndicator];
    [self.navigationController pushViewController:vc animated:YES];


Presenting and personalizing PAWebViewControllers
=================================
Some operations at this moment require to show a `PAWebViewController` that contains a `UIWebView` where the payment card information is filled. These `UIViewControllers` have a minimal UI intentionally so you can customize it.

### Presenting inside a UINavigationController

If you are already using a `UINavigationController` it is very easy to present the `PAWebViewController`. Just use the following line to present the screen

    [self.navigationController pushViewController:vc animated:YES];
    
And in the completion block pop the `PAWebViewController` this way:

    [self.navigationController popViewControllerAnimated:YES];

You can personalize the `navigationItem` of the `PAWebViewController` to put buttons on the left, on the right, as a `titleView`, etc.

### Presenting as a modal screen

If you want to present the screen modally the best way is to create a new `UINavigationController` and put the screen inside to finally present the `UINavigationController` modally. Since our new view controller is the first one inside the `UINavigationController` there is no back button and there is not a builtin way to dismiss the modally presented navigation controller. But this is easy to fix. In the following example we put a 'Close' button on the top-right corner.

Since `UIBarButtonItem` do not accept blocks we need to refer to a method in our own class and we need to dismiss the presented view controller in that method:

    - (void)dismissPresentedViewController:(id)sender {
	    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
	}

We will trigger this method when the `UIBarButtonItem` is tapped and also when the completion block is called. This is the rest of the code:

    PATokenizeCardRequest *tokenize = [[PATokenizeCardRequest alloc] init];
    tokenize.currency = @"EUR";
    tokenize.amount = 100;
    tokenize.orderDescription = @"Some useful description";
    
    UINavigationController *nc = [[UINavigationController alloc] init];
    
    PAWebViewController *vc = [[PAPagantis sharedInstance] webViewControllerToTokenizeCard:tokenize progress:^(PAWebViewController *webViewController, PAWebViewControllerProgress progress) {
        if (progress == PAWebViewControllerLoading) {
            NSLog(@"loading...");
        } else if (progress == PAWebViewControllerLoaded) {
            NSLog(@"loaded");
            [webViewController hideActivityIndicator];
        }
    } completion:^(BOOL success) {
        [self dismissPresentedViewController:nil];
        NSLog(@"completed... %@", success?@"yes":@"no");
    }];
    
    [vc showActivityIndicator];
    vc.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissPresentedViewController:)];
    
    nc.viewControllers = @[vc];
    // Change the transition style if you wish
    nc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    // Change the presentation style in an iPad
    nc.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:nc animated:YES completion:nil];



### Indicating progress

The methods that create a `PAWebViewController` accept a progress block as well as the usual completion block. In this progress block you will be notified of the progress of the operation. So this is a perfect place to, for example, show an activity indicator while the page is loading.

You can use any library such as `SVProgressHUD` or whatever you prefer. Nevertheless the `PAWebViewController` class has some utility methods that could be just what you want. These methods are:

	- (void)showActivityIndicator;
	
	- (void)showActivityIndicatorWithStyle:(UIActivityIndicatorViewStyle)style;
	
	- (void)hideActivityIndicator;

You can call `showActivityIndicator` or `showActivityIndicatorWithStyle:` as soon as you create the `PAWebViewController` and before presenting it. And then you should call `hideActivityIndicator` when the progress block is called when a value of `PAWebViewControllerLoaded`.

The progress block receives a reference to the `PAWebViewController` to simplify working with blocks so inside the block it is better to use the passed argument if you want to interact with the `PAWebViewController` (for example to hide the activity indicator).


Reference
=========

Currencies
----------

Some methods and classes require you to specifiy a currency. In this cases you need to pass a `NSString` with the currency code. The available currencies at this moment are:

* `EUR` for Euros.
* `USD` for US dollars.
* `GBP` for Great Britain Pounds.

Amounts
-------
Some methods and classes require to specify an amount of money. Amounts are always expressed in cents. So they are always an integer number. If you for example want to charge $100 you need to specify `amount = 10000`. Amounts are expressed in the currency indicated by you in a separate parameter.

Period cycles
-------------
When using plans some methods and classes require you to specify a unit in which the periods are measured. At this moment you can use:

* `month` for months


