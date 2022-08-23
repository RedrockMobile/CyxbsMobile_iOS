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

        
        _nowWeek = [NSUserDefaults.standardUserDefaults stringForKey:RisingClassSchedule_nowWeek_String].unsignedLongValue;
        
        _courseAry = NSMutableArray.array;
        [_courseAry addObject:NSMutableArray.array]; // For 0 Section
    }
    return self;
}

#pragma mark - Method

- (void)appendCourse:(ScheduleCourse *)course inWeeks:(nonnull NSArray<NSNumber *> *)weeks{
    if (!course) {
        NSParameterAssert(course);
        return;
    }
    
    NSUInteger count = _courseAry.count;
    
    [NSSet setWithArray:weeks];
    
    [_courseAry[0] addObject:course];
}

- (void)removeCourse:(ScheduleCourse *)course {
    
}

@end
