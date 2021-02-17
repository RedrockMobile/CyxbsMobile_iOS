//
//  SearchBeiginView.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/1/25.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "SearchBeiginView.h"

@implementation SearchBeiginView
#pragma mark- life cycle
- (instancetype)initWithString:(NSString *)str{
    self = [super init];
    if (self) {
        if (@available(iOS 11.0, *)) {
            self.backgroundColor = [UIColor colorNamed:@"SZHMainBoardColor"];
        } else {
            // Fallback on earlier versions
        }
        self.hotTitleStr = str;
    }
    return self;
}

- (void)layoutSubviews{
    //最顶部的搜索view
    [self addSubview:_searchTopView];
    [_searchTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.mas_top).offset(MAIN_SCREEN_H * 0.0352);
        make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W, MAIN_SCREEN_H * 0.0562));
    }];
    
    [self addSubview:self.hotSearchView];
    [self.hotSearchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchTopView.mas_bottom).offset(MAIN_SCREEN_H * 0.0449);
        make.left.equalTo(self.mas_left).offset(MAIN_SCREEN_W * 0.0426);
        make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W * 0.8506, MAIN_SCREEN_H * 0.1874));
    }];
    
    [self addSubview:self.topSeparation];
    [self.topSeparation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.hotSearchView.mas_bottom);
        make.left.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W, 1));
    }];
    
}
#pragma mark- getter
- (SearchTopView *)searchTopView{
    if (_searchTopView == nil) {
        _searchTopView = [[SearchTopView alloc] init];
    }
    return _searchTopView;
}
- (SZHHotSearchView *)hotSearchView{
    if (_hotSearchView == nil) {
        _hotSearchView = [[SZHHotSearchView alloc] initWithString:self.hotTitleStr];
    }
    return _hotSearchView;
}
- (UIView *)topSeparation{
    if (_topSeparation == nil) {
        _topSeparation = [[UIView alloc] init];
        if (@available(iOS 11.0, *)) {
            _topSeparation.backgroundColor = [UIColor colorNamed:@"SZH分割条颜色"];
        } else {
            // Fallback on earlier versions
        }
    }
    return _topSeparation;
}
@end
