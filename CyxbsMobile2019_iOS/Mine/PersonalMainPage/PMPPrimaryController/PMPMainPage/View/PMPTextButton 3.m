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
        make.bottom.mas_equalTo(self.mas_centerY);
    }];
    
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.mas_centerY);
    }];
}

#pragma mark - public method

- (void)setTitle:(NSString *)title subtitle:(NSString *)subtitle {
    
    self.titleLabel.text = title;
    [self.titleLabel sizeToFit];
    
    self.subtitleLabel.text = subtitle;
    [self.subtitleLabel sizeToFit];
}

#pragma mark - getter

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor colorNamed:@"21_49_91_1&240_240_242_1"];
        _titleLabel.font = [UIFont fontWithName:PingFangSCBold size:16];
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel {
    if (_subtitleLabel == nil) {
        _subtitleLabel = [UILabel new];
        _subtitleLabel.textColor = [UIColor colorNamed:@"21_49_91_0.7&240_240_242_0.7"];
        _subtitleLabel.font = [UIFont fontWithName:PingFangSCMedium size:12];
    }
    return _subtitleLabel;
}

@end
