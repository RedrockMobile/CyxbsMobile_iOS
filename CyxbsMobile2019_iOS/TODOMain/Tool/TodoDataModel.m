//
//  TodoDataModel.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/8/15.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "TodoDataModel.h"
#include <stdlib.h>
#include <stdio.h>

@implementation TodoDataModel
- (instancetype)init {
    self = [super init];
    if (self) {
        //这些初始化，是为了避免数据库因为空值出错
        self.todoIDStr = @"";
        self.titleStr = @"";
        self.repeatMode = TodoDataModelRepeatModeNO;
        self.weekArr = @[];
        self.dayArr = @[];
        self.dateArr = @[];
        self.timeStr = @"";
        self.detailStr = @"";
        self.isDone = NO;
    }
    return self;
}
/*
    {
        "todo_id": 1,
        "title": "这个是todo的标题",
        "remind_mode": {
            "repeat_mode": 0,
            "date": 0,
            "week": 0,
            "day": 0,
            "time":@"12:39"
        },
        "detail": "这里是todo的detail",
        "is_done": 0
    }
 */
- (void)setDataWithDict:(NSDictionary*)dict {
    self.todoIDStr = dict[@"todo_id"];
    self.titleStr = dict[@"title"];
    NSDictionary* remind_mode = dict[@"remind_mode"];
    self.repeatMode = [remind_mode[@"repeat_mode"] longValue];
    self.weekArr = remind_mode[@"week"];
    self.dayArr = remind_mode[@"day"];
    self.dateArr = remind_mode[@"date"];
    self.timeStr = remind_mode[@"time"];
    self.detailStr = dict[@"detail"];
    self.isDone = [dict[@"is_done"] boolValue];
}

- (NSDictionary*)getDataDict {
    return @{
        @"todo_id": self.todoIDStr,
        @"title": self.titleStr,
        @"remind_mode": @{
            @"repeat_mode": @(self.repeatMode),
            @"date": self.dateArr,
            @"week": self.weekArr,
            @"day": self.dayArr,
            @"time": self.timeStr
        },
        @"detail": self.detailStr,
        @"is_done": @(self.isDone)
    };
}
- (NSDateComponents*)getNextRemindTime {
    TodoDataModel* model = self;
    if ([model.timeStr isEqualToString:@""]) {
        return nil;
    }
    NSDate* nowDate = NSDate.now;
    //周秒分时日月年
    NSCalendarUnit unit = (NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday|NSCalendarUnitWeekOfMonth);
    
    NSDateComponents* nowComponents = [[NSCalendar currentCalendar] components:unit fromDate:nowDate];
    NSDate* onceDate = [NSDate dateWithString:model.timeStr format:@"yyyy年M月d日HH:mm"];
    NSDateComponents* onceDateComponents = [[NSCalendar currentCalendar] components:unit fromDate:onceDate];
    NSTimeInterval notiHourMinute = (onceDateComponents.hour*60 + onceDateComponents.minute)*60;
    NSTimeInterval nowHourMinute = (nowComponents.hour*60 + nowComponents.minute)*60;
    NSDateComponents* notiComponents = [[NSDateComponents alloc] init];
    notiComponents.hour = onceDateComponents.hour;
    notiComponents.minute = onceDateComponents.minute;
    
    
    
    switch (model.repeatMode) {
        case TodoDataModelRepeatModeNO:
            break;
        case TodoDataModelRepeatModeDay: {
            NSTimeInterval interval = -nowHourMinute + notiHourMinute;
            if (notiHourMinute<nowHourMinute) {
                //明天
                interval += 86400;
            }
            NSDate* date = [[NSDate alloc] initWithTimeInterval:interval sinceDate:nowDate];
            break;
        }
        case TodoDataModelRepeatModeWeek: {
            NSTimeInterval interval = notiHourMinute - nowHourMinute - ForeignWeekToChinaWeek((int)nowComponents.weekday)*86400;
            NSInteger cnt;
            int* intWeekArr = copySortedChainaIntWeekArr(model.weekArr, &cnt);
            NSDate* date = nil;
            for (int i=0; i<cnt; i++) {
                if ((intWeekArr[i])*86400 > interval ) {
                    date = [[NSDate alloc] initWithTimeInterval:(intWeekArr[i])*86400 + interval sinceDate:nowDate];
                }
            }
            if (date==nil) {
                date = [[NSDate alloc] initWithTimeInterval:intWeekArr[0]*86400 + interval + 86400*7 sinceDate:nowDate];
            }
            free(intWeekArr);
            break;
        }
        case TodoDataModelRepeatModeMonth: {
            NSTimeInterval interval = notiHourMinute - nowHourMinute - nowComponents.day*86400;
            NSInteger cnt;
            NSInteger numberOfDayInThisMonth = [self getNumberOfDaysInMonth:nowDate];
            int* intDayArr = copySortedIntDayArr(model.dayArr, &cnt, numberOfDayInThisMonth);
            NSDate* date = nil;
            for (int i=0; i<cnt; i++) {
                if (intDayArr[i]*86400 > interval) {
                    date = [NSDate dateWithTimeInterval:intDayArr[i]*86400 + interval sinceDate:nowDate];
                }
            }
            NSDateComponents* nextRemindDateComponents = [[NSDateComponents alloc] init];
            NSInteger month = nowComponents.month;
            NSInteger year = nowComponents.year;
            if (date==nil) {
                while (YES) {
                    month++;
                    if (month==13) {
                        year++;
                        month = 1;
                    }
                    if (intDayArr[0] <= [self getNumberOfDaysInYear:year month:month]) {
                        nextRemindDateComponents.year = year;
                        nextRemindDateComponents.month = month;
                        nextRemindDateComponents.day = intDayArr[0];
                        nextRemindDateComponents.hour = notiComponents.hour;
                        nextRemindDateComponents.minute = notiComponents.minute;
                        break;
                    }
                }
                date = [[NSCalendar currentCalendar] dateFromComponents:nextRemindDateComponents];
            }
            free(intDayArr);
            break;
        }
        case TodoDataModelRepeatModeYear:{
            NSDateComponents* startDateComponents = [[NSDateComponents alloc] init];
            NSTimeInterval interval = [nowDate timeIntervalSinceDate:[[NSCalendar currentCalendar] dateFromComponents:startDateComponents]];
            
            break;
        }
    }
    return nil;
}

- (int*)copySortedTimeIntervalOfYearBegain:(NSArray<NSDictionary<TodoDataModelKey,NSString*>*>*) arr {
     
    return nil;
}
/// 获取某一个月的最大天数
- (NSInteger)getNumberOfDaysInMonth:(NSDate*)date {
    NSRange range = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return range.length;
}

/// 获取某一个月的最大天数
- (NSInteger)getNumberOfDaysInYear:(NSInteger)year month:(NSInteger)mont {
    NSDateComponents* com = [[NSDateComponents alloc] init];
    com.year = year;
    com.month = mont;
    NSDate* date = [[NSCalendar currentCalendar] dateFromComponents:com];
    NSRange range = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return range.length;
}

/// 将字符串形式的日数组，转化为int形式的日数组，同时对日的最大值进行限制
/// @param dayStrArr 字符串形式的日数组
/// @param cnt int形式的日数组的大小
/// @param maxDay 日的最大值(可以等)
int* copySortedIntDayArr(NSArray<NSString*>* dayStrArr, NSInteger* cnt, NSInteger maxDay) {
    *cnt = dayStrArr.count;
    int* arr = calloc(*cnt, sizeof(int));
    NSInteger i=0;
    for (NSString* dayStr in dayStrArr) {
        arr[i] = dayStr.intValue;
        i++;
    }
    qsort_b(arr, *cnt, sizeof(int), ^(const void* n1, const void* n2){
        if (*(int*)n1 < *(int*)n2) {
            return -1;
        }else {
            return *(int*)n1 > *(int*)n2;
        }
    });
    i = *cnt - 1;
    while (arr[i] > maxDay) {
        i--;
    }
    *cnt = i + 1;
    return arr;
}
int* copySortedChainaIntWeekArr(NSArray<NSString*>* weekStrArr, NSInteger* cnt) {
    *cnt = weekStrArr.count;
    int* arr = calloc(*cnt, sizeof(int));
    
    int i=0;
    for (NSString* weekStr in weekStrArr) {
        arr[i] = ForeignWeekToChinaWeek(weekStr.intValue);
        i++;
    }
    
    qsort_b(arr, *cnt, sizeof(int), ^(const void* n1, const void* n2){
        if (*(int*)n1 < *(int*)n2) {
            return -1;
        }else {
            return *(int*)n1 > *(int*)n2;
        }
    });
    return arr;
}

//从[1, 2, ... 7]转化为[2, 3, ... 1]
static inline int ChinaWeekToForeignWeek(int week) {
    return week%7+1;
}
//从[2, 3, ... 1]转化为[1, 2, ... 7]
static inline int ForeignWeekToChinaWeek(int week) {
    return (week+5)%7+1;
}

- (long)getNowStamp {
    return (long)[NSDate.now timeIntervalSince1970];
}

//底下重写set方法，是为了避免数据库因为空值出错
- (void)setTodoIDStr:(NSString *)todoIDStr {
    if (todoIDStr==nil) {
        _todoIDStr = @"";
    }else {
        _todoIDStr = todoIDStr;
    }
}

- (void)setTitleStr:(NSString *)titleStr {
    if (titleStr==nil) {
        _titleStr = @"";
    }else {
        _titleStr = titleStr;
    }
}
- (void)setWeekArr:(NSArray<NSString *> *)weekArr {
    if (weekArr==nil) {
        _weekArr = @[];
    }else {
        _weekArr = weekArr;
    }
}
- (void)setDayArr:(NSArray<NSString *> *)dayArr {
    if (dayArr==nil) {
        _dayArr = @[];
    }else {
        _dayArr = dayArr;
    }
}

- (void)setDateArr:(NSArray<NSDictionary *> *)dateArr {
    if (dateArr==nil) {
        _dateArr = @[];
    }else {
        _dateArr = dateArr;
    }
}

- (void)setDetailStr:(NSString *)detailStr {
    if (detailStr==nil) {
        _detailStr = @"";
    }else {
        _detailStr = detailStr;
    }
}

- (void)setTimeStr:(NSString *)timeStr {
    if (timeStr==nil) {
        _timeStr = @"";
    }else {
        _timeStr = timeStr;
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"todoIDStr: %@; title: %@; remind_mode: %ld; date: %@; week: %@; day: %@; timeStr: %@; detail: %@; isDone: %d", self.todoIDStr, self.titleStr, self.repeatMode, self.dateArr, self.weekArr, self.dayArr, self.timeStr, self.detailStr, self.isDone];
}

/*
    {
        "todo_id": 1,
        "title": "这个是todo的标题",
        "remind_mode": {
            "repeat_mode": 0,
            "date": ["02.06", "03.05"],
            "week": [1,2,3,4],
            "day": [1,2,3]
        },
        "detail": "这里是todo的detail",
        "is_done": 0
    }
 */
@end
