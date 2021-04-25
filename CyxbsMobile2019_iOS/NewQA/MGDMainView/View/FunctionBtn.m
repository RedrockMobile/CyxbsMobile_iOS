//
//  FunctionBtn.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/12/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "FunctionBtn.h"

@implementation FunctionBtn

- (instancetype) init {
    if ([super init]) {
        self.backgroundColor = [UIColor clearColor];
        _iconView = [[UIImageView alloc] init];
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_iconView];
        
        _countLabel = [[UILabel alloc] init];
        _countLabel.font = [UIFont fontWithName:@"Arial" size: 12];
        _countLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_countLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(self);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.0547);
    }];
    
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconView.mas_top).mas_offset(SCREEN_HEIGHT * 0.009);
        make.height.mas_equalTo(SCREEN_WIDTH * 0.052 * 8.5/19.5);
        make.right.mas_equalTo(self.mas_right);
        make.left.mas_equalTo(self.iconView.mas_right).mas_offset(SCREEN_WIDTH * 0.0173);
    }];
}

- (void)setIconViewSelectedImage:(UIImage *)selectedImage AndUnSelectedImage:(UIImage *)unSelectedImnage {
    if (self.selected == YES) {
        self.iconView.contentMode = UIViewContentModeScaleAspectFit;
        self.iconView.image = selectedImage;
    }else {
        self.iconView.contentMode = UIViewContentModeScaleAspectFit;
        self.iconView.image = unSelectedImnage;
    }
}


@end

