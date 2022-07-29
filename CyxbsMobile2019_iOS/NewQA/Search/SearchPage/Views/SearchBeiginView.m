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
            self.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#F1F3F8" alpha:1] darkColor:[UIColor colorWithHexString:@"#000001" alpha:1]];
        } else {
            // Fallback on earlier versions
        }
        self.hotTitleStr = str;
        [self buildFrame];
    }
    return self;
}

//设置UI
- (void)buildFrame{
    //最顶部的搜索view
    [self addSubview:self.searchTopView];
    [self.searchTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.bottom.equalTo(self.mas_top).offset(NVGBARHEIGHT + STATUSBARHEIGHT);
        make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W, MAIN_SCREEN_H * 0.0462));
        
    }];
    [self layoutIfNeeded];
    self.searchTopView.searchFieldBackgroundView.layer.cornerRadius = self.searchTopView.searchFieldBackgroundView.frame.size.height * 0.5;
    
    [self addSubview:self.hotSearchView];
    [self.hotSearchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchTopView.mas_bottom).offset(MAIN_SCREEN_H * 0.0449);
        make.left.equalTo(self.mas_left).offset(MAIN_SCREEN_W * 0.0426);
        make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W * 0.8506, [self.hotSearchView ViewHeight]));
    }];
    
    [self addSubview:self.topSeparation];
    [self.topSeparation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W, 1));
    }];
}

- (CGFloat)searchBeginViewHeight{
    //动态高度 + 固定高度
    //topView高度 + 热搜距顶部高度 + 热搜View高度
    return (NVGBARHEIGHT+STATUSBARHEIGHT)  + MAIN_SCREEN_H * 0.0449 + [self.hotSearchView ViewHeight];
}

- (void)updateHotSearchViewFrame{
    [self.hotSearchView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchTopView.mas_bottom).offset(MAIN_SCREEN_H * 0.0449);
        make.left.equalTo(self.mas_left).offset(MAIN_SCREEN_W * 0.0426);
        make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W * 0.8506, [self.hotSearchView ViewHeight]));
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
            _topSeparation.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#E2E8EE" alpha:1] darkColor:[UIColor colorWithHexString:@"#252525" alpha:1]];
        } else {
            // Fallback on earlier versions
        }
    }
    return _topSeparation;
}
@end
