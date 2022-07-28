//
//  SelfFuncView.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/4/27.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "SelfFuncView.h"

@implementation SelfFuncView

- (instancetype)init{
    if ([super init]) {
        self.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#F1F3F8" alpha:1] darkColor:[UIColor colorWithHexString:@"#1D1D1D" alpha:1]];

        _deleteBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_deleteBtn setTitle:@"删除帖子" forState:UIControlStateNormal];
        _deleteBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size: 14];
        if (@available(iOS 11.0, *)) {
            [_deleteBtn setTitleColor:[UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#0C3573" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]] forState:UIControlStateNormal];
        } else {
            // Fallback on earlier versions
        }
        [_deleteBtn addTarget:self action:@selector(ClickedDeletePostBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteBtn];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(self);
    }];
}

- (void)ClickedDeletePostBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(ClickedDeletePostBtn:)]) {
        [self.delegate ClickedDeletePostBtn:sender];
    }
}

@end
