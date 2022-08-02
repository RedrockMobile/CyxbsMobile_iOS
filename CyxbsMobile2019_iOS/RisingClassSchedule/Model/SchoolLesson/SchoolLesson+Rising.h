//
//  SchoolLesson+Rising.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/3.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "SchoolLesson.h"

#import <WCDB.h>

NS_ASSUME_NONNULL_BEGIN

/// 数据表
FOUNDATION_EXPORT NSString *SchoolLessonTableName;

FOUNDATION_EXPORT WCTDatabase *schoolLessonDB;

#pragma mark - SchoolLesson (Rising)

@interface SchoolLesson (Rising) <
    WCTTableCoding
>

WCDB_PROPERTY(inWeek)
WCDB_PROPERTY(inDay)
WCDB_PROPERTY(period_location)
WCDB_PROPERTY(period_lenth)

WCDB_PROPERTY(course)
WCDB_PROPERTY(courseNike)
WCDB_PROPERTY(classRoom)
WCDB_PROPERTY(classRoomNike)

WCDB_PROPERTY(courseID)
WCDB_PROPERTY(rawWeek)
WCDB_PROPERTY(type)

WCDB_PROPERTY(teacher)
WCDB_PROPERTY(lesson)

@end

@interface SchoolLesson (test) <SchoolLessonDataSource>

@end

NS_ASSUME_NONNULL_END
