//
//  ScheduleHeaderView.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/10/19.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleHeaderView.h"
#import "ScheduleNeedsSupport.h"

#pragma mark - ScheduleHeaderView ()

@interface ScheduleHeaderView ()

/// in section
@property (nonatomic, strong) UILabel *sectionLab;

/// double image
@property (nonatomic, strong) UIImageView *doubleImgView;

/// widget image
@property (nonatomic, strong) UIImageView *calenderImgView;

/// return btn
@property (nonatomic, strong) UIButton *reBackBtn;

@end

#pragma mark - ScheduleHeaderView

@implementation ScheduleHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.sectionLab];
        [self addSubview:self.reBackBtn];
        [self addSubview:self.doubleImgView];
        [self addSubview:self.calenderImgView];
    }
    return self;
}

#pragma mark - Private

- (void)_tap:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(scheduleHeaderView:didSelectedBtn:)]) {
        [self.delegate scheduleHeaderView:self didSelectedBtn:btn];
    }
}

- (void)_muti:(UITapGestureRecognizer *)tap {
    if (tap.state == UIGestureRecognizerStateEnded && self.delegate && [self.delegate respondsToSelector:@selector(scheduleHeaderViewDidTapDouble:)]) {
        [self.delegate scheduleHeaderViewDidTapDouble:self];
    }
}

- (void)_calender:(UITapGestureRecognizer *)tap {
    if (tap.state == UIGestureRecognizerStateEnded && self.delegate &&[self.delegate respondsToSelector:@selector(scheduleHeaderViewDidTapCalender:)]) {
        [self.delegate scheduleHeaderViewDidTapCalender:self];
    }
}

#pragma mark - Getter

- (UILabel *)sectionLab {
    if (_sectionLab == nil) {
        _sectionLab = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, 150, 31)];
        _sectionLab.font = [UIFont fontWithName:FontName.PingFangSC.Semibold size:22];
        _sectionLab.textColor =
        [UIColor Light:UIColorHex(#112C54)
                  Dark:UIColorHex(#F0F0F2)];
    }
    return _sectionLab;
}

- (UIButton *)reBackBtn {
    if (_reBackBtn == nil) {
        _reBackBtn = [[UIButton alloc] initWithFrame:CGRectMake(-1, self.sectionLab.top, 84, 32)];
        _reBackBtn.right = self.SuperRight - 16;
        _reBackBtn.layer.cornerRadius = _reBackBtn.height / 2;
        _reBackBtn.clipsToBounds = YES;
        _reBackBtn.titleLabel.font = [UIFont fontWithName:FontName.PingFangSC.Regular size:13];
        [_reBackBtn setTitle:@"回到本周" forState:UIControlStateNormal];
        [_reBackBtn setTitleColor:UIColorHex(#FFFFFF) forState:UIControlStateNormal];
        [_reBackBtn addGradientBlueLayer];
        [_reBackBtn bringSubviewToFront:_reBackBtn.titleLabel];
        [_reBackBtn addTarget:self action:@selector(_tap:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reBackBtn;
}

- (UIImageView *)doubleImgView {
    if (_doubleImgView == nil) {
        _doubleImgView = [[UIImageView alloc] initWithFrame:CGRectMake(-1, -1, 22.5, 18)];
        _doubleImgView.hidden = YES;
        _doubleImgView.right = self.reBackBtn.left - 23;
        _doubleImgView.centerY = self.reBackBtn.centerY;
        _doubleImgView.image = [UIImage imageNamed:@"per.single"];
        _doubleImgView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_muti:)];
        [_doubleImgView addGestureRecognizer:tap];
    }
    return _doubleImgView;
}

- (UIImageView *)calenderImgView {
    if (_calenderImgView == nil) {
        _calenderImgView = [[UIImageView alloc] initWithFrame:CGRectMake(-1, -1, 22, 18)];
        _calenderImgView.contentMode = UIViewContentModeScaleAspectFit;
        _calenderImgView.hidden = YES;
        _calenderImgView.right = self.doubleImgView.left - 23;
        _calenderImgView.centerY = self.reBackBtn.centerY;
        _calenderImgView.image = [UIImage imageNamed:@"schedule.calender"];
        _calenderImgView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_calender:)];
        [_calenderImgView addGestureRecognizer:tap];
    }
    return _calenderImgView;
}

- (NSString *)title {
    return self.sectionLab.text.copy;
}

- (BOOL)calenderEdit {
    return !self.calenderImgView.hidden;
}

#pragma mark - Setter

- (void)setTitle:(NSString *)inSection {
    self.sectionLab.text = inSection.copy;
}

- (void)setReBack:(BOOL)reBack {
    if (self.reBackBtn.alpha == reBack) {
        [UIView animateWithDuration:0.3 animations:^{
            if (reBack) {
                self.reBackBtn.left = self.width;
            } else {
                self.reBackBtn.right = self.width - 16;
            }
            self.doubleImgView.right = self.reBackBtn.left - 23;
            self.calenderImgView.right = self.doubleImgView.left - 23;
            self.reBackBtn.alpha = !reBack;
        }];
    }
    _reBack = reBack;
}

- (void)setShowMuti:(BOOL)show isSingle:(BOOL)isSingle {
    _isShow = show;
    _isSingle = isSingle;
    
    self.doubleImgView.hidden = !show;
    if (isSingle) {
        self.doubleImgView.image = [UIImage imageNamed:@"per.single"];
    } else {
        self.doubleImgView.image = [UIImage imageNamed:@"per.double"];
    }
}

- (void)setCalenderEdit:(BOOL)calenderEdit {
    self.calenderImgView.hidden = !calenderEdit;
}

@end
