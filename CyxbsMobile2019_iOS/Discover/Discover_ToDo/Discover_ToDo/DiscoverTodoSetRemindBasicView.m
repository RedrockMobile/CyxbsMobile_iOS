//
//  DiscoverTodoSetRemindBasicView.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/8/8.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "DiscoverTodoSetRemindBasicView.h"

@implementation DiscoverTodoSetRemindBasicView
- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1] darkColor:[UIColor colorWithHexString:@"#2C2C2C" alpha:1]];
        self.isViewHided = YES;
        self.alpha = 0;
        [self addTipView];
        [self addCancelBtn];
        [self addSureBtn];
        [self addSeparateLine];
    }
    return self;
}
//MARK: - 初始化UI：
/// 添加紫色的TipView
- (void)addTipView {
    UIImageView* view = [[UIImageView alloc] init];
    [self addSubview:view];
    self.tipView = view;
    
    [view setImage:[UIImage imageNamed:@"todo紫色提醒图标"]];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0.016*SCREEN_WIDTH);
        make.height.mas_equalTo(0.02057142857*SCREEN_WIDTH);
    }];
}
/// 添加底部的取消按钮
- (void)addCancelBtn {
    UIButton* btn = [[UIButton alloc] init];
    [self addSubview:btn];
    self.cancelBtn = btn;
    
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    btn.layer.cornerRadius = 20;
    [btn setBackgroundColor:[UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#EDF4FD" alpha:1] darkColor:[UIColor colorWithHexString:@"#484A4D" alpha:1]]];
    
    [btn.titleLabel setFont:[UIFont fontWithName:PingFangSCSemibold size:18]];
    [btn setTitleColor:[UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]] forState:UIControlStateNormal];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0.128*SCREEN_WIDTH);
        make.bottom.equalTo(self).offset(-0.04926108374*SCREEN_HEIGHT);
        make.width.mas_equalTo(0.32*SCREEN_WIDTH);
        make.height.mas_equalTo(0.1066666667*SCREEN_WIDTH);
    }];
}
/// 添加确定的取消按钮
- (void)addSureBtn {
    UIButton* btn = [[UIButton alloc] init];
    [self addSubview:btn];
    self.sureBtn = btn;
    
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    btn.layer.cornerRadius = 20;
    [btn setBackgroundColor:[UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#4841E2" alpha:1] darkColor:[UIColor colorWithHexString:@"#4841E2" alpha:1]]];
    
    [btn.titleLabel setFont:[UIFont fontWithName:PingFangSCSemibold size:18]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-0.128*SCREEN_WIDTH);
        make.bottom.equalTo(self).offset(-0.04926108374*SCREEN_HEIGHT);
        make.width.mas_equalTo(0.32*SCREEN_WIDTH);
        make.height.mas_equalTo(0.1066666667*SCREEN_WIDTH);
    }];
}
/// 添加 分隔线 的方法
- (void)addSeparateLine{
    UIView *view = [[UIView alloc] init];
    [self addSubview:view];
    self.separatorLine = view;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    
    if (@available(iOS 11.0, *)) {
        view.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#2C2C2C" alpha:0.2] darkColor:[UIColor colorWithHexString:@"#E6E6E6" alpha:0.4]];
    } else {
        view.backgroundColor = [UIColor colorWithRed:45/255.0 green:45/255.0 blue:45/255.0 alpha:0.64];
    }
}

- (void)showView{
    
}

@end
