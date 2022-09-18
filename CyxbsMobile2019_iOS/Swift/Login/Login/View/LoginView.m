//
//  LoginView.m
//  CyxbsMobile2019_iOS
//
//  Created by 宋开开 on 2022/8/12.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "LoginView.h"

@interface LoginView ()

/// Logo图片（暂时不需要）
@property (nonatomic, strong) UIImageView *logoImgView;

/// "登录"文字
@property (nonatomic, strong) UILabel *loginLab;

/// "登录"文字下方的欢迎文字
@property (nonatomic, strong) UILabel *welcomeLab;

@end


@implementation LoginView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.tfViewArray = [NSMutableArray array];
        // 加入Logo和忘记密码按钮
//        [self addSubview:self.logoImgView];
        [self addSubview:self.loginLab];
        [self addSubview:self.welcomeLab];
        [self addSubview:self.forgetPwdBtn];
        [self addSubview:self.protocolBtn];
        [self addSubview:self.agreeBtn];
        [self setLoginPosition];
        [self update];
    }
    return self;
}

#pragma mark - Method

/// 更新一些属性
- (void)update {
    // 1.更改passwordTipLab
    self.passwordTipLab.textColor =
    [UIColor dm_colorWithLightColor:
        [UIColor colorWithHexString:@"#AFADB2" alpha:1.0]
                          darkColor:
        [UIColor colorWithHexString:@"#636267" alpha:1.0]];
    self.passwordTipLab.font = [UIFont systemFontOfSize:14];
    // 2.更改登录按钮颜色
    [self.btn setTitleColor:[UIColor colorWithHexString:@"#F8F8F8"] forState:UIControlStateNormal];
}

/// 设置位置
- (void)setLoginPosition {
    // loginLab
    [self.loginLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self).offset(80);
        make.size.mas_equalTo(CGSizeMake(68, 47.67));
    }];
    
    // welcomeLab
    [self.welcomeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.loginLab);
        make.top.equalTo(self).offset(127.67);
        make.size.mas_equalTo(CGSizeMake(216, 25.33));
    }];
}

/// 需要依据登录按钮来设置约束的，应该在加载完登录按钮后设置位置
- (void)setPositionAccordingToBtn {
    // forgetPwdBtn
    [self.forgetPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.btn.mas_bottom).offset(30);
        make.size.mas_equalTo(CGSizeMake(67, 28));
    }];
    
    // protocolBtn
    [self.protocolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(20);
        make.top.equalTo(self.forgetPwdBtn.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(140, 30));
    }];
    
    // agreeBtn
    [self.agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.protocolBtn);
        make.right.equalTo(self.protocolBtn.mas_left).offset(-10);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
}
#pragma mark - Getter

- (UIImageView *)logoImgView {
    if (_logoImgView == nil) {
        _logoImgView = [[UIImageView alloc] init];
        _logoImgView.image = [UIImage imageNamed:@"7"];
        _logoImgView.layer.masksToBounds = YES;
        _logoImgView.layer.cornerRadius = 10;
        // 尺寸
        CGRect frame = _logoImgView.frame;
        frame.size = CGSizeMake(100, 100);
        _logoImgView.frame = frame;
        _logoImgView.center = CGPointMake(SCREEN_WIDTH * 0.5, 130);
    }
    return _logoImgView;
}

- (UILabel *)loginLab {
    if (_loginLab == nil) {
        _loginLab = [[UILabel alloc] init];
        _loginLab.text = @"登录";
        _loginLab.textColor =
        [UIColor dm_colorWithLightColor:
         [UIColor colorWithHexString:@"#15315B" alpha:1.0]
                              darkColor:
         [UIColor colorWithHexString:@"#F0F0F0" alpha:1.0]];
        _loginLab.font = [UIFont fontWithName:PingFangSCSemibold size:34];
    }
    return _loginLab;
}

- (UILabel *)welcomeLab {
    if (_welcomeLab == nil) {
        _welcomeLab = [[UILabel alloc] init];
        _welcomeLab.text = @"您好，欢迎来到掌上重邮！";
        _welcomeLab.textColor =
        [UIColor dm_colorWithLightColor:
         [UIColor colorWithHexString:@"#6C809B" alpha:1.0]
                              darkColor:
         [UIColor colorWithHexString:@"#909090" alpha:1.0]];
        _welcomeLab.font = [UIFont fontWithName:PingFangSCSemibold size:18];
    }
    return _welcomeLab;
}

- (UIButton *)forgetPwdBtn {
    if (_forgetPwdBtn == nil) {
        _forgetPwdBtn = [[UIButton alloc] init];
        [_forgetPwdBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
        _forgetPwdBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_forgetPwdBtn setTitleColor:
         [UIColor dm_colorWithLightColor:
             [UIColor colorWithHexString:@"#AEBCD5" alpha:1.0]
                               darkColor:
             [UIColor colorWithHexString:@"AFBAD6" alpha:1.0]] forState:UIControlStateNormal];
    }
    return _forgetPwdBtn;
}

- (UIButton *)protocolBtn {
    if (_protocolBtn == nil) {
        _protocolBtn = [[UIButton alloc] init];
        [_protocolBtn setTitle:@"同意《掌上重邮用户协议》" forState:UIControlStateNormal];
        _protocolBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_protocolBtn setTitleColor:
         [UIColor dm_colorWithLightColor:
             [UIColor colorWithHexString:@"#AEBCD5" alpha:1.0]
                               darkColor:
             [UIColor colorWithHexString:@"AFBAD6" alpha:1.0]] forState:UIControlStateNormal];
    }
    return _protocolBtn;
}

- (UIButton *)agreeBtn {
    if (_agreeBtn == nil) {
        _agreeBtn = [[UIButton alloc] init];
        _agreeBtn.layer.masksToBounds = YES;
        _agreeBtn.layer.cornerRadius = 8;
        [_agreeBtn.layer setBorderWidth:1];
        [_agreeBtn.layer setBorderColor:
         [UIColor dm_colorWithLightColor:
             [UIColor colorWithHexString:@"#4A45DC" alpha:1.0]
                               darkColor:
             [UIColor colorWithHexString:@"#0000EE" alpha:1.0]].CGColor];
        [_agreeBtn setImage:[UIImage imageNamed:@"checkMarkCircle"] forState:UIControlStateNormal];
    }
    return _agreeBtn;
}

@end
