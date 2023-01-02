//
//  ElectricityView.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/6/8.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "ElectricityView.h"
@interface ElectricityView()

@end

@implementation ElectricityView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTitle];
        [self addSeperateLine];
        [self setUIDefaults];//对自身进行设置
        if([UserItem defaultItem].building && [UserItem defaultItem].room) {
            [self addBindingView];
        }else {
            [self addNoBindingView];
        }
        [self addClearButton];//添加透明按钮用来在被点击后设置宿舍
    }
    return self;
}
-(void)setUIDefaults {
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
-(void)addNoBindingView {
    [self addHintLabel];
}
-(void)removeUnbindingView {
//    [self.electricFeeTitle removeFromSuperview];
    [self.hintLabel removeFromSuperview];
}
-(void) addClearButton {
    UIButton * button = [[UIButton alloc]init];
    [button addTarget:self action:@selector(touchSelf) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    self.clearButton = button;

}
//被点击时调用的方法
-(void)touchSelf {
    if ([self.delegate respondsToSelector:@selector(touchElectrictyView)]) {
        [self.delegate touchElectrictyView];
    }
}

-(void)refreshViewIfNeeded {
    [self removeUnbindingView];
    [self addBindingView];
}


//MARK: 公共部分
- (void)addTitle {
    UILabel *title = [[UILabel alloc]init];//左上角标题
    self.electricFeeTitle = title;
    title.text = @"电费查询";
    title.font = [UIFont fontWithName:PingFangSCBold size: 18];
    title.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
    [self addSubview:title];

}

- (void)addSeperateLine {
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#2A4E84" alpha:0.1] darkColor:[UIColor colorWithHexString:@"#2D2D2D" alpha:0.5]];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@1);
    }];
}

//MARK: 未绑定部分
- (void)addHintLabel {
    UILabel *hintLabel = [[UILabel alloc]init];
    self.hintLabel = hintLabel;
    hintLabel.text = @"还未绑定账号哦～";
    hintLabel.font = [UIFont fontWithName:PingFangSCLight size: 15];
    hintLabel.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
    [self addSubview:hintLabel];

}

//MARK: 绑定部分
- (void) addBindingView {
//    [self addSubview:self.electricFee];
    //其中涉及网络请求的有time,money,degree
    
    [self addTime];
    [self addMoney];
    [self addDegree];
    [self addYuan];
    [self addDu];
    [self addHintLeft];
    [self addHintRight];
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.16f;
    self.layer.shadowColor = [UIColor colorWithRed:174/255.0 green:182/255.0 blue:211/255.0 alpha:1].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 5);
    
}



- (void)addTime {
    if(self.electricFeeTime) {
        [self.electricFeeTime removeFromSuperview];
    }
    UILabel *timeLab = [[UILabel alloc]init];//右上角抄表时间
    self.electricFeeTime = timeLab;
    NSString *timeStr = [NSUserDefaults.standardUserDefaults objectForKey:@"ElectricFee_time"];
    if (timeLab != NULL) {
        NSString *elecTime =
        [[NSDate dateString:timeStr
              fromFormatter:NSDateFormatter.defaultFormatter
             withDateFormat:@"yyyy.M.dd"]
         stringFromFormatter:NSDateFormatter.defaultFormatter
         withDateFormat:@"M月d日抄表"];
        timeLab.text = elecTime;
    }else {
        timeLab.text = @"加载失败";
    }
    timeLab.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
    timeLab.alpha = 0.54;
    timeLab.font = [UIFont fontWithName:PingFangSCLight size: 10];
    [self addSubview:timeLab];
}

- (void)addMoney {
    if(self.electricFeeMoney) {
        [self.electricFeeMoney removeFromSuperview];
    }
    UIButton *money = [[UIButton alloc]init];//左边数字
    self.electricFeeMoney = money;
    if ([NSUserDefaults.standardUserDefaults objectForKey:@"ElectricFee_money"] != NULL) {
        [money setTitle:[NSUserDefaults.standardUserDefaults objectForKey:@"ElectricFee_money"] forState:UIControlStateNormal];
    }else {
        [money setTitle:@"0" forState:UIControlStateNormal];
    }
//    money.text = @"0";
    if (@available(iOS 11.0, *)) {
        [money setTitleColor:[UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#2A4E84" alpha:1] darkColor:[UIColor colorWithHexString:@"#DFDFE3" alpha:1]] forState:UIControlStateNormal];
    } else {
        // Fallback on earlier versions
    }
    money.titleLabel.font = [UIFont fontWithName:ImpactMedium size: 36];
    [self addSubview:money];

}

- (void)addDegree {
    if(self.electricFeeDegree) {
        [self.electricFeeDegree removeFromSuperview];
    }
    UILabel *degree = [[UILabel alloc]init];//右边数字
    self.electricFeeDegree = degree;
    if ([NSUserDefaults.standardUserDefaults objectForKey:@"ElectricFee_degree"]){
        degree.text = [NSString stringWithFormat:@"%@", [NSUserDefaults.standardUserDefaults objectForKey:@"ElectricFee_degree"]];
        
    }else {
        degree.text = @"0";
    }
    
    if (@available(iOS 11.0, *)) {
        degree.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#2A4E84" alpha:1] darkColor:[UIColor colorWithHexString:@"#DFDFE3" alpha:1]];
    } else {
        // Fallback on earlier versions
    }
    degree.font = [UIFont fontWithName: ImpactMedium size: 36];
    [self addSubview:degree];

}

- (void)addYuan {
    if(self.electricFeeYuan) {
        [self.electricFeeYuan removeFromSuperview];
    }
    UILabel *yuan = [[UILabel alloc]init];//汉字“元”
    self.electricFeeYuan = yuan;
    yuan.text = @"元";
    yuan.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
    yuan.font = [UIFont fontWithName:PingFangSCMedium size: 13];
    [self addSubview:yuan];

}

- (void)addDu {
    if(self.electricFeeDu) {
        [self.electricFeeDu removeFromSuperview];
    }
    UILabel *du = [[UILabel alloc]init];//汉字“度”
    self.electricFeeDu = du;
    du.text = @"度";
    du.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
    du.font = [UIFont fontWithName:PingFangSCMedium size: 13];
    [self addSubview:du];

}

- (void)addHintLeft {
    if(self.electricFeeHintLeft) {
        [self.electricFeeHintLeft removeFromSuperview];
    }
    UILabel *hintLeft = [[UILabel alloc]init];//汉字“费用、本月”
    self.electricFeeHintLeft = hintLeft;
    hintLeft.text = @"费用/本月";
    hintLeft.font = [UIFont fontWithName:PingFangSCLight size: 13];
    hintLeft.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
    hintLeft.alpha = 0.6;
    [self addSubview:hintLeft];

}

- (void)addHintRight {
    if(self.electricFeeHintRight) {
        [self.electricFeeHintRight removeFromSuperview];
    }
    UILabel *hintRight = [[UILabel alloc] init];//汉字“使用度数，本月”
    self.electricFeeHintRight = hintRight;
        hintRight.text = @"使用度数/本月";
    hintRight.font = [UIFont fontWithName:PingFangSCLight size: 13];
    hintRight.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
    hintRight.alpha = 0.6;
    [self addSubview:hintRight];

}
- (void)layoutSubviews {
    [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    [self.electricFeeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(14);
        make.top.equalTo(self).offset(23);
    }];
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(20);
    }];
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
@end
