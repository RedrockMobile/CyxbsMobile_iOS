//
//  NotSetVolunteerButton.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/1/28.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "NotSetVolunteerButton.h"
///平方字体部分
#define PingFangSC @".PingFang SC"
//Bahnschrift字体部分
#define ImpactMedium @"Impact"
#define ImpactRegular @"Impact"
//颜色部分
#define Color42_78_132 [UIColor colorNamed:@"color42_78_132&#FFFFFF" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]

#define Color21_49_91_F0F0F2  [UIColor colorNamed:@"color21_49_91&#F0F0F2" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]

@interface NotSetVolunteerButton()
@property NSUserDefaults *defaults;

@end
@implementation NotSetVolunteerButton



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
         if (@available(iOS 11.0, *)) {
            self.backgroundColor = [UIColor colorNamed:@"colorWhite&#1D1D1D" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil];
        } else {
            // Fallback on earlier versions
        }
        [self loadUserDefaults];//加载缓存用作视图的初始化
        [self addSeperateLine];//一个像素的分割线
        [self addHintLabel];
        [self addVolunteerTitle];
        [self addAllTimeBackImage];
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
- (void)addHintLabel {
    UILabel *hintLabel = [[UILabel alloc]init];
    self.hintLabel = hintLabel;
    hintLabel.text = @"还未绑定志愿者账号哦～";
    hintLabel.font = [UIFont fontWithName:PingFangSCLight size: 15];
    if (@available(iOS 11.0, *)) {
        hintLabel.textColor = Color21_49_91_F0F0F2;
    } else {
        // Fallback on earlier versions
    }
    [self addSubview:hintLabel];
}
//MARK: - 志愿服务部分


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
    [self addSubview:title];
}
- (void)addAllTimeBackImage {
    UIImageView *allTimeBackImage = [[UIImageView alloc]init];
    self.allTimeBackImage = allTimeBackImage;
    [allTimeBackImage setImage:[UIImage imageNamed:@"志愿时长"]];
    [self addSubview:allTimeBackImage];
    [self addAllTime];
    [self addShi];
}
- (void)addAllTime {
    UILabel *allTime = [[UILabel alloc]init];
    self.allTime = allTime;
    allTime.text = @"0";
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

    //MARK: - 志愿服务部分的约束
- (void)layoutSubviews{
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
        make.right.equalTo(self.allTimeBackImage).offset(-5.5);
        make.bottom.equalTo(self.allTime).offset(-7);
    }];
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.allTimeBackImage);
        make.left.equalTo(self.allTimeBackImage.mas_right).offset(22);
    }];
}
@end
