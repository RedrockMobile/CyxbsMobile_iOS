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
    NSMutableArray <NSMutableArray <ScheduleCourse *> *> *_courseAry;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self clear];
    }
    return self;
}

- (void)combineModel:(ScheduleCombineModel *)model {
    _statusMap[model.identifier] = model;
    for (ScheduleCourse *course in model.courseAry) {
        [course.inSections enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, BOOL * __unused stop) {
            NSInteger section = obj.longValue;
            for (NSInteger i = _courseAry.count; i <= section; i++) {
                [_courseAry addObject:NSMutableArray.array];
            }
            // TODO: use _statusMap & _sno
            [_courseAry[section] addObject:course];
        }];
        [_courseAry[0] addObject:course];
    }
    self.nowWeek = model.nowWeek;
}

- (void)clear {
    _statusMap = NSMutableDictionary.dictionary;
    _courseAry = NSMutableArray.array;
    [_courseAry addObject:NSMutableArray.array]; // for section 0
}

#pragma mark - Method

- (NSArray<ScheduleCourse *> *)coursesWithCourse:(ScheduleCourse *)course inWeek:(NSInteger)inweek {
    NSMutableArray *ary = NSMutableArray.array;
    for (ScheduleCombineModel *model in _statusMap.allValues) {
        for (ScheduleCourse *acourse in model.courseAry) {
            if ([course isAboveVerticalTimeAs:acourse]) {
                if ([acourse.inSections containsObject:@(inweek)] || inweek == 0)
                [ary addObject:acourse];
            }
        }
    }
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
