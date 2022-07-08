//
//  QASearchResultRootView.h
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/12/11.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QASearchResultTopView.h"
NS_ASSUME_NONNULL_BEGIN
/**
 搜索结果界面最底层的一个View，这个view将会替代QASearchResultVC自带的View

 */
@interface QASearchResultRootView : UIView
///tooView
@property (nonatomic, strong) QASearchResultTopView *topView;

/// segement上按钮的文字数组
@property (nonatomic, copy) NSArray *segementBtnTextAry;
- (instancetype)initWithFrame:(CGRect)frame IsHaveKnoweledge:(BOOL)isHaveKnoweledge;
@end

NS_ASSUME_NONNULL_END
