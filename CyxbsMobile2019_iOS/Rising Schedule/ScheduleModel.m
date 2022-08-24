//
//  ScheduleModel.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/2.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleModel.h"

#pragma mark - ScheduleModel

@implementation ScheduleModel

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self) {
        _startDate =
        [NSDate dateWithString:[NSUserDefaults.standardUserDefaults stringForKey:RisingClassSchedule_classBegin_String] format:@"yyyy.M.d"];
        
        _nowWeek = [NSUserDefaults.standardUserDefaults stringForKey:RisingClassSchedule_nowWeek_Integer].unsignedLongValue;
        
        _courseAry = NSMutableArray.array;
        [_courseAry addObject:NSMutableArray.array]; // For 0 Section
    }
    return self;
}

#pragma mark - Method

- (void)appendCourse:(ScheduleCourse *)course {
    if (!course) {
        NSParameterAssert(course);
        return;
    }
    
    [course.inSections enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, BOOL * __unused stop) {
        NSUInteger section = obj.unsignedLongValue;
        
        for (NSUInteger i = _courseAry.count; i <= section; i++) {
            [_courseAry addObject:NSMutableArray.array];
        }
        
        [_courseAry[section] addObject:course];
    }];
    
    [_courseAry[0] addObject:course];
}

- (void)removeCourse:(ScheduleCourse *)course {
    if (!course) {
        NSParameterAssert(course);
        return;
    }
    
    [course.inSections enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, BOOL * __unused stop) {
        NSUInteger section = obj.unsignedLongValue;
        
        [_courseAry[section] removeObject:course];
    }];
    
    [_courseAry[0] removeObject:course];
}

#pragma mark - Setter

- (void)setNowWeek:(NSUInteger)nowWeek {
    if (_nowWeek == nowWeek) {
        return;
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _nowWeek = nowWeek;
        
        [NSUserDefaults.standardUserDefaults setInteger:_nowWeek forKey:RisingClassSchedule_nowWeek_Integer];
    });
}

@end
