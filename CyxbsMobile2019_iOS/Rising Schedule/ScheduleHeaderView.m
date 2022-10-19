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
    }
    return self;
}

#pragma mark - Private

- (void)_tap:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(scheduleHeaderView:didSelectedBtn:)]) {
        [self.delegate scheduleHeaderView:self didSelectedBtn:btn];
    }
}

#pragma mark - Getter

- (UILabel *)sectionLab {
    if (_sectionLab == nil) {
        _sectionLab = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, 150, 31)];
        _sectionLab.font = [UIFont fontWithName:PingFangSCBold size:22];
        _sectionLab.textColor =
        [UIColor Light:UIColorHex(#112C54)
                  Dark:UIColorHex(#F0F0F2)];
    }
    return _sectionLab;
}

- (UIButton *)reBackBtn {
    if (_reBackBtn == nil) {
        _reBackBtn = [[UIButton alloc] initWithFrame:CGRectMake(-1, self.sectionLab.top, 84, 32)];
        _reBackBtn.layer.cornerRadius = _reBackBtn.height / 2;
        _reBackBtn.clipsToBounds = YES;
        [_reBackBtn setTitle:@"回到本周" forState:UIControlStateNormal];
        [_reBackBtn addGradientBlueLayer];
        [_reBackBtn addTarget:self action:@selector(_tap:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reBackBtn;
}

- (NSString *)inSection {
    return self.sectionLab.text.copy;
}

#pragma mark - Setter

- (void)setInSection:(NSString *)inSection {
    self.sectionLab.text = inSection.copy;
}

- (void)setIsSingle:(BOOL)isSingle {
    _isSingle = isSingle;
}

- (void)setReBack:(BOOL)reBack {
    _reBack = reBack;
    self.reBackBtn.alpha = (reBack ? 1 : 0);
}

@end
