Pagantis iOS SDK
================

Configuration
-------------

First of all, configure the SDK

    [[PAPagantis sharedInstance] setApiKey:@"xxxx"];
    [[PAPagantis sharedInstance] setAccountId:@"xxxx"];
    [[PAPagantis sharedInstance] setSignatureKey:@"xxx"];
        

Customers
---------

Create a customer
    
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
