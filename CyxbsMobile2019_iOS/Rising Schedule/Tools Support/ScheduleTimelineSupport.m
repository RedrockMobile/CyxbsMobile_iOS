//
//  ScheduleTimelineSupport.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/12/28.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleTimelineSupport.h"

@implementation SchedulePartTimeline

- (instancetype)initWithFastBlock:(void (^)(NSDateComponents * _Nonnull, NSDateComponents * _Nonnull))block {
    self = [super init];
    if (self) {
        NSDateComponents *componets = [NSCalendar.currentCalendar componentsInTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Chongqing"] fromDate:NSDate.date];
        NSDateComponents *from = componets.copy;
        NSDateComponents *to = componets.copy;
        if (block) {
            block(from, to);
        }
        self.fromComponents = from.copy;
        self.toComponents = to.copy;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@, %p>\n[ - from: %@, \n - to: %@]", NSStringFromClass(self.class), self, self.fromComponents, self.toComponents];
}

@end



#import "RisingSingleClass.h"

#define PartTimeLineFromTo(f_h, f_m, t_h, t_m) \
[[SchedulePartTimeline alloc] initWithFastBlock:^(NSDateComponents * _Nonnull from, NSDateComponents * _Nonnull to) { \
    from.hour = f_h; from.minute = f_m; \
    to.hour = t_h; to.minute = t_m; \
}]

@implementation ScheduleTimeline {
    NSArray <SchedulePartTimeline *> *_timelineAry;
}

RisingSingleClass_IMPLEMENTATION(Timeline)

+ (ScheduleTimeline *)standardTimeLine {
    return [self.shareTimeline init];
}

- (instancetype)init {
    return [self initWithSuiteName:nil];
}

- (instancetype)initWithSuiteName:(ScheduleTimelineSuiteName)suitename {
    self = [super init];
    if (self) {
        _timelineAry = [self _getTimelineWithSuiteName:suitename];
    }
    return self;
}

- (NSUInteger)count {
    return _timelineAry.count;
}

- (SchedulePartTimeline *)objectAtIndexedSubscript:(NSUInteger)idx {
    return [_timelineAry objectAtIndexedSubscript:idx];
}

- (CGFloat)percentWithDateComponents:(NSDateComponents *)compnents {
    NSCalendar *canlendar = NSCalendar.currentCalendar;
    if ([canlendar compareDate:compnents.date toDate:(_timelineAry[0].fromComponents.date) toUnitGranularity:NSCalendarUnitHour | NSCalendarUnitMinute] == NSOrderedAscending) {
        return 0;
    }
    if ([canlendar compareDate:compnents.date toDate:(_timelineAry[_timelineAry.count - 1].toComponents.date) toUnitGranularity:NSCalendarUnitHour | NSCalendarUnitMinute] == NSOrderedDescending) {
        return 1;
    }
    
    for (NSInteger i = 0; i < _timelineAry.count; i++) {
        SchedulePartTimeline *timeline = _timelineAry[i];
        if ([canlendar compareDate:compnents.date toDate:timeline.fromComponents.date toUnitGranularity:NSCalendarUnitHour | NSCalendarUnitMinute] == NSOrderedAscending) {
            return i + 1;
        }
        if ([canlendar compareDate:compnents.date toDate:timeline.toComponents.date toUnitGranularity:NSCalendarUnitHour | NSCalendarUnitMinute] == NSOrderedAscending) {
            NSTimeInterval (^_dayTimeFrom)(NSDateComponents *) = ^NSTimeInterval (NSDateComponents *components) {
                return (NSTimeInterval)(compnents.hour * 60 + compnents.minute);
            };
            return i + 1 + (_dayTimeFrom(compnents) - _dayTimeFrom(timeline.fromComponents)) /
            (_dayTimeFrom(timeline.toComponents) - _dayTimeFrom(timeline.fromComponents));
        }
    }
    
    return self.count;
}

- (NSArray <SchedulePartTimeline *> *)_getTimelineWithSuiteName:(NSString *)suitename {
    static NSMapTable <NSString *, NSArray <SchedulePartTimeline *> *> *_map;
    if (_map == nil) {
        _map = [NSMapTable
         mapTableWithKeyOptions:
             NSPointerFunctionsStrongMemory |
         NSPointerFunctionsObjectPersonality
         valueOptions:
             NSPointerFunctionsStrongMemory |
         NSPointerFunctionsObjectPersonality];
    }
    NSArray <SchedulePartTimeline *> *value = [_map objectForKey:suitename];
    if (value) {
        return value;
    }
    
    if (suitename == nil || [suitename isEqualToString:ScheduleTimelineStandard]) {
        [_map setObject:value forKey:ScheduleTimelineStandard];
        value = @[
            PartTimeLineFromTo(  8, 00,  8, 45),
            PartTimeLineFromTo(  8, 55,  9, 40),
            PartTimeLineFromTo( 10, 15, 11, 00),
            PartTimeLineFromTo( 11, 10, 11, 55),
            
            PartTimeLineFromTo( 14, 00, 14, 45),
            PartTimeLineFromTo( 14, 55, 15, 40),
            PartTimeLineFromTo( 16, 15, 17, 00),
            PartTimeLineFromTo( 17, 10, 17, 55),
            
            PartTimeLineFromTo( 19, 00, 19, 45),
            PartTimeLineFromTo( 19, 55, 20, 40),
            PartTimeLineFromTo( 20, 50, 21, 35),
            PartTimeLineFromTo( 21, 45, 22, 30),
        ];
    }
    
    return value;
}

ScheduleTimelineSuiteName const ScheduleTimelineStandard = @"ScheduleTimelineStandard";
ScheduleTimelineSuiteName const ScheduleTimelineNoon = @"ScheduleTimelineNoon";
ScheduleTimelineSuiteName const ScheduleTimelineNight = @"ScheduleTimelineNight";
ScheduleTimelineSuiteName const ScheduleTimelineNoonAndNight = @"ScheduleTimelineNoonAndNight";

@end
