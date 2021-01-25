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
- (instancetype)init{
    self = [super init];
    if (self) {
        if (@available(iOS 11.0, *)) {
            self.backgroundColor = SZHMainBoardColor;
        } else {
            // Fallback on earlier versions
        }
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
    
}
#pragma mark- getter
- (SearchTopView *)searchTopView{
    if (_searchTopView == nil) {
        _searchTopView = [[SearchTopView alloc] init];
    }
    return _searchTopView;
}


@end
