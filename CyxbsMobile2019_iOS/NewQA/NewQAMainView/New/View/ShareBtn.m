//
//  ShareBtn.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/12/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "ShareBtn.h"

@implementation ShareBtn

- (instancetype) initWithImage:(UIImage *)image AndName:(NSString *)name {
    if ([super init]) {
        _iconImage = [[UIImageView alloc] init];
        _iconImage.image = image;
        [self addSubview:_iconImage];
        
        _title = [[UILabel alloc] init];
        _title.text = name;
        _title.textAlignment = NSTextAlignmentCenter;
        _title.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 11];
        if (@available(iOS 11.0, *)) {
            _title.textColor = [UIColor colorNamed:@"MainPageLabelColor"];
        } else {
            // Fallback on earlier versions
        }
        [self addSubview:_title];
    }
    return self;
}

- (void)layoutSubviews {
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self);
        make.height.width.mas_equalTo(SCREEN_WIDTH * 0.1173);
    }];
    
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImage.mas_bottom).mas_offset(SCREEN_HEIGHT * 0.011);
        make.bottom.left.right.mas_equalTo(self);
    }];
}


@end
