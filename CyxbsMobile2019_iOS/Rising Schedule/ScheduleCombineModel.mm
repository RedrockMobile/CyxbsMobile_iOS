//
//  ScheduleCombineModel.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/28.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleCombineModel.h"

#import "ScheduleCourse+WCTTableCoding.h"

#import <NSDate+YYAdd.h>

#pragma mark - ScheduleCombineModel

@implementation ScheduleCombineModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _courseAry = NSArray.array;
    }
    return self;
}

- (instancetype)initWithSno:(NSString *)sno type:(ScheduleModelRequestType)type {
    self = [super init];
    BOOL check = ((!sno || sno.length < 2) || (!type));
    if (check) {
        NSAssert(!check, @"\n🔴%s sno : %@, type : %@", __func__, sno, type);
        return nil;
    }
    if (self) {
        _sno = sno.copy;
        _requestType = type.copy;
    }
    return self;
}

#pragma mark - Getter

- (NSString *)identifier {
    return [NSString stringWithFormat:@"%@%@", _requestType, _sno];
}

#pragma mark - Setter

- (void)setNowWeek:(NSInteger)nowWeek {
    if (_nowWeek == nowWeek) {
        return;
    }
    _nowWeek = nowWeek;
    NSDate *date = NSDate.date;
    NSTimeInterval beforNow = (_nowWeek - 1) * 7 * 24 * 60 * 60 + (date.weekday - 2) * 24 * 60 * 60;
    _startDate = [NSDate dateWithTimeIntervalSinceNow:-beforNow];
}

- (void)setStartDate:(NSDate *)startDate {
    if ([_startDate isEqualToDate:startDate]) {
        return;
    }
    _startDate = startDate;
    NSTimeInterval beforNow = [NSDate.date timeIntervalSinceDate:startDate];
    _nowWeek = beforNow / (24 * 60 * 60) / 7;
}

@end

#pragma mark - ScheduleCombineModel (XXHB)

@implementation ScheduleCombineModel (XXHB)

+ (NSString *)path {
    NSString *pathComponent = [NSString stringWithFormat:@"/schedule/"];
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:pathComponent];
}

+ (WCTDatabase *)db {
    static WCTDatabase *_db;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _db = [[WCTDatabase alloc] initWithPath:self.path];
    });
    return _db;
}

- (void)replace {
    [self _check];
    [self.class.db deleteAllObjectsFromTable:self.identifier];
    [self.class.db insertObjects:self.courseAry into:self.identifier];
    
    [NSUserDefaults.standardUserDefaults setValue:self.startDate forKey:@"UDKey_startDate"];
}

- (void)awake {
    [self _check];
    self.courseAry = [self.class.db getAllObjectsOfClass:ScheduleCourse.class fromTable:self.identifier];
}

- (void)_check {
    if (![self.class.db isTableExists:self.identifier]) {
        [self.class.db createTableAndIndexesOfName:self.identifier withClass:ScheduleCourse.class];
    }
}

@end
