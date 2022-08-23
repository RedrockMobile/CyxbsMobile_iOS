 //
//  ScheduleCourse.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/23
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleCourse.h"

NSString *SchoolLessonTableName = @"school_lesson";

WCTDatabase *schoolLessonDB;

#pragma mark - SchoolLesson ()

@interface ScheduleCourse ()

/// 存储period
@property (nonatomic) NSInteger period_location;

/// 存储period
@property (nonatomic) NSInteger period_lenth;

@end

@interface ScheduleCourse (Rising) <
    WCTTableCoding
>

WCDB_PROPERTY(inSection)
WCDB_PROPERTY(inWeek)
WCDB_PROPERTY(period_location)
WCDB_PROPERTY(period_lenth)

WCDB_PROPERTY(course)
WCDB_PROPERTY(courseNike)
WCDB_PROPERTY(classRoom)
WCDB_PROPERTY(classRoomNike)

WCDB_PROPERTY(courseID)
WCDB_PROPERTY(rawWeek)
WCDB_PROPERTY(type)

WCDB_PROPERTY(sno)
WCDB_PROPERTY(teacher)
WCDB_PROPERTY(lesson)

@end

#pragma mark - SchoolLesson (Rising)

/**
 * 因为period_location和period_lenth在这个文件里，
 * 所以这个implementation只能写在这个.m
 */

@implementation ScheduleCourse (Rising)

WCDB_IMPLEMENTATION(ScheduleCourse)

WCDB_SYNTHESIZE(ScheduleCourse, inSection)
WCDB_SYNTHESIZE(ScheduleCourse, inWeek)
WCDB_SYNTHESIZE(ScheduleCourse, period_location)
WCDB_SYNTHESIZE(ScheduleCourse, period_lenth)

WCDB_SYNTHESIZE(ScheduleCourse, course)
WCDB_SYNTHESIZE(ScheduleCourse, courseNike)
WCDB_SYNTHESIZE(ScheduleCourse, classRoom)
WCDB_SYNTHESIZE(ScheduleCourse, classRoomNike)

WCDB_SYNTHESIZE(ScheduleCourse, courseID)
WCDB_SYNTHESIZE(ScheduleCourse, rawWeek)
WCDB_SYNTHESIZE(ScheduleCourse, type)

WCDB_SYNTHESIZE(ScheduleCourse, sno)
WCDB_SYNTHESIZE(ScheduleCourse, teacher)
WCDB_SYNTHESIZE(ScheduleCourse, lesson)

@end

#pragma mark - SchoolLesson

@implementation ScheduleCourse

#pragma mark - Before

+ (NSString *)databasePath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"school_lesson_database"];
}

#pragma mark - System

- (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        schoolLessonDB = [[WCTDatabase alloc] initWithPath:ScheduleCourse.databasePath];
        [schoolLessonDB createTableAndIndexesOfName:SchoolLessonTableName withClass:ScheduleCourse.class];
    });
}

- (instancetype) initWithDictionary:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.inSection = [dic[@"week"] intValue];
        self.inWeek = [dic[@"hash_day"] intValue] + 1;
        self.period = NSMakeRange([dic[@"begin_lesson"] unsignedLongValue],
                                  [dic[@"period"] unsignedLongValue]);
        self.course = dic[@"course"];
        self.classRoom = dic[@"classroom"];
        self.courseID = dic[@"course_num"];
        self.rawWeek = dic[@"rawWeek"];
        self.type = dic[@"type"];
        self.teacher = dic[@"teacher"];
        self.lesson = dic[@"lesson"];
        self.sno = dic[@"sno"];
        
    }
    return self;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    ScheduleCourse *model = [[ScheduleCourse allocWithZone:zone] init];
    
    model.inSection = self.inSection;
    model.inWeek = self.inWeek;
    model.period = self.period;
    model.course = self.course.copy;
    model.classRoom = self.classRoom.copy;
    model.courseID = self.courseID.copy;
    model.rawWeek = self.rawWeek.copy;
    model.type = self.type.copy;
    model.teacher = self.teacher.copy;
    model.lesson = self.lesson.copy;
    
    return model;
}

#pragma mark - Setter

- (void)setPeriod:(NSRange)period {
    _period = period;
    _period_location = period.location;
    _period_lenth = period.length;
}

- (void)setPeriod_location:(NSInteger)period_location {
    _period_location = period_location;
    _period.location = period_location;
}

- (void)setPeriod_lenth:(NSInteger)period_lenth {
    _period_lenth = period_lenth;
    _period.length = period_lenth;
}

@end
