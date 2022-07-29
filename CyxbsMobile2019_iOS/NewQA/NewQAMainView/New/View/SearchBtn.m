//
//  SearchBtn.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/12/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "SearchBtn.h"

@implementation SearchBtn

- (instancetype)init {
    if ([super init]) {
        if (@available(iOS 11.0, *)) {
            self.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1] darkColor:[UIColor colorWithHexString:@"#1F1F1F" alpha:1]];
        } else {
            // Fallback on earlier versions
        }
        self.layer.cornerRadius = self.frame.size.height * 1/2;
        UIImageView *searchBtnImageView = [[UIImageView alloc] init];
        searchBtnImageView.image = [UIImage imageNamed:@"搜索"];
        [self addSubview:searchBtnImageView];
        _searchBtnImageView = searchBtnImageView;
        
        UILabel *searchBtnLabel = [[UILabel alloc] init];
        self.searchBtnLabel.text = @"大家都在搜：红岩网校";
        if (@available(iOS 11.0, *)) {
            searchBtnLabel.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#8796AB" alpha:1] darkColor:[UIColor colorWithHexString:@"#838384" alpha:1]];
        } else {
            // Fallback on earlier versions
        }
        searchBtnLabel.textAlignment = NSTextAlignmentLeft;
        searchBtnLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 14];
        [self addSubview:searchBtnLabel];
        _searchBtnLabel = searchBtnLabel;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_searchBtnImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).mas_offset(SCREEN_WIDTH * 0.0453);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.0656);
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(SCREEN_WIDTH * 0.0656 * 20/22.5);
    }];
    
    [_searchBtnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).mas_offset(SCREEN_WIDTH * 0.1373 * 12.5/51/5);
        make.left.mas_equalTo(self.searchBtnImageView.mas_right).mas_offset(SCREEN_WIDTH * 0.032);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-SCREEN_WIDTH * 0.1373 * 12.5/51/5);
    }];
}

@end
