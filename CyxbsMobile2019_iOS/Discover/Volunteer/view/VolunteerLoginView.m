//
//  VolunteerLoginView.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/11/11.
//  Copyright © 2020 Redrock. All rights reserved.
//


#import "VolunteerLoginView.h"

@interface VolunteerLoginView()

@property (nonatomic, strong) UILabel *barTitle;
@property (nonatomic, strong) UILabel *VolunterLab;
@property (nonatomic, strong) UIImageView *accountImageView;
@property (nonatomic, strong) UIImageView *passwordImageView;
@property (nonatomic, strong) UIView *accountLine;
@property (nonatomic, strong) UIView *passwordLine;
@property (nonatomic, strong) UILabel *sourceLab;

@end

@implementation VolunteerLoginView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        if (@available(iOS 11.0, *)) {
            self.backgroundColor = [UIColor colorNamed:@"MGDLoginViewBackColor"];
        } else {
            // Fallback on earlier versions
        }
        ///返回按钮
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [backBtn setImage:[UIImage imageNamed:@"我的返回"] forState:UIControlStateNormal];
        [self addSubview:backBtn];
        _backBtn = backBtn;
        
        ///bar标题
        UILabel *barTitle = [[UILabel alloc] init];
        barTitle.text = @"完善信息";
        barTitle.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 21];
        barTitle.textAlignment = NSTextAlignmentLeft;
        if (@available(iOS 11.0, *)) {
            barTitle.textColor = [UIColor colorNamed:@"MGDLoginTitleColor"];
        } else {
            // Fallback on earlier versions
        }
        [self addSubview:barTitle];
        _barTitle = barTitle;
        
        ///志愿者标题
        UILabel *VolunterLab = [[UILabel alloc] init];
        VolunterLab.text = @"绑定志愿者账号";
        VolunterLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 34];
        if (@available(iOS 11.0, *)) {
            VolunterLab.textColor = [UIColor colorNamed:@"MGDLoginTitleColor"];
        } else {
            // Fallback on earlier versions
        }
        VolunterLab.alpha = 1.0;
        VolunterLab.textAlignment = NSTextAlignmentLeft;
        [self addSubview:VolunterLab];
        _VolunterLab = VolunterLab;
        
        ///账号输入框
        UITextField *accountField=[self createTextFieldWithFont:[UIFont systemFontOfSize:15] placeholder:@""];
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
        attrs[NSFontAttributeName] = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
        if (@available(iOS 11.0, *)) {
            attrs[NSForegroundColorAttributeName] = [UIColor colorNamed:@"MGDLoginTextFieldColor"];
        } else {
            // Fallback on earlier versions
        }
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:@"请输入志愿重庆账号" attributes:attrs];
        accountField.attributedPlaceholder = attStr;
        accountField.clearButtonMode = UITextFieldViewModeWhileEditing;
        if (@available(iOS 11.0, *)) {
            accountField.textColor = [UIColor colorNamed:@"MGDLoginTitleColor"];
        } else {
            // Fallback on earlier versions
        }
        accountField.font = [UIFont fontWithName:PingFangSCBold size:18];
        [self addSubview:accountField];
        _accountField = accountField;
        
        ///密码输入框
        UITextField *passwordField=[self createTextFieldWithFont:[UIFont systemFontOfSize:15] placeholder:@"请输入密码"];
        NSMutableDictionary *attr = [NSMutableDictionary dictionary];
        attr[NSFontAttributeName] = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
        if (@available(iOS 11.0, *)) {
            attr[NSForegroundColorAttributeName] = [UIColor colorNamed:@"MGDLoginTextFieldColor"];
        } else {
            // Fallback on earlier versions
        }
        NSAttributedString *Str = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:attr];
        passwordField.attributedPlaceholder = Str;
        passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
//        passwordField.alpha = 0.36;
        if (@available(iOS 11.0, *)) {
            passwordField.textColor = [UIColor colorNamed:@"MGDLoginTitleColor"];
        } else {
            // Fallback on earlier versions
        }
        passwordField.secureTextEntry = YES;
        [self addSubview:passwordField];
        _passwordField = passwordField;
        
        ///账号横线
        UIView *accountLine = [[UIView alloc] init];
        accountLine.backgroundColor = [UIColor grayColor];
        accountLine.alpha = 0.2;
        [self addSubview:accountLine];
        _accountLine = accountLine;
        
        ///密码横线
        UIView *passWordLine = [[UIView alloc] init];
        passWordLine.backgroundColor = [UIColor grayColor];
        passWordLine.alpha = 0.2;
        [self addSubview:passWordLine];
        _passwordLine = passWordLine;
        
        ///账号图片
        UIImageView *accountImageView = [[UIImageView alloc] init];
        UIImage *accountImage = [UIImage imageNamed:@"志愿账号图标"];
        accountImageView.image = accountImage;
        [self addSubview:accountImageView];
        _accountImageView = accountImageView;
        
        ///密码图片
        UIImageView *passwordImageView = [[UIImageView alloc] init];
        UIImage *passwordImage = [UIImage imageNamed:@"志愿密码图标"];
        passwordImageView.image = passwordImage;
        [self addSubview:passwordImageView];
        _passwordImageView = passwordImageView;
        
        ///登陆按钮
        UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [loginBtn setTitle:@"立 即 绑 定" forState:UIControlStateNormal];
        [loginBtn setTintColor:[UIColor whiteColor]];
        [loginBtn setBackgroundColor:[UIColor colorWithRed:72/255.0 green:65/255.0 blue:226/255.0 alpha:1.0]];
        [loginBtn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size: 18]];
        [self addSubview:loginBtn];
        _loginBtn = loginBtn;
        
        ///数据来源标题
        UILabel *sourceLab = [[UILabel alloc] init];
        sourceLab.text = @"部分信息来源:中国志愿服务网";
        sourceLab.font = [UIFont fontWithName:PingFangSC size: 11];
        if (@available(iOS 11.0, *)) {
            sourceLab.textColor = [UIColor colorNamed:@"MGDLoginSmallTextColor"];
        } else {
            // Fallback on earlier versions
        }
        sourceLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:sourceLab];
        _sourceLab = sourceLab;
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.024 + SCREEN_WIDTH * 0.0453);
        make.height.mas_equalTo(SCREEN_WIDTH * 0.024 * 18.51/9.01 + SCREEN_HEIGHT * 0.08);
    }];
    [_backBtn setImageEdgeInsets:UIEdgeInsetsMake(SCREEN_HEIGHT * 0.08, SCREEN_WIDTH * 0.0453, 0, 0)];
    
    [_barTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).mas_offset(SCREEN_HEIGHT * 0.0727);
        make.left.mas_equalTo(_backBtn.mas_right).mas_offset(SCREEN_WIDTH * 0.0293);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(SCREEN_WIDTH * 0.232 * 29/87);
    }];
    
    [_VolunterLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_barTitle.mas_bottom).mas_offset(SCREEN_HEIGHT * 0.048);
        make.left.mas_equalTo(self.mas_left).mas_offset(SCREEN_WIDTH * 0.0533);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(SCREEN_WIDTH * 0.6374 * 48/238);
    }];
    
    [_accountField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_VolunterLab.mas_bottom).mas_offset(SCREEN_HEIGHT * 0.054);
        make.left.mas_equalTo(self.mas_left).mas_offset(SCREEN_WIDTH * 0.184);
        make.width.mas_equalTo(_accountLine);
        make.height.mas_equalTo(SCREEN_WIDTH * 0.4507 * 25/169);
    }];
    
    [_accountLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_VolunterLab.mas_bottom).mas_offset(SCREEN_HEIGHT * 0.1023);
        make.left.mas_equalTo(self.mas_left).mas_offset(SCREEN_WIDTH * 0.08);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.826);
        make.height.equalTo(@1);
    }];
    
    [_accountImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_VolunterLab.mas_bottom).mas_offset(SCREEN_HEIGHT * 0.0616);
        make.left.mas_equalTo(self.mas_left).mas_offset(SCREEN_WIDTH * 0.064);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.0624);
        make.height.mas_equalTo(SCREEN_WIDTH * 0.0624 * 17.77/23.4);
    }];
    
    [_passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_VolunterLab.mas_bottom).mas_offset(SCREEN_HEIGHT * 0.1355);
        make.left.mas_equalTo(self.mas_left).mas_offset(SCREEN_WIDTH * 0.184);
        make.width.mas_equalTo(_passwordLine);
        make.height.mas_equalTo(SCREEN_WIDTH * 0.4507 * 25/169);
    }];
    
    [_passwordLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_VolunterLab.mas_bottom).mas_offset(SCREEN_HEIGHT * 0.1823);
        make.left.mas_equalTo(self.mas_left).mas_offset(SCREEN_WIDTH * 0.08);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.826);
        make.height.equalTo(@1);
    }];
    
    [_passwordImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_VolunterLab.mas_bottom).mas_offset(SCREEN_HEIGHT * 0.1392);
        make.left.mas_equalTo(self.mas_left).mas_offset(SCREEN_WIDTH * 0.072);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.05);
        make.height.mas_equalTo(SCREEN_WIDTH * 0.05 * 20.92/18.74);
    }];
    
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_VolunterLab.mas_bottom).mas_offset(SCREEN_HEIGHT * 0.266);
        make.left.mas_equalTo(self.mas_left).mas_offset(SCREEN_WIDTH * 0.128);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.7467);
        make.height.mas_equalTo(SCREEN_WIDTH * 0.7467 * 52/280);
    }];
    _loginBtn.layer.cornerRadius = _loginBtn.frame.size.height * 26/50;
    
    [_sourceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_loginBtn.mas_bottom).mas_offset(SCREEN_HEIGHT * 0.3695);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(SCREEN_WIDTH * 0.3893 * 16/146);
    }];
    
}

///创建输入框
- (UITextField *)createTextFieldWithFont:(UIFont *)font placeholder:(NSString *)placeholder{
    UITextField *textField = [[UITextField alloc] init];
    textField.font = font;
    textField.borderStyle = UITextBorderStyleNone;
    textField.placeholder = placeholder;
    return textField;
}

@end
