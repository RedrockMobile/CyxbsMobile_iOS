//
//  GroupFollowBtn.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/12/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "GroupFollowBtn.h"

@implementation GroupFollowBtn

- (instancetype) init {
    if ([super init]) {
        self.backgroundColor = [UIColor clearColor];
        self.adjustsImageWhenHighlighted = NO;
        [self setBackgroundImage:[UIImage imageNamed:@"关注按钮背景"] forState:UIControlStateNormal];
        UIImageView *leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"关注按钮2"]];
        UIImageView *rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"关注按钮1"]];
        [self addSubview:leftImageView];
        [self addSubview:rightImageView];
        [leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).mas_offset(SCREEN_WIDTH * 0.105 * 18/36);
            make.left.mas_equalTo(self.mas_left).mas_equalTo(SCREEN_WIDTH * 0.090);
            make.width.height.mas_equalTo(SCREEN_WIDTH * 0.1079);
        }];
        [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_bottom);
            make.left.mas_equalTo(SCREEN_WIDTH * 0.6253);
            make.width.mas_equalTo(SCREEN_WIDTH * 0.2919);
            make.height.mas_equalTo(SCREEN_WIDTH * 0.2919 * 70.25/109.45);
        }];
        
        UILabel *findGroup = [[UILabel alloc] init];
        if (@available(iOS 11.0, *)) {
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"发现你喜欢的圈子~" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: 16],NSForegroundColorAttributeName: [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#556C89" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]]}];
            findGroup.attributedText = string;
        } else {
            // Fallback on earlier versions
        }
        [self addSubview:findGroup];
        [findGroup mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).mas_offset(SCREEN_WIDTH * 0.9147 * 73/343 * 0.3904);
            make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-SCREEN_WIDTH * 0.9147 * 73/343 * 0.3973);
            make.left.mas_equalTo(leftImageView.mas_right).mas_offset(SCREEN_WIDTH * 0.04);
            make.right.mas_equalTo(rightImageView.mas_left);
        }];
    }
    return self;
}

@end
