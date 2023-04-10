//
//  NSIndexPath+Schedule.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/12/10.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_HEADER_AUDIT_BEGIN(nullability, sendability)

#define ScheduleIndexPathNew(s, w, l) [NSIndexPath indexPathForLocation:l inWeek:w inSection:s]

// This category provides convenience methods to make it easier to use an NSIndexPath to represent a location, week and section, for use with UICollectionView For Schedule
@interface NSIndexPath (Schedule)

+ (instancetype)indexPathForLocation:(NSInteger)location inWeek:(NSInteger)week inSection:(NSInteger)section;

// Returns the index at position 0.
@property (nonatomic, readonly) NSInteger section;

// Returns the index at position 1.
@property (nonatomic, readonly) NSInteger week;

// Returns the index at position 2.
@property (nonatomic, readonly) NSInteger location;

@end

typedef NSUInteger ScheduleIndexPathHashFunction(const void *item, NSUInteger (* _Nullable size)(const void *item));
typedef BOOL ScheduleIndexPathEqualFunction(const void *item1, const void*item2, NSUInteger (* _Nullable size)(const void *item));

FOUNDATION_EXPORT ScheduleIndexPathHashFunction schedule_section_week_hash;
FOUNDATION_EXPORT ScheduleIndexPathEqualFunction schedule_section_week_equal;

typedef NS_ENUM(NSUInteger, ScheduleCollectionViewLayoutTime) {
    ScheduleCollectionViewLayoutTimeNoon = 015,
    ScheduleCollectionViewLayoutTimeNight
};

// UICollectionElementKind

FOUNDATION_EXPORT NSString *const UICollectionElementKindSectionLeading API_AVAILABLE(ios(6.0));
FOUNDATION_EXPORT NSString *const UICollectionElementKindSectionTrailing API_AVAILABLE(ios(6.0));
FOUNDATION_EXPORT NSString *const UICollectionElementKindSectionPlaceholder API_AVAILABLE(ios(6.0));
FOUNDATION_EXPORT NSString *const UICollectionElementKindSectionHolder API_AVAILABLE(ios(6.0));

NS_HEADER_AUDIT_END(nullability, sendability)
