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
    NSMutableArray <ScheduleCourse *> *_sectionCourseAry;
}

- (void)setCombining:(ScheduleCombineItem *)combining {
    _combining = combining;
    
    _startDate = _combining.identifier.exp < NSTimeIntervalSince1970 ? nil :
        [NSDate dateWithTimeIntervalSince1970:_combining.identifier.exp];
    _nowWeek = ceil([NSDate.date timeIntervalSinceDate:self.startDate] / (7 * 24 * 60 * 60));
    
    _sectionCourseAry = NSMutableArray.array;
    for (ScheduleCourse *course in self.combining.value) {
        _lastSection = MAX(_lastSection, course.inSections.lastIndex);
        if (self.nowWeek > 0 && [course.inSections containsIndex:self.nowWeek]) {
            [_sectionCourseAry addObject:course];
        }
    }
    
    __weak ScheduleTouchItem *blockItem = self;
    if (blockItem) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(45 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            ScheduleTouchItem *item = blockItem;
            [item setCombining:combining];
        });
    }
}

- (ScheduleCourse *)floorCourse {
    if (self.nowWeek <= 0 || self.nowWeek > self.lastSection || _sectionCourseAry.count == 0) {
        return nil;
    }
    
    ScheduleCourse *next = nil;
    
    
    
    return next;
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
