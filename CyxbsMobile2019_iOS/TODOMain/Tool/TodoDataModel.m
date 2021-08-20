//
//  TodoDataModel.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/8/15.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "TodoDataModel.h"

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
    switch (self.repeatMode) {
        case TodoDataModelRepeatModeNO:
            
            break;
        case TodoDataModelRepeatModeDay:
            
            break;
        case TodoDataModelRepeatModeWeek:
            
            break;
        case TodoDataModelRepeatModeMonth:
            
            break;
        case TodoDataModelRepeatModeYear:
            
            break;
    }
    return nil;
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
