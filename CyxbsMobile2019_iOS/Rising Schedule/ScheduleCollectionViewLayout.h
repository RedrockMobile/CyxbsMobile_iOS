//
//  ScheduleCollectionViewLayout.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/9/4.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ScheduleCollectionViewLayout;

#pragma mark - ScheduleCollectionViewLayoutDelegate

@protocol ScheduleCollectionViewLayoutDelegate <NSObject>

@required

/// 星期几
/// @param collectionView 视图
/// @param layout 布局
/// @param indexPath 下标
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

@end

#pragma mark - ScheduleCollectionViewLayout

@interface ScheduleCollectionViewLayout : UICollectionViewLayout

/// 代理
@property (nonatomic, weak) id <ScheduleCollectionViewLayoutDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
