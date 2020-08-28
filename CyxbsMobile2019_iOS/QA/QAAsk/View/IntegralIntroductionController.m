//
//  IntegralIntroductionController.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/8/28.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "IntegralIntroductionController.h"
#import <NudeIn.h>

@interface IntegralIntroductionController ()

@end

@implementation IntegralIntroductionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)) {
        self.view.backgroundColor = [UIColor colorNamed:@"LoginBackgroundColor"];
    } else {
        self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:252/255.0 alpha:1];
    }
    
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [backButton setTitle:@"完成" forState:UIControlStateNormal];
    if (@available(iOS 11.0, *)) {
        [backButton setTitleColor:[UIColor colorNamed:@"LoginTitleColor"] forState:UIControlStateNormal];
    } else {
        [backButton setTitleColor:[UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1] forState:UIControlStateNormal];
    }
    backButton.titleLabel.font = [UIFont fontWithName:PingFangSCBold size:19];
    backButton.frame = CGRectMake(MAIN_SCREEN_W - 20 - 50, 10, 50, 30);
    [backButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UIView *separatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, 50, MAIN_SCREEN_W, 1)];
    separatorLine.alpha = 0.15;
    separatorLine.backgroundColor = backButton.titleLabel.textColor;
    [self.view addSubview:separatorLine];
    
    
    
    CGFloat rowSpace;
    CGFloat titleRowSpace;
    CGFloat titleFontSize;
    CGFloat subTitleFontSize;
    CGFloat textFontSize;
    
    if (IS_IPHONEX) {                       // iPhone X, Xs, XR, 11, 11 Pro, 11 Pro Max等
        titleRowSpace = 22;
        rowSpace = 16;
        titleFontSize = 20;
        subTitleFontSize = 17;
        textFontSize = 16;
    } else if (IS_IPHONESE) {               // 4.0寸iPhone
        titleRowSpace = 10;
        rowSpace = 7;
        titleFontSize = 17;
        subTitleFontSize = 14;
        textFontSize = 13;
    } else if (SCREEN_WIDTH == 375.f) {     // 4.7寸iPhone
        titleRowSpace = 13;
        rowSpace = 8;
        titleFontSize = 18;
        subTitleFontSize = 15;
        textFontSize = 14;
    } else {                                // 5.5寸iPhone
        titleRowSpace = 20;
        rowSpace = 15;
        titleFontSize = 19;
        subTitleFontSize = 16;
        textFontSize = 15;
    }
    
    NudeIn *userProtocolTextView = [NudeIn make:^(NUDTextMaker *make) {
        
        make.text(@"悬赏积分是干嘛的？\n")
        .fontName(PingFangSCBold, subTitleFontSize)
        .paraSpacing(0, rowSpace)
        .attach();
        
        make.text(@"\t为了营造邮问社区的良好氛围，使你的问题得到及时的解答，你将通过您获取的积分来进行提问，而你选取的优质回答将获得你的悬赏积分。\n")
        .fontName(PingFangSCRegular, textFontSize)
        .paraSpacing(0, rowSpace)
        .attach();
        
        make.text(@"任务最晚完成时间是什么意思？\n")
        .fontName(PingFangSCBold, subTitleFontSize)
        .paraSpacing(0, rowSpace)
        .attach();
        
        make.text(@"\t在你设定的任务最晚完成时间内，你可以主动对您获取的回答进行采纳，将你的积分悬赏给该用户；如果你没有及时对用户的回答进行采纳，且你的提问已经超过了任务最晚完成时间，这个时候我们将对你所提问的所有回答进行查看，选出最有价值的回答（以获赞、评论数评判），将你的积分悬赏给最优回答用户。\n")
        .fontName(PingFangSCRegular, textFontSize)
        .paraSpacing(0, rowSpace)
        .attach();
        
        make.text(@"如何评判优质回答？\n")
        .fontName(PingFangSCBold, subTitleFontSize)
        .paraSpacing(0, rowSpace)
        .attach();
        
        make.text(@"\t优质回答的首要判断条件是用户自行选择进行采纳的用户，若用户在任务最短完成时间内没有进行采纳，且该提问下已有回答，这时候首要判断机制为：获得最高赞回答数的回答为该提问的优质回答。\n")
        .fontName(PingFangSCRegular,textFontSize)
        .paraSpacing(0, rowSpace)
        .attach();
        
        make.text(@"如果任务最晚完成时间内没有回答？\n")
        .fontName(PingFangSCBold, subTitleFontSize)
        .paraSpacing(0, rowSpace)
        .attach();
        
        make.text(@"\t若存在这种情况的话，我们将对您设置的悬赏积分退还至您的账户。\n")
        .fontName(PingFangSCRegular,textFontSize)
        .paraSpacing(0, rowSpace)
        .attach();
    }];
    userProtocolTextView.frame = CGRectMake(20, 51, MAIN_SCREEN_W - 40, self.view.frame.size.height - 100);
    if (@available(iOS 11.0, *)) {
        userProtocolTextView.textColor = [UIColor colorNamed:@"LoginTitleColor"];
        userProtocolTextView.backgroundColor = [UIColor colorNamed:@"LoginBackgroundColor"];
    } else {
        userProtocolTextView.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1];
        userProtocolTextView.backgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:252/255.0 alpha:1];
    }
    userProtocolTextView.scrollEnabled = YES;
    userProtocolTextView.textContainerInset = UIEdgeInsetsMake(20, 0, 0, 0);
    [self.view addSubview:userProtocolTextView];
    
}

- (void)backButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
