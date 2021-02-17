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
//分割条
@property (nonatomic, strong) UIView *topSeparation;

//保存传入的str进行热门搜索或者邮问知识库的初始化
@property (nonatomic, strong) NSString *hotTitleStr;

/// 根据传入的标题进行初始化为热搜或者邮问知识库
/// @param str 传入的字符串
- (instancetype)initWithString:(NSString *)str;
@end

NS_ASSUME_NONNULL_END
