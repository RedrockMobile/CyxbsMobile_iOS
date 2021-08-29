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
    self.timeStr = remind_mode[@"notify_datetime"];
    self.detailStr = dict[@"detail"];
    _isDone = [dict[@"is_done"] boolValue];
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
            @"notify_datetime": self.timeStr
        },
        @"detail": self.detailStr,
        @"is_done": @(self.isDone)
    };
}

- (NSDate* _Nullable)getTimeStrDate {
    if ([self.timeStr isEqualToString:@""]) {
        return nil;
    }
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年M月d日HH:mm"];
    return [formatter dateFromString:self.timeStr];
}

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
        state = TodoDataModelStateNeedDone;
        if (self.isDone==YES) {
            _isDone = NO;
            //需要通知数据库刷新todo
            mark += 2;
        }
    }else {
        if (self.isDone) {
            state = TodoDataModelStateDone;
        }else if (self.lastOverdueTime==-1) {
            //代表这是第一次提醒，所以应该是NeedDone
            state = TodoDataModelStateNeedDone;
        }else{
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

- (NSString *)overdueTimeStr {
    if (self.overdueTime==0) {
        [self resetOverdueTime];
    }
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
    self.overdueTime = [TodoDateTool getOverdueTimeStampFrom:(long)[NSDate date].timeIntervalSince1970 inModel:self];
    self.lastOverdueTime = -1;
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
    if (isDone) {
        self.lastOverdueTime = self.overdueTime;
        self.overdueTime = [TodoDateTool getOverdueTimeStampFrom:self.overdueTime inModel:self];
    }else {
        self.overdueTime = self.lastOverdueTime;
        self.lastOverdueTime = -1;
    } 
}

/// 由于初始化、内部结构而改变isDone，调用这个方法
- (void)setIsDoneForInnerActivity:(BOOL)isDone {
    //避免isDone 为非01的情况
    _isDone = !!isDone;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"todoIDStr: %@; title: %@; remind_mode: %ld; date: %@; week: %@; day: %@; timeStr: %@; detail: %@; isDone: %d", self.todoIDStr, self.titleStr, self.repeatMode, self.dateArr, self.weekArr, self.dayArr, self.timeStr, self.detailStr, self.isDone];
}

- (double)cellHeight{
    if (!_cellHeight) {
        //不动高度 + 变化高度（文本框的高度）
            //固定高度
        double fixedHeight = SCREEN_HEIGHT * 0.0899;
//        double fixedHeight = SCREEN_HEIGHT * 0.0449;
            //变化高度
                //标题的高度
        NSDictionary *attr = @{NSFontAttributeName:[UIFont fontWithName:PingFangSCMedium size:18]};
        double dynamicHeight = [self.titleStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH * 0.8266, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size.height;
        if (![self.timeStr isEqualToString:@""]) {
            fixedHeight = SCREEN_HEIGHT * 0.0779;
            dynamicHeight += SCREEN_WIDTH * 0.0269;
        }
        //最后的5是一个保险高度
        _cellHeight = dynamicHeight + fixedHeight + 5;
    }
    return _cellHeight;
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
