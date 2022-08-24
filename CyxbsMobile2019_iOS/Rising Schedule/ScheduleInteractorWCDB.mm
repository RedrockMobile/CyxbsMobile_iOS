//
//  ScheduleInteractorWCDB.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/24.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleInteractorWCDB.h"

#import <WCDB.h>

#pragma mark - ScheduleInteractorWCDB ()

@interface ScheduleInteractorWCDB ()

/// 唯一的db
@property (nonatomic, readonly, class) WCTDatabase *db;

@end

#pragma mark - ScheduleInteractorWCDB

@implementation ScheduleInteractorWCDB

#pragma mark - Getter

+ (NSString *)DBPath {
    static NSString *_path;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"schedule_course_database"];
    });
    
    return _path;
}

+ (NSString *)tableName {
    return @"schedule_course_table";
}

+ (WCTDatabase *)db {
    static WCTDatabase *_db;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _db = [[WCTDatabase alloc] initWithPath:self.DBPath];
        
        [_db createTableAndIndexesOfName:self.tableName withClass:self.class];
    });
    
    return _db;
}

@end
