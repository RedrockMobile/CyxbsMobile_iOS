//
//  LocalNotiManager.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/8/27.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "LocalNotiManager.h"

@implementation LocalNotiManager

+ (void)setLocalNotiWithWeekNum:(int)weekNum weekDay:(int)weekDay lesson:(int)lesson before:(int)minute titleStr:(NSString*)title subTitleStr:(NSString*_Nullable)subTitleStr bodyStr:(NSString*)body ID:(NSString*)idStr{
    NSDateComponents *component = [self getComponentWithWeekNum:weekNum weekDay:weekDay lesson:lesson before:minute];
    
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:component repeats:NO];
    
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = title;
    content.body = body;
    content.subtitle = subTitleStr;
    [content setSound:[UNNotificationSound defaultSound]];
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:idStr content:content trigger:trigger];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:nil];
}

/// 计算提醒时间
/// @param weekNum 第x周，x属于[1, 24]
/// @param weekDay 星期x
/// @param lesson 第x节大课
/// @param minute 课前x分钟提醒
+ (NSDateComponents*)getComponentWithWeekNum:(int)weekNum weekDay:(int)weekDay lesson:(int)lesson before:(int)minute{
    if(weekNum==0){
        
    }
    NSArray *timeArray = @[@"8:00",@"10:15",@"14:00",@"16:15",@"19:00",@"21:15"];
    
    NSDateComponents *component = [[NSDateComponents alloc] init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-M-d-k:mm"];
    NSDate *itemBegainTime = [formatter dateFromString:[NSString stringWithFormat: @"2020-9-7-%@",timeArray[lesson]]];
    int dayIntervel = (weekNum-1)*7+weekDay;
    
    NSDate *roughNotiTime = [itemBegainTime dateByAddingDays:dayIntervel];
    NSDate *notiTime = [roughNotiTime dateByAddingMinutes:-minute];
    component.year = notiTime.year;
    component.month = notiTime.month;
    component.day = notiTime.day;
    component.hour = notiTime.hour;
    component.minute = notiTime.minute;
    return component;
}
//Sat Sep 12 20:49:00 2020
@end
//@"y":年,
//@"M":月,
//@"d":日,
//@"k":小时（24小时制）,[1, 24]
//@"m:分"
//@"e":周几，2～周一，1~周日，4～周3
//@"c":周几，2～周一，1~周日，4～周3
