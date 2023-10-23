//
//  LoginBaseView.m
//  CyxbsMobile2019_iOS
//
//  Created by 宋开开 on 2022/8/9.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "LoginBaseView.h"

@interface LoginBaseView ()

/// 顶部“忘记密码”的文字
@property (nonatomic, strong) UILabel *ForgetPwdLab;

/// COPYRIGHT@红岩网校工作站
@property (nonatomic, strong) UILabel *RedRockSignLab;

@end

@implementation LoginBaseView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.tfViewArray = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Method

/// 加入底部红岩网校标识
- (void)addCopyRight {
    [self addSubview:self.RedRockSignLab];
    [self.RedRockSignLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-22);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(142, 14));
    }];
}

/// 添加顶部返回按钮
- (void)addBackItem {
    if (self.isBack) {
        self.backgroundColor =
        [UIColor dm_colorWithLightColor:UIColor.whiteColor
                              darkColor:
            [UIColor colorWithHexString:@"#191919" alpha:1.0]];
        [self addCopyRight];
        [self addSubview:self.backBtn];
        [self addSubview:self.ForgetPwdLab];
        
        // 设置位置
        [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(34);
            make.top.equalTo(self).offset(STATUSBARHEIGHT + 11.58);
            make.size.mas_equalTo(CGSizeMake(9, 16));
        }];
        
        [self.ForgetPwdLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(STATUSBARHEIGHT + 7.5);
            make.size.mas_equalTo(CGSizeMake(72, 25));
        }];
    }else {
        self.backgroundColor =
        [UIColor dm_colorWithLightColor:
            [UIColor colorWithHexString:@"#F6F6F6" alpha:1.0]
                              darkColor:
            [UIColor colorWithHexString:@"#010101" alpha:1.0]];
    }
}

/// 根据输入框个数来展示输入框
- (void)addTextField {
    for (unsigned long i = 0; i < self.textFieldCount; i++) {
        LoginTextFieldView *tfView = [[LoginTextFieldView alloc] init];
        tfView.isLoginVC = !self.isBack;
        [tfView setTextTield];
        [self addSubview:tfView];
        // 设置位置
        if (self.tfViewArray.count == 0) {
            // 忘记密码的两个界面
            if (self.isBack) {
                [tfView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self);
                    make.left.equalTo(self).offset(47);
                    make.height.mas_equalTo(44);
                    make.top.equalTo(self).offset(STATUSBARHEIGHT + 84);
                }];
            }else {
                [tfView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self);
                    make.left.equalTo(self).offset(20);
                    make.height.mas_equalTo(44);
                    make.top.equalTo(self).offset(STATUSBARHEIGHT + 160);
                }];
            }
            
        }else {
                [tfView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self);
                    make.top.equalTo(self.tfViewArray.lastObject.mas_bottom).offset(22);
                    make.size.mas_equalTo(self.tfViewArray.lastObject);
                }];
        }
        [self.tfViewArray addObject:tfView];
    }
}

/// 如果有提示文字，设置提示文字数据
- (void)addPasswordTip {
    if (self.isPasswordtip == YES) {
        [self addSubview:self.passwordTipLab];
        [self.passwordTipLab mas_makeConstraints:^(MASConstraintMaker*make) {
            make.top.equalTo(self.tfViewArray.lastObject.mas_bottom).offset(14);
            make.left.equalTo(self.tfViewArray.lastObject);
            make.right.equalTo(self.tfViewArray.lastObject).offset(10);
            make.height.mas_equalTo(32);
        }];
    }
}

/// 按钮
- (void)addBtn {
    [self addSubview:self.btn];
    if (self.isPasswordtip == YES) {
        [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.passwordTipLab.mas_bottom).offset(28);
            make.left.equalTo(self).offset(64);
            make.height.mas_equalTo(51);
        }];
    }else {
        [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.tfViewArray.lastObject.mas_bottom).offset(72);
            make.left.equalTo(self).offset(64);
            make.height.mas_equalTo(51);
        }];
    }
}

#pragma mark - Getter

- (UIButton *)backBtn {
    if (_backBtn == nil) {
        _backBtn = [[UIButton alloc] init];
        [_backBtn setImage:[UIImage imageNamed:@"backToLogin"] forState:UIControlStateNormal];
    }
    return _backBtn;
}

- (UILabel *)ForgetPwdLab {
    if (_ForgetPwdLab == nil) {
        _ForgetPwdLab = [[UILabel alloc] init];
        _ForgetPwdLab.text = @"忘记密码";
        _ForgetPwdLab.textColor =
        [UIColor dm_colorWithLightColor:
            [UIColor colorWithHexString:@"#242424" alpha:1.0]
                              darkColor:
            [UIColor colorWithHexString:@"#F1F1F1" alpha:1.0]];
        _ForgetPwdLab.font = [UIFont fontWithName:PingFangSCSemibold size:18];
        
    }
    return _ForgetPwdLab;
}

- (UILabel *)passwordTipLab {
    if (_passwordTipLab == nil) {
        _passwordTipLab = [[UILabel alloc] init];
        _passwordTipLab.textColor =
        [UIColor dm_colorWithLightColor:
            [UIColor colorWithHexString:@"#FFB3C5" alpha:1.0]
                              darkColor:
            [UIColor colorWithHexString:@"#FFA2BA" alpha:0.4]];
        _passwordTipLab.font = [UIFont fontWithName:PingFangSCMedium size:11];
        _passwordTipLab.numberOfLines = 0;
        _passwordTipLab.textAlignment = NSTextAlignmentLeft;
    }
    return _passwordTipLab;
}

- (UIButton *)btn {
    if (_btn == nil) {
        _btn = [[UIButton alloc] init];
        _btn.titleLabel.font = [UIFont fontWithName:PingFangSCSemibold size:18];
        [_btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _btn.layer.masksToBounds = YES;
        _btn.layer.cornerRadius = 25.5;
    }
    return _btn;
}

- (UILabel *)RedRockSignLab {
    if (_RedRockSignLab == nil) {
        _RedRockSignLab = [[UILabel alloc] init];
        _RedRockSignLab.text = @"COPYRIGHT@红岩网校工作站";
        _RedRockSignLab.textColor =
        [UIColor dm_colorWithLightColor:
            [UIColor colorWithHexString:@"#A4A3B7" alpha:1.0]
                              darkColor:
            [UIColor colorWithHexString:@"#A4A3B7" alpha:0.5]];
        _RedRockSignLab.textAlignment = NSTextAlignmentLeft;
        _RedRockSignLab.font = [UIFont fontWithName:PingFangSCMedium size:10];
    }
    return _RedRockSignLab;
}
@end
