//
//  NSIndexPath+Schedule.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/12/10.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "NSIndexPath+Schedule.h"

NSString *const UICollectionElementKindSectionLeading = @"UICollectionElementKindSectionLeading";
NSString *const UICollectionElementKindSectionTrailing = @"UICollectionElementKindSectionTrailing";
NSString *const UICollectionElementKindSectionPlaceholder = @"UICollectionElementKindSectionPlaceholder";
NSString *const UICollectionElementKindSectionHolder = @"UICollectionElementKindSectionHolder";

@implementation NSIndexPath (Schedule)

+ (instancetype)indexPathForLocation:(NSInteger)location inWeek:(NSInteger)week inSection:(NSInteger)section {
    NSUInteger nums[] = {section, week, location};
    return [NSIndexPath indexPathWithIndexes:nums length:3];
}

- (NSInteger)section {
    return [self indexAtPosition:0];
}

- (NSInteger)week {
    return [self indexAtPosition:1];
}

- (NSInteger)location {
    return [self indexAtPosition:2];
}

// ----- Hash & Equal -----

NSUInteger schedule_section_week_hash(const void *item, NSUInteger (* _Nullable size)(const void *item)) {
    NSIndexPath *idx = (__bridge NSIndexPath *)(item);
    return (2 << 2) + 06 + (idx.section << 8) + (idx.week << 21);
}

BOOL schedule_section_week_equal(const void *item1, const void *item2, NSUInteger (* _Nullable size)(const void *item)) {
    NSIndexPath *idx1 = (__bridge NSIndexPath *)(item1);
    NSIndexPath *idx2 = (__bridge NSIndexPath *)(item2);
    return idx1.section == idx2.section && idx1.week == idx2.week;
}

@end
