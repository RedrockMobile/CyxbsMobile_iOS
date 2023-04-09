//
//  ScheduleEventTableViewHeaderView.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/4/4.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "ScheduleEventTableViewHeaderView.h"
#import "ScheduleNeedsSupport.h"

NSString *ScheduleEventTableViewHeaderViewReuseIdentifier = @"ScheduleEventTableViewHeaderView";

@interface ScheduleEventTableViewHeaderView ()

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UIButton *toBtn;

@end

@implementation ScheduleEventTableViewHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.titleLab];
        [self addSubview:self.toBtn];
    }
    return self;
}

- (void)layoutSubviews {
    [self.titleLab sizeToFit];
    self.titleLab.bottom = self.height;
    
    self.toBtn.centerY = self.titleLab.centerY;
    self.toBtn.right = self.width - 16;
}

#pragma mark - Private

- (void)_tapTo:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewHeaderView:didResponseBtn:)]) {
        [self.delegate tableViewHeaderView:self didResponseBtn:btn];
    }
}

#pragma mark - Lazy

- (UILabel *)titleLab {
    if (_titleLab == nil) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont fontWithName:FontName.PingFangSC.Semibold size:28];
        _titleLab.textColor = [UIColor Light:UIColorHex(#122D55) Dark:UIColorHex(#F0F0F2)];
    }
    return _titleLab;
}

- (UIButton *)toBtn {
    if (_toBtn == nil) {
        _toBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 51, 31)];
        _toBtn.layer.cornerRadius = _toBtn.height / 2;
        _toBtn.clipsToBounds = YES;
        _toBtn.titleLabel.font = [UIFont fontWithName:FontName.PingFangSC.Regular size:15];
        [_toBtn setTitleColor:UIColorHex(#FFFFFF) forState:UIControlStateNormal];
        [_toBtn addGradientBlueLayer];
        [_toBtn bringSubviewToFront:_toBtn.titleLabel];
        [_toBtn addTarget:self action:@selector(_tapTo:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _toBtn;
}

#pragma mark - Setter

- (void)setTitle:(NSString *)title {
    self.titleLab.text = title;
    [self.titleLab sizeToFit];
}

- (void)setBtnDetail:(NSString *)btnDetail {
    [self.toBtn setTitle:btnDetail forState:UIControlStateNormal];
    [_toBtn bringSubviewToFront:_toBtn.titleLabel];
}

#pragma mark - Getter

- (NSString *)title {
    return self.titleLab.text;
}

- (NSString *)btnDetail {
    return self.toBtn.titleLabel.text;
}

@end
