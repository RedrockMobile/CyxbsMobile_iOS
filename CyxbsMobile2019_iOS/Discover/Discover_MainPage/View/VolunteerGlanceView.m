//
//  VolunteerGlanceView.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/1/28.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "VolunteerGlanceView.h"
///平方字体部分
#define PingFangSC @".PingFang SC"
//Bahnschrift字体部分
#define ImpactMedium @"Impact"
#define ImpactRegular @"Impact"
//颜色部分
#define Color42_78_132 [UIColor colorNamed:@"color42_78_132&#FFFFFF" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]

#define Color21_49_91_F0F0F2  [UIColor colorNamed:@"color21_49_91&#F0F0F2" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]

@interface VolunteerGlanceView()
@property NSUserDefaults *defaults;

@end
@implementation VolunteerGlanceView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadUserDefaults];//加载缓存用作视图的初始化
        [self addVolunteerButton];
        [self addSeperateLine];//一个像素的分割线
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}
- (void)loadUserDefaults {
    NSUserDefaults *defualts = [NSUserDefaults standardUserDefaults];
    self.defaults = defualts;
}
- (void)addSeperateLine {
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 1)];
    line.backgroundColor = [UIColor colorWithRed:232/255.0 green:223/255.0 blue:241/255.0 alpha:1];
    [self addSubview:line];
}
//MARK: - 志愿服务部分
- (void)addVolunteerButton {
    UIButton *button = [[UIButton alloc]init];
    self.volunteer = button;
    if (@available(iOS 11.0, *)) {
        button.backgroundColor = [UIColor colorNamed:@"colorWhite&#1D1D1D" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil];
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
        title.textColor = Color21_49_91_F0F0F2;
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
        allTime.textColor = Color21_49_91_F0F0F2;
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
  
    //MARK: - 志愿服务部分的约束
    [self.volunteer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.height.equalTo(@151.5);
        make.left.right.equalTo(self);
    }];
    [self.volunteerTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(14);
        make.top.equalTo(self).offset(30);
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
