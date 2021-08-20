//
//  TodoDataModel.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/8/15.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSString* const _Nonnull TodoDataModelKeyMonth = @"TodoDataModelKeyMonth";
static NSString* const _Nonnull TodoDataModelKeyDay = @"TodoDataModelKeyDay";

typedef enum : NSUInteger {
    TodoDataModelRepeatModeNO = 0,  //不重复
    TodoDataModelRepeatModeDay,     //每日重复
    TodoDataModelRepeatModeWeek,    //每周重复
    TodoDataModelRepeatModeMonth,   //每月重复
    TodoDataModelRepeatModeYear     //每年重复
} TodoDataModelRepeatMode;

@interface TodoDataModel : NSObject

/// todo的ID，创建时的时间戳
@property (nonatomic, copy)NSString* todoIDStr;

/// todo的标题
@property (nonatomic, copy)NSString* titleStr;

/// todo的重复模式，枚举
@property (nonatomic, assign)TodoDataModelRepeatMode repeatMode;

/// 每年提醒的日期，[
///     @{
///         TodoDataModelKeyMonth:@"2",
///         TodoDataModelKeyDay:@"6"
///     }
/// ] 代表2月6日，TodoDataModelKeyMonth是定义好的NSString常量，详见TodoDataModel.h的最上方。
@property (nonatomic, copy)NSArray<NSDictionary*>* dateArr;

/// 每周提醒的星期数。[1, 2, 7]代表周日，周一，周六
@property (nonatomic, copy)NSArray<NSString*>* weekArr;

/// 每月提醒的日期，[1, 2, 3]代表1日、2日、3日
@property (nonatomic, copy)NSArray<NSString*>* dayArr;

/// todo的detail
@property (nonatomic, copy)NSString* detailStr;

/// 具体的提醒时间
@property (nonatomic, copy)NSString* timeStr;

/// 是否已完成
@property (nonatomic, assign)BOOL isDone;

- (void)setDataWithDict:(NSDictionary*)dict;
- (NSDictionary*)getDataDict;
- (long)getNowStamp;
- (NSDateComponents*)getNextRemindTime;
@end

NS_ASSUME_NONNULL_END


/*
 model.todoIDStr = <#dict[@"todo_id"]#>;
 model.titleStr = <#dict[@"todo_id"]#>;
 model.repeatMode = <#dict[@"todo_id"]#>;
 model.weekArr = <#dict[@"todo_id"]#>;
 model.dayArr = <#dict[@"todo_id"]#>;
 model.dateArr = <#dict[@"todo_id"]#>;
 model.timeStr = <#dict[@"todo_id"]#>;
 model.detailStr = <#dict[@"todo_id"]#>;
 model.isDone = <#dict[@"todo_id"]#>;
 */

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
