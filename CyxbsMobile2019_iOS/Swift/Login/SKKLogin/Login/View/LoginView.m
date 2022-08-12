//
//  LoginView.m
//  CyxbsMobile2019_iOS
//
//  Created by 宋开开 on 2022/8/12.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "LoginView.h"

@interface LoginView ()

/// Logo图片
@property (nonatomic, strong) UIImageView *logoImgView;

@end


@implementation LoginView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.tfViewArray = [NSMutableArray array];
        // 加入Logo和忘记密码按钮
        [self addSubview:self.logoImgView];
        [self addSubview:self.forgetPwdBtn];
        [self addSubview:self.protocolBtn];
        [self addSubview:self.agreeBtn];
        [self setLoginPosition];
    }
    return self;
}

#pragma mark - Method
/// 设置位置
- (void)setLoginPosition {
    // forgetPwdBtn
    [self.forgetPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(220);
        make.right.equalTo(self).offset(-30);
        make.size.mas_equalTo(CGSizeMake(120, 30));
    }];
    // protocolBtn
    [self.protocolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(20);
        make.top.equalTo(self.forgetPwdBtn.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(220, 30));
    }];
    // agreeBtn
    [self.agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.protocolBtn);
        make.right.equalTo(self.protocolBtn.mas_left).offset(5);
        make.size.mas_equalTo(CGSizeMake(30, 30));
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

- (UIButton *)forgetPwdBtn {
    if (_forgetPwdBtn == nil) {
        _forgetPwdBtn = [[UIButton alloc] init];
        [_forgetPwdBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
        [_forgetPwdBtn setTitleColor:UIColor.brownColor forState:UIControlStateNormal];
    }
    return _forgetPwdBtn;
}

- (UIButton *)protocolBtn {
    if (_protocolBtn == nil) {
        _protocolBtn = [[UIButton alloc] init];
        [_protocolBtn setTitle:@"同意《掌上重邮用户协议》" forState:UIControlStateNormal];
        [_protocolBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    }
    return _protocolBtn;
}

- (UIButton *)agreeBtn {
    if (_agreeBtn == nil) {
        _agreeBtn = [[UIButton alloc] init];
        [_agreeBtn setImage:[UIImage imageNamed:@"checkMarkCircle"] forState:UIControlStateNormal];
    }
    return _agreeBtn;
}

@end
