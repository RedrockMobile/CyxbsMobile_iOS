//
//  LessonRemindNotification.m
//  MoblieCQUPT_iOS
//
//  Created by hzl on 2016/11/30.
//  Copyright © 2016年 Orange-W. All rights reserved.
//

#import "LessonRemindNotification.h"
#import <UserNotifications/UserNotifications.h>

@interface LessonRemindNotification()

@property (nonatomic, strong) NSMutableArray *weekDateArray;
@property (nonatomic, strong) NSMutableArray *contentArray;
@property (nonatomic, strong) NSMutableArray *identifierArray;

@end

@implementation LessonRemindNotification{
    NSArray *_bigMonthArray;
}

- (NSMutableArray *)identifierArray{
    if (!_identifierArray) {
        _identifierArray = [[NSMutableArray alloc] init];
    }
    return _identifierArray;
}

- (NSMutableArray *)contentArray{
    if (!_contentArray) {
        _contentArray = [[NSMutableArray alloc] init];
    }
    return _contentArray;
}

- (NSMutableArray *)weekDateArray{
    
    if (!_weekDateArray) {
        _weekDateArray = [[NSMutableArray alloc] init];
    }
    return _weekDateArray;
}


- (void)deleteNotification
{
    NSMutableArray *noticeArray = [UserDefaultTool valueWithKey:@"lessonNotification"];
    [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers:noticeArray];
}


- (void)notificationBody
{
    [self newWeekDataArray];
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"明天的课有:";
    NSString *appendStr = [[NSString alloc] init];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.weekDateArray.count; i++) {
        
        array = self.weekDateArray[i];
        
        for (int j = 0; j < array.count; j++ ) {
            appendStr = [appendStr stringByAppendingString:[self tomorrowLessonInfoWithArray:array][j]];
            appendStr = [appendStr stringByAppendingString:[self tomorrowLessonTimeInfoWithArray:array][j]];
            appendStr = [appendStr stringByAppendingString:[self tomorrowClassInfoWithArray:array][j]];
        }
        
        if ([appendStr isEqualToString:@""]) {
            content.body =  @"明天没有课哦";
        }else{
            content.body = appendStr;
        }
        
        [self.contentArray addObject:[content mutableCopy]];
        
        appendStr = @"";
    }
}


- (void)addTomorrowNotificationWithMinute:(NSString *)minute AndHour:(NSString *)hour
{
    [self notificationBody];
    
    NSDateComponents *components = [self calculateNotificationComponents];
    components.hour = hour.integerValue;
    components.minute = minute.integerValue;
    
    //    UNTimeIntervalNotificationTrigger *trigger1 = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];
    
    
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    
    for (int i = 0; i < self.contentArray.count; i++) {
        
        UNCalendarNotificationTrigger *calendarTrigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:NO];
        
        NSString *requestIdentifier = [NSString stringWithFormat:@"tomorrowRequestWithIdentifier%@%ld%ld",content.body,components.month,components.day];
        
        if (![self.identifierArray containsObject:requestIdentifier]) {
            [self.identifierArray addObject:requestIdentifier];
        }
        
        NSMutableArray *noticeArray = [UserDefaultTool valueWithKey:@"lessonNotification"];
        [noticeArray addObjectsFromArray:self.identifierArray];
        [UserDefaultTool saveValue:noticeArray forKey:@"lessonNotification"];
        
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifier content:self.contentArray[i] trigger:calendarTrigger];
        
        
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            NSLog(@"Error:%@",error);
        }];
        
        if (([_bigMonthArray containsObject:[NSString stringWithFormat:@"%ld",components.month]]&&components.month==31)
            || (![_bigMonthArray containsObject:[NSString stringWithFormat:@"%ld",components.month]]&&components.month==30)){
            components.day = 0;
        }
        NSLog(@"------%@-------",components);
        components.day += 1;
    }
}


- (void)newWeekDataArray
{
    NSString *hashDate = [[NSString alloc] init];
    NSString *hashDay = [[NSString alloc] init];
    hashDate = [self weekDayStr];
    
    NSString *nowWeek = [[NSString alloc] initWithFormat:@"%@",[UserDefaultTool valueWithKey:@"nowWeek"]];
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[UserDefaultTool valueWithKey:@"lessonResponse"][@"data"]];
    NSMutableArray *dayArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 6; i++) {
        
        if (hashDate.integerValue == 7) {
            hashDate = @"0";
            nowWeek = [NSString stringWithFormat:@"%ld",nowWeek.integerValue+1];
        }
        
        for (int j = 0; j < array.count; j++) {
            
            hashDay = [NSString stringWithFormat:@"%@",array[j][@"hash_day"]];
            
            if ([hashDay isEqualToString:hashDate]&&[array[j][@"week"] containsObject:[NSNumber numberWithInteger:[nowWeek integerValue]]]) {
                [dayArray addObject:array[j]];
            }
        }
        
        self.weekDateArray[i] = [dayArray mutableCopy];
        [dayArray removeAllObjects];
        hashDate = [NSString stringWithFormat:@"%ld",hashDate.integerValue+1];
    }
}


- (NSMutableArray *)tomorrowClassInfoWithArray:(NSMutableArray *)array
{
    NSString *classInfo = [[NSString alloc] init];
    NSMutableArray *classInfos = [[NSMutableArray alloc] init];
    for (int i = 0; i < array.count; i++) {
        classInfo = [NSString stringWithFormat:@" | %@\n",array[i][@"classroom"]];
        [classInfos addObject:classInfo];
    }
    return classInfos;
}


- (NSMutableArray *)tomorrowLessonInfoWithArray:(NSMutableArray *)array
{
    NSString *lessonInfo = [[NSString alloc] init];
    NSMutableArray *lessonInfos = [[NSMutableArray alloc] init];
    for (int i = 0; i < array.count; i++) {
        lessonInfo = [NSString stringWithFormat:@"%@",array[i][@"course"]];
        [lessonInfos addObject:lessonInfo];
    }
    return lessonInfos;
}


- (NSMutableArray *)tomorrowLessonTimeInfoWithArray:(NSMutableArray *)array
{
    NSString *timeInfo = [[NSString alloc] init];
    NSMutableArray *timeInfos = [[NSMutableArray alloc] init];
    for (int i = 0; i < array.count; i++) {
        timeInfo = [NSString stringWithFormat:@" | 第%@节开始上课",array[i][@"begin_lesson"]];
        [timeInfos addObject:timeInfo];
    }
    return timeInfos;
}


- (NSString *)weekDayStr{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDate *now = [NSDate date];
    calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    comps = [calendar components:unitFlags fromDate:now];
    if (comps.weekday == 7) {
        comps.weekday = 0;
    }else{
        comps.weekday -= 1;
    }
    NSString *nowWeek = [NSString stringWithFormat:@"%ld",(long)[comps weekday]];
    return nowWeek;
}


-(NSDateComponents *)calculateNotificationComponents
{
    _bigMonthArray = [NSArray arrayWithObjects:@"1",@"3",@"5",@"7",@"8",@"10",@"12",nil];
    
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd"];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSUInteger unitFlags = NSCalendarUnitMonth | NSCalendarUnitDay;
    
    NSDateComponents *comp = [gregorian components:unitFlags fromDate:now];
    
    return comp;
}

@end

