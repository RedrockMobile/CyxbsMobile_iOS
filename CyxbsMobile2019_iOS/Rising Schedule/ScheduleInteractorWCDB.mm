//
//  ScheduleInteractorWCDB.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/24.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleInteractorWCDB.h"

#import "ScheduleCourse+WCTTableCoding.h"

#pragma mark - ScheduleInteractorWCDB ()

@interface ScheduleInteractorWCDB ()

/// 唯一的db
@property (nonatomic, readonly) WCTDatabase *db;

@end

#pragma mark - ScheduleInteractorWCDB

@implementation ScheduleInteractorWCDB

- (void)insertCourse:(ScheduleCourse *)course {
    NSParameterAssert(course);
    
    [self.db
     insertObject:course
     into:self.class.tableName];
}

- (void)updateCourse:(ScheduleCourse *)course {
    NSParameterAssert(course);
    
    [self.db
     updateRowsInTable:self.class.tableName
     onProperties:ScheduleCourse.AllProperties
     withObject:course
     where:ScheduleCourse.sno == course.sno];
}

- (void)deleteCourse:(ScheduleCourse *)course {
    NSParameterAssert(course);
    
    [self.db
     deleteObjectsFromTable:self.class.tableName
     where:ScheduleCourse.sno == course.sno];
}

- (NSArray<ScheduleCourse *> *)courseAryForSno:(NSString *)num {
    BOOL check = (!num && num.length < 1);
    if (check) {
        NSAssert(check, @"\n🔴%s sno : %@", __func__, num);
        return nil;
    }
    
    return [self.db
            getObjectsOfClass:ScheduleCourse.class
            fromTable:self.class.tableName
            where:ScheduleCourse.sno == num];
}

#pragma mark - Getter

- (NSString *)DBPath {
    NSString *pathComponent = [NSString stringWithFormat:@"schedule/%@", self.class.tableName];
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:pathComponent];
}

+ (NSString *)tableName {
    return @"schedule_course_table";
}

- (WCTDatabase *)db {
    static WCTDatabase *_db;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _db = [[WCTDatabase alloc] initWithPath:self.DBPath];
        
        [_db createTableAndIndexesOfName:self.class.tableName withClass:ScheduleCourse.class];
    });
    
    return _db;
}

@end
