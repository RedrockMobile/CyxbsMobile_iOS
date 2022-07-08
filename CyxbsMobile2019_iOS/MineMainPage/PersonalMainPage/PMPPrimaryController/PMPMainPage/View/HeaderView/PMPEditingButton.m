//
//  PMPEditingButton.m
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/9/17.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "PMPEditingButton.h"

@implementation PMPEditingButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureView];
    }
    return self;
}

- (void)configureView {
    [self addSubview:self.iconImgView];
    [self addSubview: self.textLabel];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self);
    }];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self.iconImgView.mas_right).offset(4);
    }];
}

#pragma mark - lazy

- (UIImageView *)iconImgView {
    if (_iconImgView == nil) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.image = [UIImage imageNamed:@"MainPage_Header_Editing"];
        [_iconImgView sizeToFit];
    }
    return _iconImgView;
}

- (UILabel *)textLabel {
    if (_textLabel == nil) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont fontWithName:PingFangSCMedium size:12];
        _textLabel.textColor =
        [UIColor dm_colorWithLightColor:RGBColor(21, 49, 91, 0.4) darkColor:RGBColor(240, 240, 242, 0.4)];
        _textLabel.text = @"编辑信息";
        [_textLabel sizeToFit];
    }
    return _textLabel;
}

@end
