//
//  URLController.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/5/17.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "URLController.h"
#import <WebKit/WebKit.h>

@interface URLController ()<WKNavigationDelegate>
@property (nonatomic, weak)UIButton *backButton;//返回按钮
@property (nonatomic, weak)WKWebView *webView;
@end

@implementation URLController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",self.webView.title);
    if (@available(iOS 11.0, *)) {
        self.view.backgroundColor = [UIColor colorNamed:@"ColorBackground" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil];
    } else {
        // Fallback on earlier versions
    }
//    self.navigationController.navigationBar.hidden=YES;
    
    //获取导航栏高度
    double navHeight = self.navigationController.navigationBar.frame.size.height;
    //获取状态栏高度
    double statusHeight = UIApplication.sharedApplication.statusBarFrame.size.height;
    NSLog(@"nav%f,sta%f",navHeight,statusHeight);
    WKWebView * webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, statusHeight+navHeight, self.view.width, self.view.height-statusHeight-navHeight)];
    self.webView = webView;
    self.webView.navigationDelegate = self;
//    if(!IS_IPHONEX) {
//        webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 75, self.view.width, self.view.height)];
//    }
    NSURL * url = [NSURL URLWithString:_toUrl];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];

    [webView loadRequest:request];
    [self.view addSubview:webView];
    [self addBackButton];

        // 添加观察者，监听 WKWebView 对象的 title 属性
    //
    //    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    //
    // Do any additional setup after loading the view.
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"网页加载失败");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
//    NSLog(@"**%@**",self.webView.title);
//    self.navigationItem.title = self.webView.title;
    [self addTitle];
}
//- (void)observeValueForKeyPath:(NSString *)keyPath
//                      ofObject:(id)object
//                        change:(NSDictionary<NSString *,id> *)change
//                       context:(void *)context
//{
//    if ([keyPath isEqualToString:@"title"]) {
//        if (object == self.webView)
//        {
//            self.title = self.webView.title;
//        }
//        else {
//            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//        }
//
//    }
//
//}
//
////移除监听
//- (void)dealloc{
//    [self.webView removeObserver:self forKeyPath:@"title" context:nil];
//}
- (void)addBackButton {
    UIButton *button = [[UIButton alloc]init];
    [self.view addSubview:button];
    self.backButton = button;
    [button setImage:[UIImage imageNamed:@"LQQBackButton"] forState:normal];
    [button setImage: [UIImage imageNamed:@"EmptyClassBackButton"] forState:UIControlStateHighlighted];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@30);
        make.height.equalTo(@30);
//        make.bottom.equalTo(self.navigationController.navigationBar.mas_bottom).offset(-10);
        make.bottom.equalTo(self.webView.mas_top).offset(-10);
//        if (IS_IPHONEX) {
//            make.top.equalTo(self.view).offset(65);
//        }else {
//            make.top.equalTo(self.view).offset(40);
//        }
        make.left.equalTo(self.view).offset(8.6);
    }];
    [button setImageEdgeInsets:UIEdgeInsetsMake(6, 10, 6, 10)];//增大点击范围
    [button addTarget:self action:@selector(popController) forControlEvents:UIControlEventTouchUpInside];
}
-(void)addTitle {
    UILabel *label = [[UILabel alloc]init];
    [self.view addSubview:label];
    label.text = self.webView.title;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backButton.mas_right).offset(15);
        make.centerY.equalTo(self.backButton);
    }];
    label.font = [UIFont fontWithName:PingFangSCMedium size: 22];
    if (@available(iOS 11.0, *)) {
        label.textColor = [UIColor colorNamed:@"color21_49_91&#F0F0F2" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil];
    } else {
        // Fallback on earlier versions
    }
}
- (void)popController {
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBar.hidden = NO;
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
