//
//  CQUPTMapMyStarButton.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/8/12.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "CQUPTMapMyStarButton.h"

@interface CQUPTMapMyStarButton ()

@property (nonatomic, weak) UILabel *starLabel;
@property (nonatomic, weak) UIView *separateLine;

@end

@implementation CQUPTMapMyStarButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        UIView *separateLine = [[UIView alloc] init];
        if (@available(iOS 11.0, *)) {
            separateLine.backgroundColor = [UIColor colorNamed:@"Map_StarLabelColor"];
        } else {
            separateLine.backgroundColor = [UIColor colorWithHexString:@"#778AA9"];
        }
        separateLine.alpha = 0.2;
        [self addSubview:separateLine];
        self.separateLine = separateLine;
        
        UILabel *starLabel = [[UILabel alloc] init];
        starLabel.text = @"我的收藏";
        starLabel.font = [UIFont fontWithName:PingFangSCBold size:14];
        if (@available(iOS 11.0, *)) {
            starLabel.textColor = [UIColor colorNamed:@"Map_HotWordColor"];
        } else {
            starLabel.textColor = [UIColor colorWithHexString:@"#0E2A53"];
        }
        [self addSubview:starLabel];
        self.starLabel = starLabel;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.separateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.bottom.equalTo(self);
        make.width.equalTo(@1);
    }];
    
    [self.starLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self);
    }];
}

@end
