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
    NSMutableArray <NSMutableArray <NSIndexPath *> *> *_courseIdxPaths;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _statusMap = NSMutableDictionary.dictionary;
    }
    return self;
}

- (void)combineModel:(ScheduleCombineModel *)model {
    if (_statusMap[model.identifier]) {
        return;
    }
    [super combineModel:model];
    _statusMap[model.identifier] = model;
    _courseIdxPaths = nil;
    self.nowWeek = model.nowWeek;
}

- (void)clear {
    [super clear];
    [_statusMap removeAllObjects];
    _courseIdxPaths = nil;
}

- (NSArray<ScheduleCourse *> *)coursesWithLocationIdxPath:(NSIndexPath *)idxPath {
    NSMutableArray *ary = NSMutableArray.array;
    [_statusMap enumerateKeysAndObjectsUsingBlock:^(NSString * __unused key, ScheduleCombineModel * _Nonnull obj, BOOL * __unused stop) {
        for (ScheduleCourse *course in obj.courseAry) {
            if (course.inSections && course.inWeek == idxPath.week && NSLocationInRange(idxPath.location, course.period) ) {
                [ary addObject:course];
            }
        }
    }];
    return ary;
}

#pragma mark - Getter

- (NSArray<NSArray<NSIndexPath *> *> *)courseIdxPaths {
    if (_courseIdxPaths == nil) {
        _courseIdxPaths = @[NSMutableArray.array].mutableCopy;
        
        NSEnumerator <NSIndexPath *> *idxEnum = self.mapTable.keyEnumerator;
        for (NSIndexPath *indexPath = idxEnum.nextObject; indexPath; indexPath = idxEnum.nextObject) {
            for (NSInteger i = _courseIdxPaths.count; i <= indexPath.section; i++) {
                [_courseIdxPaths addObject:NSMutableArray.array];
            }
            [_courseIdxPaths[indexPath.section] addObject:indexPath];
        }
    }
    return _courseIdxPaths;
}

#pragma mark - Setter

- (void)setNowWeek:(NSUInteger)nowWeek {
    if (_nowWeek == nowWeek) {
        return;
    }
    _nowWeek = nowWeek;
    NSDate *date = NSDate.date;
    NSUInteger originWeek = date.weekday;
    originWeek = (originWeek + 6) % 7 + originWeek / 7;
    NSTimeInterval beforNow = (_nowWeek - 1) * 7 * 24 * 60 * 60 + (date.weekday - 2) * 24 * 60 * 60;
    _startDate = [NSDate dateWithTimeIntervalSinceNow:-beforNow];
}

@end
