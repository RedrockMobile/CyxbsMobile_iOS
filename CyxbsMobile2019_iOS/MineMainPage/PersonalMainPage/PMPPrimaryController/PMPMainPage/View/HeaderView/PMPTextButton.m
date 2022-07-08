//
//  PMPTextButton.m
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/9/15.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "PMPTextButton.h"

@implementation PMPTextButton

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureView];
    }
    return self;
}

- (void)configureView {
    [self addSubview:self.titleLabel];
    [self addSubview:self.subtitleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self.subtitleLabel.mas_top);
    }];
    
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.bottom.mas_equalTo(self);
    }];
}

#pragma mark - public method

- (void)setTitle:(NSString *)title
        subtitle:(NSString *)subtitle
           index:(NSUInteger)index {
    
    self.titleLabel.text = title;
    [self.titleLabel sizeToFit];
    
    self.subtitleLabel.text = subtitle;
    [self.subtitleLabel sizeToFit];
    
    self.index = index;
}

#pragma mark - getter

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor =
        [UIColor dm_colorWithLightColor:RGBColor(21, 49, 91, 1) darkColor:RGBColor(240, 240, 242, 1)];
        _titleLabel.font = [UIFont fontWithName:PingFangSCBold size:16];
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel {
    if (_subtitleLabel == nil) {
        _subtitleLabel = [UILabel new];
        _subtitleLabel.textColor =
        [UIColor dm_colorWithLightColor:RGBColor(21, 49, 91, 0.7) darkColor:RGBColor(240, 240, 242, 0.7)];
        _subtitleLabel.font = [UIFont fontWithName:PingFangSCMedium size:12];
    }
    return _subtitleLabel;
}

@end
