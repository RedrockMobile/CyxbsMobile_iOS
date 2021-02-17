//
//  setEmail.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/10/29.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "setEmail.h"

@interface setEmail()

@property (nonatomic, strong) UILabel *barTitle;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *contactBtn;
@property (nonatomic, strong) UIView *line;


@end

@implementation setEmail

- (instancetype) initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        if (@available(iOS 11.0, *)) {
            self.backgroundColor = [UIColor colorNamed:@"MGDSafePopBackColor"];
        } else {
            // Fallback on earlier versions
        }
        ///返回按钮
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"我的返回"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backBtn];
        _backBtn = backBtn;
        
        ///标题
        if (@available(iOS 11.0, *)) {
            UILabel *barTitle = [self creatLabelWithText:@"绑定邮箱" AndFont:[UIFont fontWithName:@"PingFangSC-Medium" size: 21] AndTextColor:[UIColor colorNamed:@"MGDSafeTextColor"]];
            barTitle.textAlignment = NSTextAlignmentLeft;
            [self addSubview:barTitle];
            _barTitle = barTitle;
        } else {
            // Fallback on earlier versions
        }
        
        ///分割线
        UIView *line = [[UIView alloc] init];
        if (@available(iOS 11.0, *)) {
            line.backgroundColor = [UIColor colorNamed:@"MGDSafeLineColor"];
        } else {
            // Fallback on earlier versions
        }
        [self addSubview:line];
        _line = line;
        
        ///绑定邮箱描述 / 发送邮箱描述
        if (@available(iOS 11.0, *)) {
            UILabel *sendEmailLab = [self creatLabelWithText:@"请输入邮箱地址:" AndFont:[UIFont fontWithName:@"PingFangSC-Regular" size: 16] AndTextColor:[UIColor colorNamed:@"MGDSafeTextColor"]];
            sendEmailLab.alpha = 0.64;
            sendEmailLab.numberOfLines = 0;
            sendEmailLab.textAlignment = NSTextAlignmentLeft;
            [self addSubview:sendEmailLab];
            _sendEmailLab = sendEmailLab;
        } else {
            // Fallback on earlier versions
        }
        
        ///输入框
        UITextField *emailField = [[UITextField alloc] init];
        emailField.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 18];
        if (@available(iOS 11.0, *)) {
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@" 请输入邮箱地址" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size:15], NSForegroundColorAttributeName:[UIColor colorNamed:@"MGDSafePlaceholderColor"]}];
            emailField.attributedPlaceholder = string;
            emailField.textColor = [UIColor colorNamed:@"MGDSafeTextColor"];
            emailField.backgroundColor = [UIColor colorNamed:@"MGDSafeFieldBackColor"];
        } else {
            // Fallback on earlier versions
        }
        emailField.borderStyle = UITextBorderStyleNone;
        emailField.layer.cornerRadius = 8;
        UIView *blankView = [[UIView alloc] initWithFrame:CGRectMake(emailField.frame.origin.x,emailField.frame.origin.y,15.0, emailField.frame.size.height)];
        emailField.leftView = blankView;
        emailField.leftViewMode =UITextFieldViewModeAlways;
        emailField.clearButtonMode = UITextFieldViewModeNever;
        [self addSubview:emailField];
        _emailField = emailField;
        
        
        ///提示语
        UILabel *placeholderLab = [self creatLabelWithText:@"请输入正确的邮箱地址" AndFont:[UIFont fontWithName:@"PingFangSC-Regular" size: 12] AndTextColor:[UIColor colorWithRed:11/255.0 green:204/255.0 blue:240/255.0 alpha:1.0]];
        [self addSubview:placeholderLab];
        _placeholderLab = placeholderLab;
        
        ///失败按钮
        UIButton *contactBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [contactBtn setTitle:@"验证失败？联系我们" forState:UIControlStateNormal];
        if (IS_IPHONESE) {
            contactBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 10];
        }else {
            contactBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 12];
        }
        [contactBtn setBackgroundColor:[UIColor clearColor]];
        [contactBtn setTitleColor:[UIColor colorWithRed:171/255.0 green:188/255.0 blue:216/255.0 alpha:1.0] forState:UIControlStateNormal];
        [contactBtn addTarget:self action:@selector(ClickedContactUS) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:contactBtn];
        _contactBtn = contactBtn;
        
        ///下一步按钮
        UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        nextBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 18];
        [nextBtn setBackgroundColor:[UIColor colorWithRed:72/255.0 green:65/255.0 blue:226/255.0 alpha:1.0]];
        [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [nextBtn addTarget:self action:@selector(ClickedNext) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:nextBtn];
        _nextBtn = nextBtn;
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.top).mas_offset(SCREEN_HEIGHT * 0.0739);
        make.left.mas_equalTo(self.left).mas_offset(SCREEN_WIDTH * 0.0453);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.024);
        make.height.mas_equalTo(SCREEN_HEIGHT * 0.0228);
    }];
    
    [_barTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.top).mas_offset(SCREEN_HEIGHT * 0.069);
        make.left.mas_equalTo(_backBtn.mas_right).mas_offset(SCREEN_WIDTH * 0.0347);
        make.right.mas_equalTo(self.right);
        make.height.mas_equalTo(SCREEN_WIDTH * 0.2 * 25/75);
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.top).mas_offset(SCREEN_HEIGHT * 0.1071);
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(3);
    }];

    [_sendEmailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_line.mas_bottom).mas_offset(SCREEN_HEIGHT * 0.0234);
        make.left.mas_equalTo(self.left).mas_offset(SCREEN_WIDTH * 0.0533);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.904);
        make.height.mas_equalTo(SCREEN_WIDTH * 0.904 * 54/339);
    }];

    [_emailField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_sendEmailLab.mas_bottom).mas_offset(SCREEN_HEIGHT * 0.0074);
        make.left.mas_equalTo(self.left).mas_offset(SCREEN_WIDTH * 0.0533);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.904);
        make.height.mas_equalTo(SCREEN_WIDTH * 0.904 * 41/339);
    }];

    [_placeholderLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_emailField.mas_bottom).mas_offset(SCREEN_HEIGHT * 0.0148);
        make.left.mas_equalTo(self.left).mas_offset(SCREEN_WIDTH * 0.056);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.4444);
        make.height.mas_equalTo(SCREEN_WIDTH * 0.3333 * 17/125);
    }];

    [_contactBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_emailField.mas_bottom).mas_offset(SCREEN_HEIGHT * 0.0148);
        make.left.mas_equalTo(self.left).mas_offset(SCREEN_WIDTH * 0.6507);
        make.right.mas_equalTo(self.right).mas_offset(-SCREEN_WIDTH * 0.048);
        make.height.mas_equalTo(SCREEN_WIDTH * 0.3013 * 17/113);
    }];

    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_line.mas_bottom).mas_offset(SCREEN_HEIGHT * 0.3867);
        make.left.mas_equalTo(self.left).mas_offset(SCREEN_WIDTH * 0.128);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.7467);
        make.height.mas_equalTo(SCREEN_WIDTH * 0.7467 * 43/280);
    }];
    _nextBtn.layer.cornerRadius = _nextBtn.frame.size.height * 1/2;
}

#pragma mark - View的代理
- (void)backButtonClicked {
    if ([self.delegate respondsToSelector:@selector(backButtonClicked)]) {
        [self.delegate backButtonClicked];
    }
}

- (void)ClickedNext {
    if ([self.delegate respondsToSelector:@selector(ClickedNext)]) {
        [self.delegate ClickedNext];
    }
}

- (void)ClickedContactUS {
    if ([self.delegate respondsToSelector:@selector(ClickedContactUS)]) {
        [self.delegate ClickedContactUS];
    }
}


///创建提示文字
- (UILabel *)creatLabelWithText:(NSString *)text AndFont:(UIFont *)font AndTextColor:(UIColor *)color {
    UILabel *lab = [[UILabel alloc] init];
    lab.font = font;
    lab.text = text;
    lab.textColor = color;
    return lab;
}

@end

