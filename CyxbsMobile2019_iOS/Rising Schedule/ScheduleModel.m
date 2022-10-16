//
//  ScheduleModel.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/2.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleModel.h"

#pragma mark - ScheduleModel ()

@interface ScheduleModel ()

/// combine映射表
@property (nonatomic, strong) NSMutableDictionary <NSString *, ScheduleCombineModelStatus *> *statusMap;

@end

#pragma mark - ScheduleModel

@implementation ScheduleModel {
    NSMutableArray <NSMutableArray <NSDictionary <NSValue *, ScheduleCourse *> *> *> *_transDraw;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _statusMap = NSMutableDictionary.dictionary;
        _courseAry = NSMutableArray.array;
        NSMutableURLRequest *request;
    }
    return self;
}

- (void)combineModel:(ScheduleCombineModel *)model {
    for (ScheduleCourse *course in model.courseAry) {
//        NSInteger week = course.inWeek;
        [course.inSections enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, BOOL * __unused stop) {
            NSInteger section = obj.longValue;
            
            for (NSInteger i = _courseAry.count; i <= section; i++) {
                [_courseAry addObject:NSMutableArray.array];
            }
            
            [_courseAry[section] addObject:course];
        }];
    }
}

- (void)_clear {
    
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
