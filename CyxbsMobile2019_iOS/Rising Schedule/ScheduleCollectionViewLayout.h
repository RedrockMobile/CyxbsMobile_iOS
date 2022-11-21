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

#import "ScheduleCollectionViewLayoutAttributes.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - ScheduleCollectionViewLayoutDataSource

@class ScheduleCollectionViewLayout;

@protocol ScheduleCollectionViewLayoutDataSource <NSObject>

@required

- (NSInteger)collectionView:(UICollectionView *)collectionView
                     layout:(ScheduleCollectionViewLayout *)layout
numberOfSupplementaryOfKind:(NSString *)kind
                  inSection:(NSInteger)section;

/// 返回LayoutAttributes，只有基础的东西才会被使用，
/// @param collectionView 视图
/// @param layout 布局
/// @param indexPath 下标布局
- (ScheduleCollectionViewLayoutModel *)collectionView:(UICollectionView *)collectionView
                                               layout:(ScheduleCollectionViewLayout *)layout
                        layoutModelForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional

/// 布局中午或者晚上的时候使用，若不使用，则不布局中午晚上
/// @param collectionView 视图
/// @param layout 布局
/// @param section 那一个section
/// @param layTransform 布局的话，则传回这个，不传也可以
- (void)collectionView:(UICollectionView *)collectionView
                layout:(ScheduleCollectionViewLayout *)layout
             inSection:(NSInteger)section
          noonAndNight:(void (^)(BOOL layNoon, BOOL layNight))layTransform
__deprecated_msg("即将部署该API，测试阶段");

/// 双人展示 - 对比两个重合的视图（callBack为YES才会掉用）
/// 如需要改变，请直接对两个Attributes进行改变
/// 返回值： NSOrderedDescending 和 NSOrderedAscending 会再次对Attributes进行改变
/// 如果不想判断，就返回NSOrderedSame，会采用默认情况
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
@property (nonatomic) BOOL callBack __deprecated_msg("正在测试阶段");

@end

NS_ASSUME_NONNULL_END
