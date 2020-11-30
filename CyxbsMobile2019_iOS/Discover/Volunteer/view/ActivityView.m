//
//  ActivityView.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/11/11.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "ActivityView.h"

@interface ActivityView()

@property (nonatomic, strong) UILabel *signUpTimeLabel;
@property (nonatomic, strong) UILabel *activityTimeLabel;
@property (nonatomic, strong) UILabel *activityHourLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *placeholderLabel;

@end

@implementation ActivityView

- (instancetype) initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        backView.backgroundColor = [UIColor colorWithRed:0/255.0 green:15/255.0 blue:37/255.0 alpha:0.14];
        [self addSubview:backView];
        _backView = backView;
        
        UIView *popView = [[UIView alloc] init];
        popView.layer.cornerRadius = 16;
        popView.backgroundColor = [UIColor whiteColor];
        popView.alpha = 1;
        [_backView addSubview:popView];
        _popView = popView;
        
        UILabel *activityLabel = [self LabelWithText:@"" AndFont:[UIFont fontWithName:@"PingFangSC-Medium" size: 22] AndTintColor:[UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0] AndAlpha:1.0];
        activityLabel.textAlignment = NSTextAlignmentLeft;
        [_popView addSubview:activityLabel];
        _activityLabel = activityLabel;
        
        UILabel *describeLabel = [self LabelWithText:@"" AndFont:[UIFont fontWithName:@"PingFangSC-Medium" size: 13] AndTintColor:[UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0] AndAlpha:1.0];
        describeLabel.numberOfLines = 1;
        describeLabel.textAlignment = NSTextAlignmentLeft;
        [_popView addSubview:describeLabel];
        _describeLabel = describeLabel;
        
        UILabel *signUpTimeLabel = [self LabelWithText:@"报名截至时间" AndFont:[UIFont fontWithName:@"PingFangSC-Medium" size: 15] AndTintColor:[UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0] AndAlpha:1.0];
        signUpTimeLabel.textAlignment = NSTextAlignmentLeft;
        [_popView addSubview:signUpTimeLabel];
        _signUpTimeLabel = signUpTimeLabel;
        
        UILabel *activityTimeLabel = [self LabelWithText:@"志愿服务时间" AndFont:[UIFont fontWithName:@"PingFangSC-Medium" size: 13] AndTintColor:[UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0] AndAlpha:1.0];
        activityTimeLabel.textAlignment = NSTextAlignmentLeft;
        [_popView addSubview:activityTimeLabel];
        _activityTimeLabel = activityTimeLabel;
        
        UILabel *activityHourLabel = [self LabelWithText:@"志愿服务时长" AndFont:[UIFont fontWithName:@"PingFangSC-Medium" size: 13] AndTintColor:[UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0] AndAlpha:1.0];
        activityHourLabel.textAlignment = NSTextAlignmentLeft;
        [_popView addSubview:activityHourLabel];
        _activityHourLabel = activityHourLabel;
        
        UILabel *signUpTime = [self LabelWithText:@"" AndFont:[UIFont fontWithName:@"PingFangSC-Medium" size: 15] AndTintColor:[UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0] AndAlpha:1.0];
        signUpTime.textAlignment = NSTextAlignmentRight;
        [_popView addSubview:signUpTime];
        _signUpTime = signUpTime;
        
        UILabel *activityTime = [self LabelWithText:@"" AndFont:[UIFont fontWithName:@"PingFangSC-Medium" size: 15] AndTintColor:[UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0] AndAlpha:1.0];
        activityTime.textAlignment = NSTextAlignmentRight;
        [_popView addSubview:activityTime];
        _activityTime = activityTime;
        
        UILabel *activityHour = [self LabelWithText:@"" AndFont:[UIFont fontWithName:@"PingFangSC-Medium" size: 15] AndTintColor:[UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0] AndAlpha:1.0];
        activityHour.textAlignment = NSTextAlignmentRight;
        [_popView addSubview:activityHour];
        _activityHour = activityHour;
        
        UIView *lineView = [[UIView alloc] init];
        if (@available(iOS 11.0, *)) {
            lineView.backgroundColor = [UIColor colorNamed:@"#2A4E84"];
        } else {
            // Fallback on earlier versions
        }
        [_popView addSubview:lineView];
        _lineView = lineView;
        
        UILabel *placeholderLabel = [self LabelWithText:@"可前往微信小程序：重邮帮参与该志愿服务的报名" AndFont:[UIFont fontWithName:@"PingFangSC-Medium" size: 12] AndTintColor:[UIColor colorWithRed:58/255.0 green:57/255.0 blue:211/255.0 alpha:1.0] AndAlpha:1.0];
        placeholderLabel.numberOfLines = 1;
        placeholderLabel.textAlignment = NSTextAlignmentLeft;
        [_popView addSubview:placeholderLabel];
        _placeholderLabel = placeholderLabel;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_popView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_backView.mas_top).mas_offset(SCREEN_HEIGHT * 0.6576);
        make.left.mas_equalTo(_backView.mas_left);
        make.right.mas_equalTo(_backView.mas_right);
        make.bottom.mas_equalTo(_backView.bottom);
    }];
    
    [_activityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_popView.mas_top).mas_offset(SCREEN_HEIGHT * 0.0271);
        make.left.mas_equalTo(_backView.mas_left).mas_offset(SCREEN_WIDTH * 0.04);
        make.right.mas_equalTo(_backView.mas_right);
        make.height.mas_equalTo(SCREEN_HEIGHT * 0.0369);
    }];

    [_describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_popView.mas_top).mas_offset(SCREEN_HEIGHT * 0.0727);
        make.left.mas_equalTo(_backView.mas_left).mas_offset(SCREEN_WIDTH * 0.04);
        make.right.mas_equalTo(_backView.mas_right);
        make.height.mas_equalTo(SCREEN_HEIGHT * 0.0222);
    }];

    [_signUpTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_popView.mas_top).mas_offset(SCREEN_HEIGHT * 0.1256);
        make.left.mas_equalTo(_backView.mas_left).mas_offset(SCREEN_WIDTH * 0.04);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.2453);
        make.height.mas_equalTo(SCREEN_HEIGHT * 0.0259);
    }];

    [_activityTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_popView.mas_top).mas_offset(SCREEN_HEIGHT * 0.181);
        make.left.width.height.mas_equalTo(_signUpTimeLabel);
    }];

    [_activityHourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_popView.mas_top).mas_offset(SCREEN_HEIGHT * 0.2365);
        make.left.width.height.mas_equalTo(_signUpTimeLabel);
    }];

    [_signUpTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.mas_equalTo(_signUpTimeLabel);
        make.left.mas_equalTo(_signUpTimeLabel.mas_right);
        make.right.mas_equalTo(_backView.mas_right).mas_offset(-SCREEN_WIDTH * 0.048);
    }];

    [_activityTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.mas_equalTo(_activityTimeLabel);
        make.left.mas_equalTo(_activityTimeLabel.mas_right);
        make.right.mas_equalTo(_backView.mas_right).mas_offset(-SCREEN_WIDTH * 0.048);
    }];

    [_activityHour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.mas_equalTo(_activityHourLabel);
        make.left.mas_equalTo(_activityHourLabel.mas_right);
        make.right.mas_equalTo(_backView.mas_right).mas_offset(-SCREEN_WIDTH * 0.048);
    }];

    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_popView.mas_top).mas_offset(SCREEN_HEIGHT * 0.2931);
        make.left.right.mas_equalTo(_backView);
        make.height.mas_equalTo(2);
    }];

    [_placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_popView.mas_top).mas_offset(SCREEN_HEIGHT * 0.3079);
        make.left.mas_equalTo(_backView.mas_left).mas_offset(SCREEN_WIDTH * 0.04);
        make.right.mas_equalTo(_backView.mas_right);
        make.height.mas_equalTo(SCREEN_HEIGHT * 0.031);
    }];
}

- (UILabel *)LabelWithText:(NSString *)title AndFont:(UIFont *)font AndTintColor:(UIColor *)color AndAlpha:(double)alpha{
    UILabel *lab = [[UILabel alloc] init];
    lab.text = title;
    lab.font = font;
    lab.textColor = color;
    lab.alpha = alpha;
    return lab;
}

@end
