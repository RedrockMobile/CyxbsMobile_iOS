//
//  UserProtocolViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/7/23.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "UserProtocolViewController.h"


@interface UserProtocolViewController ()

@end

@implementation UserProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UITextView *textView = [[UITextView alloc] init];
//    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.top.equalTo(self.view).offset(20);
//        make.trailing.bottom.equalTo(self.view).offset(-20);
//    }];
//
//    NSString *protocolPath = [[NSBundle mainBundle] pathForResource:@"UserProtocol" ofType:@"txt"];
//    textView.text = [NSString stringWithContentsOfFile:protocolPath encoding:NSUTF8StringEncoding error:nil];
//    [self.view addSubview:textView];
    
    
    UIWebView *myWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:myWebView];
    
//    myWebView.backgroundColor = [UIColor whiteColor];
    NSURL *filePath = [NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"FootFirst设计模式.pdf" ofType:nil]];
    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:@"https://baidu.com"]];
    //使文档的显示范围适合UIWebView的bounds
    [myWebView loadRequest:request];
    [myWebView setScalesPageToFit:YES];
    
    
}

@end
