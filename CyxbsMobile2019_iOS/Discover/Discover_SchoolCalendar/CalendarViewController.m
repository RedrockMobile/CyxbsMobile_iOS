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
@property (nonatomic, weak)UIButton *backButton;//返回按钮

@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    [self.view addSubview:scrollView];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    NSURL *url = [NSURL URLWithString:@"https://cyxbsmobile.redrock.team/234/newapi/schoolCalendar"];
    [imageView sd_setImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        imageView.width = MAIN_SCREEN_W;
        imageView.height = image.size.height / image.size.width * MAIN_SCREEN_W;
        
        imageView.frame = CGRectMake(0, 0, MAIN_SCREEN_W, (image.size.height / image.size.width) * MAIN_SCREEN_W);
        
        scrollView.contentSize = CGSizeMake(0, imageView.height);
        
    }];
    [scrollView addSubview:imageView];
    
}

@end
