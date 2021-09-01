//
//  WeekAndDay.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/8/23.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "WeekAndDay.h"

@implementation WeekAndDay
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:DateFormat];
        NSDate *resDate = [formatter dateFromString:getDateStart_NSString];
        
        // 计算当前是第几周
        NSInteger beginTime=[resDate timeIntervalSince1970];
        NSDate *now = [NSDate date];
        NSInteger nowTime = [now timeIntervalSince1970];
        double day = (float)(nowTime - beginTime)/(float)86400/(float)7;
        NSInteger nowWeek = (int)ceil(day) - 1;
        if(nowWeek < 0 ){
            nowWeek = 0;
        }
        self.weekNumber = [NSString stringWithFormat:@"%ld",(long)nowWeek];
        // 获取当前是星期几
        NSInteger today;
        if ([NSDate date].weekday == 1) {
            today = 7;
        } else {
            today = [NSDate date].weekday - 1;
        }
        NSArray *weekDayArray = @[@"一", @"二", @"三", @"四", @"五", @"六", @"日"];
        self.weekday = [NSString stringWithFormat:@"%@",weekDayArray[today-1]];
        
    }
    return self;
}
+ (instancetype)defaultWeekDay {
    return [[self alloc] init];
}
@end
