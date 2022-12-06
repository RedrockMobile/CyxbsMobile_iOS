//
//  ScheduleModel.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/2.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleModel.h"

#pragma mark - ScheduleModel

@implementation ScheduleModel {
    NSMutableDictionary <NSString *, ScheduleCombineModel *> *_statusMap;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _statusMap = NSMutableDictionary.dictionary;
    }
    return self;
}

- (void)combineModel:(ScheduleCombineModel *)model {
    [super combineModel:model];
    _statusMap[model.identifier] = model;
}

- (void)clear {
    [super clear];
    [_statusMap removeAllObjects];
}

- (NSArray<ScheduleCourse *> *)coursesWithLocationIdxPath:(NSIndexPath *)idxPath {
    NSMutableArray *ary = NSMutableArray.array;
    [_statusMap enumerateKeysAndObjectsUsingBlock:^(NSString * __unused key, ScheduleCombineModel * _Nonnull obj, BOOL * __unused stop) {
        for (ScheduleCourse *course in obj.courseAry) {
            if (course.inWeek == idxPath.week && NSLocationInRange(idxPath.location, course.period) ) {
                [ary addObject:obj];
            }
        }
    }];
    return ary;
}

#pragma mark - Setter

- (void)setNowWeek:(NSUInteger)nowWeek {
    if (_nowWeek == nowWeek) {
        return;
    }
    _nowWeek = nowWeek;
    NSDate *date = NSDate.date;
    NSTimeInterval beforNow = (_nowWeek - 1) * 7 * 24 * 60 * 60 + (date.weekday - 2) * 24 * 60 * 60;
    _startDate = [NSDate dateWithTimeIntervalSinceNow:-beforNow];
}

@end
