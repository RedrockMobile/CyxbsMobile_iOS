//
//  ScheduleHeaderView.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/10/19.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleHeaderView.h"

#import "SameDrawUI.h"

#pragma mark - ScheduleHeaderView ()

@interface ScheduleHeaderView ()

/// in section
@property (nonatomic, strong) UILabel *sectionLab;

/// double image
@property (nonatomic, strong) UIImageView *doubleImgView;

/// widget image
@property (nonatomic, strong) UIImageView *widgetImgView;

/// return btn
@property (nonatomic, strong) UIButton *reBackBtn;

@end

#pragma mark - ScheduleHeaderView

@implementation ScheduleHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.sectionLab];
        [self addSubview:self.doubleImgView];
        [self addSubview:self.reBackBtn];
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

- (void)_widget {
    if (self.delegate && [self.delegate respondsToSelector:@selector(scheduleHeaderViewDidTapWidget:)]) {
        [self.delegate scheduleHeaderViewDidTapWidget:self];
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
        _doubleImgView.right = self.reBackBtn.left - 30;
        _doubleImgView.centerY = self.reBackBtn.centerY;
        _doubleImgView.image = [UIImage imageNamed:@"per.single"];
        _doubleImgView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_muti:)];
        [_doubleImgView addGestureRecognizer:tap];
    }
    return _doubleImgView;
}

- (UIImageView *)widgetImgView {
    if (_widgetImgView == nil) {
        _widgetImgView = [[UIImageView alloc] initWithFrame:CGRectMake(-1, -1, 22.5, 18)];
        _widgetImgView.hidden = YES;
        _widgetImgView.right = self.doubleImgView.left - 30;
        _widgetImgView.centerY = self.reBackBtn.centerY;
        _widgetImgView.image = [UIImage imageNamed:@"widget"];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_widget)];
        [_widgetImgView addGestureRecognizer:tap];
    }
    return _widgetImgView;
}

- (NSString *)title {
    return self.sectionLab.text.copy;
}

#pragma mark - Setter

- (void)setTitle:(NSString *)inSection {
    self.sectionLab.text = inSection.copy;
}

- (void)setReBack:(BOOL)reBack {
    _reBack = reBack;
    self.reBackBtn.hidden = (reBack ? 1 : 0);
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

- (void)setWidget:(BOOL)widget {
    if (@available(iOS 14.0, *)) {
        _widget = widget;
        if (_widget) {
            self.widgetImgView.hidden = !widget;
        }
    }
}

@end