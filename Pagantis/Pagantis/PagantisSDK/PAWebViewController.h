//
//  PASaleViewController.h
//  Pagantis
//
//  Created by Alberto Gimeno Brieba on 2/27/14.
//  Copyright (c) 2014 Pagantis - TPS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    PAWebViewControllerLoading,
    PAWebViewControllerLoaded,
} PAWebViewControllerProgress;

@class PAWebViewController;

typedef void(^WebViewControllerCompletionBlock)(BOOL success);
typedef void(^WebViewControllerProgressBlock)(PAWebViewController *webViewController, PAWebViewControllerProgress progress);

@interface PAWebViewController : UIViewController

@property (nonatomic, copy) WebViewControllerCompletionBlock completionBlock;
@property (nonatomic, copy) WebViewControllerProgressBlock progressBlock;

- (id)initWithParams:(NSDictionary*)params;

- (void)showActivityIndicator;

- (void)showActivityIndicatorWithStyle:(UIActivityIndicatorViewStyle)style;

- (void)hideActivityIndicator;

@end
