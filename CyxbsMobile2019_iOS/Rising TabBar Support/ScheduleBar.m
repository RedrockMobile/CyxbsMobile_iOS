//
//  ScheduleBar.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/1/13.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "ScheduleBar.h"

#import "RyCycleView.h"

#pragma mark - ScheduleBar ()

@interface ScheduleBar ()

@property (nonatomic, strong) RyCycleView *titleCycleView;

@property (nonatomic, strong) UIImageView *timeImgView;

@property (nonatomic, strong) UILabel *timeLab;

@property (nonatomic, strong) UIImageView *placeImgView;

@property (nonatomic, strong) UILabel *placeLab;


@property (nonatomic, strong) UIView *bar;

@property (nonatomic, strong) UIView *line;

@end

#pragma mark - ScheduleBar

@implementation ScheduleBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.titleCycleView];
        [self addSubview:self.timeImgView];
        [self addSubview:self.timeLab];
        [self addSubview:self.placeImgView];
        [self addSubview:self.placeLab];
        
        [self addSubview:self.bar];
        [self addSubview:self.line];
    }
    return self;
}

#pragma mark - Lazy

- (RyCycleView *)titleCycleView {
    if (_titleCycleView == nil) {
        _titleCycleView = [[RyCycleView alloc] initWithFrame:CGRectMake(16, 0, 120, 30)];
        _titleCycleView.centerY = self.height / 2;
        _titleCycleView.dwellTime = 3;
        _titleCycleView.animateDuration = 4;
    }
    return _titleCycleView;
}

- (UILabel *)_cycleLab {
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 25)];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont fontWithName:FontName.PingFangSC.Semibold size:22];
    lab.textColor = [UIColor Light:UIColorHex(#15315B) Dark:UIColorHex(#F0F0F2)];
    return lab;
}

- (UIImageView *)timeImgView {
    if (_timeImgView == nil) {
        _timeImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"time"]];
        _timeImgView.left = self.width / 3 + 12;
        _timeImgView.size = CGSizeMake(12, 12);
        _timeImgView.centerY = self.height / 2;
    }
    return _timeImgView;
}

- (UILabel *)timeLab {
    if (_timeLab == nil) {
        _timeLab = [self _contentLab];
        _timeLab.size = CGSizeMake(120, 20);
        _timeLab.left = self.timeImgView.right + 5;
        _timeLab.centerY = self.timeImgView.centerY;
    }
    return _timeLab;
}

- (UIImageView *)placeImgView {
    if (_placeImgView == nil) {
        _placeImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"locale"]];
        _placeImgView.left = self.width / 3 * 2 + 9;
        _placeImgView.size = CGSizeMake(9, 12);
        _placeImgView.centerY = self.height / 2;
    }
    return _placeImgView;
}

- (UILabel *)placeLab {
    if (_placeLab == nil) {
        _placeLab = [self _contentLab];
        _placeLab.size = CGSizeMake(120, 20);
        _placeLab.left = self.placeImgView.right + 5;
        _placeLab.centerY = self.placeImgView.centerY;
    }
    return _placeLab;
}

- (UILabel *)_contentLab {
    UILabel *lab = [[UILabel alloc] init];
    lab.font = [UIFont fontWithName:FontName.PingFangSC.Light size:12];
    lab.textColor = [UIColor Light:UIColorHex(#15315B) Dark:UIColorHex(#F0F0F2)];
    return lab;
}

- (UIView *)bar {
    if (_bar == nil) {
        _bar = [[UIView alloc] initWithFrame:CGRectMake(0, 5, 27, 5)];
        _bar.centerX = self.width / 2;
        _bar.layer.cornerRadius = _bar.height / 2;
        _bar.backgroundColor = [UIColor Light:UIColorHex(#E2EDFB) Dark:UIColorHex(#5A5A5A)];
    }
    return _bar;
}

- (UIView *)line {
    if (_line == nil) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 2)];
        _line.bottom = self.SuperBottom;
        _line.backgroundColor = [UIColor Light:UIColorHex(#EAEDF1) Dark:UIColorHex(#7C7C7C)];
    }
    return _line;
}

#pragma mark - setter

- (void)setTitle:(NSString *)title {
    _title = title;
    UILabel *lab = [self _cycleLab];
    lab.text = title;
    [lab sizeToFit];
    [self.titleCycleView setCycleView:lab];
}

- (void)setTime:(NSString *)time {
    self.timeLab.text = time.copy;
}

- (void)setPlace:(NSString *)place {
    self.placeLab.text = place.copy;
}

#pragma mark - getter

- (NSString *)time {
    return self.timeLab.text.copy;
}

- (NSString *)place {
    return self.placeLab.text.copy;
}

@end
