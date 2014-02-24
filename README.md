Pagantis iOS SDK
================

Configuration
-------------

First of all, set your API key

    [[PAPagantis sharedInstance] setApiKey:@"YOUR_API_KEY"];
    

Customers
---------

Create a customer
    
    PAPagantis *pagantis = [PAPagantis sharedInstance];
    [pagantis createCustomerWithName:@"John Snow" email:@"john@example.com" reference:@"ref_john" completion:^(NSError *error, PACustomer *customer) {
        
        if (error) {
            NSLog(@"error %@", [error localizedDescription]);
            return;
        }
        
        NSLog(@"name %@", customer.name);
        NSLog(@"email %@", customer.email);
        NSLog(@"reference %@", customer.reference);
        NSLog(@"id %@", customer.identifier);
    }];
