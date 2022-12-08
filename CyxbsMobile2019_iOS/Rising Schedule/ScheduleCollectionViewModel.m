//
//  ScheduleCollectionViewModel.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/11/23.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleCollectionViewModel.h"

#pragma mark - ScheduleCollectionViewModel

@implementation ScheduleCollectionViewModel

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    ScheduleCollectionViewModel *model = [[ScheduleCollectionViewModel alloc] init];
    model.title = self.title.copy;
    model.content = self.content.copy;
    model.hadMuti = self.hadMuti;
    model.kind = self.kind;
    model.lenth = self.lenth;
    return model;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"len:%ld, kind:%ld, muti:%d (%@ %@)", self.lenth, self.kind, self.hadMuti, self.title, self.content];
}

@end

#pragma mark - NSIndexPath (ScheduleTimeline)

@implementation NSIndexPath (ScheduleTimeline)

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

#pragma mark - Hash & Equal

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

#pragma mark - ScheduleCollectionViewModel (ScheduleCourse)

@implementation ScheduleCollectionViewModel (ScheduleCourse)

- (instancetype)initWithScheduleCourse:(ScheduleCourse *)course {
    self = [super init];
    if (self) {
        self.title = course.course;
        self.content = course.classRoom;
        self.hadMuti = NO;
        self.kind = ScheduleBelongUnknow;
        self.lenth = course.period.length;
    }
    return self;
}

@end
