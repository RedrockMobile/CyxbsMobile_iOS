//
//  MessageDetailVC.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/4/30.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "MessageDetailVC.h"

#import <WebKit/WebKit.h>

#import "SSRTopBarBaseView.h"

#pragma mark - MessageDetailVC ()

@interface MessageDetailVC () <
    WKNavigationDelegate
>

/// 顶视图
@property (nonatomic, strong) SSRTopBarBaseView *topView;

/// 加载的URL
@property (nonatomic, strong) NSURL *url;

/// 加载页
@property (nonatomic, strong) WKWebView *webView;

@end

#pragma mark - MessageDetailVC

@implementation MessageDetailVC

#pragma mark - Life cycle

/// 根据URL加载页面
/// @param url 传入url
- (instancetype)initWithURL:(NSURL *)url {
    self = [super init];
    if (self) {
        self.url = url;
        self.view.backgroundColor = 
        [UIColor dm_colorWithLightColor:[UIColor xFF_R:248 G:249 B:252 Alpha:1]
                              darkColor:[UIColor xFF_R:0 G:1 B:1 Alpha:1]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.topView];
    [self.view addSubview:self.webView];
}

#pragma mark - Method

// MARK: SEL

- (void)messageDetailVC_pop {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)messageDetailVC_showWebView {
    self.webView.hidden = NO;
}

#pragma mark - <WKNavigationDelegate>

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSString *backgroundColor = @"#F8F9FC";
    NSString *textColor = @"#112C54";
    if (DMTraitCollection.overrideTraitCollection.userInterfaceStyle != DMUserInterfaceStyleLight) {
        backgroundColor = @"#000000";
        textColor = @"#F0F0F0";
    }
    
    [webView evaluateJavaScript:
     [NSString stringWithFormat:@"document.body.style.backgroundColor = \"%@\"", backgroundColor]
              completionHandler:nil];
    
    [webView evaluateJavaScript:
     [NSString stringWithFormat:@"document.body.style.webkitTextFillColor = \"%@\"", textColor]
              completionHandler:nil];
    
    [webView evaluateJavaScript:@"document.body.style.fontFamily = \"PingFang SC\"" completionHandler:nil];
    
    [self performSelector:@selector(messageDetailVC_showWebView) afterDelay:0.1];
}

#pragma mark - Getter

- (SSRTopBarBaseView *)topView {
    if (_topView == nil) {
        _topView = [[SSRTopBarBaseView alloc] initWithSafeViewHeight:44];
        _topView.hadLine = NO;
        [_topView addTitle:@"详情" withTitleLay:SSRTopBarBaseViewTitleLabLayLeft withStyle:nil];
        [_topView addBackButtonTarget:self action:@selector(messageDetailVC_pop)];
    }
    return _topView;
}

- (WKWebView *)webView {
    if (_webView == nil) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, self.topView.bottom, self.view.width, self.view.height - self.topView.bottom)];
        [_webView loadRequest:[NSURLRequest requestWithURL:self.url]];
        _webView.hidden = YES;
        _webView.navigationDelegate = self;
    }
    return _webView;
}

@end
