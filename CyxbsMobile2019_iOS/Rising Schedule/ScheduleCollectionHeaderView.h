//
//  ScheduleCollectionHeaderView.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/9/6.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ScheduleCollectionHeaderView;

/// 复用标志
UIKIT_EXTERN NSString *ScheduleCollectionHeaderViewReuseIdentifier;

#pragma mark - ScheduleCollectionHeaderViewDataSource

@protocol ScheduleCollectionHeaderViewDataSource <NSObject>

@required

/// 是否需要检查数据源
/// (0周请返回NO)
/// @param view 视图
/// @param section 所在周
- (BOOL)scheduleCollectionHeaderView:(ScheduleCollectionHeaderView *)view
                 needSourceInSection:(NSInteger)section;

/// 返回leading数据(n月)
/// @param view 视图
/// @param section 所在周
- (NSString *)scheduleCollectionHeaderView:(ScheduleCollectionHeaderView *)view
                     leadingTitleInSection:(NSInteger)section;

/// 返回具体日期数据(n日)
/// @param view 视图
/// @param indexPath 所在周以及星期
- (NSString * _Nullable)scheduleCollectionHeaderView:(ScheduleCollectionHeaderView *)view
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
@property (nonatomic, weak) id <ScheduleCollectionHeaderViewDataSource> delegate;

/// 月份所占空间
@property (nonatomic) CGFloat widthForLeadingView;

/// 列间距
@property (nonatomic) CGFloat columnSpacing;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
