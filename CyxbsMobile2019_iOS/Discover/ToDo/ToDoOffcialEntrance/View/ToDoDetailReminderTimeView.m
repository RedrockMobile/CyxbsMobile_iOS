//
//  ToDoDetailReminderTimeView.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/9/18.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "ToDoDetailReminderTimeView.h"

@implementation ToDoDetailReminderTimeView
@dynamic delegate;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.titleLbl.text = @"提醒时间";
        [self setUI];
    }
    return self;
}

- (void)setUI{
    [super setUI];
    [self addSubview:self.reminderTimeLbl];
    [self.reminderTimeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.titleLbl.mas_bottom).offset(SCREEN_HEIGHT * 0.0123);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.8266, SCREEN_HEIGHT * 0.0258));
    }];
}

- (void)clickedLbl{
    if (self.delegate && [self.delegate respondsToSelector:@selector(setReminderTime)]) {
        [self.delegate setReminderTime];
    }
}

- (UILabel *)reminderTimeLbl{
    if (!_reminderTimeLbl) {
        _reminderTimeLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _reminderTimeLbl.font = [UIFont fontWithName:PingFangSCMedium size:15];
        _reminderTimeLbl.textColor = [UIColor colorNamed:@"21_49_91&240_240_242"];
        _reminderTimeLbl.userInteractionEnabled = YES;
        //增加点击手势
        [_reminderTimeLbl addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedLbl)]];
    }
    return _reminderTimeLbl;
}
@end
