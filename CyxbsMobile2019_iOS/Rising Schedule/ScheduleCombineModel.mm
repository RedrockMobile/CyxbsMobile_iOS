//
//  ScheduleCombineModel.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/28.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleCombineModel.h"

#import "ScheduleCourse+WCTTableCoding.h"

#pragma mark - ScheduleCombineModel

@implementation ScheduleCombineModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _courseAry = NSMutableArray.array;
    }
    return self;
}

+ (instancetype)combineWithSno:(NSString *)sno type:(ScheduleModelRequestType)type {
    BOOL check = ((!sno || sno.length < 2) || (!type));
    if (check) {
        NSAssert(!check, @"\n🔴%s sno : %@, type : %@", __func__, sno, type);
        return nil;
    }
    
    ScheduleCombineModel *model = [[ScheduleCombineModel alloc] init];
    
    model->_sno = sno.copy;
    model->_requestType = type.copy;
    
    return model;
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
    
    NSArray *ary = [self.class.db getAllObjectsOfClass:ScheduleCourse.class fromTable:self.identifier];
    RisingLog("😀", @"replace %@", ary);
    
    [NSUserDefaults.standardUserDefaults setValue:self.startDate forKey:UDKey.startDate];
}

- (void)awake {
    [self _check];
    self.courseAry = [self.class.db getAllObjectsOfClass:ScheduleCourse.class fromTable:self.identifier];
    RisingLog("😀", @"replace %@", self.courseAry);
    self.startDate = [NSUserDefaults.standardUserDefaults valueForKey:UDKey.startDate];
}

- (void)_check {
    if (![self.class.db isTableExists:self.identifier]) {
        [self.class.db createTableAndIndexesOfName:self.identifier withClass:ScheduleCourse.class];
    }
}

@end
