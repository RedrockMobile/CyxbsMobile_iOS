//
//  UserAgreementViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/11/10.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "UserAgreementViewController.h"

#import "ScheduleNeedsSupport.h"

#import "UserAgreementView.h"
#import "UserAgreementConsentView.h"

#pragma mark - UserAgreementViewController ()

@interface UserAgreementViewController () <
    UserAgreementConsentViewDelegate
>

/// title
@property (nonatomic, strong) UILabel *titleLab;

/// user agreement view
@property (nonatomic, strong) UserAgreementView *agreementView;

/// consent view
@property (nonatomic, strong) UserAgreementConsentView *consentView;

/// cancel btn
@property (nonatomic, copy) UIButton *cancelBtn;

@end

#pragma mark - UserAgreementViewController

@implementation UserAgreementViewController {
    CAGradientLayer *_gradientLayer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =
    [UIColor Light:UIColorHex(#FFFFFF)
              Dark:UIColorHex(#1D1D1D)];
    
    [self.view addSubview:self.agreementView];
    [self.view addSubview:self.titleLab];
    [self.view addSubview:self.consentView];
    [self.view addSubview:self.cancelBtn];
}

#pragma mark - Method

- (void)_cancel:(UIButton *)btn {
    [NSUserDefaults.standardUserDefaults setBool:YES forKey:@"UDKey_hadReadAgreement"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - <UserAgreementConsentViewDelegate>

- (void)userAgreementConsentView:(UserAgreementConsentView *)view selectedWithBtn:(UIButton *)btn {
    if (!btn.selected) {
        self.cancelBtn.userInteractionEnabled = YES;
        _gradientLayer.colors = @[
            (__bridge id)UIColorHex(#4841E2).CGColor,
            (__bridge id)UIColorHex(#5D5DF7).CGColor
        ];
    } else {
        self.cancelBtn.userInteractionEnabled = NO;
        _gradientLayer.colors = @[
            (__bridge id)UIColor.darkGrayColor.CGColor,
            (__bridge id)UIColor.grayColor.CGColor
        ];
    }
    RisingLog(s🥹, @"%d", btn.selected);
}

#pragma mark - Getter

- (UserAgreementView *)agreementView {
    if (_agreementView == nil) {
        CGFloat width = self.view.width - 2 * 30;
        _agreementView = [[UserAgreementView alloc] initWithFrame:CGRectMake(0, 0, width, width / 3 * 4.3)];
        _agreementView.center = self.view.SuperCenter;
        _agreementView.top -= 30;
    }
    return _agreementView;
}

- (UILabel *)titleLab {
    if (_titleLab == nil) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(-1, -1, 300, 48)];
        _titleLab.left = self.agreementView.left + 5;
        _titleLab.centerY = (self.agreementView.top + StatusBarHeight()) / 2;
        _titleLab.height = 48;
        _titleLab.backgroundColor = UIColor.clearColor;
        _titleLab.text = @"掌上重邮用户协议";
        _titleLab.font = [UIFont fontWithName:FontName.PingFangSC.Semibold size:22];
        _titleLab.textColor =
        [UIColor Light:UIColorHex(#112C54) Dark:UIColorHex(#F0F0F2)];
    }
    return _titleLab;
}

- (UserAgreementConsentView *)consentView {
    if (_consentView == nil) {
        _consentView = [[UserAgreementConsentView alloc] initWithFrame:CGRectMake(self.agreementView.left, self.agreementView.bottom + 10, 340, 20)];
        _consentView.centerX = self.view.SuperCenter.x;
        _consentView.delegate = self;
    }
    return _consentView;
}

- (UIButton *)cancelBtn {
    if (_cancelBtn == nil) {
        _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(-1, -1, 274, 51)];
        _cancelBtn.centerX = self.view.width / 2;
        _cancelBtn.centerY = (self.agreementView.bottom + self.view.height) / 2;
        _cancelBtn.backgroundColor = UIColor.darkGrayColor;
        _cancelBtn.userInteractionEnabled = NO;
        _cancelBtn.layer.cornerRadius = _cancelBtn.height / 3;
        [_cancelBtn.layer addSublayer:self._getGradientLayer];
        _gradientLayer.colors = @[
            (__bridge id)UIColor.darkGrayColor.CGColor,
            (__bridge id)UIColor.grayColor.CGColor
        ];
        _cancelBtn.clipsToBounds = YES;
        _cancelBtn.titleLabel.font = [UIFont fontWithName:FontName.PingFangSC.Semibold size:16];
        [_cancelBtn setTitle:@"已阅读并同意" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:UIColorHex(#FFFFFF) forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(_cancel:)
          forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (CALayer *)_getGradientLayer {
    if (_gradientLayer == nil) {
        _gradientLayer = [[CAGradientLayer alloc] init];
        _gradientLayer.frame = _cancelBtn.SuperFrame;
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint = CGPointMake(1, 1);
        _gradientLayer.locations = @[@(0),@(1.0f)];
    }
    return _gradientLayer;
}

@end
