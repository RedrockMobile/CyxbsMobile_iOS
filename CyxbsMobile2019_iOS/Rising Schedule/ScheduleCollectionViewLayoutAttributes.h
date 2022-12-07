//
//  ScheduleCollectionViewLayoutAttributes.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/11/19.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_HEADER_AUDIT_BEGIN(nullability, sendability)

#pragma mark - ScheduleCollectionViewDataSource

// When you use NSIndexPath (Schedule), you must use those function to replace some of functions in UICollectionViewDataSource
NS_SWIFT_UI_ACTOR
@protocol ScheduleCollectionViewDataSource <UICollectionViewDataSource>

@optional

/// 返回一周所拥有的装饰视图数量，默认返回0
/// - Parameters:
///   - collectionView: 视图
///   - kind: 名字
///   - section: 第几周
- (NSInteger)collectionView:(UICollectionView *)collectionView
numberOfSupplementaryOfKind:(NSString *)kind
                  inSection:(NSInteger)section;

@end

NS_HEADER_AUDIT_END(nullability, sendability)





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
