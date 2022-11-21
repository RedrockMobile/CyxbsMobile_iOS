//
//  ScheduleCollectionViewLayoutAttributes.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/11/19.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ScheduleCourse.h"

NS_ASSUME_NONNULL_BEGIN


#pragma mark - ScheduleCollectionViewLayoutModel

@interface ScheduleCollectionViewLayoutModel: NSObject <NSCopying>

/// 标题
@property (nonatomic, copy) NSString *title;

/// 描述
@property (nonatomic, copy) NSString *content;

/// 星期
@property (nonatomic) NSInteger week;

/// 绘制的点
@property (nonatomic) NSRange orginRange;

/// 是否有多个重复视图
@property (nonatomic) BOOL hadMuti;

@end

#pragma mark - ScheduleCollectionViewLayoutAttributes

@interface ScheduleCollectionViewLayoutAttributes : UICollectionViewLayoutAttributes

/// Layout Model
@property (nonatomic, copy) ScheduleCollectionViewLayoutModel *layoutModel;

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

NS_ASSUME_NONNULL_END
