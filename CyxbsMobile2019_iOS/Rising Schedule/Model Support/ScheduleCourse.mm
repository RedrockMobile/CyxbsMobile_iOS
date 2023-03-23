//
//  ScheduleCourse.mm
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/23
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleCourse.h"

#import "ScheduleTimelineSupport.h"
#import "ScheduleNeedsSupport.h"

@interface ScheduleCourse ()

/// 存储period
@property (nonatomic) NSInteger period_location;

/// 存储period
@property (nonatomic) NSUInteger period_lenth;

@end

#pragma mark - ScheduleCourse

#import "ScheduleCourse+WCTTableCoding.h"



@implementation ScheduleCourse {
    NSString *_timeStr;
}

#ifdef WCDB_h

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

#endif

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
            NSMutableIndexSet *idxSet = NSMutableIndexSet.indexSet;
            for (NSNumber *sectionNumber in weekAry) {
                [idxSet addIndex:sectionNumber.longValue];
            }
            self.inSections = idxSet.copy;
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

- (NSString *)timeStr {
    if (_timeStr == nil) {
        SchedulePartTimeline *timeline = [ScheduleTimeline partTimeLineWithCouse:self];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.locale = CNLocale();
        formatter.timeZone = CQTimeZone();
        formatter.dateFormat = @"HH:mm";
        NSString *beginStr = [formatter stringFromDate:timeline.fromComponents.date];
        NSString *endStr = [formatter stringFromDate:timeline.toComponents.date];
        _timeStr = [beginStr stringByAppendingFormat:@" - %@", endStr];
    }
    return _timeStr;
}

#pragma mark - override

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p>;\n \
            course: %@, place: %@, inWeek: %ld, period: %ld, %ld\n", NSStringFromClass(self.class), self,
            self.course, self.classRoom, self.inWeek, self.period.location, self.period.length];
}

#pragma mark - <NSSecureCoding>

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)decoder {
    self.inWeek = [decoder decodeIntegerForKey:@"inWeek"];
    self.inSections = [decoder decodeObjectOfClass:NSIndexSet.class forKey:@"inSections"];
    self.period_location = [decoder decodeIntegerForKey:@"location"];
    self.period_lenth = [decoder decodeIntegerForKey:@"lenth"];
    self.course = [decoder decodeObjectForKey:@"course"];
    self.courseNike = [decoder decodeObjectForKey:@"courseNike"];
    self.classRoom = [decoder decodeObjectForKey:@"classRoom"];
    self.classRoomNike = [decoder decodeObjectForKey:@"classRoomNike"];
    self.courseID = [decoder decodeObjectForKey:@"id"];
    self.rawWeek = [decoder decodeObjectForKey:@"rawWeek"];
    self.type = [decoder decodeObjectForKey:@"type"];
    self.teacher = [decoder decodeObjectForKey:@"teacher"];
    
    return self;
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeInteger:self.inWeek forKey:@"inWeek"];
    [coder encodeObject:self.inSections forKey:@"inSections"];
    [coder encodeInteger:self.period_location forKey:@"location"];
    [coder encodeInteger:self.period_lenth forKey:@"lenth"];
    [coder encodeObject:self.course forKey:@"course"];
    [coder encodeObject:self.courseNike forKey:@"courseNike"];
    [coder encodeObject:self.classRoom forKey:@"classRoom"];
    [coder encodeObject:self.classRoomNike forKey:@"classRoomNike"];
    [coder encodeObject:self.courseID forKey:@"id"];
    [coder encodeObject:self.rawWeek forKey:@"rawWeek"];
    [coder encodeObject:self.type forKey:@"type"];
    [coder encodeObject:self.teacher forKey:@"teacher"];
}

@end
