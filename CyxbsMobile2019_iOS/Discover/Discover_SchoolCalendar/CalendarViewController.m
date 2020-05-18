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
    self.navigationController.navigationBar.hidden = YES;
    // Do any additional setup after loading the view.
    if (@available(iOS 11.0, *)) {
        self.view.backgroundColor =  [UIColor colorNamed:@"ColorBackground" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    [self addBackButton];
    [self.view addSubview:self.scrollView];
}

- (UIImageView *)calendarView1 {
    if (!_calendarView1) {
        _calendarView1 = [[UIImageView alloc] init];
        _calendarView1.image = [UIImage imageNamed:@"schoolschedule_2"];
        [_calendarView1 sizeToFit];
        _calendarView1.frame = CGRectMake(8, 0, MAIN_SCREEN_W-16, (MAIN_SCREEN_W-16) * 2.13);
    }
    return _calendarView1;
}

- (UIImageView *)calendarView2 {
    if (!_calendarView2) {
        _calendarView2 = [[UIImageView alloc] init];
        _calendarView2.image = [UIImage imageNamed:@"schoolschedule_1"];
        [_calendarView2 sizeToFit];
        _calendarView2.frame = CGRectMake(8, _calendarView1.frame.size.height, MAIN_SCREEN_W-16, (MAIN_SCREEN_W-16) * 2.13);
    }
    return _calendarView2;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 75, MAIN_SCREEN_W, MAIN_SCREEN_H)];
        if (IS_IPHONEX) {
            _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, MAIN_SCREEN_W, MAIN_SCREEN_H)];
        }
        [_scrollView addSubview:self.calendarView1];
        [_scrollView addSubview:self.calendarView2];
        _scrollView.contentSize = CGSizeMake(MAIN_SCREEN_W, self.calendarView1.frame.size.height * 2 +16);
    }
    return _scrollView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)addBackButton {
    UIButton *button = [[UIButton alloc]init];
    [self.view addSubview:button];
    self.backButton = button;
    [button setImage:[UIImage imageNamed:@"LQQBackButton"] forState:normal];
    [button setImage: [UIImage imageNamed:@"EmptyClassBackButton"] forState:UIControlStateHighlighted];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@30);
        make.height.equalTo(@30);
        if (IS_IPHONEX) {
            make.top.equalTo(self.view).offset(65);
        }else {
            make.top.equalTo(self.view).offset(40);
        }
        make.left.equalTo(self.view).offset(8.6);
    }];
    [button setImageEdgeInsets:UIEdgeInsetsMake(6, 10, 6, 10)];//增大点击范围
    [button addTarget:self action:@selector(popController) forControlEvents:UIControlEventTouchUpInside];
}
- (void)popController {
    [self.navigationController popViewControllerAnimated:YES];
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
