//
//  GroupBtn.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/12/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "GroupBtn.h"

@implementation GroupBtn

- (instancetype)init {
    if ([super init]) {
        self.backgroundColor = [UIColor clearColor];
        UIImageView *groupBtnImageView = [[UIImageView alloc] init];
        [self addSubview:groupBtnImageView];
        _groupBtnImageView = groupBtnImageView;
        
        UILabel *groupBtnLabel = [[UILabel alloc] init];
        if (@available(iOS 11.0, *)) {
            groupBtnLabel.textColor = [UIColor colorNamed:@"GroupBtnLabelColor"];
        } else {
            // Fallback on earlier versions
        }
        groupBtnLabel.textAlignment = NSTextAlignmentCenter;
        groupBtnLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 12];
        [self addSubview:groupBtnLabel];
        _groupBtnLabel = groupBtnLabel;
        
        ///新帖子数的小蓝点
        UILabel *messageCountLabel = [[UILabel alloc] init];
        messageCountLabel.backgroundColor = [UIColor colorWithRed:41/255.0 green:35/255.0 blue:210/255.0 alpha:1.0];
        messageCountLabel.font = [UIFont fontWithName:@"Arial" size: 10];
        messageCountLabel.textColor = [UIColor whiteColor];
        messageCountLabel.textAlignment = NSTextAlignmentCenter;
        messageCountLabel.text = @"32";
        [self addSubview:messageCountLabel];
        _messageCountLabel = messageCountLabel;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_groupBtnImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.bottom.mas_equalTo(self.groupBtnLabel.mas_top).mas_offset(-SCREEN_WIDTH * 0.1293 * 5.5/48.5);
        make.height.mas_equalTo(self.mas_width);
    }];
    
    [_groupBtnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.groupBtnImageView.mas_bottom).mas_offset(SCREEN_WIDTH * 0.1293 * 5.5/48.5);
        make.centerX.mas_equalTo(_groupBtnImageView);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
    [_messageCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.right.mas_equalTo(self.mas_right);
        make.width.height.mas_equalTo(SCREEN_WIDTH * 0.048);
    }];
    _messageCountLabel.layer.cornerRadius = SCREEN_WIDTH * 0.048 * 1/2;
    _messageCountLabel.layer.masksToBounds = YES;
}
@end
