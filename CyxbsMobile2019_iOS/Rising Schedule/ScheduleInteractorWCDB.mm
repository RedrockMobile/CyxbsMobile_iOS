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

- (instancetype)initWithBindModel:(ScheduleCombineModel *)model {
    self = [super init];
    if (self) {
        _bindModel = model;
    }
    return self;
}

// 建表
- (void)creatTable {
    NSParameterAssert(self.class.db);
    [self.class.db createTableAndIndexesOfName:_bindModel.identifier withClass:ScheduleCourse.class];
}

// 这个批量缓存用于缓存自己和他人的系统课表
- (void)saveSystemData {
    [self.class.db insertObjects:_bindModel.courseAry into:_bindModel.identifier];
}

// MARK: 增

- (void)insertCourse:(ScheduleCourse *)course {
    NSParameterAssert(course);
    [self.db insertObject:course into:self.bindModel.identifier];
}

// MARK: 删

- (void)deleteCourse:(ScheduleCourse *)course {
    NSParameterAssert(course);
    // 删除：依据这节自定义的课程的周数，星期，period来定位到需要删除的课程
    [self.db deleteObjectsFromTable:self.bindModel.identifier where:(ScheduleCourse.inWeek == course.inWeek) && (ScheduleCourse.inSections == course.inSections) && (ScheduleCourse.period_lenth == course.period.length) && (ScheduleCourse.period_location == course.period.location)];
}

// MARK: 改

- (void)updateCourse:(ScheduleCourse *)course {
    NSParameterAssert(course);
    // 更新：依据这节自定义的课程的周数，星期，period来定位到需要更新的课程
    [self.db updateRowsInTable:self.bindModel.identifier
                  onProperties:ScheduleCourse.AllProperties
                    withObject:course
                         where:(ScheduleCourse.inWeek == course.inWeek) && (ScheduleCourse.inSections == course.inSections) && (ScheduleCourse.period_lenth == course.period.length) && (ScheduleCourse.period_location == course.period.location)];
}

// MARK: 查

+ (instancetype)getScheduleDataBaseFromSno:(NSString *)sno Type:(ScheduleCombineType)type {
    ScheduleCombineModel *model = [ScheduleCombineModel combineWithSno:sno type:type];
    model.courseAry = [self.db getAllObjectsOfClass:ScheduleCourse.class fromTable:model.identifier].mutableCopy;
    ScheduleInteractorWCDB *dataBase = [[self alloc] initWithBindModel:model];
    return dataBase;
}

#pragma mark - Getter

+ (NSString *)DBPath {
    NSString *pathComponent = [NSString stringWithFormat:@"/schedule/"];
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:pathComponent];
}

+ (WCTDatabase *)db {
    static WCTDatabase *_db;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _db = [[WCTDatabase alloc] initWithPath:self.DBPath];
        
    });
    
    return _db;
}

@end
