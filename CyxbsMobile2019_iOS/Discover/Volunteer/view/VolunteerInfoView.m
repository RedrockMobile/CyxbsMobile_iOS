//
//  VolunteerInfoView.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/11/11.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "VolunteerInfoView.h"

@interface VolunteerInfoView()

@property (nonatomic, strong) UILabel *barTitle;
@property (nonatomic, strong) UILabel *totalTime;
@property (nonatomic, strong) UILabel *timeUnit;
@property (nonatomic, strong) UILabel *frequency;
@property (nonatomic, strong) UILabel *frequencyUnit;

@end

@implementation VolunteerInfoView

- (instancetype) initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:242/255.0 green:243/255.0 blue:248/255.0 alpha:1.0];
        
        ///背景
        UIView *backView = [[UIView alloc] init];
        [self addSubview:backView];
        _backView = backView;

        ///总时长（文字）
        UILabel *totalTime = [self LabelWithText:@"总时长" AndFont:[UIFont fontWithName:@"PingFangSC-Regular" size: 13] AndTintColor:[UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0] AndAlpha:0.6];
        [_backView addSubview:totalTime];
        _totalTime = totalTime;

        ///总次数（文字）
        UILabel * frequency= [self LabelWithText:@"总次数" AndFont:[UIFont fontWithName:@"PingFangSC-Regular" size: 13] AndTintColor:[UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0] AndAlpha:0.6];
        [_backView addSubview:frequency];
        _frequency = frequency;

        ///总时长（数字）
        UILabel *totalText = [self LabelWithText:@"" AndFont:[UIFont fontWithName:@"Impact" size: 32] AndTintColor:[UIColor colorWithRed:42/255.0 green:78/255.0 blue:132/255.0 alpha:1.0] AndAlpha:1.0];
        totalText.textAlignment = NSTextAlignmentRight;
        [_backView addSubview:totalText];
        _totalText = totalText;

        UILabel *frequencyText = [self LabelWithText:@"" AndFont:[UIFont fontWithName:@"Impact" size: 32] AndTintColor:[UIColor colorWithRed:42/255.0 green:78/255.0 blue:132/255.0 alpha:1.0] AndAlpha:1.0];
        frequencyText.textAlignment = NSTextAlignmentRight;
        [_backView addSubview:frequencyText];
        _frequencyText = frequencyText;

        ///时间单位
        UILabel *timeUnit = [self LabelWithText:@"时" AndFont:[UIFont fontWithName:@"PingFangSC-Regular" size: 13] AndTintColor:[UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0] AndAlpha:1.0];
        timeUnit.textAlignment = NSTextAlignmentRight;
        [_backView addSubview:timeUnit];
        _timeUnit = timeUnit;

        ///次数单位
        UILabel *frequencyUnit = [self LabelWithText:@"次" AndFont:[UIFont fontWithName:@"PingFangSC-Regular" size: 13] AndTintColor:[UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0] AndAlpha:1.0];
        frequencyUnit.textAlignment = NSTextAlignmentRight;
        [_backView addSubview:frequencyUnit];
        _frequencyUnit = frequencyUnit;

    }
    return self;
}

- (void)layoutSubviews {
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(SCREEN_HEIGHT * 0.1108);
    }];
    
    [_totalText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_backView.mas_top).mas_offset(SCREEN_HEIGHT * 0.0179);
        make.left.mas_equalTo(self.mas_left).mas_offset(SCREEN_WIDTH * 0.0453);
        make.right.mas_equalTo(self.mas_right).mas_offset(-SCREEN_WIDTH * 0.672);
        make.height.mas_equalTo(SCREEN_HEIGHT * 0.048);
    }];
    
    [_frequencyText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_backView.mas_top).mas_offset(SCREEN_HEIGHT * 0.0191);
        make.left.mas_equalTo(self.mas_left).mas_offset(SCREEN_WIDTH * 0.5453);
        make.right.mas_equalTo(self.mas_right).mas_offset(-SCREEN_WIDTH * 0.2107);
        make.height.mas_equalTo(SCREEN_HEIGHT * 0.048);
    }];
    
    [_timeUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_backView.mas_top).mas_offset(SCREEN_HEIGHT * 0.0382);
        make.right.mas_equalTo(_frequencyUnit.mas_left).mas_offset(-SCREEN_WIDTH * 0.4133);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.0347);
        make.height.mas_equalTo(SCREEN_HEIGHT * 0.0222);
    }];
    
    [_frequencyUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_backView.mas_top).mas_offset(SCREEN_HEIGHT * 0.0394);
        make.left.mas_equalTo(_frequency.mas_right).mas_offset(SCREEN_WIDTH * 0.0373);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.0347);
        make.height.mas_equalTo(SCREEN_HEIGHT * 0.0222);
    }];
    
    [_totalTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_totalText.mas_bottom).mas_offset(SCREEN_HEIGHT * 0.0012);
        make.right.mas_equalTo(_timeUnit.mas_left).mas_offset(-SCREEN_WIDTH * 0.0667);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.1067);
        make.height.mas_equalTo(SCREEN_HEIGHT * 0.0222);
    }];
    
    [_frequency mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_frequencyText.mas_bottom);
        make.left.mas_equalTo(self.mas_left).mas_offset(SCREEN_WIDTH * 0.6987);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.1067);
        make.height.mas_equalTo(SCREEN_HEIGHT * 0.0222);
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
