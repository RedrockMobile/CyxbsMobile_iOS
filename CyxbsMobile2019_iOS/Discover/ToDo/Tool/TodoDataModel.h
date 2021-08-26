//
//  TodoDataModel.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/8/15.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString* TodoDataModelKey;

static TodoDataModelKey const _Nonnull TodoDataModelKeyMonth = @"TodoDataModelKeyMonth";
static TodoDataModelKey const _Nonnull TodoDataModelKeyDay = @"TodoDataModelKeyDay";

typedef enum : NSUInteger {
    TodoDataModelRepeatModeNO = 0,  //不重复
    TodoDataModelRepeatModeDay,     //每日重复
    TodoDataModelRepeatModeWeek,    //每周重复
    TodoDataModelRepeatModeMonth,   //每月重复
    TodoDataModelRepeatModeYear     //每年重复
} TodoDataModelRepeatMode;

typedef enum : NSUInteger {
    //已完成
    TodoDataModelStateDone,
    //已过期
    TodoDataModelStateOverdue,
    //待完成
    TodoDataModelStateNeedDone,
} TodoDataModelState;

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
@property (nonatomic, copy)NSArray<NSDictionary<TodoDataModelKey, NSString*>*>* dateArr;

/// 每周提醒的星期数。[1, 2, 7]代表周日，周一，周六
@property (nonatomic, copy)NSArray<NSString*>* weekArr;

/// 每月提醒的日期，[1, 2, 3]代表1日、2日、3日
@property (nonatomic, copy)NSArray<NSString*>* dayArr;

/// todo的detail
@property (nonatomic, copy)NSString* detailStr;

/// 具体的提醒时间，格式为@"yyyy年M月d日HH:mm"，如果设置为@""，则表示不提醒
@property (nonatomic, copy)NSString* timeStr;

/// 是否已完成
@property (nonatomic, assign)BOOL isDone;

/// 这个model对应的cell的高度
@property (nonatomic, assign)double cellHeight;

/// todo的状态，待完成、已完成、已过期。
/// 每次读取这个属性时，内部都会根据已有信息进行判断，避免因为时间的变化而导致的状态错误。
/// 同时也会根据状态的更新，而对数据库进行修改。
@property (nonatomic, assign, readonly)TodoDataModelState todoState;

/// 完成的截止日期
@property (nonatomic, readonly)NSString* overdueTimeStr;

/// todo的过期时间（有提醒的情况下，代表提醒时间，无提醒的情况则代表todo需要完成的那一天的23:59:59的时间）
/// 使用这个工具，写UI交互的同学，无需为这个属性赋值，只需在完成todo的各种数据设置后调用resetOverdueTime
/// 为0意味着没有初始化，为-1意味着没有下一次提醒了
@property (nonatomic, assign)long overdueTime;

/// 上一次的过期时间
/// 使用这个工具，写UI交互的同学，无需为这个属性赋值，只需在完成todo的各种数据设置后调用resetOverdueTime
@property (nonatomic, assign)long lastOverdueTime;

- (void)setIsDone:(BOOL)isDone DEPRECATED_MSG_ATTRIBUTE("\n不要使用setIsDone:方法修改isDone标记位，使用setIsDoneForUserActivity:方法 或者 setIsDoneForInnerActivity:方法，后续会将isDone设置成readonly");

/// 由于用户操作时改变isDone标记时，调用这个方法
- (void)setIsDoneForUserActivity:(BOOL)isDone;

/// 由于初始化、修改内部结构而isDone，调用这个方法
- (void)setIsDoneForInnerActivity:(BOOL)isDone;

/// 通过字典完成数据配置
/// @param dict 字典
- (void)setDataWithDict:(NSDictionary*)dict;

/// 获取相应的字典
- (NSDictionary*)getDataDict;

/// 调用后计算过期时间，一般在完成todo的各种数据设置后调用，必须调用。
- (void)resetOverdueTime;

- (NSDate* _Nullable)getTimeStrDate;


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
