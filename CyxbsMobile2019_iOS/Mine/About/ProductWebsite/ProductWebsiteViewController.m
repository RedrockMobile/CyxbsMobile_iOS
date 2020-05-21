//
//  ProductWebsiteViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/5/21.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "ProductWebsiteViewController.h"
#import <WebKit/WebKit.h>

@interface ProductWebsiteViewController ()

@end

@implementation ProductWebsiteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKWebViewConfiguration *webConfiguration = [WKWebViewConfiguration new];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds configuration:webConfiguration];
    NSString *urlStr = @"https://redrock.team/aboutus/";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [webView loadRequest:request];
    
    [self.view addSubview:webView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
