//
//  ScheduleCollectionHeaderView.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/9/6.
//  Copyright © 2022 Redrock. All rights reserved.
//

/**ScheduleCollectionHeaderViewDataSource头视图
 * 请在每次使用时赋值**所有**属性
 * 代理必须需要，否则没有数据用于驱动
 * 必须执行- sizeToFit来保证UI正确
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ScheduleCollectionHeaderView;

/// 复用标志
UIKIT_EXTERN NSString *ScheduleCollectionHeaderViewReuseIdentifier;

#pragma mark - ScheduleCollectionHeaderViewDataSource

@protocol ScheduleCollectionHeaderViewDataSource <NSObject>

@required

/// 返回leading数据(n月)
/// @param view 视图
/// @param section 所在周
- (NSString *)scheduleCollectionHeaderView:(ScheduleCollectionHeaderView *)view
                     leadingTitleInSection:(NSInteger)section;

/// 是否需要检查数据源
/// (仅仅不需要日期，但还是会掉用leading)
/// @param view 视图
/// @param section 所在周
- (BOOL)scheduleCollectionHeaderView:(ScheduleCollectionHeaderView *)view
                 needSourceInSection:(NSInteger)section;

/// 返回具体日期数据(n日)
/// @param view 视图
/// @param indexPath 所在周以及星期
- (NSString *)scheduleCollectionHeaderView:(ScheduleCollectionHeaderView *)view
                    contentDateAtIndexPath:(NSIndexPath *)indexPath;

/// 是否是当天
/// @param view 视图
/// @param indexPath 所在周以及星期
- (BOOL)scheduleCollectionHeaderView:(ScheduleCollectionHeaderView *)view
            isCurrentDateAtIndexPath:(NSIndexPath *)indexPath;

@end

#pragma mark - ScheduleCollectionHeaderView

@interface ScheduleCollectionHeaderView : UICollectionReusableView

/// 代理
@property (nonatomic, weak) id <ScheduleCollectionHeaderViewDataSource> dataSource;

/// 父视图
@property (nonatomic, weak) UICollectionView *superCollectionView;

/// 头视图的宽
@property (nonatomic) CGFloat widthForLeadingView;

/// 列间距
@property (nonatomic) CGFloat columnSpacing;

/// 添加current视图，记录如下
/// 1) view.top = self.height / 2; view.height = self.height/2; view.width FIT;
/// 2) week = [1,7], others will do not addSubview;
/// @param view 视图
/// @param week 周数
- (void)addCurrentView:(__kindof UIView *)view atWeek:(NSInteger)week;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
