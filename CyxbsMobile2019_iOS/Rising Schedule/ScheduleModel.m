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
        [self clear];
    }
    return self;
}

- (void)combineModel:(ScheduleCombineModel *)model {
   
}

- (void)clear {
    _statusMap = NSMutableDictionary.dictionary;
    _courseAry = NSMutableArray.array;
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

- (NSComparisonResult)compareResultOfCourse:(ScheduleCourse *)aCourse {
    if (!_sno || ![_sno isEqualToString:@""]) {
        return NSOrderedSame;
    }
    if (![aCourse.sno isEqualToString:_sno]) {
        return NSOrderedAscending;
    }
    if ([aCourse.requestType isEqualToString:ScheduleModelRequestStudent]) {
        return NSOrderedDescending;
    }
    return NSOrderedSame;
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

- (ScheduleCourse *)nowCourse {
    if (self.nowWeek >= self.courseAry.count) {
        return nil;
    }
    NSArray <ScheduleCourse *> *ary = self.courseAry[self.nowWeek];
    
    
    NSDate *date = NSDate.date;
    NSInteger weekday = NSDate.date.weekday - 1;
    weekday = weekday ? weekday : 7;
    
    
    return nil;
}

@end
