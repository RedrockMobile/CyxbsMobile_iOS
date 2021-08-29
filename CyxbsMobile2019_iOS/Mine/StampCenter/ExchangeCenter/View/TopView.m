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
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    [self addSubview:backBtn];
    _backBtn = backBtn;
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(45);
    }];
    backBtn.backgroundColor = [UIColor colorNamed:@"White&Black"];
    [backBtn setImage: [UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.left.equalTo(backBtn.mas_right).offset(10);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(40);
    }];
    titleLabel.font = [UIFont boldSystemFontOfSize:22];
    titleLabel.textColor = [UIColor colorNamed:@"21_49_91"];
}

@end
