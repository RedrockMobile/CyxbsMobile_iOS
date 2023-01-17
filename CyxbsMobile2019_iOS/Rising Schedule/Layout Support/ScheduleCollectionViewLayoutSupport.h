//
//  ScheduleCollectionViewLayoutSupport.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/11/19.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - ScheduleCollectionViewLayoutAttributes

@interface ScheduleCollectionViewLayoutAttributes : UICollectionViewLayoutAttributes <NSCopying>

/// indexPath
@property (nonatomic, copy) NSIndexPath *pointIndexPath;

/// lenth
@property (nonatomic) NSInteger lenth;

@end





#pragma mark - ScheduleCollectionViewLayoutInvalidationContext

@interface ScheduleCollectionViewLayoutInvalidationContext : UICollectionViewLayoutInvalidationContext

/// 是否立刻重新布局顶视图
@property (nonatomic) BOOL invalidateHeaderSupplementaryAttributes;

/// 是否立刻重新布局左视图
@property (nonatomic) BOOL invalidateLeadingSupplementaryAttributes;

@end

NS_ASSUME_NONNULL_END
