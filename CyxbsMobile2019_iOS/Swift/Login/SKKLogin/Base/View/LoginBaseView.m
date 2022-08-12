//
//  LoginBaseView.m
//  CyxbsMobile2019_iOS
//
//  Created by 宋开开 on 2022/8/9.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "LoginBaseView.h"

@interface LoginBaseView ()

/// 顶部“忘记密码”的按钮
@property (nonatomic, strong) UILabel *ForgetPwdLab;

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

/// 添加顶部返回按钮
- (void)addBackItem {
    if (self.isBack) {
        [self addSubview:self.backBtn];
        [self addSubview:self.ForgetPwdLab];
        
        // 设置位置
        [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.top.equalTo(self).offset(30);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        
        [self.ForgetPwdLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.backBtn.mas_right).offset(15);
            make.centerY.equalTo(self.backBtn);
            make.size.mas_equalTo(CGSizeMake(100, 40));
        }];
    }
}

/// 根据输入框个数来展示输入框
- (void)addTextField {
    for (unsigned long i = 0; i < self.textFieldCount; i++) {
        LoginTextFieldView *tfView = [[LoginTextFieldView alloc] init];
        [self addSubview:tfView];
        // 设置位置
        if (self.tfViewArray.count == 0) {
            [tfView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.equalTo(self).offset(180);
                make.size.mas_equalTo(CGSizeMake(280, 90));
            }];
            
        }else {
            [tfView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.equalTo(self.tfViewArray.lastObject.mas_bottom).offset(20);
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
        [self.passwordTipLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.tfViewArray.lastObject.mas_bottom).offset(5);
            make.width.equalTo(self.tfViewArray.lastObject);
            make.height.mas_equalTo(60);
        }];
    }
}

/// 按钮
- (void)addBtn {
    [self addSubview:self.btn];
    if (self.isPasswordtip == YES) {
        [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.passwordTipLab.mas_bottom).offset(50);
            make.width.equalTo(self.tfViewArray.lastObject);
            make.height.mas_equalTo(40);
        }];
    }else {
        [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.tfViewArray.lastObject.mas_bottom).offset(150);
            make.width.equalTo(self.tfViewArray.lastObject);
            make.height.mas_equalTo(40);
        }];
    }
}

#pragma mark - Getter

- (UIButton *)backBtn {
    if (_backBtn == nil) {
        _backBtn = [[UIButton alloc] init];
        [_backBtn setImage:[UIImage imageNamed:@"7"] forState:UIControlStateNormal];
    }
    return _backBtn;
}

- (UILabel *)ForgetPwdLab {
    if (_ForgetPwdLab == nil) {
        _ForgetPwdLab = [[UILabel alloc] init];
        _ForgetPwdLab.text = @"忘记密码";
        _ForgetPwdLab.textColor = UIColor.blackColor;
        _ForgetPwdLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:21.0];
        
    }
    return _ForgetPwdLab;
}

- (UILabel *)passwordTipLab {
    if (_passwordTipLab == nil) {
        _passwordTipLab = [[UILabel alloc] init];
        _passwordTipLab.textColor = UIColor.grayColor;
        _passwordTipLab.font = [UIFont systemFontOfSize:18];
        _passwordTipLab.textAlignment = NSTextAlignmentLeft;
        _passwordTipLab.numberOfLines = 2;
    }
    return _passwordTipLab;
}

- (UIButton *)btn {
    if (_btn == nil) {
        _btn = [[UIButton alloc] init];
        _btn.titleLabel.font = [UIFont boldSystemFontOfSize:22];
        [_btn setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
        _btn.layer.masksToBounds = YES;
        _btn.layer.cornerRadius = 10;
    }
    return _btn;
}

@end
