//
//  QASearchResultTopView.h
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/12/11.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SearchTopView.h"
#import "SZHHotSearchView.h"
#import "QASearchResultTopView.h"
#import "SegmentBarView.h"
NS_ASSUME_NONNULL_BEGIN
/**
 上半部分页面
 主要承载一个搜索的Bar，以及一个表示下方左右table所在的左右滑条
 */
@interface QASearchResultTopView : UIView

/// 顶部的搜索的bar
@property (nonatomic, strong) SearchTopView *searchBarView;

/// 邮问知识库的View
@property (nonatomic, strong) SZHHotSearchView *knowledgeView;

/// 上半部分表示
@property (nonatomic, strong) SegmentBarView *segementBarView;

/// verticalScroll最大偏移高度
@property (nonatomic, assign) CGFloat maxOffsetHeight;

/// 自身的高度
@property (nonatomic, assign) CGFloat viewHeight;

/// SegmentBarView上按钮文字数组
@property (nonatomic, copy) NSArray *segementBtnTextAry;

- (instancetype)initWithFrame:(CGRect)frame AndTextAry:(nonnull NSArray *)textAry IsHaveQAKnowledge:(BOOL)isHaveQAKnowledge;

///重新调整frame
- (void)updateHotSearchViewFrame;
@end

NS_ASSUME_NONNULL_END
