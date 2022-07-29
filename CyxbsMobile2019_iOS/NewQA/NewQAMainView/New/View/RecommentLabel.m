//
//  RecommentLabel.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/3/22.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "RecommentLabel.h"

@implementation RecommentLabel

- (instancetype)init {
    if ([super init]) {
        if (@available(iOS 11.0, *)) {
            self.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#F1F3F8" alpha:1] darkColor:[UIColor colorWithHexString:@"#000000" alpha:1]];
            self.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
        } else {
            self.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:243.0/255.0 blue:248.0/255.0 alpha:1];
            self.textColor = [UIColor colorWithRed:21.0/255.0 green:49.0/255.0 blue:91.0/255.0 alpha:1];
        }
        self.text = @"   推荐";
        self.font = [UIFont fontWithName:PingFangSCSemibold size: 18];
        self.textAlignment = NSTextAlignmentLeft;
        
        _lineView = [[UIView alloc] init];
        if (@available(iOS 11.0, *)) {
            _lineView.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#E2E8EE" alpha:1] darkColor:[UIColor colorWithHexString:@"#343434" alpha:1]];
        } else {
            _lineView.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:232.0/255.0 blue:238.0/255.0 alpha:1];
        }
        [self addSubview:_lineView];
        
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.right.mas_equalTo(self.mas_right);
            make.left.mas_equalTo(self.mas_left);
            make.height.mas_equalTo(2);
        }];
    }
    return self;
}

@end
