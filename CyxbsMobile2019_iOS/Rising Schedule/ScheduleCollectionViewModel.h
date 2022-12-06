//
//  ScheduleCollectionViewModel.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/11/23.
//  Copyright © 2022 Redrock. All rights reserved.
//

/**
 *
 * 外部的indexPath确定 *周* 和 *所在点*
 * timeline确定 *星期* 和 *长度*
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ScheduleBelongKind) {
    ScheduleBelongFistSystem,
    ScheduleBelongFistCustom,
    ScheduleBelongSecondSystem,
    ScheduleBelongUnknow = ScheduleBelongFistSystem
};

#pragma mark - ScheduleCollectionViewModel

@interface ScheduleCollectionViewModel : NSObject <NSCopying>

/// 标题
@property (nonatomic, copy) NSString *title;

/// 描述
@property (nonatomic, copy) NSString *content;

/// 是否有多个重复视图
@property (nonatomic) BOOL hadMuti;

/// 长度
@property (nonatomic) NSInteger lenth;

/// 类型
@property (nonatomic) ScheduleBelongKind kind;

@end

NS_ASSUME_NONNULL_END





#pragma mark - NSIndexPath (ScheduleTimeline)

NS_HEADER_AUDIT_BEGIN(nullability, sendability)

#define ScheduleIndexPath(s, w, l) [NSIndexPath indexPathForLocation:l inWeek:w inSection:s]

// This category provides convenience methods to make it easier to use an NSIndexPath to represent a location, week and section, for use with UICollectionView For Schedule
@interface NSIndexPath (ScheduleTimeline)

+ (instancetype)indexPathForLocation:(NSInteger)location inWeek:(NSInteger)week inSection:(NSInteger)section;

// Returns the index at position 0.
@property (nonatomic, readonly) NSInteger section;

// Returns the index at position 1.
@property (nonatomic, readonly) NSInteger week;

// Returns the index at position 2.
@property (nonatomic, readonly) NSInteger location;

@end

#pragma mark - Hash & Equal

typedef NSUInteger ScheduleIndexPathHash(const void *item, NSUInteger (* _Nullable size)(const void *item));
typedef BOOL ScheduleIndexPathEqual(const void *item1, const void*item2, NSUInteger (* _Nullable size)(const void *item));

FOUNDATION_EXPORT ScheduleIndexPathHash schedule_section_week_hash;
FOUNDATION_EXPORT ScheduleIndexPathEqual schedule_section_week_equal;

FOUNDATION_EXPORT ScheduleIndexPathHash schedule_sample_hash;
FOUNDATION_EXPORT ScheduleIndexPathEqual schedule_sample_equal;
//
//FOUNDATION_EXPORT ScheduleIndexPathEqual schedule_pointer_equal;

#pragma mark - ENUM (ScheduleCollectionViewLayoutTime)

typedef NS_ENUM(NSUInteger, ScheduleCollectionViewLayoutTime) {
    ScheduleCollectionViewLayoutTimeNoon = 015,
    ScheduleCollectionViewLayoutTimeNight
};

NS_HEADER_AUDIT_END(nullability, sendability)






#if __has_include("ScheduleCourse.h")
#import "ScheduleCourse.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScheduleCollectionViewModel (ScheduleCourse)

- (instancetype)initWithScheduleCourse:(ScheduleCourse *)course;

@end

NS_ASSUME_NONNULL_END

#endif




