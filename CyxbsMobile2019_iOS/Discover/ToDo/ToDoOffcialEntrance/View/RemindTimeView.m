//
//  RemindTimeView.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/8/24.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "RemindTimeView.h"
#import "DiscoverTodoSelectTimeView.h"
@interface RemindTimeView()
/// 左上角的title
@property (nonatomic, strong) UILabel *titleLbl;

/// 日期选择器
@property (nonatomic, strong) UIDatePicker *datePicker;

/// 紫色三角形
@property(nonatomic, strong)UIImageView* tipView;

/// 取消按钮
@property(nonatomic, strong)UIButton* cancelBtn;

/// 确定按钮
@property(nonatomic, strong)UIButton* sureBtn;

///分割线
@property(nonatomic, strong)UIView* separatorLine;
@end
@implementation RemindTimeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorNamed:@"255_255_255&045_45_45"];
        [self buileFrame];
    }
    return self;
}

- (void)buileFrame{
    [self addSubview:self.titleLbl];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(SCREEN_WIDTH * 0.04);
        make.top.equalTo(self).offset(SCREEN_HEIGHT * 0.0258);
    }];
    
    //日期选择器
    [self addSubview:self.datePicker];
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset( SCREEN_HEIGHT * 0.039408867);
        make.bottom.equalTo(self).offset(- SCREEN_HEIGHT * 0.22814815);
    }];
    
    //紫色三角形下标
    [self addSubview:self.tipView];
    [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.datePicker);
        make.right.equalTo(self.datePicker.mas_left);
    }];
    
    //取消按钮
    [self addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0.128*SCREEN_WIDTH);
        make.bottom.equalTo(self).offset(-0.04926108374*SCREEN_HEIGHT);
        make.width.mas_equalTo(0.32*SCREEN_WIDTH);
        make.height.mas_equalTo(0.1066666667*SCREEN_WIDTH);
    }];
    
    //确定按钮
    [self addSubview:self.sureBtn];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-0.128*SCREEN_WIDTH);
        make.bottom.equalTo(self).offset(-0.04926108374*SCREEN_HEIGHT);
        make.width.mas_equalTo(0.32*SCREEN_WIDTH);
        make.height.mas_equalTo(0.1066666667*SCREEN_WIDTH);
    }];
    
    //分割线
    [self addSubview:self.separatorLine];
    [self.separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
}

#pragma mark- event respones
/// 下方的取消按钮点击后调用
- (void)cancelBtnClicked {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(selectTimeViewCancelBtnClicked)]) {
        [self.delegate selectTimeViewCancelBtnClicked];
    }
}

/// 下方的确定按钮点击后调用
- (void)sureBtnClicked {
    NSDateComponents* components = [[NSCalendar currentCalendar] components:252 fromDate:self.datePicker.date];
    components.timeZone = NSTimeZone.localTimeZone;
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(selectTimeViewSureBtnClicked:)]) {
        [self.delegate selectTimeViewSureBtnClicked:components];
    }
}

#pragma mark- getter
- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont fontWithName:PingFangSCBold size:15];
        _titleLbl.text = @"设置提醒时间";
        _titleLbl.textColor = [UIColor colorNamed:@"21_49_91&240_240_242"];
    }
    return _titleLbl;
}

- (UIDatePicker *)datePicker{
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
        //本地化设置为中国
        _datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CHT"];
        //设置提醒时间最少为十分钟后
        NSDate *date = [NSDate dateWithTimeInterval:600 sinceDate:[NSDate date]];
        [_datePicker setDate:date];
        [_datePicker setMinimumDate:date];
        //设置成轮滑样式
        _datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
        //设置本地时区
        _datePicker.timeZone = NSTimeZone.localTimeZone;
    }
    return _datePicker;
}

- (UIImageView *)tipView{
    if (!_tipView) {
        _tipView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _tipView.image = [UIImage imageNamed:@"todo紫色提醒图标"];
    }
    return _tipView;
}

- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _cancelBtn.layer.cornerRadius = 20;
        [_cancelBtn setTitleColor:[UIColor colorNamed:@"color21_49_91&#F0F0F2"] forState:UIControlStateNormal];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn.titleLabel setFont:[UIFont fontWithName:PingFangSCBold size:18]];
        [_cancelBtn setTitleColor:[UIColor colorNamed:@"color21_49_91&#F0F0F2"] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _sureBtn.layer.cornerRadius = 20;
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setBackgroundColor:[UIColor colorNamed:@"72_65_226&93_93_247"]];
        [_sureBtn.titleLabel setFont:[UIFont fontWithName:PingFangSCBold size:18]];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(sureBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

- (UIView *)separatorLine{
    if (!_separatorLine) {
        _separatorLine = [[UIView alloc] init];
        _separatorLine.backgroundColor = [UIColor colorNamed:@"45_45_45_20&230_230_230_40"];
    }
    return _separatorLine;
}
@end
