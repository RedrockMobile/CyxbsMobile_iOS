//
//  ElectricityView.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/6/8.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "ElectricityView.h"
@interface ElectricityView ()

@end

@implementation ElectricityView

#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addTitle];
        [self addSeperateLine];
        [self setUIDefaults];//对自身进行设置
        if ([UserItem defaultItem].building && [UserItem defaultItem].room) {
            [self addBindingView];
        } else {
            [self addNoBindingView];
        }
//        [self addClearButton];//添加透明按钮用来在被点击后设置宿舍
    }
    return self;
}

#pragma mark - Method
- (void)setUIDefaults {
    if (@available(iOS 11.0, *)) {
        self.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#F8F9FC" alpha:1] darkColor:[UIColor colorWithHexString:@"#1D1D1D" alpha:1]];
    } else {
        // Fallback on earlier versions
    }

    //    self.layer.shadowOpacity = 0.16f;
    //    self.layer.shadowColor = [UIColor colorWithRed:174/255.0 green:182/255.0 blue:211/255.0 alpha:1].CGColor;
    //    self.layer.shadowOffset = CGSizeMake(0, 5);
    //    self.layer.cornerRadius = 25;
    self.clipsToBounds = YES;
}

- (void)addNoBindingView {
    [self addHintLabel];
}

- (void)removeUnbindingView {
    //    [self.electricFeeTitle removeFromSuperview];
    [self.hintLabel removeFromSuperview];
}

//点击之后跳转绑定宿舍
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self.delegate respondsToSelector:@selector(touchElectrictyView)]) {
        [self.delegate touchElectrictyView];
    }
}

- (void)refreshViewIfNeeded {
    [self removeUnbindingView];
    [self addBindingView];
}

#pragma mark - 公共部分
- (void)addTitle {
    //左上角标题
    [self addSubview:self.electricFeeTitle];
    
//    [self.electricFeeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(14);
//        make.top.equalTo(self).offset(23);
//    }];
}

- (void)addSeperateLine {
    UIView *line = [[UIView alloc]init];

    line.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#2A4E84" alpha:0.1] darkColor:[UIColor colorWithHexString:@"#2D2D2D" alpha:0.5]];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.equalTo(@1);
    }];
}

#pragma mark - 未绑定部分
- (void)addHintLabel {
    [self addSubview:self.hintLabel];
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(20);
    }];
}

#pragma mark - 绑定部分
- (void)addBindingView {
//    [self addSubview:self.electricFee];
    //其中涉及网络请求的有time,money,degree
    [self addTime];
    [self addMoney];
    [self addDegree];
    [self addYuan];
    [self addDu];
    [self addHintLeft];
    [self addHintRight];
    [self configUI];
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.16f;
    self.layer.shadowColor = [UIColor colorWithRed:174 / 255.0 green:182 / 255.0 blue:211 / 255.0 alpha:1].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 5);
}

- (void)addTime {
    //右上角抄表时间
    NSString *timeStr = [NSUserDefaults.standardUserDefaults objectForKey:@"ElectricFee_time"];

    NSString *elecTime = [[NSDate dateString:timeStr
                               fromFormatter:NSDateFormatter.defaultFormatter
                              withDateFormat:@"yyyy.M.dd"]
                          stringFromFormatter:NSDateFormatter.defaultFormatter
                               withDateFormat:@"M月d日抄表"];
    self.electricFeeTime.text = elecTime;

    [self addSubview:self.electricFeeTime];
}

- (void)addMoney {
    if ([NSUserDefaults.standardUserDefaults objectForKey:@"ElectricFee_money"] != NULL) {
        [self.electricFeeMoney setText:[NSUserDefaults.standardUserDefaults objectForKey:@"ElectricFee_money"]];
    } else {
        [self.electricFeeMoney setText:@"0"];
    }
    [self addSubview:self.electricFeeMoney];
}

- (void)addDegree {
    if ([NSUserDefaults.standardUserDefaults objectForKey:@"ElectricFee_degree"]) {
        self.electricFeeDegree.text = [NSString stringWithFormat:@"%@", [NSUserDefaults.standardUserDefaults objectForKey:@"ElectricFee_degree"]];
    } else {
        self.electricFeeDegree.text = @"0";
    }
    [self addSubview:self.electricFeeDegree];
}

- (void)addYuan {
    //汉字“元”
    [self addSubview:self.electricFeeYuan];
}

- (void)addDu {
    //汉字“度”
    [self addSubview:self.electricFeeDu];
}

- (void)addHintLeft {
    //汉字“费用、本月”
    [self addSubview:self.electricFeeHintLeft];
}

- (void)addHintRight {
    //汉字“使用度数，本月”
    [self addSubview:self.electricFeeHintRight];
}

- (void)configUI {
    [self.electricFeeTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.electricFeeTitle);
        make.right.equalTo(self).offset(-15);
    }];
    [self.electricFeeMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.electricFeeTitle.mas_bottom).offset(17);
        make.centerX.equalTo(self).offset(-self.width / 4.0);
        make.height.equalTo(@44);
    }];
    [self.electricFeeDegree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.electricFeeMoney);
        make.centerX.equalTo(self).offset(self.width / 4.0);
        make.height.equalTo(@44);
    }];
    [self.electricFeeYuan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.electricFeeMoney.mas_right).offset(9);
        make.bottom.equalTo(self.electricFeeMoney).offset(-6);
    }];
    [self.electricFeeDu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.electricFeeDegree.mas_right).offset(9);
        make.bottom.equalTo(self.electricFeeDegree).offset(-6);
    }];
    [self.electricFeeHintLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.electricFeeMoney.mas_bottom);
        make.centerX.equalTo(self.electricFeeMoney);
    }];
    [self.electricFeeHintRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.electricFeeDegree.mas_bottom);
        make.centerX.equalTo(self.electricFeeDegree);
    }];
}

#pragma mark - Lazy

- (UILabel *)electricFeeTime {
    if(!_electricFeeTime) {
        _electricFeeTime = [[UILabel alloc]init];
        _electricFeeTime.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
        _electricFeeTime.alpha = 0.54;
        _electricFeeTime.font = [UIFont fontWithName:PingFangSCLight size:10];
    }
    return _electricFeeTime;
}

- (UILabel *)electricFeeMoney {
    if (!_electricFeeMoney) {
        _electricFeeMoney = [[UILabel alloc]init];
        [_electricFeeMoney setTextColor:[UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#2A4E84" alpha:1] darkColor:[UIColor colorWithHexString:@"#DFDFE3" alpha:1]]];
        [_electricFeeMoney setFont:[UIFont fontWithName:ImpactMedium size:36]];
    }
    return _electricFeeMoney;
}

- (UILabel *)electricFeeDegree {
    if (!_electricFeeDegree) {
        _electricFeeDegree = [[UILabel alloc]init];
        _electricFeeDegree.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#2A4E84" alpha:1] darkColor:[UIColor colorWithHexString:@"#DFDFE3" alpha:1]];
        _electricFeeDegree.font = [UIFont fontWithName:ImpactMedium size:36];
    }
    return _electricFeeDegree;
}

- (UILabel *)electricFeeYuan {
    if (!_electricFeeYuan) {
        _electricFeeYuan = [[UILabel alloc]init];
        _electricFeeYuan.text = @"元";
        _electricFeeYuan.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
        _electricFeeYuan.font = [UIFont fontWithName:PingFangSCMedium size:13];
    }
    return _electricFeeYuan;
}

- (UILabel *)electricFeeDu {
    if (!_electricFeeDu) {
        _electricFeeDu = [[UILabel alloc]init];
        _electricFeeDu.text = @"度";
        _electricFeeDu.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
        _electricFeeDu.font = [UIFont fontWithName:PingFangSCMedium size:13];
    }
    return _electricFeeDu;
}

- (UILabel *)electricFeeTitle {
    if (!_electricFeeTitle) {
        _electricFeeTitle = [[UILabel alloc] initWithFrame:CGRectMake(14, 23, 80, 20)];
        _electricFeeTitle.text = @"电费查询";
        _electricFeeTitle.font = [UIFont fontWithName:PingFangSCBold size:18];
        _electricFeeTitle.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
    }
    return _electricFeeTitle;
}

- (UILabel *)electricFeeHintLeft {
    if (!_electricFeeHintLeft) {
        _electricFeeHintLeft = [[UILabel alloc]init];
        _electricFeeHintLeft.text = @"费用/本月";
        _electricFeeHintLeft.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:0.6] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:0.6]];
        _electricFeeHintLeft.font = [UIFont fontWithName:PingFangSCMedium size:13];
    }
    return _electricFeeHintLeft;
}

- (UILabel *)hintLabel {
    if(!_hintLabel){
        _hintLabel = [[UILabel alloc] init];
        _hintLabel.text = @"还未绑定账号哦～";
        _hintLabel.font = [UIFont fontWithName:PingFangSCLight size:15];
        _hintLabel.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
    }
    return _hintLabel;
}

- (UILabel *)electricFeeHintRight {
    if (!_electricFeeHintRight) {
        _electricFeeHintRight = [[UILabel alloc]init];
        _electricFeeHintRight.text = @"使用度数/本月";
        _electricFeeHintRight.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:0.6] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:0.6]];
        _electricFeeHintRight.font = [UIFont fontWithName:PingFangSCMedium size:13];
    }
    return _electricFeeHintRight;
}

@end
