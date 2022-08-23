 //
//  ScheduleCourse.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/23
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleCourse.h"

#import "ScheduleCourse+WCTTableCoding.h"

ScheduleCourseType required = @"必修";

ScheduleCourseType elective = @"选修";

ScheduleCourseType transaction = @"事务";

#pragma mark - SchoolLesson (WCTTableCoding)

@implementation ScheduleCourse (WCTTableCoding)

WCDB_IMPLEMENTATION(ScheduleCourse)

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

#pragma mark - Init

- (instancetype) initWithDictionary:(NSDictionary *)dic {
    BOOL check = (!dic || dic.count < 10);
    if (check) {
        NSAssert(!check, @"\n🚩%s dic : %@", __func__, dic);
        return nil;
    }
    
    self = [super init];
    if (self) {
        self.inWeek = [dic[@"hash_day"] intValue] + 1;
        self.period_location = [dic[@"begin_lesson"] longValue];
        self.period_lenth = [dic[@"period"] unsignedLongValue];
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
    
    model.period_lenth = self.period_lenth;
    model.period_location = self.period_location;
    model.course = self.course.copy;
    model.classRoom = self.classRoom.copy;
    model.courseID = self.courseID.copy;
    model.rawWeek = self.rawWeek.copy;
    model.type = self.type.copy;
    model.teacher = self.teacher.copy;
    model.lesson = self.lesson.copy;
    
    return model;
}

#pragma mark - Getter

- (NSRange)period {
    if (_period_location < 0) {
        _period_location = 12 - _period_location;
    }
    return NSMakeRange(_period_location, _period_lenth);
}

#pragma mark - <IGListDiffable>

- (nonnull id<NSObject>)diffIdentifier {
    return self;
}

- (BOOL)isEqualToDiffableObject:(nullable id<IGListDiffable>)object {
    BOOL check = (!object || ![object.diffIdentifier isKindOfClass:ScheduleCourse.class]);
    if (check) {
        NSAssert(!check, @"\n🚩%s object : %@", __func__, object);
        return NO;
    }
    
    ScheduleCourse *anotherCourse = (ScheduleCourse *)object;
    return NO;
    
//    return self.inSection == anotherCourse.inSection
//        && NSEqualRanges(self.period, anotherCourse.period)
//
//        && [self.sno isEqualToString:anotherCourse.sno]
//        && [self.courseID isEqualToString:anotherCourse.courseID];
}

@end
