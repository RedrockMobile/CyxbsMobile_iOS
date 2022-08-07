//
//  AlertView.m
//  CyxbsMobile2019_iOS
//
//  Created by 小艾同学 on 2022/8/6.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "AlertView.h"

@interface AlertView()
/// 弹窗
@property (nonatomic, strong) UIView *alertView;
/// 大标题
@property (nonatomic, strong) NSString *title;
/// 小标题
@property (nonatomic, strong) NSString *hint;
/// 左按钮
@property (nonatomic, strong) UIButton *leftButton;
/// 右按钮
@property (nonatomic, strong) UIButton *rightButton;
/// 大标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 小标题
@property (nonatomic, strong) UILabel *hintLabel;

@end

@implementation AlertView

- (instancetype)initWithTitle:(NSString *)titleString AndHintTitle:(NSString *)hintString {
    self = [super init];
    if (self) {
        self.title = titleString;
        self.hint = hintString;
        if (@available(iOS 11.0, *)) {
            self.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#000F25" alpha:0.14] darkColor:[UIColor colorWithHexString:@"#000000" alpha:0.5]];
        } else {
            self.backgroundColor = [UIColor colorWithHexString:@"#000F25" alpha:0.14];
        }
        [self setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        
        [self addAlertView];
    }
    return self;
}

// 提示框
- (void)addAlertView {
    UIView *view = [[UIView alloc] init];
    self.alertView = view;
    view.layer.cornerRadius = 12.5;
    if (@available(iOS 11.0, *)) {
        view.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1] darkColor:[UIColor colorWithHexString:@"#2C2C2C" alpha:1]];
    } else {
        view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:1];
    }
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0.16*SCREEN_WIDTH);
        make.top.equalTo(self).offset(0.43*SCREEN_HEIGHT);
        make.right.equalTo(self).offset(-0.16*SCREEN_WIDTH);
        make.bottom.equalTo(self).offset(-0.39*SCREEN_HEIGHT);
    }];
    
    [self addTitle];        // 添加标题
    [self addHint];         // 副标题
    [self addLeftButton];   // 左
    [self addRightButton];  // 右
    
}

// 标题
- (void)addTitle {
    UILabel *label = [[UILabel alloc] init];
    self.titleLabel = label;
    label.numberOfLines = 0;
    label.text = self.title;
    if (@available(iOS 11.0, *)) {
        label.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#112C54" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
    } else {
        label.textColor = [UIColor colorWithHexString:@"#112C54" alpha:1];
    }
    label.font = [UIFont fontWithName:PingFangSC size:14];
    
    [self.alertView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.alertView).mas_offset(32);
        make.centerX.equalTo(self.alertView);
    }];
}


- (void)addHint {
    UILabel *label = [[UILabel alloc] init];
    self.hintLabel = label;
    label.text = self.hint;
//    label.textColor = [UIColor colorNamed:@"titleColor"];
//    label.font = [UIFont systemFontOfSize:14];
    if (@available(iOS 11.0, *)) {
        label.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#112C54" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
    } else {
        label.textColor = [UIColor colorWithHexString:@"#112C54" alpha:1];
    }
    label.font = [UIFont fontWithName:PingFangSC size:14];
    
    [self.alertView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel).mas_offset(25);
        make.centerX.equalTo(self.alertView);
    }];
}


// 左按钮
- (void)addLeftButton {
    UIButton *leftBtn = [[UIButton alloc] init];
    self.leftButton = leftBtn;
//    [leftBtn setBackgroundColor:[UIColor colorNamed:@"取消Color"]];
    if (@available(iOS 11.0, *)) {
        leftBtn.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#C3D4EE" alpha:1] darkColor:[UIColor colorWithHexString:@"#5A5A5A" alpha:0.8]];
    } else {
        leftBtn.backgroundColor = [UIColor colorWithHexString:@"#C3D4EE" alpha:1];
    }
    leftBtn.layer.cornerRadius = 16;
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.alertView addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.alertView).mas_offset(0.069*SCREEN_WIDTH);
        make.top.equalTo(self.hintLabel.mas_bottom).mas_offset(24);
        make.height.mas_equalTo(34);
        make.width.mas_equalTo(0.246*SCREEN_WIDTH);
    }];
}

// 左按钮方法
- (void)leftButtonClicked {
    [self removeFromSuperview];
}

// 右按钮
- (void)addRightButton {
    UIButton *rightBtn = [[UIButton alloc] init];
    self.rightButton = rightBtn;
    rightBtn.layer.cornerRadius = 16;
//    rightBtn.backgroundColor = [UIColor colorNamed:@"确定Color"];
    if (@available(iOS 11.0, *)) {
        rightBtn.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#4A44E4" alpha:1] darkColor:[UIColor colorWithHexString:@"#4A44E4" alpha:0.8]];
    } else {
        rightBtn.backgroundColor = [UIColor colorWithHexString:@"#4A44E4" alpha:1];
    }
    
    [self.alertView addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.alertView).mas_offset(-0.069*SCREEN_WIDTH);
        make.left.equalTo(self.leftButton.mas_right).mas_offset(0.067*SCREEN_WIDTH);
        make.centerY.equalTo(self.leftButton);
        make.width.equalTo(self.leftButton);
    }];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

// 右按钮方法
- (void)rightButtonClicked {
    [self.delegate rightButtonTouchedDelegateWithBtn:self.leftButton];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
