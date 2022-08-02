//
//  ClassScheduleLayout.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/6/4.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ClassScheduleLayout;

#pragma mark - ClassScheduleLayoutDelegate

@protocol ClassScheduleLayoutDelegate <UICollectionViewDelegate>

@required

- (NSIndexPath *)classScheduleLayout:(ClassScheduleLayout *)layout sectionWeekForIndexPath:(NSIndexPath *)indexPath;

- (NSRange)classScheduleLayout:(ClassScheduleLayout *)layout rangeForIndexPath:(NSIndexPath *)indexPath;

@end

#pragma mark - ClassScheduleLayout

@interface ClassScheduleLayout : UICollectionViewLayout

/// 代理
@property (nonatomic, weak) id <ClassScheduleLayoutDelegate> delegate;

/// 行间距
@property (nonatomic) CGFloat lineSpacing;

/// 列间距
@property (nonatomic) CGFloat interitemSpacing;

/// 头视图宽度
@property (nonatomic) CGFloat headerWidth;

/// 每个item高度
@property (nonatomic) CGFloat itemHeight;

/// 中午
@property (nonatomic) BOOL needNoon __deprecated_msg("中午布局没写");

/// 晚上
@property (nonatomic) BOOL needNight __deprecated_msg("晚上布局没写");

@end

NS_ASSUME_NONNULL_END
