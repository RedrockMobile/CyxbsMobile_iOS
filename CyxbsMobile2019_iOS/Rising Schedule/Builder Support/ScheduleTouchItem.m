//
//  ScheduleTouchItem.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/1/26.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "ScheduleTouchItem.h"

#import "ScheduleTimelineSupport.h"
#import "ScheduleNeedsSupport.h"

#import "ScheduleCourse.h"

@implementation ScheduleTouchItem

- (void)setCombining:(ScheduleCombineItem *)combining {
    if (!combining) { return; }
    _combining = combining;
    
    _startDate = _combining.identifier.exp <= 0 ? nil :
        [NSDate dateWithTimeIntervalSince1970:_combining.identifier.exp];
    for (ScheduleCourse *course in self.combining.value) {
        _lastSection = MAX(_lastSection, course.inSections.lastIndex);
    }
}

- (NSInteger)nowWeek {
    NSTimeInterval since = [NSDate.date timeIntervalSinceDate:self.startDate];
    return since / (7 * 24 * 60 * 60) + 1;
}

- (ScheduleCourse *)floorCourse {
    if (self.nowWeek <= 0 || self.nowWeek > self.lastSection) {
        return nil;
    }
    NSInteger weekday = [NSCalendar.republicOfChina componentsInTimeZone:CQTimeZone() fromDate:NSDate.date].scheduleWeekday;
    
    NSMutableArray <ScheduleCourse *> *_sectionCourseAry = NSMutableArray.array;
    ScheduleTimeline *timeline = [[ScheduleTimeline alloc] init];
    for (ScheduleCourse *course in self.combining.value) {
        if (self.nowWeek > 0 && course.inWeek == weekday &&
            [course.inSections containsIndex:self.nowWeek]) {
            [_sectionCourseAry addObject:course];
        }
    }
    for (ScheduleCourse *course in _sectionCourseAry) {
        if (NSLocationInRange(timeline.percent, course.period)) {
            return course;
        }
    }
    
    ScheduleCourse *fin = nil;
    for (ScheduleCourse *course in _sectionCourseAry) {
        if (course.period.location >= timeline.percent) {
            fin = fin ? (course.period.location < fin.period.location ? course : fin) : course;
        }
    }
    
    return fin;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@, %p> %@", NSStringFromClass(self.class), self, self.combining];
}

#pragma mark - <NSCopying>

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    ScheduleTouchItem *item = [[ScheduleTouchItem alloc] init];
    item.combining = self.combining;
    return item;
}

#pragma mark - <NSSecureCoding>

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:self.combining forKey:@"combining"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    self = [super init];
    if (self) {
        ScheduleCombineItem *item = [coder decodeObjectForKey:@"combining"];
        self.combining = item;
    }
    return self;
}

@end
