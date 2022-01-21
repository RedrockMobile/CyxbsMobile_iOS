//
//  TodoDataModel.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/8/15.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "TodoDataModel.h"
#import "TodoDateTool.h"
#import "TodoSyncTool.h"

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
        _isDone = NO;
    }
    return self;
}
//+ (NSDictionary*)mj_replacedKeyFromPropertyName {
//    return @{
//        @"todoIDStr":@"todo_id",
//    };
//}
/*
 {
     "todo_id": 1,
     "title": "内卷",
     "remind_mode": {
         "repeat_mode": 0,
         "notify_datetime":"",
         "date": [],
         "week": [],
         "day": [],
     },
     "detail": "全栈永远滴神",
     "last_modify_time": 1561561561,
     "is_done": 0
 }
 */
- (void)setDataWithDict:(NSDictionary*)dict {
    self.todoIDStr = dict[@"todo_id"];
    self.titleStr = dict[@"title"];
    NSDictionary* remind_mode = dict[@"remind_mode"];
    self.repeatMode = [remind_mode[@"repeat_mode"] longValue];
    self.lastModifyTime = [dict[@"last_modify_time"] longValue];
    self.timeStr = remind_mode[@"notify_datetime"];
    self.detailStr = dict[@"detail"];
    _isDone = [dict[@"is_done"] boolValue];
    
    self.weekArr = remind_mode[@"week"];
    self.dayArr = remind_mode[@"day"];
    NSMutableArray *dateArr = [[NSMutableArray alloc] init];
    NSArray *tempArr;
    for (NSString *dateStr in remind_mode[@"date"]) {
        tempArr = [dateStr componentsSeparatedByString:@"."];
        [dateArr addObject:@{
            TodoDataModelKeyMonth:@([[tempArr firstObject] intValue]),
            TodoDataModelKeyDay:@([[tempArr lastObject] intValue])
        }];
    }
    self.dateArr = dateArr;
}

- (NSDictionary*)getDataDictToPush {
    NSMutableArray *dateArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in self.dateArr) {
        [dateArr addObject:[NSString stringWithFormat:@"%02d.%02d", [dict[TodoDataModelKeyMonth] intValue], [dict[TodoDataModelKeyDay] intValue]]];
    }
    NSMutableArray *dayArr = [[NSMutableArray alloc] init];
    for (NSString *dayStr in self.dayArr) {
        [dayArr addObject:@(dayStr.intValue)];
    }
    return @{
        @"todo_id": @(self.todoIDStr.longValue),
        @"title": self.titleStr,
        @"remind_mode": @{
            @"repeat_mode": @((int)self.repeatMode),
            @"date": dateArr,
            @"week": [self foreignWeekToChinaWeek:self.weekArr],
            @"day": dayArr,
            @"notify_datetime": self.timeStr
        },
        @"detail": self.detailStr,
        @"last_modify_time":@(self.lastModifyTime),
        @"is_done": @((int)self.isDone)
    };
}
//从[1, 2, ... 7]转化为[2, 3, ... 1]
static inline int ChinaWeekToForeignWeek(int week) {
    return week%7+1;
}
//从[2, 3, ... 1]转化为[1, 2, ... 7]
static inline int ForeignWeekToChinaWeek(int week) {
    return (week+5)%7+1;
}
- (NSArray*)foreignWeekToChinaWeek:(NSArray<NSString*>*) arr {
    NSMutableArray* resultArr = [NSMutableArray arrayWithCapacity:4];
    for (NSString* weekStr in arr) {
        [resultArr addObject:@(ForeignWeekToChinaWeek(weekStr.intValue))];
    }
    return resultArr;
}

- (NSDate* _Nullable)getTimeStrDate {
    if ([self.timeStr isEqualToString:@""]) {
        return nil;
    }
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年M月d日HH:mm"];
    return [formatter dateFromString:self.timeStr];
}
/*
 
 维护：overdueTime 指向未来
 
 如果 overdueTime = -1 意味着未来没有提醒了，也就是说重复模式为不重复，
 如果有一次提醒，那么这次提醒指向过去，
 或者没有设置提醒
 
 overdueTime 的分类：
 指向今天的未来、指向非今天的未来、-1
 
 isDone的分类：
 0、1
 
 
 
 已完成、待完成、已过期
 
 已完成：overdueTime 指向
 
 */

//MARK: - 重写的getter
- (TodoDataModelState)todoState {
    TodoDataModelState state;
    [self refreshOverdueTime];
    if (self.overdueTime==-1) {
        if (self.isDone) {
            return TodoDataModelStateDone;
        }else {
            return TodoDataModelStateOverdue;
        }
    }
        
    NSDate* remindDate = [NSDate dateWithTimeIntervalSince1970:self.overdueTime];
    if ([remindDate isToday]) {
        //remindDate指向今天的未来
        state = TodoDataModelStateNeedDone;
        if (self.isDone==YES) {
            [self setIsDoneForInnerActivity:NO];
        }
    }else {
        //remindDate指向非今天的未来
        if (self.isDone) {
            state = TodoDataModelStateDone;
        }else if (self.lastOverdueTime==-1) {
            //代表这是第一次提醒，所以应该是NeedDone
            state = TodoDataModelStateNeedDone;
        }else {
            state = TodoDataModelStateOverdue;
        }
    }
    
    //通知数据库刷新todo
    [[TodoSyncTool share] alterTodoWithModel:self needRecord:NO];
    return state;
}

/// 维护overdueTime
/// 如果overdueTime为-1或者指向未来，则什么都不做。
/// overdueTime指向过去，将lastOverdueTime更新为 overdueTime
/// 则将overdueTime更新为下一次提醒的时间
/// 将isDone置为NO
- (void)refreshOverdueTime {
    if (self.overdueTime > [NSDate date].timeIntervalSince1970 || self.overdueTime==-1) {
        return;
    }
    self.lastOverdueTime = self.overdueTime;
    self.overdueTime = [TodoDateTool getOverdueTimeStampFrom:self.overdueTime inModel:self];
    [self setIsDoneForInnerActivity:NO];
}

- (NSString *)overdueTimeStr {
    [self resetOverdueTime];
    NSString* str;
    if (self.overdueTime==-1) {
        str = @"";
    }else {
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy年M月d日HH:mm"];
        str = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.overdueTime]];
    }
    return str;
}

- (void)resetOverdueTime {
    if (self.overdueTime < 1) {
    self.overdueTime = [TodoDateTool getOverdueTimeStampFrom:(long)[NSDate date].timeIntervalSince1970 inModel:self];
    self.lastOverdueTime = -1;
    }
}
//MARK: - 底下重写setter方法，是为了避免数据库因为空值出错
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

/// 由于用户操作时改变isDone标记时，调用这个方法
- (void)setIsDoneForUserActivity:(BOOL)isDone {
    //避免isDone 为非01的情况
    isDone = !!isDone;
    if (isDone==_isDone) {
        return;
    }
    _isDone = isDone;
    [self debugLog];
    
    if (isDone) {
        self.lastOverdueTime = self.overdueTime;
        self.overdueTime = [TodoDateTool getOverdueTimeStampFrom:self.overdueTime inModel:self];
    }else {
        self.overdueTime = self.lastOverdueTime;
        self.lastOverdueTime = -1;
    }
    [self debugLog];
    
}

- (void)debugLog {
    CCLog(@"%@, %@", [self timeStampToTimeStr:self.overdueTime], [self timeStampToTimeStr:self.lastOverdueTime]);
}
- (NSString*)timeStampToTimeStr:(NSInteger)t {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:t];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-DD HH:mm";
//    NSDateComponents *comp = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:date];
    return [format stringFromDate:date];
}

/// 由于初始化、内部结构而改变isDone，调用这个方法
- (void)setIsDoneForInnerActivity:(BOOL)isDone {
    //避免isDone 为非01的情况
    _isDone = !!isDone;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", self.mj_keyValues];
}

- (double)cellHeight{
    if (!_cellHeight) {
        //不动高度 + 变化高度（文本框的高度）
            //固定高度
//        double fixedHeight = SCREEN_HEIGHT * 0.0899;
//        double fixedHeight = SCREEN_HEIGHT * 0.0492;
        double fixedHeight = 40;
            //变化高度
                //标题的高度
        NSDictionary *attr = @{NSFontAttributeName:[UIFont fontWithName:PingFangSCMedium size:18]};
        double dynamicHeight = [self.titleStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH * 0.8266, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size.height;
        if (![self.timeStr isEqualToString:@""]) {
//            fixedHeight = SCREEN_HEIGHT * 0.0779;
            fixedHeight -= 10;
            dynamicHeight += [self.timeStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH * 0.8266, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont fontWithName:PingFangSCMedium size:13]} context:nil].size.height;
        }
        //最后的5是一个保险高度
        _cellHeight = dynamicHeight + fixedHeight + 5;
    }
    return _cellHeight;
}
/*
 {
     "todo_id": 1,
     "title": "内卷",
     "remind_mode": {
         "repeat_mode": 0,
         "notify_datetime":"",
         "date": [],
         "week": [],
         "day": [],
     },
     "detail": "全栈永远滴神",
     "last_modify_time": 1561561561,
     "is_done": 0
 }
 */
@end

/*
 
 //MARK: - 重写的getter
 - (TodoDataModelState)todoState {
     TodoDataModelState state;
     
     int mark = 0;
     if (self.overdueTime < [NSDate date].timeIntervalSince1970&&self.overdueTime!=-1) {
         self.lastOverdueTime = self.overdueTime;
             self.overdueTime = [TodoDateTool getOverdueTimeStampFrom:self.overdueTime inModel:self];
             //需要通知数据库刷新todo
             mark += 1;
     }
     
     NSDate* remindDate = [NSDate dateWithTimeIntervalSince1970:self.overdueTime];
     if ([remindDate isToday]) {
         //remindDate指向今天的未来
         state = TodoDataModelStateNeedDone;
         if (self.isDone==YES) {
             _isDone = NO;
             //需要通知数据库刷新todo
             mark += 2;
         }
     }else {
         //remindDate指向非今天的未来
         if (self.isDone) {
             state = TodoDataModelStateDone;
         }else if (self.lastOverdueTime==-1) {
             //代表这是第一次提醒，所以应该是NeedDone
             state = TodoDataModelStateNeedDone;
         }else {
             state = TodoDataModelStateOverdue;
         }
     }
     //通知数据库刷新todo
     if (mark>=2) {
         //mark>=2，代表isDone标记为发生了变化，那么需要记录变化（也就是这次改变是需要和服务器同步的）
         [[TodoSyncTool share] alterTodoWithModel:self needRecord:YES];
     }else if (mark==1) {
         [[TodoSyncTool share] alterTodoWithModel:self needRecord:NO];
     }
     return state;
 }
 */
