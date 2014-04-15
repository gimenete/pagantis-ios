//
//  PAHomeViewController.m
//  Pagantis
//
//  Created by Alberto Gimeno Brieba on 2/28/14.
//  Copyright (c) 2014 Pagantis - TPS. All rights reserved.
//

#import "PAHomeViewController.h"
#import "PAPagantis.h"
#import "PAListingController.h"

@interface PAHomeViewController ()

@end

@implementation PAHomeViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
    return 3;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Actions with WebViews";
    } else {
        return @"Listings";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Charge";
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"Tokenize";
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"Subscription";
        }
    } else {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Plans";
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"Charges";
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"Customers";
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
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
            
        } else if (indexPath.row == 1) {
            
            PATokenizeCardRequest *tokenize = [[PATokenizeCardRequest alloc] init];
            tokenize.currency = @"EUR";
            tokenize.amount = 100;
            tokenize.orderDescription = @"Precio de alta";
            
            UINavigationController *nc = [[UINavigationController alloc] init];
            
            PAWebViewController *vc = [[PAPagantis sharedInstance] webViewControllerToTokenizeCard:tokenize progress:^(PAWebViewController *webViewController, PAWebViewControllerProgress progress) {
                if (progress == PAWebViewControllerLoading) {
                    NSLog(@"loading...");
                } else if (progress == PAWebViewControllerLoaded) {
                    NSLog(@"loaded");
                    [webViewController hideActivityIndicator];
                }
            } completion:^(BOOL success) {
                // [self dismissPresentedViewController:nil];
                NSLog(@"completed... %@", success?@"yes":@"no");
            }];
            
            [vc showActivityIndicator];
            vc.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissPresentedViewController:)];
            
            nc.viewControllers = @[vc];
            nc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            nc.modalPresentationStyle = UIModalPresentationFormSheet;
            [self presentViewController:nc animated:YES completion:nil];
            
        } else if (indexPath.row == 2) {
            
            PACreateSubscriptionRequest *subscription = [[PACreateSubscriptionRequest alloc] init];
            subscription.currency = @"EUR";
            subscription.amount = 100;
            subscription.orderDescription = @"Recurrente";
            subscription.planIdentifier = @"pla_a422185ba306983fb8c259ac35c40929";
            
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
            
        }
    } else {
        
        if (indexPath.row == 0) {
            
            PAListingController *vc = [[PAListingController alloc] init];
            [vc setLoadBlock:^void(PAListingController *vc) {
                [vc showActivityIndicator];
                [[PAPagantis sharedInstance] findPlans:1 completion:^(NSError *error, NSArray *objects) {
                    [vc hideActivityIndicator];
                    if (error) {
                        [self showError:error inViewController:vc];
                        return;
                    }
                    vc.results = objects;
                    [vc.tableView reloadData];
                }];
            }];
            [vc setCellBlock:^void(UITableViewCell *cell, id result) {
                PAPlan *plan = (PAPlan*)result;
                cell.textLabel.text = plan.name;
            }];
            
            [self.navigationController pushViewController:vc animated:YES];
            
        } else if (indexPath.row == 1) {
                
            PAListingController *vc = [[PAListingController alloc] init];
            [vc setLoadBlock:^void(PAListingController *vc) {
                [vc showActivityIndicator];
                [[PAPagantis sharedInstance] findCharges:1 completion:^(NSError *error, NSArray *objects) {
                    [vc hideActivityIndicator];
                    if (error) {
                        [self showError:error inViewController:vc];
                        return;
                    }
                    vc.results = objects;
                    [vc.tableView reloadData];
                }];
            }];
            [vc setCellBlock:^void(UITableViewCell *cell, id result) {
                PACharge *charge = (PACharge*)result;
                cell.textLabel.text = [NSString stringWithFormat:@"%zd %@", charge.amount, charge.currency];
                cell.detailTextLabel.text = charge.identifier;
            }];
            
            [self.navigationController pushViewController:vc animated:YES];
            
        } else if (indexPath.row == 2) {
            
            PAListingController *vc = [[PAListingController alloc] init];
            [vc setLoadBlock:^void(PAListingController *vc) {
                [vc showActivityIndicator];
                [[PAPagantis sharedInstance] findCustomers:1 completion:^(NSError *error, NSArray *objects) {
                    [vc hideActivityIndicator];
                    if (error) {
                        [self showError:error inViewController:vc];
                        return;
                    }
                    vc.results = objects;
                    [vc.tableView reloadData];
                }];
            }];
            [vc setCellBlock:^void(UITableViewCell *cell, id result) {
                PACustomer *customer = (PACustomer*)result;
                if (customer.name && customer.email) {
                    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", customer.name, customer.email];
                } else if (customer.name) {
                    cell.textLabel.text = customer.name;
                } else if (customer.email) {
                    cell.textLabel.text = customer.email;
                } else {
                    cell.textLabel.text = customer.reference;
                }
                cell.detailTextLabel.text = customer.identifier;
            }];
            
            [self.navigationController pushViewController:vc animated:YES];
            
        } else if (indexPath.row == 3) {
            
            PAListingController *vc = [[PAListingController alloc] init];
            [vc setLoadBlock:^void(PAListingController *vc) {
                [vc showActivityIndicator];
                [[PAPagantis sharedInstance] findCustomers:1 completion:^(NSError *error, NSArray *objects) {
                    [vc hideActivityIndicator];
                    if (error) {
                        [self showError:error inViewController:vc];
                        return;
                    }
                    vc.results = objects;
                    [vc.tableView reloadData];
                }];
            }];
            [vc setCellBlock:^void(UITableViewCell *cell, id result) {
                PACustomer *customer = (PACustomer*)result;
                if (customer.name && customer.email) {
                    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", customer.name, customer.email];
                } else if (customer.name) {
                    cell.textLabel.text = customer.name;
                } else if (customer.email) {
                    cell.textLabel.text = customer.email;
                } else {
                    cell.textLabel.text = customer.reference;
                }
                cell.detailTextLabel.text = customer.identifier;
            }];
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    }
    
}

- (void)showError:(NSError*)error inViewController:(UIViewController*)vc {
    [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
}

- (void)dismissPresentedViewController:(id)sender {
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
