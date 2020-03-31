//
//  ScheduleInquiryViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/1/20.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "ScheduleInquiryViewController.h"
#import "QAListSegmentView.h"
#import "StudentScheduleViewController.h"
#import "TeacherScheduleViewController.h"
#define Color21_49_91_F0F0F2  [UIColor colorNamed:@"color21_49_91&#F0F0F2" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]
#define navigationbarColor  [UIColor colorNamed:@"Color#FFFFFF&#1D1D1D" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]


@interface ScheduleInquiryViewController () <StudentScheduleDelegate>
@property (nonatomic, weak)UIView *backgroundView;
@property (nonatomic, weak)UILabel *titleLabel;
@end

@implementation ScheduleInquiryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.view.backgroundColor = navigationbarColor;
    } else {
        // Fallback on earlier versions
    }
    self.navigationController.navigationBar.hidden = YES;
    [self addCustomTabbarView];
    [self addSegmentView];
    [self addBackButton];
    // Do any additional setup after loading the view.
}

- (void)addCustomTabbarView {
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 100)];
    self.backgroundView = backgroundView;
    if (@available(iOS 11.0, *)) {
        backgroundView.backgroundColor = navigationbarColor;
    } else {
        backgroundView.backgroundColor = UIColor.whiteColor;
    }
    [self.view addSubview:backgroundView];
    //addTitleView
    UILabel *titleLabel = [[UILabel alloc]init];
    self.titleLabel = titleLabel;
    titleLabel.text = @"查课表";
    titleLabel.font = [UIFont fontWithName:PingFangSCBold size:21];
    [self.backgroundView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.backgroundView).offset(-20);
    }];
    if (@available(iOS 11.0, *)) {
        titleLabel.textColor = Color21_49_91_F0F0F2;
    } else {
        titleLabel.textColor = [UIColor colorWithHexString:@"#15315B"];
    }
}
- (void)addBackButton {
    UIButton *backButton = [[UIButton alloc]init];
    [self.view addSubview:backButton];
    [backButton setImage:[UIImage imageNamed:@"EmptyClassBackButton"] forState:UIControlStateNormal];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(17);
        make.centerY.equalTo(self.titleLabel);
        make.width.equalTo(@9);
        make.height.equalTo(@19);
    }];
    [backButton addTarget:self action: @selector(back) forControlEvents:UIControlEventTouchUpInside];
}
- (void) back {
[self.navigationController popViewControllerAnimated:YES];
self.navigationController.navigationBar.hidden = NO;
    
}
- (void)addSegmentView {
    StudentScheduleViewController *stuVC = [[StudentScheduleViewController alloc]init];
    stuVC.title = @"学生课表";
    stuVC.delegate = self;
    TeacherScheduleViewController *teacherVC = [[TeacherScheduleViewController alloc]init];
    teacherVC.title = @"老师课表";
    QAListSegmentView *segmentView = [[QAListSegmentView alloc]initWithFrame:CGRectMake(0, 120, self.view.width, self.view.height-120) controllers:@[stuVC, teacherVC]];
    [self.view addSubview:segmentView];

    if (@available(iOS 11.0, *)) {
        [segmentView setValue:Color21_49_91_F0F0F2 forKey:@"titleColor"];
    } else {
        [segmentView setValue:[UIColor colorWithHexString:@"#15315B"] forKey:@"titleColor"];
    }
    
    [segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundView.mas_bottom);
        make.left.right.width.equalTo(self.backgroundView);
        make.bottom.equalTo(self.view);
    }];
}
- (void)pushToController:(UIViewController *)studentListVC {
    [self.navigationController pushViewController:studentListVC animated:YES];
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
