//
//  ScheduleCourse.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/23
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleCourse.h"

#import "ScheduleCourse+WCTTableCoding.h"

@interface ScheduleCourse ()

/// 存储period
@property (nonatomic) NSInteger period_location;

/// 存储period
@property (nonatomic) NSUInteger period_lenth;

@end

#pragma mark - SchoolLesson

@implementation ScheduleCourse

WCDB_IMPLEMENTATION(ScheduleCourse)

WCDB_SYNTHESIZE(ScheduleCourse, inWeek)
WCDB_SYNTHESIZE(ScheduleCourse, inSections)
WCDB_SYNTHESIZE(ScheduleCourse, period_location)
WCDB_SYNTHESIZE(ScheduleCourse, period_lenth)

WCDB_SYNTHESIZE(ScheduleCourse, course)
WCDB_SYNTHESIZE(ScheduleCourse, courseNike)
WCDB_SYNTHESIZE(ScheduleCourse, classRoom)
WCDB_SYNTHESIZE(ScheduleCourse, classRoomNike)

WCDB_SYNTHESIZE(ScheduleCourse, courseID)
WCDB_SYNTHESIZE(ScheduleCourse, rawWeek)
WCDB_SYNTHESIZE(ScheduleCourse, type)

WCDB_SYNTHESIZE(ScheduleCourse, teacher)
WCDB_SYNTHESIZE(ScheduleCourse, lesson)

WCDB_SYNTHESIZE(ScheduleCourse, sno)
WCDB_SYNTHESIZE(ScheduleCourse, requestType)

#pragma mark - Init

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    
    BOOL check = (!dic || dic.count < 10);
    if (check) {
        NSAssert(!check, @"\n🔴%s dic : %@", __func__, dic);
        return nil;
    }
    
    self = [super init];
    if (self) {
        self.inWeek = [dic[@"hash_day"] intValue] + 1;
        id weekAry = dic[@"week"];
        if ([weekAry isKindOfClass:NSArray.class]) {
            self.inSections = [NSMutableSet setWithArray:weekAry];
        }
        self.period_location = [dic[@"begin_lesson"] longValue];
        self.period_lenth = [dic[@"period"] unsignedLongValue];
        self.course = dic[@"course"];
        self.classRoom = dic[@"classroom"];
        self.courseID = dic[@"course_num"];
        self.rawWeek = dic[@"rawWeek"];
        self.type = dic[@"type"];
        self.teacher = dic[@"teacher"];
        self.lesson = dic[@"lesson"];
    }
    return self;
}

#pragma mark - Method

- (BOOL)isAboveVerticalTimeAs:(ScheduleCourse *)course {
    if (self.inWeek == course.inWeek && !NSEqualRanges(NSIntersectionRange(self.period, course.period), NSMakeRange(0, 0))) {
        return YES;
    }
    return NO;
}

#pragma mark - Setter

- (void)setPeriod:(NSRange)period {
    _period_location = period.location;
    _period_lenth = period.length;
}

#pragma mark - Getter

- (NSRange)period {
    if (_period_location < 0) {
        _period_location = 12 - _period_location;
    }
    
    return NSMakeRange(_period_location, _period_lenth);
}

- (NSString *)descriptionv{
    return [NSString stringWithFormat:@"%@", @{
        @"周" : @(_inWeek)
    }];
}

- (NSString *)timeStr {
    if (_period_location <= 0 || NSMaxRange(self.period) - 1 > 12) {
        return @"";
    }
    __block NSString *str;
    [ScheduleCourse getTimelineString:^(NSArray<NSString *> *beginTimes, NSArray<NSString *> *endTimes) {
        str = [NSString stringWithFormat:@"%@ - %@", beginTimes[(self.period_location - 1) % 12], endTimes[(NSMaxRange(self.period) - 2) % 12]];
    }];
    return str;
}

+ (void)getTimelineString:(void (^)(NSArray <NSString *> *beginTimes, NSArray <NSString *> *endTimes))block {
    static NSArray *beginTime = @[
        @"8:00",
        @"8:55",
        @"10:15",
        @"11:10",
        
        @"14:00",
        @"14:55",
        @"16:15",
        @"17:10",
        
        @"19:00",
        @"19:55",
        @"20:50",
        @"21:45"];
    
    static NSArray *endTime = @[
        @"8:45",
        @"9:40",
        @"11:00",
        @"11:55",
        
        @"14:45",
        @"15:40",
        @"17:00",
        @"17:55",
        
        @"19:45",
        @"20:40",
        @"20:35",
        @"22:30"
    ];
    if (block) {
        block(beginTime, endTime);
    }
}

@end
