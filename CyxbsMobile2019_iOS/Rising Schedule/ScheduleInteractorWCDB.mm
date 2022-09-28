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

/// 自己的定义事务的identifier
@property (nonatomic, readonly, class) NSString *selfCustomTableName;

@end

#pragma mark - ScheduleInteractorWCDB

@implementation ScheduleInteractorWCDB

- (instancetype)initWithBindModel:(ScheduleCombineModel *)model {
    self = [super init];
    if (self) {
        _bindModel = model;
        // 创建表
        [self _creatTable];
    }
    return self;
}

// 建表
- (void)_creatTable {
    NSParameterAssert(self.class.db);
    [self.class.db createTableAndIndexesOfName:_bindModel.identifier withClass:ScheduleCourse.class];
}

// 批量缓存，也可用于自定义课表的单课程缓存
- (void)saveData {
    [self.class.db insertObjects:_bindModel.courseAry into:_bindModel.identifier];
}

// MARK: 增

+ (void)insertCourse:(ScheduleCourse *)course {
    NSParameterAssert(course);
    [self.db insertObject:course into:self.selfCustomTableName] ;
}

// MARK: 删

// 删除一节课
+ (void)deleteCourse:(ScheduleCourse *)course {
    NSParameterAssert(course);
    // 删除：依据这节自定义的课程的周数，星期，period来定位到需要删除的课程
    [self.db deleteObjectsFromTable:self.selfCustomTableName where:(ScheduleCourse.inWeek == course.inWeek) && (ScheduleCourse.inSections == course.inSections) && (ScheduleCourse.period_lenth == course.period.length) && (ScheduleCourse.period_location == course.period.location)];
}

// 删除全部课程（用于保证本地数据库里面不会出现相同的课程，即所有课程需要在再次请求并存入数据库之前调用此方法，清除原先数据）
- (void)deleteAllCourse {
    [self.class.db deleteAllObjectsFromTable:self.bindModel.identifier];
}

// MARK: 改

+ (void)updateCourse:(ScheduleCourse *)course {
    NSParameterAssert(course);
    // 更新：依据这节自定义的课程的周数，星期，period来定位到需要更新的课程
    [self.db updateRowsInTable:self.selfCustomTableName
                  onProperties:ScheduleCourse.AllProperties
                    withObject:course
                         where:(ScheduleCourse.inWeek == course.inWeek) && (ScheduleCourse.inSections == course.inSections) && (ScheduleCourse.period_lenth == course.period.length) && (ScheduleCourse.period_location == course.period.location)];
}

// MARK: 查

// 查看是否存在该表
+ (BOOL)tableIsExist:(NSString *)tableName {
    if ([self.db isTableExists:tableName]) {
        return YES;
    }else {
        return NO;
    }
}

// 查看该表里面是否有数据
- (BOOL)isCache {
    if ([self.class.db getAllObjectsOfClass:ScheduleCourse.class fromTable:self.bindModel.identifier].count) {
        return YES;
    }else {
        return NO;
    }
}

+ (instancetype)getScheduleDataBaseFromSno:(NSString *)sno Type:(ScheduleCombineType)type {
    // 获得identifier为传入的CombineModel
    ScheduleCombineModel *CombineModel = [ScheduleCombineModel combineWithSno:sno type:type];
    CombineModel.courseAry = [self.db getAllObjectsOfClass:ScheduleCourse.class fromTable:CombineModel.identifier].mutableCopy;
    ScheduleInteractorWCDB *dataBase = [[self alloc] initWithBindModel:CombineModel];
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

/// 自己的定义事务的identifier
+ (NSString *)selfCustomTableName {
    return [NSString stringWithFormat:@"%@%@", ScheduleCombineCustom, UserItemTool
    .defaultItem.stuNum];
}

@end
