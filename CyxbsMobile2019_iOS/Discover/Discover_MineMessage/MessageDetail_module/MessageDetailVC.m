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

@interface MessageDetailVC ()

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
        [UIColor dm_colorWithLightColor:[UIColor xFF_R:248 G:249 B:252 Alpha:1] darkColor:[UIColor xFF_R:0 G:1 B:1 Alpha:1]];
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
    }
    return _webView;
}

@end
