//
//  LQQGlanceView.m
//  testForLargeTitle
//
//  Created by 千千 on 2019/10/22.
//  Copyright © 2019 千千. All rights reserved.
//
#import "LQQGlanceView.h"
///平方字体部分
#define PingFangSC @".PingFang SC"
//Bahnschrift字体部分
#define ImpactMedium @"Impact"
#define ImpactRegular @"Impact"
//颜色部分
#define Color42_78_132 [UIColor colorNamed:@"color42_78_132" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]

#define Color21_49_91  [UIColor colorNamed:@"color21_49_91" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]
#define Color21_49_91_F0F0F2  [UIColor colorNamed:@"color21_49_91&#F0F0F2" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]
@interface LQQGlanceView()
@property NSUserDefaults *defaults;




@end
@implementation LQQGlanceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadUserDefaults];//加载缓存用作视图的初始化
        [self addElectricFeeButton];
        [self addVolunteerButton];
        
        self.layer.cornerRadius = 30;
        self.clipsToBounds = YES;
    }
    return self;
}
- (void)loadUserDefaults {
    NSUserDefaults *defualts = [NSUserDefaults standardUserDefaults];
    self.defaults = defualts;
}
//MARK: 电费查询部分
- (void) addElectricFeeButton {
    UIButton *button = [[UIButton alloc]init];
    self.electricFee = button;
     if (@available(iOS 11.0, *)) {
        button.backgroundColor = [UIColor colorNamed:@"color248_249_252&#1D1D1D" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil];
    } else {
        // Fallback on earlier versions
    }
    [self addChildViewToElectricFeeButton];//给按钮添加子视图
    
    button.layer.shadowColor = [UIColor blackColor].CGColor;
    button.layer.shadowOpacity = 0.16f;
    button.layer.shadowColor = [UIColor colorWithRed:174/255.0 green:182/255.0 blue:211/255.0 alpha:1].CGColor;
    button.layer.shadowOffset = CGSizeMake(0, 5);
    
    [self addSubview:self.electricFee];
}
- (void)addChildViewToElectricFeeButton {
    //其中涉及网络请求的有time,money,degree
    [self addTitle];
    [self addTime];
    [self addMoney];
    [self addDegree];
    [self addYuan];
    [self addDu];
    [self addHintLeft];
    [self addHintRight];
}
- (void)addTitle {
    UILabel *title = [[UILabel alloc]init];//左上角标题
    self.electricFeeTitle = title;
    title.text = @"电费查询";
    title.font = [UIFont fontWithName:PingFangSCBold size: 18];if (@available(iOS 11.0, *)) {
        
        title.textColor = Color21_49_91;
    } else {
        // Fallback on earlier versions
    }
    [self.electricFee addSubview:title];
}
- (void)addTime {
    UILabel *time = [[UILabel alloc]init];//右上角抄表时间
    self.electricFeeTime = time;
    time.text = [self.defaults objectForKey:@"ElectricFee_time"];
    if (@available(iOS 11.0, *)) {
        time.textColor = Color21_49_91;
    } else {
        // Fallback on earlier versions
    }
    time.alpha = 0.54;
    time.font = [UIFont fontWithName:PingFangSCLight size: 10];
    [self.electricFee addSubview:time];
}
- (void)addMoney {
    UILabel *money = [[UILabel alloc]init];//左边数字
    self.electricFeeMoney = money;
    money.text = [self.defaults objectForKey:@"ElectricFee_money"];
    if (@available(iOS 11.0, *)) {
        money.textColor = Color42_78_132;
    } else {
        // Fallback on earlier versions
    }
    money.font = [UIFont fontWithName:ImpactMedium size: 36];
    [self.electricFee addSubview:money];
}
- (void)addDegree {
    UILabel *degree = [[UILabel alloc]init];//右边数字
    self.electricFeeDegree = degree;
    degree.text = [self.defaults objectForKey:@"ElectricFee_degree"];
    if (@available(iOS 11.0, *)) {
        degree.textColor = Color42_78_132;
    } else {
        // Fallback on earlier versions
    }
    degree.font = [UIFont fontWithName: ImpactMedium size: 36];
    [self.electricFee addSubview:degree];
}
- (void)addYuan {
    UILabel *yuan = [[UILabel alloc]init];//汉字“元”
    self.electricFeeYuan = yuan;
        yuan.text = @"元";
    if (@available(iOS 11.0, *)) {
        yuan.textColor = Color21_49_91;
    } else {
        // Fallback on earlier versions
    }
    yuan.font = [UIFont fontWithName:PingFangSCMedium size: 13];
    [self.electricFee addSubview:yuan];
}
- (void)addDu {
    UILabel *du = [[UILabel alloc]init];//汉字“度”
    self.electricFeeDu = du;
        du.text = @"度";
    if (@available(iOS 11.0, *)) {
        du.textColor = Color21_49_91;
    } else {
        // Fallback on earlier versions
    }
    du.font = [UIFont fontWithName:PingFangSCMedium size: 13];
    [self.electricFee addSubview:du];
}
- (void)addHintLeft {
    UILabel *hintLeft = [[UILabel alloc]init];//汉字“费用、本月”
    self.electricFeeHintLeft = hintLeft;
    hintLeft.text = @"费用/本月";
    hintLeft.font = [UIFont fontWithName:PingFangSCLight size: 13];
    if (@available(iOS 11.0, *)) {
        hintLeft.textColor = Color21_49_91_F0F0F2;
    } else {
        // Fallback on earlier versions
    }
    hintLeft.alpha = 0.6;
    [self.electricFee addSubview:hintLeft];
}
- (void)addHintRight {
    UILabel *hintRight = [[UILabel alloc] init];//汉字“使用度数，本月”
    self.electricFeeHintRight = hintRight;
        hintRight.text = @"使用度数/本月";
    hintRight.font = [UIFont fontWithName:PingFangSCLight size: 13];
    if (@available(iOS 11.0, *)) {
        hintRight.textColor = Color21_49_91_F0F0F2;
    } else {
        // Fallback on earlier versions
    }
    hintRight.alpha = 0.6;
    [self.electricFee addSubview:hintRight];
}
//MARK: - 志愿服务部分
- (void)addVolunteerButton {
    UIButton *button = [[UIButton alloc]init];
    self.volunteer = button;
    if (@available(iOS 11.0, *)) {
        button.backgroundColor = [UIColor colorNamed:@"color248_249_252&#1D1D1D" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil];
    } else {
        // Fallback on earlier versions
    }
    [self addChildViewToVolunteerButton];//给按钮添加子视图
    [self addSubview:self.volunteer];
}
- (void)addChildViewToVolunteerButton {
    [self addVolunteerTitle];
    [self addAllTimeBackImage];
    [self addRecentTitle];
    [self addRecentDate];
    [self addRecentTime];
    [self addRecentTeam];
    
}
- (void)addVolunteerTitle {
    UILabel *title = [[UILabel alloc]init];//左上角标题
    self.volunteerTitle = title;
    title.text = @"志愿时长";
    title.font = [UIFont fontWithName:PingFangSCBold size: 18];
    if (@available(iOS 11.0, *)) {
        title.textColor = Color21_49_91;
    } else {
        // Fallback on earlier versions
    }
    [self.volunteer addSubview:title];
}
- (void)addAllTimeBackImage {
    UIImageView *allTimeBackImage = [[UIImageView alloc]init];
    self.allTimeBackImage = allTimeBackImage;
    [allTimeBackImage setImage:[UIImage imageNamed:@"志愿时长"]];
    [self.volunteer addSubview:allTimeBackImage];
    [self addAllTime];
    [self addShi];
}
- (void)addAllTime {
    UILabel *allTime = [[UILabel alloc]init];
    self.allTime = allTime;
    allTime.text = @"18";
    allTime.font = [UIFont fontWithName:ImpactRegular size:36];
    if (@available(iOS 11.0, *)) {
        allTime.textColor = Color21_49_91;
    } else {
        // Fallback on earlier versions
    }
    [self.allTimeBackImage addSubview:allTime];
}
- (void)addShi {
    UILabel *shi = [[UILabel alloc]init];
    self.shi = shi;
    shi.text = @"时";
    shi.font = [UIFont fontWithName:PingFangSCBold size:10];
    if (@available(iOS 11.0, *)) {
        shi.textColor = Color42_78_132;
    } else {
        // Fallback on earlier versions
    }
    [self.allTimeBackImage addSubview:shi];
}
- (void)addRecentTitle {
    UILabel *recentTitle = [[UILabel alloc]init];
    self.recentTitle = recentTitle;
    recentTitle.text = @"测试标题";
    recentTitle.font = [UIFont fontWithName: PingFangSCRegular size:15];
    if (@available(iOS 11.0, *)) {
        recentTitle.textColor = Color21_49_91_F0F0F2;
    } else {
        // Fallback on earlier versions
    }
    [self.volunteer addSubview:recentTitle];
}
- (void)addRecentDate {
    UILabel *recentDate = [[UILabel alloc]init];
    self.recentDate = recentDate;
    recentDate.text = @"2019.8.2";
    recentDate.font = [UIFont fontWithName:PingFangSCLight size: 10];
    if (@available(iOS 11.0, *)) {
        recentDate.textColor = Color21_49_91_F0F0F2;
    } else {
        // Fallback on earlier versions
    }
    recentDate.alpha = 0.54;
    [self.volunteer addSubview:recentDate];
}
- (void)addRecentTime {
    UILabel *recentTime = [[UILabel alloc]init];
    self.recentTime = recentTime;
    recentTime.text = @"5小时";
    recentTime.font = [UIFont fontWithName:PingFangSCLight size: 13];
    if (@available(iOS 11.0, *)) {
        recentTime.textColor = Color21_49_91_F0F0F2;
    } else {
        // Fallback on earlier versions
    }
    recentTime.alpha = 0.8;
    [self.volunteer addSubview:recentTime];
}
- (void)addRecentTeam {
    UILabel *recentTeam= [[UILabel alloc]init];
    self.recentTeam = recentTeam;
    recentTeam.text = @"红领巾志愿服务小分队";
    recentTeam.font = [UIFont fontWithName:PingFangSCLight size: 13];
    if (@available(iOS 11.0, *)) {
        recentTeam.textColor = Color21_49_91_F0F0F2;
    } else {
        // Fallback on earlier versions
    }
    recentTeam.alpha = 0.8;
    [self.volunteer addSubview:recentTeam];
}
- (void)layoutSubviews {
    //MARK: - 电费部分的约束
    [self.electricFee mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.height.equalTo(@151.5);
        make.left.right.equalTo(self);
    }];
    [self.electricFeeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(14);
        make.top.equalTo(self).offset(30);
    }];
    [self.electricFeeTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.electricFeeTitle);
        make.right.equalTo(self).offset(-15);
    }];
    [self.electricFeeMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.electricFeeTitle.mas_bottom).offset(17);
        make.centerX.equalTo(self).offset(-self.width / 4.0);
    }];
    [self.electricFeeYuan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.electricFeeMoney.mas_right).offset(9);
        make.bottom.equalTo(self.electricFeeMoney).offset(-6);
    }];
    [self.electricFeeDegree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.electricFeeMoney);
        make.centerX.equalTo(self).offset(self.width / 4.0);
    }];
    [self.electricFeeDu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.electricFeeDegree.mas_right).offset(9);
        make.bottom.equalTo(self.electricFeeDegree).offset(-6);
    }];
    [self.electricFeeHintLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.electricFeeMoney.mas_bottom).offset(-5);
        make.centerX.equalTo(self.electricFeeMoney);
    }];
    [self.electricFeeHintRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.electricFeeDegree.mas_bottom).offset(-5);
        make.centerX.equalTo(self.electricFeeDegree);
    }];
    //MARK: - 志愿服务部分的约束
    [self.volunteer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.electricFee.mas_bottom).offset(1);
        make.width.height.equalTo(self.electricFee);
    }];
    [self.volunteerTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.electricFeeTitle);
        make.top.equalTo(self.volunteer).offset(16);
    }];
    [self.allTimeBackImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.volunteerTitle);
        make.top.equalTo(self.volunteerTitle.mas_bottom).offset(16);
        make.width.height.equalTo(@64);
    }];
    [self.allTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.allTimeBackImage);
        make.centerY.equalTo(self.allTimeBackImage).offset(2);
    }];
    [self.shi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.allTime.mas_right);
        make.bottom.equalTo(self.allTime).offset(-7);
    }];
    [self.recentTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.volunteerTitle.mas_right).offset(22);
        make.top.equalTo(self.allTimeBackImage);
    }];
    [self.recentTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.recentTitle);
        make.top.equalTo(self.recentTitle.mas_bottom).offset(4);
    }];
    [self.recentTeam mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.recentTime);
        make.top.equalTo(self.recentTime.mas_bottom).offset(4);
    }];
    [self.recentDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.recentTitle);
        make.right.equalTo(self).offset(-15);
    }];
    
}
@end
