//
//  ScheduleInquiryViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/1/20.
//  Copyright © 2020 Redrock. All rights reserved.
//这个控制器是查课表页的总控制器

#import "ScheduleInquiryViewController.h"
#import "QAListSegmentView.h"
#import "ScheduleViewController.h"
#define STU_FIND_HISTORY @"FindStudentSchedule_historyArray"
#define TEA_FIND_HISTORY @"FindTeacherSchedule_historyArray"
#define Color21_49_91_F0F0F2  [UIColor colorNamed:@"color21_49_91&#F0F0F2" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]
#define navigationbarColor  [UIColor colorNamed:@"Color#FFFFFF&#1D1D1D" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]


@interface ScheduleInquiryViewController () <ScheduleViewControllerDelegate>
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
    [self addCustomTabbarView];
    [self addSegmentView];
    [self addBackButton];
    // Do any additional setup after loading the view.
}

//自定义的Tabbar（显示“查课表”的那块）
- (void)addCustomTabbarView {
    UIView *backgroundView;
    if IS_IPHONEX {
        backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 55, self.view.width, 40)];
    }else {
        backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 25, self.view.width, 40)];
    }
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
        make.centerY.equalTo(self.backgroundView);
    }];
    if (@available(iOS 11.0, *)) {
        titleLabel.textColor = Color21_49_91_F0F0F2;
    } else {
        titleLabel.textColor = [UIColor colorWithHexString:@"#15315B"];
    }
}

//添加推出查课表页的按钮
- (void)addBackButton {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:backButton];
    [backButton setImage:[UIImage imageNamed:@"空教室返回"] forState:UIControlStateNormal];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(17);
        make.centerY.equalTo(self.titleLabel);
        make.width.equalTo(@9);
        make.height.equalTo(@19);
    }];
    [backButton addTarget:self action: @selector(back) forControlEvents:UIControlEventTouchUpInside];
}

//跳出查课表页的方法
- (void) back {
     [self.navigationController popViewControllerAnimated:YES];
}

//添加带标签栏的一个分页的一个scrollView（即QAListSegmentView）
- (void)addSegmentView {
    ScheduleViewController *stu = [[ScheduleViewController alloc] initWithUserDefaultKey:STU_FIND_HISTORY andPeopleType:PeopleTypeStudent];
    stu.title = @"学生课表";
    stu.delegate = self;
    
    ScheduleViewController *tea = [[ScheduleViewController alloc] initWithUserDefaultKey:TEA_FIND_HISTORY andPeopleType:PeopleTypeTeacher];
    tea.title = @"老师课表";
    tea.delegate = self;
    
    
    QAListSegmentView *segmentView = [[QAListSegmentView alloc]initWithFrame:CGRectMake(0, 120, self.view.width, self.view.height-60) controllers:@[stu, tea]];
    [self.view addSubview:segmentView];

    NSString *width = [NSString stringWithFormat:@"%f",MAIN_SCREEN_W*0.1086];
    [segmentView setValue:width forKey:@"sliderWidth"];
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

//这个是<ScheduleViewControllerDelegate>协议里需要实现的方法，起到跳转到符合条件的人员名单页的功能
- (void)pushToController:(UIViewController *)studentListVC {
    [self.navigationController pushViewController:studentListVC animated:YES];
}

@end
