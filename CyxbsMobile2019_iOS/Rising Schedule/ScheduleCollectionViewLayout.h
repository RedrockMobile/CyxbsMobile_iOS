//
//  ScheduleCollectionViewLayout.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/9/4.
//  Copyright © 2022 Redrock. All rights reserved.
//

/**ScheduleCollectionViewLayout视图布局
 * 设置所有陈列出来的属性，来达到最佳的视觉效果
 * 请查看飞书云文档
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - ScheduleCollectionViewLayoutAttributes

@interface ScheduleCollectionViewLayoutAttributes : UICollectionViewLayoutAttributes

/// 星期
@property (nonatomic) NSInteger week;

/// 绘制的range
@property (nonatomic) NSRange drawRange;

/// 是否有多个重复视图
@property (nonatomic) BOOL hadMuti;

@end

#pragma mark - ScheduleCollectionViewLayoutInvalidationContext

@interface ScheduleCollectionViewLayoutInvalidationContext : UICollectionViewLayoutInvalidationContext

/// 是否立刻重新布局顶视图
@property (nonatomic) BOOL invalidateHeaderSupplementaryAttributes;

/// 是否立刻重新布局左视图
@property (nonatomic) BOOL invalidateLeadingSupplementaryAttributes;

/// 是否立刻重新布局课表视图
@property (nonatomic) BOOL invalidateAllAttributes;

@end

#pragma mark - ScheduleCollectionViewLayoutDelegate

@class ScheduleCollectionViewLayout;

@protocol ScheduleCollectionViewLayoutDataSource <NSObject>

@required

/// 星期几
/// @param collectionView 视图
/// @param layout 布局
/// @param indexPath 下标布局
- (NSUInteger)collectionView:(UICollectionView *)collectionView
                      layout:(ScheduleCollectionViewLayout *)layout
      weekForItemAtIndexPath:(NSIndexPath *)indexPath;

/// 第几节-长度
/// @param collectionView 视图
/// @param layout 布局
/// @param indexPath 下标
- (NSRange)collectionView:(UICollectionView *)collectionView
                   layout:(ScheduleCollectionViewLayout *)layout
  rangeForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional

/// 双人展示 - 对比两个重合的视图
/// 如需要改变，请直接对两个Attributes进行改变
/// @param collectionView 视图
/// @param layout 布局
/// @param compareAttributes 之前在视图里面的Attributes
/// @param conflictAttributes 即将呈现的Attributes
- (NSComparisonResult)collectionView:(UICollectionView *)collectionView
                              layout:(ScheduleCollectionViewLayout *)layout
             compareOriginAttributes:(ScheduleCollectionViewLayoutAttributes *)compareAttributes
              conflictWithAttributes:(ScheduleCollectionViewLayoutAttributes *)conflictAttributes
__deprecated_msg("即将部署该API，测试阶段");

@end

#pragma mark - ScheduleCollectionViewLayout

@interface ScheduleCollectionViewLayout : UICollectionViewLayout

/// 代理
@property (nonatomic, weak) id <ScheduleCollectionViewLayoutDataSource> dataSource;

/// 行间距
@property (nonatomic) CGFloat lineSpacing;

/// 列间距
@property (nonatomic) CGFloat columnSpacing;

/// 前部装饰视图宽
@property (nonatomic) CGFloat widthForLeadingSupplementaryView;

/// 头部装饰视图高
@property (nonatomic) CGFloat heightForHeaderSupplementaryView;

/// 课表自布局callback，默认为NO
/// 如果是YES， 必掉用optional的**compareOrigin:conflictWith:**回掉
/// 否则则不会掉用
@property (nonatomic) BOOL callBack __deprecated_msg("正在修改阶段");

@end

NS_ASSUME_NONNULL_END
