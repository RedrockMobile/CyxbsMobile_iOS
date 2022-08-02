//
//  SchoolLesson+Rising.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/3.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "SchoolLesson+Rising.h"

#pragma mark - SchoolLesson (test)

@implementation SchoolLesson (test)

#pragma mark - WCDB

+ (void)deleteAll {
    // TODO: 个别不删除
    [schoolLessonDB deleteAllObjectsFromTable:SchoolLessonTableName];
}

- (void)save {
    [schoolLessonDB insertObject:self into:SchoolLessonTableName];
}

+ (NSArray <SchoolLesson *> *)aryFromWCDB {
    NSArray<SchoolLesson *> *modelAry = [schoolLessonDB getAllObjectsOfClass:SchoolLesson.class fromTable:SchoolLessonTableName];
    return modelAry;
}

+ (NSArray<SchoolLesson *> *)request:(void (^)(SchoolLesson * _Nonnull))requestBlock {
    NSArray<SchoolLesson *> *modelAry =
    [schoolLessonDB
     getObjectsOfClass:self.class
     fromTable:SchoolLessonTableName
     where:SchoolLesson.period_location > 3];
    return modelAry;
}

@end
