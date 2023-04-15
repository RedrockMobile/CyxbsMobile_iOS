//
//  ScheduleTimelineSupport.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/12/28.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleTimelineSupport.h"

#import "ScheduleNeedsSupport.h"

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






@implementation ScheduleTimeline

- (NSUInteger)count {
    switch (self.type) {
        case ScheduleTimelineSimple:
            return 12;
            break;
        case ScheduleTimelineNoon:
            return 13;
            break;
        case ScheduleTimelineNight:
            return 13;
            break;
        case ScheduleTimelineNoonAndNight:
            return 14;
            break;
    }
    return 0;
}

- (SchedulePartTimeline *)partTimelineAtPosition:(NSUInteger)position {
    if (position <= 0 || position > 14) { return nil; }
    switch (self.type) {
        case ScheduleTimelineSimple: {
            if (position <= 4) { return ScheduleTimeline._simple[position - 1]; } // [1, 4] -> [0...3]
            else if (position <= 8) { return ScheduleTimeline._simple[position]; } // [5, 8] -> [5...8]
            else if (position <= 12) { return ScheduleTimeline._simple[position + 1]; } // [9, 12] -> [10...14]
            else { return  nil; }
            break;
        };
        case ScheduleTimelineNoon: {
            if (position <= 9 ) { return ScheduleTimeline._simple[position - 1]; } // [1, 8] -> [0...7]
            else if (position <= 13) { return ScheduleTimeline._simple[position + 1]; } // [9, 13] -> [10...14]
            else { return nil; }
            break;
        }
        case ScheduleTimelineNight: {
            if (position <= 4 ) { return ScheduleTimeline._simple[position - 1]; } // [1, 4] -> [0...3]
            else if (position <= 13) { return ScheduleTimeline._simple[position]; } // [5, 13] -> [5...13]
            else { return nil; }
            break;
        }
        case ScheduleTimelineNoonAndNight: {
            return ScheduleTimeline._simple[position - 1]; // [1, 14] -> [0...13]
        }
    }
    return nil;
}

- (NSRange)layoutRangeWithOriginRange:(NSRange)range {
    switch (self.type) {
        case ScheduleTimelineSimple: {
            return range;
            break;
        }
            /*
        case ScheduleTimelineNoon: {
            if (NSLocationInRange(<#NSUInteger loc#>, <#NSRange range#>))
            if (range.location >= 4) { range.location += 1; }
            break;
        }
        case ScheduleTimelineNight:
            <#code#>
            break;
        case ScheduleTimelineNoonAndNight:
            <#code#>
            break;
             */
        default: break;
    }
    return NSMakeRange(0, 0);
}

- (CGFloat)percent {
    NSInteger(^getSec)(NSDateComponents *) = ^NSInteger(NSDateComponents *com) {
        return com.hour * 60 * 60 + com.minute * 60 + com.second;
    };
    NSDateComponents *components = [NSCalendar.republicOfChina components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:NSDate.date];
    NSInteger nowsec = getSec(components);
    switch (self.type) {
        case ScheduleTimelineSimple: {
            if (getSec(components) < getSec([self partTimelineAtPosition:0].fromComponents)) {
                return 1;
            }
            for (NSInteger i = 1; i <= self.count; i++) {
                NSInteger from = getSec([self partTimelineAtPosition:i].fromComponents);
                NSInteger to = getSec([self partTimelineAtPosition:i].toComponents);
                if (nowsec >= from && nowsec < to) {
                    return i + ((CGFloat)(nowsec - from)) / (to - from);
                }
            }
            for (NSInteger i = 1; i <= self.count - 1; i++) {
                NSInteger from = getSec([self partTimelineAtPosition:i].toComponents);
                NSInteger to = getSec([self partTimelineAtPosition:i + 1].fromComponents);
                if (nowsec >= from && nowsec <= to) {
                    return i + 1;
                }
            }
            return self.count + 1;
            break;
        }
            
        default: break;
            /*
        case ScheduleTimelineNoon:
            <#code#>
            break;
        case ScheduleTimelineNight:
            <#code#>
            break;
        case ScheduleTimelineNoonAndNight:
            <#code#>
            break;
             */
    }
    return  0;
}

#pragma mark - pravate

+ (NSArray <SchedulePartTimeline *> *)_simple {
    static NSArray <SchedulePartTimeline *> *_simple;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _simple = @[
            _partFromTo( @"1",  8, 00,  8, 45),  // 0
            _partFromTo( @"2",  8, 55,  9, 40),
            _partFromTo( @"3", 10, 15, 11, 00),
            _partFromTo( @"4", 11, 10, 11, 55),
            
            _partFromTo(@"中\n午", 12, 10, 13, 50), // 4
            
            _partFromTo( @"5", 14, 00, 14, 45), // 5
            _partFromTo( @"6", 14, 55, 15, 40),
            _partFromTo( @"7", 16, 15, 17, 00),
            _partFromTo( @"8", 17, 10, 17, 55),
            
            _partFromTo(@"晚\n上", 18, 10, 18, 50), // 9
            
            _partFromTo( @"9", 19, 00, 19, 45), // 10
            _partFromTo(@"10", 19, 55, 20, 40),
            _partFromTo(@"11", 20, 50, 21, 35),
            _partFromTo(@"12", 21, 45, 22, 30), // 14
        ];
    });
    return _simple;
}

static SchedulePartTimeline * _partFromTo(NSString *title, NSInteger f_h, NSInteger f_m, NSInteger e_h, NSInteger e_m) {
    SchedulePartTimeline *item = [[SchedulePartTimeline alloc] init];
    item.title = title;
    item.fromComponents.hour = f_h;
    item.fromComponents.minute = f_m;
    item.fromComponents.second = 0;
    item.toComponents.hour = e_h;
    item.toComponents.minute = e_m;
    item.toComponents.second = 0;
    return item;
}

@end

@implementation ScheduleTimeline (ScheduleCourse)

+ (SchedulePartTimeline *)partTimeLineWithCouse:(ScheduleCourse *)course {
    ScheduleTimeline *timeline = [[ScheduleTimeline alloc] init];
    SchedulePartTimeline *from = [timeline partTimelineAtPosition:course.period.location];
    SchedulePartTimeline *to = [timeline partTimelineAtPosition:NSMaxRange(course.period) - 1];
    from.fromComponents.weekday = course.inWeek;
    to.toComponents.weekday = course.inWeek;
    SchedulePartTimeline *fin = [[SchedulePartTimeline alloc] init];
    fin.title = from.title;
    fin.fromComponents = from.fromComponents;
    fin.toComponents = to.toComponents;
    return fin;
}

@end
