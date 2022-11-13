//
//  UserAgreementConsentView.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/11/12.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "UserAgreementConsentView.h"

#pragma mark - UserAgreementConsentView ()

@interface UserAgreementConsentView ()

/// consent btn
@property (nonatomic, strong) UIButton *consentBtn;

/// agreemet lab
@property (nonatomic, strong) UILabel *agreementLab;

@end

#pragma mark - UserAgreementConsentView

@implementation UserAgreementConsentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.consentBtn];
        [self addSubview:self.agreementLab];
    }
    return self;
}

- (void)_tapBtn:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(userAgreementConsentView:selectedWithBtn:)]) {
        [self.delegate userAgreementConsentView:self selectedWithBtn:btn];
    }
    btn.selected = !btn.selected;
}

#pragma mark - Getter

- (UIButton *)consentBtn {
    if (_consentBtn == nil) {
        _consentBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _consentBtn.layer.cornerRadius = _consentBtn.height / 2;
        _consentBtn.clipsToBounds = YES;
        _consentBtn.layer.borderWidth = 2;
        _consentBtn.layer.borderColor = UIColor.blueColor.CGColor;
        [_consentBtn setImage:nil forState:UIControlStateNormal];
        [_consentBtn setImage:[UIImage imageNamed:@"select.red"] forState:UIControlStateSelected];
        [_consentBtn addTarget:self action:@selector(_tapBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _consentBtn;
}

- (UILabel *)agreementLab {
    if (_agreementLab == nil) {
        _agreementLab = [[UILabel alloc] initWithFrame:CGRectMake(self.consentBtn.right + 7, 0, -1, self.height)];
        _agreementLab.width = self.width - _agreementLab.left - 7;
        _agreementLab.font = [UIFont fontWithName:FontName.PingFangSC.Medium size:18];
        _agreementLab.textColor =
        [UIColor Light:UIColorHex(#112C54) Dark:UIColorHex(#F0F0F2)];
        _agreementLab.text = @"已阅读并同意《掌上重邮用户协议》";
    }
    return _agreementLab;
}

@end
