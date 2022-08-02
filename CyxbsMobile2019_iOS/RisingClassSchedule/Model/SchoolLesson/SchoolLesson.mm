 //
//  SchoolLesson.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/5/28.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "SchoolLesson.h"

#import "SchoolLesson+Rising.h"

#import <WCDB.h>

NSString *SchoolLessonTableName = @"school_lesson";

WCTDatabase *schoolLessonDB;

#pragma mark - SchoolLesson ()

@interface SchoolLesson ()

/// 存储period
@property (nonatomic) NSInteger period_location;

/// 存储period
@property (nonatomic) NSInteger period_lenth;

@end

@implementation SchoolLesson (Rising)

WCDB_IMPLEMENTATION(SchoolLesson)

WCDB_SYNTHESIZE(SchoolLesson, inSection)
WCDB_SYNTHESIZE(SchoolLesson, inWeek)
WCDB_SYNTHESIZE(SchoolLesson, period_location)
WCDB_SYNTHESIZE(SchoolLesson, period_lenth)

WCDB_SYNTHESIZE(SchoolLesson, course)
WCDB_SYNTHESIZE(SchoolLesson, courseNike)
WCDB_SYNTHESIZE(SchoolLesson, classRoom)
WCDB_SYNTHESIZE(SchoolLesson, classRoomNike)

WCDB_SYNTHESIZE(SchoolLesson, courseID)
WCDB_SYNTHESIZE(SchoolLesson, rawWeek)
WCDB_SYNTHESIZE(SchoolLesson, type)

WCDB_SYNTHESIZE(SchoolLesson, teacher)
WCDB_SYNTHESIZE(SchoolLesson, lesson)

@end

#pragma mark - SchoolLesson

@implementation SchoolLesson

#pragma mark - Before

+ (NSString *)databasePath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"school_lesson_database"];
}

#pragma mark - Life cycle

- (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        schoolLessonDB = [[WCTDatabase alloc] initWithPath:SchoolLesson.databasePath];
        [schoolLessonDB createTableAndIndexesOfName:SchoolLessonTableName withClass:SchoolLesson.class];
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
        
        
    }
    return self;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    SchoolLesson *model = [[SchoolLesson allocWithZone:zone] init];
    
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
