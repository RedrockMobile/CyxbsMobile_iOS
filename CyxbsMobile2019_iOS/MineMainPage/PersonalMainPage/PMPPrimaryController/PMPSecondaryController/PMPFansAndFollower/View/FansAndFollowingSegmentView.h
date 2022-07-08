//
//  FansAndFollowingSegmentView.h
//  CyxbsMobile2019_iOS
//
//  Created by p_tyou on 2021/9/17.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FansAndFollowingSegmentView;
@protocol SegmentViewDelegate <NSObject>

- (void)segmentView:(FansAndFollowingSegmentView *)segmentView
     alertWithIndex:(NSInteger)index;

@end

/**
 * 分隔栏视图
 * 必须使用初始化方法
 * 1. segmentViewWithFrame:titles:
 * 2. initWithFrame:(CGRect)frame titles:(NSArray <NSString *> *)titles;
 */

@interface FansAndFollowingSegmentView : UIView

@property (nonatomic, strong) UIImageView * sliderLinePart;

@property (nonatomic, weak) id <SegmentViewDelegate> delegate;
/// 所有的标题
@property (nonatomic, copy) NSArray <NSString *> * titles;
/// 选中的button
@property (nonatomic, assign) NSInteger selectedIndex;

+ (instancetype)segmentViewWithTitles:(NSArray <NSString *> *)titles;
- (instancetype)initWithTitles:(NSArray <NSString *> *)titles;

@end

NS_ASSUME_NONNULL_END
