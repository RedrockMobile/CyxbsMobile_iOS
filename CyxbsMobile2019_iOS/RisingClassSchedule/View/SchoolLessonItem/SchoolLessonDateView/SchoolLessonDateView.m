//
//  SchoolLessonDateView.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/6/18.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "SchoolLessonDateView.h"

NSString *SchoolLessonDateViewReuseIdentifier = @"SchoolLessonDateView";

#pragma mark - SchoolLessonDateView ()

@interface SchoolLessonDateView ()

/// 超级长的长条
@property (nonatomic, strong) UIView *todayView;

/// 头视图
@property (nonatomic, strong) UIView *dateView;

/// 星期
@property (nonatomic, strong) UILabel *weekLab;

/// 日期
@property (nonatomic, strong) UILabel *dayLab;

@end

#pragma mark - SchoolLessonDateView

@implementation SchoolLessonDateView

#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.todayView];
        [self addSubview:self.dateView]; {
            [self.dateView addSubview:self.weekLab];
            [self.dateView addSubview:self.dayLab];
        }
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // TODO: Masonry
    
}

#pragma mark - Method

- (void)withWeek:(NSString *)week day:(NSString *)day isCurrent:(BOOL)isCurrent {
    self.todayView.hidden = !isCurrent;
    if (isCurrent) {
        self.dateView.backgroundColor =
        [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#2A4E84" alpha:1]
                              darkColor:[UIColor colorWithHexString:@"#5A5A5A" alpha:0.8]];
    } else {
        self.dateView.backgroundColor = UIColor.clearColor;
    }
    self.weekLab.text = week;
    self.dayLab.text = day;
}

#pragma mark - Getter

- (UIView *)todayView {
    if (_todayView == nil) {
        _todayView = [[UIView alloc] initWithFrame:self.SuperFrame];
        _todayView.layer.cornerRadius = 8;
        _todayView.height = CGFLOAT_MAX;
        _todayView.backgroundColor =
        [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#E8F0FC" alpha:0.5]
                              darkColor:[UIColor colorWithHexString:@"#000000" alpha:0.25]];
    }
    return _todayView;
}

- (UIView *)dateView {
    if (_dateView == nil) {
        _dateView = [[UIView alloc] initWithFrame:self.SuperFrame];
        _dateView.layer.cornerRadius = 8;
        _dateView.backgroundColor =
        [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#2A4E84" alpha:1]
                              darkColor:[UIColor colorWithHexString:@"#5A5A5A" alpha:0.8]];
    }
    return _dateView;
}

- (UILabel *)weekLab {
    if (_weekLab == nil) {
        _weekLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 24, 10)];
        _weekLab.font = [UIFont fontWithName:PingFangSCMedium size:11];
        _weekLab.textColor = [UIColor colorWithHexString:@"#F0F0F0" alpha:1];
        _weekLab.textAlignment = NSTextAlignmentCenter;
    }
    return _weekLab;
}

- (UILabel *)dayLab {
    if (_dayLab == nil) {
        _dayLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 24, 10)];
        _dayLab.font = [UIFont fontWithName:PingFangSCMedium size:11];
        _dayLab.textColor = [UIColor colorWithHexString:@"#F0F0F0" alpha:1];
        _dayLab.textAlignment = NSTextAlignmentCenter;
    }
    return _dayLab;
}

@end
