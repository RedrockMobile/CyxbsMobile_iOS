//
//  CalendarViewController.m
//  MoblieCQUPT_iOS
//
//  Created by user on 15/9/5.
//  Copyright (c) 2015年 Orange-W. All rights reserved.
//

#import "CalendarViewController.h"

@interface CalendarViewController ()
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *calendarView1;
@property (strong, nonatomic) UIImageView *calendarView2;

@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    [self.view addSubview:scrollView];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    NSURL *url = [NSURL URLWithString:Discover_schoolCalendar_API];
    [imageView sd_setImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image==nil) {
            [NewQAHud showHudWith:@"加载失败～" AddView:self.view];
            return;
        }
        imageView.width = MAIN_SCREEN_W;
        imageView.height = image.size.height / image.size.width * MAIN_SCREEN_W;
        
        imageView.frame = CGRectMake(0, 0, MAIN_SCREEN_W, (image.size.height / image.size.width) * MAIN_SCREEN_W);
        
        scrollView.contentSize = CGSizeMake(0, imageView.height);
        
    }];
    [scrollView addSubview:imageView];
    
    [self setBackButton];
}

#pragma mark - 返回按钮
- (void)setBackButton {
    // 返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [backButton setImage:[UIImage imageNamed:@"我的返回"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(STATUSBARHEIGHT + 15);
        make.leading.equalTo(self.view).offset(15);
        make.height.equalTo(@19);
        make.width.equalTo(@9);
    }];
}

/// 点击 返回按钮 后调用的方法
- (void)backButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
