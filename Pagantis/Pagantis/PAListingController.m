//
//  PAListingController.m
//  Pagantis
//
//  Created by Alberto Gimeno Brieba on 4/15/14.
//  Copyright (c) 2014 Pagantis - TPS. All rights reserved.
//

#import "PAListingController.h"

@interface PAListingController ()

@end

@implementation PAListingController

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
    
    self.loadBlock(self);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    id result = self.results[indexPath.row];
    self.cellBlock(cell, result);
    
    return cell;
}

- (void)showActivityIndicator {
    [self showActivityIndicatorWithStyle:UIActivityIndicatorViewStyleWhiteLarge];
}

- (void)showActivityIndicatorWithStyle:(UIActivityIndicatorViewStyle)style {
    CGRect frame = self.view.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    
    UIView* view = [[UIView alloc] initWithFrame:frame];
    view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    view.backgroundColor = [UIColor darkGrayColor];
    view.layer.opacity = 0.5;
    view.tag = 1001;
    [self.view addSubview:view];
    
    UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
    indicator.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin
    | UIViewAutoresizingFlexibleRightMargin
    | UIViewAutoresizingFlexibleTopMargin
    | UIViewAutoresizingFlexibleBottomMargin;
    indicator.tag = 1002;
    indicator.center = view.center;
    [indicator startAnimating];
    [self.view addSubview:indicator];
}

- (void)hideActivityIndicator {
    [[self.view viewWithTag:1001] removeFromSuperview];
    [[self.view viewWithTag:1002] removeFromSuperview];
}

@end
