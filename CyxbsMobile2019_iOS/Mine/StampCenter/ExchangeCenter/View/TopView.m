//
//  TopView.m
//  CyxbsMobile2019_iOS
//
//  Created by p_tyou on 2021/8/13.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "TopView.h"
#import <Masonry/Masonry.h>

@implementation TopView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
///设置
- (void)setup {
    [self addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(45);
    }];
    
    
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.left.equalTo(_backBtn.mas_right).offset(10);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(40);
    }];
}
#pragma mark -getter
- (UIButton *)backBtn {
    if (_backBtn == nil) {
        _backBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        _backBtn.backgroundColor = [UIColor colorNamed:@"White&Black"];
        [_backBtn setImage: [UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    }
    return _backBtn;
}
- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont boldSystemFontOfSize:22];
        _titleLabel.textColor = [UIColor colorNamed:@"21_49_91"];
    }
    return _titleLabel;
}
@end
