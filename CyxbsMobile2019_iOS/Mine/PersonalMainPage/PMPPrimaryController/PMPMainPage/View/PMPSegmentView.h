//
//  PMPSegmentView.h
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/9/15.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PMPSegmentView;
@protocol SegmentViewDelegate <NSObject>

- (void)segmentView:(PMPSegmentView *)segmentView
     alertWithIndex:(NSInteger)index;

@end

/**
 * 分隔栏视图
 * 必须使用初始化方法
 * 1. segmentViewWithFrame:titles:
 * 2. initWithFrame:(CGRect)frame titles:(NSArray <NSString *> *)titles;
 */
@interface PMPSegmentView : UIView

@property (nonatomic, weak) id <SegmentViewDelegate> delegate;
/// 所有的标题
@property (nonatomic, copy) NSArray <NSString *> * titles;
/// 选中的button
@property (nonatomic, assign) NSInteger selectedIndex;

+ (instancetype)segmentViewWithFrame:(CGRect)frame titles:(NSArray <NSString *> *)titles;
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray <NSString *> *)titles;

@end

NS_ASSUME_NONNULL_END

