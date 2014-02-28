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

typedef void(^WebViewControllerCompletionBlock)(BOOL success);
typedef void(^WebViewControllerProgressBlock)(PAWebViewControllerProgress progress);

@interface PAWebViewController : UIViewController

@property (nonatomic, copy) WebViewControllerCompletionBlock completionBlock;
@property (nonatomic, copy) WebViewControllerProgressBlock progressBlock;

- (id)initWithParams:(NSDictionary*)params;

@end
