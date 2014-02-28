//
//  PASaleViewController.m
//  Pagantis
//
//  Created by Alberto Gimeno Brieba on 2/27/14.
//  Copyright (c) 2014 Pagantis - TPS. All rights reserved.
//

#import "PAWebViewController.h"
#import "PAPagantis.h"
#import "PAUtils.h"
#import "NSDictionary+SanityChecks.h"

@interface PAWebViewController () <UIWebViewDelegate>

@property (nonatomic, strong) NSDictionary *postParams;
@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, assign) BOOL waitingToFinish;

@end

@implementation PAWebViewController

- (id)initWithParams:(NSDictionary*)params
{
    self = [super init];
    if (self) {
        self.postParams = params;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    self.webView = [[UIWebView alloc] init];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.webView.delegate = self;
    
    self.view = self.webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *bodyString = [PAUtils queryString:self.postParams];
    
    NSString *urlString = [[PAPagantis sharedInstance] urlWithPath:@"/sale"];
    urlString = @"https://psp.pagantis.com/2/sale";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
    [self.webView loadRequest:request];
    
    self.waitingToFinish = YES;
    if (self.progressBlock) {
        self.progressBlock(PAWebViewControllerLoading);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (self.waitingToFinish) {
        self.waitingToFinish = NO;
        if (self.progressBlock) {
            self.progressBlock(PAWebViewControllerLoaded);
        }
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if ([request.URL.description isEqualToString:@"http://localhost/ok"]) {
        
        if (self.completionBlock) {
            self.completionBlock(YES);
        }
        
    } else if ([request.URL.description isEqualToString:@"http://localhost/nok"]) {
        
        if (self.completionBlock) {
            self.completionBlock(NO);
        }
        
    }
    
    return YES;
}

@end
