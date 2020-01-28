//
//  NotSetElectriceFeeButton.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/1/28.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "NotSetElectriceFeeButton.h"
///平方字体部分
#define PingFangSC @".PingFang SC"
//Bahnschrift字体部分
#define ImpactMedium @"Impact"
#define ImpactRegular @"Impact"
//颜色部分
#define Color42_78_132 [UIColor colorNamed:@"color42_78_132&#FFFFFF" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]

#define Color21_49_91_F0F0F2  [UIColor colorNamed:@"color21_49_91&#F0F0F2" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]
@interface NotSetElectriceFeeButton()
@property NSUserDefaults *defaults;

@end
@implementation NotSetElectriceFeeButton
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadUserDefaults];//加载缓存用作视图的初始化
         if (@available(iOS 11.0, *)) {
            self.backgroundColor = [UIColor colorNamed:@"colorWhite&#1D1D1D" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil];
        } else {
            // Fallback on earlier versions
        }
        self.layer.shadowOpacity = 0.16f;
        self.layer.shadowColor = [UIColor colorWithRed:174/255.0 green:182/255.0 blue:211/255.0 alpha:1].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 5);
        self.layer.cornerRadius = 25;
        self.clipsToBounds = YES;
        [self addTitle];
        [self addHintLabel];
    }
    return self;
}
- (void)loadUserDefaults {
    NSUserDefaults *defualts = [NSUserDefaults standardUserDefaults];
    self.defaults = defualts;
}
//MARK: 电费查询部分


- (void)addTitle {
    UILabel *title = [[UILabel alloc]init];//左上角标题
    self.electricFeeTitle = title;
    title.text = @"电费查询";
    title.font = [UIFont fontWithName:PingFangSCBold size: 18];
    if (@available(iOS 11.0, *)) {
        title.textColor = Color21_49_91_F0F0F2;
    } else {
        // Fallback on earlier versions
    }
    [self addSubview:title];
}
- (void)addHintLabel {
    UILabel *hintLabel = [[UILabel alloc]init];
    self.hintLabel = hintLabel;
    hintLabel.text = @"还未绑定账号哦～";
    hintLabel.font = [UIFont fontWithName:PingFangSCLight size: 15];
    if (@available(iOS 11.0, *)) {
        hintLabel.textColor = Color21_49_91_F0F0F2;
    } else {
        // Fallback on earlier versions
    }
    [self addSubview:hintLabel];
}
- (void)layoutSubviews {
    //MARK: - 电费部分的约束
    [self.electricFeeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(14);
        make.top.equalTo(self).offset(30);
    }];
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.electricFeeTitle.mas_bottom).offset(38);
        make.left.equalTo(self.electricFeeTitle.mas_right).offset(41);
    }];
}

@end
