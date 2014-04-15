//
//  PAListingController.h
//  Pagantis
//
//  Created by Alberto Gimeno Brieba on 4/15/14.
//  Copyright (c) 2014 Pagantis - TPS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PAListingController;

typedef void (^CellBlock)(UITableViewCell *cell, id result);
typedef void (^LoadBlock)(PAListingController *controller);

@interface PAListingController : UITableViewController

@property (nonatomic, strong) NSArray *results;
@property (nonatomic, copy) CellBlock cellBlock;
@property (nonatomic, copy) LoadBlock loadBlock;

- (void)showActivityIndicator;

- (void)showActivityIndicatorWithStyle:(UIActivityIndicatorViewStyle)style;

- (void)hideActivityIndicator;

@end
