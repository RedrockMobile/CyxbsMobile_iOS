//
//  SearchBeiginView.h
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/1/25.
//  Copyright © 2021 Redrock. All rights reserved.
//
/**
 搜索初始页的上半部分View
 */
#import <UIKit/UIKit.h>
#import "SearchTopView.h"
#import "SZHHotSearchView.h"
NS_ASSUME_NONNULL_BEGIN

@interface SearchBeiginView : UIView
/// 顶部搜索的视图
@property (nonatomic, strong) SearchTopView *searchTopView;
@property (nonatomic, strong) SZHHotSearchView *hotSearchView;
@property (nonatomic, strong) UIView *topSeparation;
@end

NS_ASSUME_NONNULL_END
