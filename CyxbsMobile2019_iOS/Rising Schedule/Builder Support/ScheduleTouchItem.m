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

@implementation ScheduleTouchItem {
    NSMutableArray <ScheduleCourse *> *_todayCourse;
    NSUInteger _maxSection;
}

- (void)setCombining:(ScheduleCombineItem *)combining {
    _todayCourse = NSMutableArray.array;
    _combining = combining;
    _startDate = [NSDate dateWithTimeIntervalSince1970:combining.identifier.exp];
    double nowWeek = ceil([NSDate.date timeIntervalSinceDate:_startDate] / (7 * 24 * 60 * 60));
    _nowWeek = nowWeek;
    
    _maxSection = 0;
    for (ScheduleCourse *course in self.combining.value) {
        _maxSection = MAX(_maxSection, course.inSections.lastIndex);
        if ([course.inSections containsIndex:self.nowWeek]) {
            [_todayCourse addObject:course];
        }
    }
    
    __weak ScheduleTouchItem *blockItem = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(45 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ScheduleTouchItem *item = blockItem;
        [item setCombining:combining];
    });
}

- (ScheduleCourse *)floorCourse {
    if (_todayCourse.count == 0) {
        return nil;
    }
    NSInteger (^timesInDay)(NSDateComponents *) = ^NSInteger(NSDateComponents *components) {
        return (components.hour * 60 + components.minute);
    };
    NSDateComponents *components = [ScheduleCalendar() componentsInTimeZone:CQTimeZone() fromDate:NSDate.date];
    NSInteger times = timesInDay(components);
    ScheduleCourse *next;
    for (ScheduleCourse *course in _todayCourse) {
        SchedulePartTimeline *part = [ScheduleTimeline partTimeLineForOriginRange:course.period];
        if (times >= timesInDay(part.fromComponents)) {
            next = course;
            if (times < timesInDay(part.toComponents)) {
                return course;
            }
        }
    }
    return next;
}

@end
