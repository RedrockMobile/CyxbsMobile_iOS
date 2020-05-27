//
//  ElectricFeeGlanceView.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/1/28.
//  Copyright © 2020 Redrock. All rights reserved.
//

///平方字体部分
#define PingFangSC @".PingFang SC"
//Bahnschrift字体部分
#define ImpactMedium @"Impact"
#define ImpactRegular @"Impact"
//颜色部分
#define Color42_78_132 [UIColor colorNamed:@"color42_78_132&#FFFFFF" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]

#define Color21_49_91_F0F0F2  [UIColor colorNamed:@"color21_49_91&#F0F0F2" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]
#import "ElectricFeeGlanceButton.h"
@interface ElectricFeeGlanceButton()
@property NSUserDefaults *defaults;

@end
@implementation ElectricFeeGlanceButton
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadUserDefaults];//加载缓存用作视图的初始化
        [self addElectricFeeButton];
        
        self.layer.cornerRadius = 25;
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
        button.backgroundColor = [UIColor colorNamed:@"colorLikeWhite&#1D1D1D" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil];
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
        
        title.textColor = Color21_49_91_F0F0F2;
    } else {
        // Fallback on earlier versions
    }
    [self.electricFee addSubview:title];
}
- (void)addTime {
    UILabel *time = [[UILabel alloc]init];//右上角抄表时间
    self.electricFeeTime = time;
    if ([self.defaults objectForKey:@"ElectricFee_time"]!= NULL) {
        time.text = [self.defaults objectForKey:@"ElectricFee_time"];
    }else {
        time.text = @"加载失败";
    }
    if (@available(iOS 11.0, *)) {
        time.textColor = Color21_49_91_F0F0F2;
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
    if ([self.defaults objectForKey:@"ElectricFee_money"] != NULL) {
        money.text = [self.defaults objectForKey:@"ElectricFee_money"];
    }else {
        money.text = @"0";
    }
//    money.text = @"0";
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
    NSLog(@"%@",[self.defaults objectForKey:@"ElectricFee_degree"]);
    if ([self.defaults objectForKey:@"ElectricFee_degree"] != NULL){
        degree.text = [self.defaults objectForKey:@"ElectricFee_degree"];
    }else {
        degree.text = @"0";
    }
    
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
        yuan.textColor = Color21_49_91_F0F0F2;
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
        du.textColor = Color21_49_91_F0F0F2;
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
    
}
@end
