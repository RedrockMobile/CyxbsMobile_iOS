//
//  LocalNotiManager.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/8/27.
//  Copyright © 2020 Redrock. All rights reserved.
//用来添加本地通知的一个工具类

#import "LocalNotiManager.h"

@implementation LocalNotiManager

+ (void)setLocalNotiWithWeekNum:(int)weekNum weekDay:(int)weekDay lesson:(int)lesson before:(int)minute titleStr:(NSString*)title subTitleStr:(NSString*_Nullable)subTitleStr bodyStr:(NSString*)body ID:(NSString*)idStr{
    //获取component，component的作用是告诉UNNotificationRequest在什么时候通知
    NSDateComponents *component = [self getComponentWithWeekNum:weekNum weekDay:weekDay lesson:lesson before:minute];
    
    //trigger有好几种，定时、延时、定地点、通知。。这里是定时通知型，不重复
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:component repeats:NO];
    
    //content的作用是设置通知标题、子标题等
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = title;
    content.body = body;
    content.subtitle = subTitleStr;
    [content setSound:[UNNotificationSound defaultSound]];
    
    //创建request，还需要一个IDString
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:idStr content:content trigger:trigger];
    
    //[UNUserNotificationCenter currentNotificationCenter]是单例
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:nil];
}

/// 计算提醒时间
/// @param weekNum 第x周，x属于[1, 24]
/// @param weekDay 星期x
/// @param lesson 第x节大课
/// @param minute 课前x分钟提醒
+ (NSDateComponents*)getComponentWithWeekNum:(int)weekNum weekDay:(int)weekDay lesson:(int)lesson before:(int)minute{
    
    NSArray *timeArray = @[@"8:00",@"10:15",@"14:00",@"16:15",@"19:00",@"20:50"];
    NSDateComponents *component = [[NSDateComponents alloc] init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-M-d-k:mm"];
    NSDate *itemBegainTime = [formatter dateFromString:[NSString stringWithFormat: @"2020-9-7-%@",timeArray[lesson]]];
    int dayIntervel = (weekNum-1)*7+weekDay;
    
    NSDate *roughNotiTime = [itemBegainTime dateByAddingDays:dayIntervel];
    //得到提醒时间
    NSDate *notiTime = [roughNotiTime dateByAddingMinutes:-minute];
    
    //设置component
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
