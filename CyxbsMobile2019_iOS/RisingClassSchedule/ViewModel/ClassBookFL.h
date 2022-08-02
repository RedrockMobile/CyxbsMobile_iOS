//
//  ClassBookFL.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/6/4.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ClassBookFL;

#pragma mark - ClassBookFLDelegate

@protocol ClassBookFLDelegate <UICollectionViewDelegate>

@required

/// 确定left的leftIndexPath = 第几周，星期几- section个数
/// @param fl 检测fl
/// @param indexPath 系统indexPath
- (NSIndexPath *)classBookFL:(ClassBookFL *)fl leftIndexPathForIndexPath:(NSIndexPath *)indexPath;

/// 确定唯一性的rangeIndexPath = 星期几，第几节-  item个数
/// @param fl 检测fl
/// @param indexPath 系统indexPath
/// @param leftIndexPath leftIndexPath
- (NSIndexPath *)classBookFL:(ClassBookFL *)fl rangeIndexPathForIndexPath:(NSIndexPath *)indexPath leftIndexPath:(NSIndexPath *)leftIndexPath;

/// 小的item的大小
/// @param fl 检测fl
/// @param leftIndexPath leftIndexPath
/// @param rangeIndexPath rangeIndexPath
- (CGSize)classBookFL:(ClassBookFL *)fl littleSizeForLeftIndexPath:(NSIndexPath *)leftIndexPath rangeIndexPath:(NSIndexPath *)rangeIndexPath;

@end

#pragma mark - ClassBookFL

@interface ClassBookFL : UICollectionViewLayout

/// 代理
@property (nonatomic, weak) id <ClassBookFLDelegate> delegate;

@property (nonatomic) CGFloat lineSpacing;

@property (nonatomic) CGFloat interitemSpacing;

@end

NS_ASSUME_NONNULL_END
