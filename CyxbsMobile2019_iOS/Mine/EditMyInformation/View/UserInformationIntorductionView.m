//
//  UserInformationIntorductionView.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/7/29.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "UserInformationIntorductionView.h"
#import <WebKit/WebKit.h>
#import <NudeIn.h>

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
        
//        WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 45, frame.size.width, frame.size.height - 40)];
//        webView.layer.cornerRadius = 16;
//        webView.clipsToBounds = YES;
//        webView.backgroundColor = [UIColor whiteColor];
//        [self addSubview:webView];
//
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"UserInformationIntroduction" ofType:@"html"];
//        NSString *htmlStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//        NSString *assetPath = NSBundle.mainBundle.bundlePath;
//        NSURL *baseUrl = [NSURL fileURLWithPath:assetPath];
//
//        [webView loadHTMLString:htmlStr baseURL:baseUrl];
//
//
//
//
//        self.alpha = 0;
//        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            self.alpha = 1;
//        } completion:nil];
        
//        UIScrollView *scrollView = [[UIScrollView alloc] init];
//        scrollView.frame = self.frame;
//        scrollView.contentSize = CGSizeMake(0, 500);
//        [self addSubview:scrollView];

        
        NudeIn *userProtocolTextlabel = [NudeIn make:^(NUDTextMaker *make) {
            make.text(@"数据互通\n").fontName(@"PingFangSC-Semibold", 18).aligment(NUDAliCenter).paraSpacing(0, 15).attach();
            make.text(@"1.若您已经同意相关用户协议条款,那么关于您的头像,您须知以下情况:\n").fontName(@"PingFangSC-Semibold", 15).paraSpacing(0, 10).attach();
            make.text(@"      若您已经通过微信绑定了红岩网校工作站的微信公众号:重邮小帮手\n      那么您的头像信息也将会被我们所知,且您如果没有对掌.上重邮APP上的头像进行自主修改的话,那么您的默认头像将会是您的微信头像,您可以自主修改您的头像,您自主修改的头像我们将会优先设置为您在掌上重邮APP上的头像。\n      若您并没有通过微信绑定红岩网校工作站的微信公众号:重邮小帮手\n      如果您没有设置您的掌上重邮APP头像,那么我们将会使用默认头像作为您的账户头像。您可以自定义修改您的头像。\n").fontName(@"PingFangSC-Regular", 14).paraSpacing(0, 10).attach();
            make.text(@"2.若您未同意相关用户协议条款,那么关于您的头像,您须知以下情况:\n").fontName(@"PingFangSC-Semibold", 15).paraSpacing(0, 10).attach();
            make.text(@"      您将无法获得权限进入掌上重邮APP并使用相关功能。").fontName(@"PingFangSC-Regular", 14).paraSpacing(0, 20).attach();
        }];
//
        userProtocolTextlabel.layer.cornerRadius = 16;
        userProtocolTextlabel.clipsToBounds = YES;
        userProtocolTextlabel.frame = CGRectMake(20, 20, self.frame.size.width - 40, self.frame.size.height - 70);
        
        if (@available(iOS 11.0, *)) {
            self.backgroundColor = [UIColor colorNamed:@"Mine_EditInfo_BackgroundColor"];
            userProtocolTextlabel.backgroundColor = [UIColor colorNamed:@"Mine_EditInfo_BackgroundColor"];
            userProtocolTextlabel.textColor = [UIColor colorNamed:@"Mine_CheckIn_TitleView"];
        } else {
            self.backgroundColor = [UIColor whiteColor];
            userProtocolTextlabel.backgroundColor = [UIColor whiteColor];
            userProtocolTextlabel.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1];
        }
        [self addSubview:userProtocolTextlabel];
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [backButton setTitle:@"知道了" forState:UIControlStateNormal];
        backButton.titleLabel.font = [UIFont fontWithName:PingFangSCBold size:17];
        backButton.frame = CGRectMake(frame.size.width / 2.0 - 40, self.frame.size.height - 50, 80, 35);
        if (@available(iOS 11.0, *)) {
            [backButton setTitleColor:[UIColor colorNamed:@"Mine_CheckIn_TitleView"] forState:UIControlStateNormal];
        } else {
            [backButton setTitleColor:[UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1] forState:UIControlStateNormal];
        }
        [backButton addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backButton];
        self.backButton = backButton;
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
