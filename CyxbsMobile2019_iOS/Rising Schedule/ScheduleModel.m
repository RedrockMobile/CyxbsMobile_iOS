//
//  ScheduleModel.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/2.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleModel.h"

#pragma mark - ClassScheduleModel ()

@interface ScheduleModel ()

/// 真正的课表存储
@property (nonatomic, strong) NSMutableArray <NSMutableArray <ScheduleCourse *> *> *model;

@end

#pragma mark - ClassScheduleModel

@implementation ScheduleModel

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _startDate =
        [NSDate dateString:[NSUserDefaults.standardUserDefaults
                            stringForKey:RisingClassSchedule_classBegin_String]
             fromFormatter:NSDateFormatter.defaultFormatter
            withDateFormat:@"yyyy.M.d"];
        
        _nowWeek = [NSUserDefaults.standardUserDefaults stringForKey:RisingClassSchedule_nowWeek_String].unsignedLongValue;
        
        [self model];
    }
    return self;
}

#pragma mark - Private Modthod

- (void)onceSave:(NSDictionary *)object {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 检查日期
        NSString *startDateStr = object[@"version"];
        NSString *nowWeek = object[@"nowWeek"];
        if (startDateStr) {
            // 不为空则直接设置
            [NSUserDefaults.standardUserDefaults setValue:startDateStr forKey:RisingClassSchedule_classBegin_String];
            [NSUserDefaults.standardUserDefaults setValue:nowWeek forKey:RisingClassSchedule_nowWeek_String];
        }
        
        self->_startDate =
        [NSDate dateString:[NSUserDefaults.standardUserDefaults
                            stringForKey:RisingClassSchedule_classBegin_String]
             fromFormatter:NSDateFormatter.defaultFormatter
            withDateFormat:@"yyyy.M.d"];
        self->_nowWeek = [NSUserDefaults.standardUserDefaults
                          stringForKey:RisingClassSchedule_nowWeek_String].longValue;
    });
}

#pragma mark - Method

#pragma mark - Request

#pragma mark - WCDB

- (void)awakeFromWCDB {
//    NSArray <ScheduleCourse *> *ary = [ScheduleCourse aryFromWCDB];
    NSArray <ScheduleCourse *> *ary;
    if (!_model) {
        self.model = nil;
    }
    [self model];
    
    for (ScheduleCourse *lesson in ary) {
        [self.model[lesson.inSection] addObject:lesson];
        /// for (int i = 0; i < lesson.period.lenth; i++) {
        ///     self.a[lesson.inSection][lesson.inWeek][lesson.period.location + i] = TODO
        /// }
    }
}

#pragma mark - Getter

- (NSArray<NSArray<ScheduleCourse *> *> *)courseAry {
    return self.model.copy;
}

- (NSMutableArray<NSMutableArray<ScheduleCourse *> *> *)model {
    if (_model == nil) {
        NSInteger count = 25;
        _model = [NSMutableArray arrayWithCapacity:count];
        for (NSInteger i = 0; i < count; i++) {
            NSMutableArray <ScheduleCourse *> *perAry = NSMutableArray.array;
            [_model addObject:perAry];
        }
    }
    return _model;
}

@end
