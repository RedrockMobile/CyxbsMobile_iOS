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
            make.top.mas_equalTo(self.mas_top).mas_offset(SCREEN_HEIGHT * 0.025);
            make.left.mas_equalTo(self.mas_left).mas_equalTo(SCREEN_WIDTH * 0.090);
            make.width.height.mas_equalTo(SCREEN_WIDTH * 0.0987);
        }];
        [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.left.mas_equalTo(SCREEN_WIDTH * 0.6253);
            make.right.mas_equalTo(self.mas_right);
            make.bottom.mas_equalTo(self.mas_bottom);
        }];
        
        UILabel *findGroup = [[UILabel alloc] init];
        if (@available(iOS 11.0, *)) {
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"发现你喜欢的圈子~" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: 16],NSForegroundColorAttributeName: [UIColor colorNamed:@"FollowGroupColor"]}];
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
