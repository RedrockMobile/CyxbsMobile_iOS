//
//  UserInformationIntorductionView.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/7/29.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "UserInformationIntorductionView.h"
#import <WebKit/WebKit.h>

@interface UserInformationIntorductionView ()

@property (nonatomic, weak) UIButton *backButton;

@end

@implementation UserInformationIntorductionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 16;
        
        WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 45, frame.size.width, frame.size.height - 40)];
        webView.layer.cornerRadius = 16;
        webView.clipsToBounds = YES;
        webView.backgroundColor = [UIColor whiteColor];
        [self addSubview:webView];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"UserInformationIntroduction" ofType:@"html"];
        NSString *htmlStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSString *assetPath = NSBundle.mainBundle.bundlePath;
        NSURL *baseUrl = [NSURL fileURLWithPath:assetPath];
        
        [webView loadHTMLString:htmlStr baseURL:baseUrl];
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [backButton setTitle:@"取消" forState:UIControlStateNormal];
        backButton.frame = CGRectMake(frame.size.width - 50 - 5, 10, 50, 25);
        [backButton addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backButton];
        self.backButton = backButton;
        
        
        
        self.alpha = 0;
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.alpha = 1;
        } completion:nil];
    }
    return self;
}

- (void)dismissView {
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end
