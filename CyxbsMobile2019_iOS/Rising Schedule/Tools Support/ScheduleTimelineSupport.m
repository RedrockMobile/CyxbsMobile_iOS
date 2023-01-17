//
//  ScheduleTimelineSupport.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/12/28.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleTimelineSupport.h"

@implementation SchedulePartTimeline

- (instancetype)init {
    self = [super init];
    if (self) {
        self.fromComponents = [NSCalendar.currentCalendar componentsInTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Chongqing"] fromDate:NSDate.date];
        self.toComponents = self.fromComponents.copy;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@, %p>\n[ - from: %@, \n - to: %@]", NSStringFromClass(self.class), self, self.fromComponents, self.toComponents];
}

- (id)copyWithZone:(nullable NSZone *)zone {
    SchedulePartTimeline *item = [[SchedulePartTimeline alloc] init];
    item.fromComponents = self.fromComponents.copy;
    item.toComponents = self.toComponents.copy;
    item.title = self.title.copy;
    return item;
}

@end



#import "RisingSingleClass.h"

@implementation ScheduleTimeline {
    NSMutableArray *_timelineAry;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = ScheduleTimelineSimple;
        _timelineAry = [[NSMutableArray alloc] initWithArray:self.class._simple copyItems:YES];
    }
    return self;
}

- (NSUInteger)count {
    return _timelineAry.count;
}

- (SchedulePartTimeline *)objectAtIndexedSubscript:(NSUInteger)idx {
    return [_timelineAry objectAtIndexedSubscript:idx];
}

- (NSRange)layoutRangeWithOriginRange:(NSRange)range {
    if (range.location < 1) { range.location = 1; }
    if (NSMaxRange(range) > self.count) {
        range.length -= NSMaxRange(range) - self.count;
    }
    // noon support
    BOOL noon = NO;
    if (self.type & ScheduleTimelineNoon) {
        noon = YES;
        if (range.location >= 5) {
            range.location += 1;
        } else if (NSLocationInRange(5, range)) {
            range.length += 1;
        }
    }
    // night support
    if (self.type & ScheduleTimelineNight) {
        if (range.location >= (noon ? 10 : 9)) {
            range.location += 1;
        } else if (NSLocationInRange((noon ? 10 : 9), range)) {
            range.length += 1;
        }
    }
    
    return range;
}

+ (SchedulePartTimeline *)partTimeLineForOriginRange:(NSRange)range {
    NSArray <SchedulePartTimeline *> *simpleAry = self._simple;
    SchedulePartTimeline *timeline = [[SchedulePartTimeline alloc] init];;
    
    if (range.location == 13) {
        timeline.fromComponents = self._noon.fromComponents;
        range.location = 5;
        range.length -= 1;
    } else if (range.length == 14) {
        timeline.fromComponents = self._night.fromComponents;
        range.length = 9;
        range.length -= 1;
    } else {
        timeline.fromComponents = simpleAry[range.location - 1].fromComponents;
    }
    
    if (range.location < 5 && NSMaxRange(range) > 5) {
        range.length -= 1;
    } else if (range.location < 9 && NSMaxRange(range) > 9) {
        range.length -= 1;
    }
    if (range.length == 0) {
        timeline.toComponents = timeline.fromComponents.copy;
    } else {
        timeline.toComponents = simpleAry[NSMaxRange(range) - 2].toComponents.copy;
    }
    
    return timeline;
}

- (void)setType:(ScheduleTimelineType)type {
    NSAssert(type & ScheduleTimelineSimple, @"你想干嘛？");
    type &= ScheduleTimelineSimple;
    if (type == _type) {
        return;
    }
    
    ScheduleTimelineType diff = type ^ _type;
    BOOL noon = YES;
    if (diff & ScheduleTimelineNoon) {
        [_timelineAry removeObjectAtIndex:4];
        noon = NO;
    } else {
        [_timelineAry insertObject:self.class._noon atIndex:4];
    }
    if (diff & ScheduleTimelineNight) {
        [_timelineAry removeObjectAtIndex:(noon ? 9 : 8)];
    } else {
        [_timelineAry insertObject:self.class._night atIndex:(noon ? 9 : 8)];
    }
}

#pragma mark - pravate

+ (NSArray <SchedulePartTimeline *> *)_simple {
    static NSArray <SchedulePartTimeline *> *_simple;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _simple = @[
            _partFromTo( @"1",  8, 00,  8, 45),
            _partFromTo( @"2",  8, 55,  9, 40),
            _partFromTo( @"3", 10, 15, 11, 00),
            _partFromTo( @"4", 11, 10, 11, 55),
            
            _partFromTo( @"5", 14, 00, 14, 45),
            _partFromTo( @"6", 14, 55, 15, 40),
            _partFromTo( @"7", 16, 15, 17, 00),
            _partFromTo( @"8", 17, 10, 17, 55),
            
            _partFromTo( @"9", 19, 00, 19, 45),
            _partFromTo(@"10", 19, 55, 20, 40),
            _partFromTo(@"11", 20, 50, 21, 35),
            _partFromTo(@"12", 21, 45, 22, 30),
        ];
    });
    return _simple;
}

+ (SchedulePartTimeline *)_noon {
    return _partFromTo(@"中\n午", 12, 10, 13, 50);
}

+ (SchedulePartTimeline *)_night {
    return _partFromTo(@"晚\n上", 18, 10, 18, 50);
}

static SchedulePartTimeline * _partFromTo(NSString *title, NSInteger f_h, NSInteger f_m, NSInteger e_h, NSInteger e_m) {
    SchedulePartTimeline *item = [[SchedulePartTimeline alloc] init];
    item.title = title;
    item.fromComponents.hour = f_h;
    item.fromComponents.minute = f_m;
    item.toComponents.hour = e_h;
    item.toComponents.minute = e_m;
    return item;
}

@end
