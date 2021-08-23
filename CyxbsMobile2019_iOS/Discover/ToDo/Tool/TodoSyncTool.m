//
//  TodoSyncTool.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/8/15.
//  Copyright © 2021 Redrock. All rights reserved.
//
//  好长的数据处理代码，S.H.I.T
//

#import "TodoSyncTool.h"
#import <AFNetworkReachabilityManager.h>

//同步完成后的方式的通知名，通知的object有下面3种，分别代表成功、失败、冲突
NSNotificationName const TodoSyncToolSyncNotification = @"TodoSyncToolSyncNotification";
NSString* const TodoSyncToolSyncNotificationSuccess = @"TodoSyncToolSyncNotificationSuccess";
NSString* const TodoSyncToolSyncNotificationFailure = @"TodoSyncToolSyncNotificationFailure";
NSString* const TodoSyncToolSyncNotificationConflict = @"TodoSyncToolSyncNotificationConflict";

//用来从缓存获取上次同步的时间戳
NSString* const TodoSyncToolKeyLastSyncTimeStamp = @"TodoSyncToolKeyLastSyncTimeStamp";
//用来从缓存获取是否修改过
NSString* const TodoSyncToolKeyIsModified = @"TodoSyncToolKeyIsModified";


//数据库路径
#define TODO_DBPATH [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/todoDatabase"]
//将s转为C字符串
#define STRING(s) #s
//将s转为OC字符串
#define OSTRING(s) [NSString stringWithUTF8String:STRING(s)]


@interface TodoSyncTool()
/// 数据库对象
@property(nonatomic, strong)FMDatabase* db;

/// 是否需要同步(是否需要推送数据给服务器)
@property(nonatomic, assign, readonly)BOOL needSynchronize;

/// 是否修改过(任何的增删改操作都会使这个标记为变成YES)
@property(nonatomic, assign)BOOL isModified;

/// 上次和服务器同步的时间
@property(nonatomic, assign)long lastSyncTimeStamp;

@property(nonatomic, assign, readonly) AFNetworkReachabilityStatus netWorkStatus;
@end

//生产环境：https://be-prod.redrock.cqupt.edu.cn/magipoke-todo
//测试环境：https://be-dev.redrock.cqupt.edu.cn/magipoke-todo
@implementation TodoSyncTool
static TodoSyncTool* _instance;

//MARK: +++++++++++++++++++++数据同步的代码++++++++++++++++++++++++++++
/// 调用后触发同步
- (void)syncData {
    if (self.netWorkStatus!=AFNetworkReachabilityStatusReachableViaWWAN
        &&self.netWorkStatus!=AFNetworkReachabilityStatusReachableViaWiFi) {
        [[NSNotificationCenter defaultCenter] postNotificationName:TodoSyncToolSyncNotification object:TodoSyncToolSyncNotificationFailure];
        return;
    }
    //获取上次同步时间
    [[HttpClient defaultClient] requestWithPath:@"https://be-dev.redrock.cqupt.edu.cn/magipoke-todo/sync-time" method:HttpRequestGet parameters:nil prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        CCLog(@"%@",responseObject);
        if (![responseObject[@"info"] isEqualToString:@"success"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:TodoSyncToolSyncNotification object:TodoSyncToolSyncNotificationFailure];
            return;
        }
        long syncTime = [responseObject[@"data"][@"sync_time"] longValue];
        if (syncTime!=self.lastSyncTimeStamp) {
            //时间不相等，代表需要下载数据
            if (self.needSynchronize) {
                //冲突(即使本地只是新增，也应当视为冲突)，提示用户进行取舍
                [[NSNotificationCenter defaultCenter] postNotificationName:TodoSyncToolSyncNotification object:TodoSyncToolSyncNotificationConflict];
            }else {
                if (self.lastSyncTimeStamp==0) {
                    //第一次下载数据，然后合并数据（并且不记录修改）
                    [self fistDownload];
                }else{
                    //需要下载数据，然后合并数据（并且不记录修改）
                    [self downloadDataAndMerge];
                }
            }
        }else if (self.needSynchronize) {
            if (syncTime==0) {
                //服务器没有数据，进行首次推送
                [self firstPush];
            }else {
                //需要同步，把离线时的增删该数据推送上去
                [self pushModifiedData];
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        CCLog(@"%@",error);
        [[NSNotificationCenter defaultCenter] postNotificationName:TodoSyncToolSyncNotification object:TodoSyncToolSyncNotificationFailure];
    }];
}

- (void)fistDownload {
    [[HttpClient defaultClient] requestWithPath:@"https://be-dev.redrock.cqupt.edu.cn/magipoke-todo/list" method:HttpRequestGet parameters:nil prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (![responseObject[@"info"] isEqualToString:@"success"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:TodoSyncToolSyncNotification object:TodoSyncToolSyncNotificationFailure];
            return;
        }
        
        NSDictionary* dataDitc = responseObject[@"data"];
        //增加的序列
        NSArray* changeArr = dataDitc[@"changed_todo_array"];
        TodoDataModel* model = [[TodoDataModel alloc] init];
        for (NSDictionary* todoDict in changeArr) {
            [model setDataWithDict:todoDict];
            [self saveTodoWithModel:model needRecord:NO];
        }
        self.lastSyncTimeStamp = [dataDitc[@"sync_time"] longValue];
        [[NSNotificationCenter defaultCenter] postNotificationName:TodoSyncToolSyncNotification object:TodoSyncToolSyncNotificationSuccess];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:TodoSyncToolSyncNotification object:TodoSyncToolSyncNotificationFailure];
    }];
}

//调用的前提是没有冲突
- (void)downloadDataAndMerge {
    [[HttpClient defaultClient] requestWithPath:@"https://be-dev.redrock.cqupt.edu.cn/magipoke-todo/todos" method:HttpRequestGet parameters:@{@"sync_time":@(self.lastSyncTimeStamp)} prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (![responseObject[@"info"] isEqualToString:@"success"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:TodoSyncToolSyncNotification object:TodoSyncToolSyncNotificationFailure];
            return;
        }
        NSDictionary* dataDitc = responseObject[@"data"];
        //被删除的序列
        NSArray* deleteArr = dataDitc[@"del_todo_array"];
        //修改序列和增加的序列
        NSArray* changeArr = dataDitc[@"changed_todo_array"];
        for (NSString* todoIDStr in deleteArr) {
            [self deleteTodoWithTodoID:todoIDStr needRecord:NO];
        }
        TodoDataModel* model = [[TodoDataModel alloc] init];
        for (NSDictionary* todoDict in changeArr) {
            [model setDataWithDict:todoDict];
            if ([self isTodoID:model.todoIDStr existsInTable:@"todoTable"]) {
                [self alterTodoWithModel:model needRecord:NO];
            }else {
                [self saveTodoWithModel:model needRecord:NO];
            }
        }
        self.lastSyncTimeStamp = [dataDitc[@"sync_time"] longValue];
        [[NSNotificationCenter defaultCenter] postNotificationName:TodoSyncToolSyncNotification object:TodoSyncToolSyncNotificationSuccess];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:TodoSyncToolSyncNotification object:TodoSyncToolSyncNotificationFailure];
    }];
}

/// 从本地记录修改的逻辑来说，第一次推送修改时，推送的数据必定只有新增事项，所以，不必再调用删除事项的接口
- (void)firstPush {
    NSDictionary* paramDict = @{
        @"data":[self getAddAndAlterDataToPush],
        @"sync_time":@"0",
        @"first_push":@"1"
    };
    [[HttpClient defaultClient] requestWithPath:@"https://be-dev.redrock.cqupt.edu.cn/magipoke-todo/batch-create" method:HttpRequestPost parameters:paramDict prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString* state = responseObject[@"info"];
        if ([state isEqualToString:@"success"]) {
            self.lastSyncTimeStamp = [responseObject[@"data"][@"sync_time"] longValue];
            [self cleanRecordForTable:@"addTodoIDTable"];
            [self cleanRecordForTable:@"alterTodoIDTable"];
            [[NSNotificationCenter defaultCenter] postNotificationName:TodoSyncToolSyncNotification object:TodoSyncToolSyncNotificationSuccess];
        }else if ([state hasPrefix:@"data"]){
            //"data conflict, and does not indicate to override"
            [[NSNotificationCenter defaultCenter] postNotificationName:TodoSyncToolSyncNotification object:TodoSyncToolSyncNotificationConflict];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:TodoSyncToolSyncNotification object:TodoSyncToolSyncNotificationFailure];
    }];
}

/// 推送新增和修改的数据
- (void)pushModifiedData {
    //在子线程作网络请求，因为有阻塞线程的操作。为什么要使用有阻塞线程的操作？因为看起来优雅一些。
    //为什么不同时进行这两个网络请求？因为会由于时序问题导致self.lastSyncTimeStamp和服务器不一样，而被服务器视为冲突。
    dispatch_queue_t que = dispatch_queue_create("TodoPushModifiedDataQue", DISPATCH_QUEUE_CONCURRENT);
    //使用信号量来化异步为同步
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    //记录网络请求成功的个数
    __block int mark = 0;
    
    dispatch_async(que, ^{
        NSDictionary* paramDict;
        paramDict = @{
            @"data":[self getAddAndAlterDataToPush],
            @"sync_time":@(self.lastSyncTimeStamp),
        };
        [[HttpClient defaultClient] requestWithPath:@"https://be-dev.redrock.cqupt.edu.cn/magipoke-todo/batch-create" method:HttpRequestPost parameters:paramDict prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            NSString* state = responseObject[@"info"];
            if ([state isEqualToString:@"success"]) {
                self.lastSyncTimeStamp = [responseObject[@"data"][@"sync_time"] longValue];
                [self cleanRecordForTable:@"addTodoIDTable"];
                [self cleanRecordForTable:@"alterTodoIDTable"];
                mark |= 0b1;
            }else if ([state hasPrefix:@"data"]){
                mark |= 0b100;
                //"data conflict, and does not indicate to override"
            }else if ([state hasPrefix:@"the"]){
                //"the sync_time does not exist"
                mark |= 0b1000;
            }else if([state hasPrefix:@"unknown"]) {
                //"unknown error"
                mark |= 0b10000;
            }
            dispatch_semaphore_signal(sema);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            dispatch_semaphore_signal(sema);
        }];
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
        paramDict = @{
            @"del_todo_array": [self getDeleteDataToPush],
            @"sync_time": @(self.lastSyncTimeStamp),
            @"force": @1
        };
        [[HttpClient defaultClient] requestWithPath:@"https://be-dev.redrock.cqupt.edu.cn/magipoke-todo/todos" method:HttpRequestDelete parameters:paramDict prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            NSString* state = responseObject[@"info"];
            if ([state isEqualToString:@"success"]) {
                self.lastSyncTimeStamp = [responseObject[@"data"][@"sync_time"] longValue];
                [self cleanRecordForTable:@"deleteTodoIDTable"];
                mark |= 0b10;
            }else if ([state hasPrefix:@"data"]){
                //"data conflict, and does not indicate to override"
                mark |= 0b100;
            }else if ([state hasPrefix:@"the"]){
                //"the sync_time does not exist"
                mark |= 0b1000;
            }else if ([state hasPrefix:@"unknown"]) {
                //"unknown error"
                mark |= 0b10000;
            }
            dispatch_semaphore_signal(sema);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            dispatch_semaphore_signal(sema);
        }];
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    });
        
    dispatch_barrier_async(que, ^{
        if (mark==0b11) {
            //成功
            self.isModified = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:TodoSyncToolSyncNotification object:TodoSyncToolSyncNotificationSuccess];
        }else if (mark==(mark|0b100)) {
            //冲突
            [[NSNotificationCenter defaultCenter] postNotificationName:TodoSyncToolSyncNotification object:TodoSyncToolSyncNotificationConflict];
        }else if (mark==(mark|0b1000)){
            //服务器没有数据
            CCLog(@"服务器还没有同步时间，请使用firstPush方法");
            [[NSNotificationCenter defaultCenter] postNotificationName:TodoSyncToolSyncNotification object:TodoSyncToolSyncNotificationFailure];
        }else {
            [[NSNotificationCenter defaultCenter] postNotificationName:TodoSyncToolSyncNotification object:TodoSyncToolSyncNotificationFailure];
        }
    });
}

/// 推送数据到服务器成功后调用，用来清除记录
- (void)cleanRecordForTable:(NSString*)tableName {
    NSString* code = OSTRING(
                             DELETE FROM tableName
                             );
    code = [code stringByReplacingOccurrencesOfString:@"tableName" withString:tableName];
    [self.db executeUpdate:code];
}

/// 收到网络状态改变的通知时调用，发送通知的代码在AppDelegate
- (void)netWorkStateChanges:(NSNotification*)noti {
    AFNetworkReachabilityStatus status = [noti.object longValue];
    switch (status) {
        case AFNetworkReachabilityStatusReachableViaWWAN:
        case AFNetworkReachabilityStatusReachableViaWiFi:
            [self syncData];
            break;
        default:
            break;
    }
}

//MARK: +++++++++++++++重写的 geter/setter 方法++++++++++++++++++++++
/// 是否需要推送数据给服务器
- (BOOL)needSynchronize {
    //修改过，不代表需要同步，因为用户可能在离线时增加一个事项，再删除同一个事项，此时是不需要同步的。
    //isModified==YES是同步的必要条件，三个记录ID的表是否存在元组是同步的充分必要条件。
    if (self.isModified==NO) {
        return NO;
    }else {
        NSArray* tableNameArr = @[@"addTodoIDTable", @"alterTodoIDTable", @"deleteTodoIDTable"];
        for (NSString* tableName in tableNameArr) {
            if ([self getTupleCntOfTable:tableName]!=0) {
                return YES;
            }
        }
    }
    return NO;
}

/// 网络状态
- (AFNetworkReachabilityStatus)netWorkStatus {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"AFNetworkReachabilityStatus"];
}

- (void)setLastSyncTimeStamp:(long)lastSyncTimeStamp {
    _lastSyncTimeStamp = lastSyncTimeStamp;
    [[NSUserDefaults standardUserDefaults] setInteger:lastSyncTimeStamp forKey:TodoSyncToolKeyLastSyncTimeStamp];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setIsModified:(BOOL)isModified {
    _isModified = isModified;
    [[NSUserDefaults standardUserDefaults] setBool:isModified forKey:TodoSyncToolKeyIsModified];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//MARK: +++++++++++++++++++++增删改查++++++++++++++++++++++++++++
/// 获取全部事项的结果集
- (FMResultSet*)getAllTodoResultSet {
    NSString* code = OSTRING(
                             SLECT * FROM TodoTable
                             );
    FMResultSet* resultSet = [self.db executeQuery:code];
    return resultSet;
}
/// 将结果集转化为模型
- (TodoDataModel*)resultSetToDataModel:(FMResultSet*)resultSet {
    TodoDataModel* model = [[TodoDataModel alloc] init];
    NSString* code;
    
    model.todoIDStr = [resultSet stringForColumn:@"todo_id"];
    model.titleStr = [resultSet stringForColumn:@"title"];
    model.detailStr = [resultSet stringForColumn:@"detail"];
    model.isDone = [resultSet boolForColumn:@"is_done"];
    
    code = OSTRING(
                   SELECT *
                       FROM remindModeTable
                       WHERE todo_id = ?
                   );
    FMResultSet* subSet = [self.db executeQuery:code withArgumentsInArray:@[model.todoIDStr]];
    if ([subSet next]) {
        model.repeatMode = [subSet longForColumn:@"repeat_mode"];
        model.timeStr = [subSet stringForColumn:@"time"];
        switch (model.repeatMode) {
            case TodoDataModelRepeatModeWeek:
                model.weekArr = [self weekStrToWeekArr:[subSet stringForColumn:@"week"]];
                break;
            case TodoDataModelRepeatModeMonth:
                model.dayArr = [self dayStrToDayArr:[subSet stringForColumn:@"day"]];
                break;
            case TodoDataModelRepeatModeYear:
                model.dateArr = [self dateStrToDateArr:[subSet stringForColumn:@"date"]];
                break;
            default:
                break;
        }
    }
    /*
     todo_id TEXT,
     title TEXT,
     detail TEXT,
     is_done INTEGER,
     
     
     id text
     repeat_mode INTEGER,
     week TEXT,
     day TEXT,
     date TEXT,
     
     */
    return model;
}

/// 保存事项数据，由于用户的操作而调用时is填YES，内部合并数据时is填NO
- (void)saveTodoWithModel:(TodoDataModel*)model needRecord:(BOOL)is {
    NSString* code;
    code = OSTRING(
                   INSERT INTO todoTable
                       VALUES
                        (?, ?, ?, ?)
                   );
    [self.db executeUpdate:code withArgumentsInArray:@[model.todoIDStr, model.titleStr, model.detailStr, @(model.isDone)]];
    
    code = OSTRING(
                   INSERT INTO remindModeTable(todo_id, repeat_mode, week, day, date, time)
                       VALUES
                        (?, ?, ?, ?, ?, ?)
                   );
    [self.db executeUpdate:code withArgumentsInArray:@[model.todoIDStr, @(model.repeatMode), [self weekArrToWeekStr:model.weekArr], [self dayArrToDayStr:model.dayArr], [self dateArrToDateStr:model.dateArr], model.timeStr]];
    
    //记录修改
    if (is) {
        [self recordAddWithTodoID:model.todoIDStr];
        self.isModified = YES;
        [self syncData];
    }
}

/// 更新(修改已有的)事项数据，由于用户的操作而调用时is填YES，内部合并数据时is填NO
- (void)alterTodoWithModel:(TodoDataModel*)model needRecord:(BOOL)is {
        NSString* code = OSTRING(
                              UPDATE remindModeTable
                                  SET repeat_mode = ? <
                                      date = ? <
                                      week = ? <
                                      day = ? <
                                      time = ?
                                  WHERE todo_id = ?
                              );
    code = [code stringByReplacingOccurrencesOfString:@"<" withString:@","];
    [self.db executeUpdate:code withArgumentsInArray:@[@(model.repeatMode), [self dateArrToDateStr:model.dateArr], [self weekArrToWeekStr:model.weekArr], [self dayArrToDayStr:model.dayArr], model.timeStr, model.todoIDStr]];
    
    code = OSTRING(
                   UPDATE todoTable
                       SET title = ? <
                           detail = ? <
                           is_done = ?
                       WHERE todo_id = ?
                   );
    code = [code stringByReplacingOccurrencesOfString:@"<" withString:@","];
    [self.db executeUpdate:code withArgumentsInArray:@[model.titleStr, model.detailStr, @(model.isDone), model.todoIDStr]];
    
    //记录修改
    if (is) {
        [self recordAlterWithTodoID:model.todoIDStr];
        self.isModified = YES;
        [self syncData];
    }
}

/// 删除事项，由于用户的操作而调用时is填YES，内部合并数据时is填NO
- (void)deleteTodoWithTodoID:(NSString*)todoIDStr needRecord:(BOOL)is {
    NSString* code = OSTRING(
                             DELETE FROM remindModeTable
                                 WHERE todo_id = ?
                             );
    [self.db executeUpdate:code withArgumentsInArray:@[todoIDStr]];
    
    code = OSTRING(
                   DELETE FROM todoTable
                       WHERE todo_id = ?
                   );
    [self.db executeUpdate:code withArgumentsInArray:@[todoIDStr]];
    
    //记录修改
    if (is) {
        [self recordDeleteWithTodoID:todoIDStr];
        self.isModified = YES;
        [self syncData];
    }
}

/// 获取最近创建的3个todo，用来在发现页显示
- (NSArray<TodoDataModel*>*)getTodoForDiscoverMainPage {
    NSMutableArray* resultArr = [NSMutableArray array];
    NSString* code = OSTRING(
                             SELECT *
                                FROM todoTable
                                WHERE is_done = 0
                                ORDER BY todo_id DESC
                             );
    FMResultSet* resultSet = [self.db executeQuery:code];
    int cnt = 0;
    while ([resultSet next]) {
        TodoDataModel* model = [self resultSetToDataModel:resultSet];
        [resultArr addObject:model];
        cnt++;
        if (cnt==4) {
            break;
        }
    }
    return resultArr;
}

//MARK: +++++++++++++++++++++一些基础的工具方法++++++++++++++++++++++++++++

/// 检测todoID为 todoIDStr 的元祖是否已经在 tableName 中存在
- (BOOL)isTodoID:(NSString*)todoIDStr existsInTable:(NSString*)tableName {
    NSString* code = OSTRING(
                             SELECT *
                               FROM tableName
                               WHERE todo_id = ?
                 );
    code = [code stringByReplacingOccurrencesOfString:@"tableName" withString:tableName];
    FMResultSet* set = [self.db executeQuery:code withArgumentsInArray:@[todoIDStr]];
    if ([set next]) {
        return YES;
    }else {
        return NO;
    }
}

///@"02.06, 03.05, 08.07" -> @[
///  @{@"TodoDataModelKeyMonth":@"02", TodoDataModelKeyDay:@"06"},
///  @{@"TodoDataModelKeyMonth":@"03", TodoDataModelKeyDay:@"05"},
///  @{@"TodoDataModelKeyMonth":@"08", TodoDataModelKeyDay:@"07"},
///]
- (NSArray<NSDictionary*>*)dateStrToDateArr:(NSString*)str {
    if (str==nil||[str isEqualToString:@""]) {
        return @[];
    }
    NSArray* arr = [str componentsSeparatedByString:@", "];
    NSMutableArray* dateArr = [NSMutableArray arrayWithCapacity:10];
    for (NSString* dateStr in arr) {
        NSArray* temp = [dateStr componentsSeparatedByString:@"."];
        [dateArr addObject:@{
            TodoDataModelKeyMonth:[temp firstObject],
            TodoDataModelKeyDay:[temp lastObject],
        }];
    }
    return dateArr;
}

///@"1, 2, 3, 7" -> @[
/// @"2", @"3", @"4", @"1"
///]
- (NSArray<NSString*>*)weekStrToWeekArr:(NSString*)str {
    if (str==nil||[str isEqualToString:@""]) {
        return @[];
    }
    NSArray* arr = [str componentsSeparatedByString:@", "];
    NSMutableArray* weekArr = [NSMutableArray arrayWithCapacity:3];
    for (NSString* weekStr in arr) {
        [weekArr addObject:[NSString stringWithFormat:@"%d",ChinaWeekToForeignWeek(weekStr.intValue)]];
    }
    return weekArr;
}

//@"1, 2, 3, 4" -> @[@"1", @"2", @"3", @"4"]
- (NSArray<NSString*>*)dayStrToDayArr:(NSString*)str {
    if (str==nil||[str isEqualToString:@""]) {
        return @[];
    }
    return [str componentsSeparatedByString:@", "];;
}


///@[
///  @{@"TodoDataModelKeyMonth":@"02", TodoDataModelKeyDay:@"06"},
///  @{@"TodoDataModelKeyMonth":@"03", TodoDataModelKeyDay:@"05"},
///  @{@"TodoDataModelKeyMonth":@"08", TodoDataModelKeyDay:@"07"},
///] -> ///@"02.06, 03.05, 08.07"
- (NSString*)dateArrToDateStr:(NSArray<NSDictionary*>*)arr {
    NSMutableString* str = [[NSMutableString alloc] initWithString:@""];
    for (NSDictionary* dateDict in arr) {
        [str appendFormat:@", %@.%@", dateDict[TodoDataModelKeyMonth], dateDict[TodoDataModelKeyDay]];
    }
    if (str.length==0) {
        return @"";
    }else {
        return [str substringFromIndex:2];
    }
}

///@[
/// @"2", @"3", @"4", @"1"
///] -> @"1, 2, 3, 7"
- (NSString*)weekArrToWeekStr:(NSArray<NSString*>*)arr {
    NSMutableString* str = [[NSMutableString alloc] initWithString:@""];
    for (NSString* weekStr in arr) {
        [str appendFormat:@", %d", ForeignWeekToChinaWeek(weekStr.intValue)];
    }
    if (str.length==0) {
        return @"";
    }else {
        return [str substringFromIndex:2];
    }
}

//@[@"1", @"2", @"3", @"4"] -> @"1, 2, 3, 4"
- (NSString*)dayArrToDayStr:(NSArray<NSString*>*)arr {
    if (arr==nil||[arr isEqualToArray:@[]]) {
        return @"";
    }
    return [arr componentsJoinedByString:@", "];
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

- (long)getTupleCntOfTable:(NSString*)tableName {
    NSString* code = OSTRING(
                             SELECT COUNT(*)
                                 FROM tableName
                             );
    code = [code stringByReplacingOccurrencesOfString:@"tableName" withString:tableName];
    FMResultSet* set = [self.db executeQuery:code];
    long cnt = 0;
    if ([set next]) {
        cnt = [set longForColumn:@"COUNT(*)"];
    }
    return cnt;
}

/// 获取增加/修改的事项数据来上传
- (NSArray<NSDictionary*>*)getAddAndAlterDataToPush {
    NSString* code = OSTRING(
                             SELECT * FROM TodoTable
                                 WHERE todo_id IN (SELECT todo_id FROM addTodoIDTable UNION SELECT todo_id FROM alterTodoIDTable)
                             );
    FMResultSet* resultSet = [self.db executeQuery:code];
    NSMutableArray* arr = [NSMutableArray arrayWithCapacity:5];
    while ([resultSet next]) {
        [arr addObject:[self resultSetToDataModel:resultSet]];
    }
    return arr;
}

/// 获取被删除的事项ID
- (NSArray<NSString*>*)getDeleteDataToPush {
    NSString* code = OSTRING(
                             SELECT * FROM deleteTodoIDTable
                             );
    FMResultSet* resultSet = [self.db executeQuery:code];
    NSMutableArray* arr = [NSMutableArray arrayWithCapacity:5];
    while ([resultSet next]) {
        [arr addObject:[resultSet stringForColumn:@"todo_id"]];
    }
    return arr;
}

/// 记录修改
- (void)recordAlterWithTodoID:(NSString*)todoIDStr {
    if (![self isTodoID:todoIDStr existsInTable:@"addTodoIDTable"]&&![self isTodoID:todoIDStr existsInTable:@"alterTodoIDTable"]) {
        NSString* code = OSTRING(
                                 INSERT INTO alterTodoIDTable
                                     VALUES(?)
                                 );
        [self.db executeUpdate:code withArgumentsInArray:@[todoIDStr]];
    }
}
/// 记录增加
- (void)recordAddWithTodoID:(NSString*)todoIDStr {
    NSString* code = OSTRING(
                   INSERT INTO addTodoIDTable
                       VALUES(?)
                   );
    [self.db executeUpdate:code withArgumentsInArray:@[todoIDStr]];
}
/// 记录删除
- (void)recordDeleteWithTodoID:(NSString*)todoIDStr {
    NSString* code;
    if ([self isTodoID:todoIDStr existsInTable:@"addTodoIDTable"]) {
        code = OSTRING(
                       DELETE FROM addTodoIDTable
                           WHERE todo_id = ?
                       );
        [self.db executeUpdate:code withArgumentsInArray:@[todoIDStr]];
    }else if([self isTodoID:todoIDStr existsInTable:@"alterTodoIDTable"]) {
        code = OSTRING(
                       DELETE FROM alterTodoIDTable
                           WHERE todo_id = ?
                       );
        [self.db executeUpdate:code withArgumentsInArray:@[todoIDStr]];
    }else {
        code = OSTRING(
                       INSERT INTO deleteTodoIDTable
                           VALUES(?)
                       );
        [self.db executeUpdate:code withArgumentsInArray:@[todoIDStr]];
    }
}

//MARK: +++++++++++++++++++++初始化相关++++++++++++++++++++++++++++
+ (instancetype)share {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:nil] init];
        [_instance initDataBase];
        _instance->_lastSyncTimeStamp = [[NSUserDefaults standardUserDefaults] integerForKey:TodoSyncToolKeyLastSyncTimeStamp];
        _instance.isModified = [[NSUserDefaults standardUserDefaults] boolForKey:TodoSyncToolKeyIsModified];
        [[NSNotificationCenter defaultCenter] addObserver:_instance selector:@selector(netWorkStateChanges:) name:@"AFNetworkReachabilityStatusChanges" object:nil];
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self share];
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}

/// 初始化数据库，如果数据库以存在，那么什么事都不会做
- (void)initDataBase {
    self.db = [[FMDatabase alloc] initWithPath:TODO_DBPATH];
    if ([self.db open]) {
        [self creatTodoTable];
        CCLog(@"todo数据库打开成功");
    }else {
        CCLog(@"todo数据库打开失败");
    }
}

/// 建表
- (void)creatTodoTable {
    NSString* code = OSTRING(
                             CREATE TABLE IF NOT EXISTS
                                todoTable (
                                               todo_id TEXT not null,
                                               title TEXT,
                                               detail TEXT,
                                               is_done INTEGER,
                                               
                                               PRIMARY KEY(todo_id)
                                           )
                             );
    [self.db executeUpdate:code];
    
    code = OSTRING(
                   CREATE TABLE IF NOT EXISTS
                    remindModeTable (
                                         todo_id text not null,
                                         repeat_mode INTEGER,
                                         date TEXT,
                                         week TEXT,
                                         day TEXT,
                                         time TEXT,
                                         
                                         FOREIGN KEY(todo_id) REFERENCES todoTable(todo_id)
                                     )
                   );
    [self.db executeUpdate:code];
    
    
    code = OSTRING(
                   CREATE UNIQUE INDEX IF NOT EXISTS todoTable_todo_id ON todoTable(todo_id)
                   );
    [self.db executeUpdate:code];
    
    code = OSTRING(
                   CREATE TABLE IF NOT EXISTS
                       addTodoIDTable(
                                      todo_id text not null,
                                      FOREIGN KEY(todo_id) REFERENCES todoTable(todo_id)
                                      )
                   );
    [self.db executeUpdate:code];
    
    code = OSTRING(
                   CREATE TABLE IF NOT EXISTS
                       deleteTodoIDTable(
                                      todo_id text not null,
                                      FOREIGN KEY(todo_id) REFERENCES todoTable(todo_id)
                                      )
                   );
    [self.db executeUpdate:code];
    
    code = OSTRING(
                   CREATE TABLE IF NOT EXISTS
                       alterTodoIDTable(
                                      todo_id text not null,
                                      FOREIGN KEY(todo_id) REFERENCES todoTable(todo_id)
                                      )
                   );
    [self.db executeUpdate:code];
}

//MARK: +++++++++++++++++++++测试时会用到的方法++++++++++++++++++++++++++++
- (void)logTodoTable {
    NSString* code;
    code = OSTRING(
                   SELECT *
                       FROM todoTable
                   );
    FMResultSet* set = [self.db executeQuery:code];
    while ([set next]) {
        NSString* todo_id = [set stringForColumn:@"todo_id"];
        NSString* title = [set stringForColumn:@"title"];
        NSString* detail = [set stringForColumn:@"detail"];
        NSInteger is_done = [set longForColumn:@"is_done"];
        CCLog(@"%@, %@, %@, %ld,", todo_id, title, detail, is_done);
    }
    /*
     todo_id TEXT,
     title TEXT,
     detail TEXT,
     is_done INTEGER,
     */
}

- (void)logRemindModeTable {
    NSString* code;
    code = OSTRING(
                   SELECT *
                       FROM remindModeTable
                   );
    FMResultSet* set = [self.db executeQuery:code];
    while ([set next]) {
        NSString* ID = [set stringForColumn:@"ID"];
        NSInteger repeat_mode = [set longForColumn:@"repeat_mode"];
        NSString* week = [set stringForColumn:@"week"];
        NSString* day = [set stringForColumn:@"day"];
        NSString* date = [set stringForColumn:@"date"];
        NSString* time = [set stringForColumn:@"time"];
        CCLog(@"%@, %ld, %@, %@, %@, %@", ID, repeat_mode, week, day, date, time);
    }
    /*
     todo_id text,
     repeat_mode INTEGER,
     week TEXT,
     day TEXT,
     date TEXT,
     */
}

- (void)logTodoData {
    NSString* code = OSTRING(
                             SELECT *
                                FROM todoTable
                             );
    FMResultSet* resultSet = [self.db executeQuery:code];
    while ([resultSet next]) {
        TodoDataModel* model = [[TodoDataModel alloc] init];
        model.todoIDStr = [resultSet stringForColumn:@"todo_id"];
        model.titleStr = [resultSet stringForColumn:@"title"];
        model.detailStr = [resultSet stringForColumn:@"detail"];
        model.isDone = [resultSet boolForColumn:@"is_done"];
        
        code = OSTRING(
                       SELECT *
                           FROM remindModeTable
                           WHERE todo_id = ?
                       );
        FMResultSet* subSet = [self.db executeQuery:code withArgumentsInArray:@[model.todoIDStr]];
        while ([subSet next]) {
            model.repeatMode = [subSet longForColumn:@"repeat_mode"];
            model.timeStr = [subSet stringForColumn:@"time"];
            switch (model.repeatMode) {
                case TodoDataModelRepeatModeWeek:
                    model.weekArr = [self weekStrToWeekArr:[subSet stringForColumn:@"week"]];
                    break;
                case TodoDataModelRepeatModeMonth:
                    model.dayArr = [self dayStrToDayArr:[subSet stringForColumn:@"day"]];
                    break;
                case TodoDataModelRepeatModeYear:
                    model.dateArr = [self dateStrToDateArr:[subSet stringForColumn:@"date"]];
                    break;
                default:
                    break;
            }
        }
        CCLog(@"%@", model);
    }
    
    /*
     todo_id TEXT,
     title TEXT,
     detail TEXT,
     is_done INTEGER,
     
     
     id text
     repeat_mode INTEGER,
     week TEXT,
     day TEXT,
     date TEXT,
     
     */
}
- (void)dropTable:(NSString*)tableName {
    NSString* code = OSTRING(
                             DROP TABLE IF EXISTS tableName
                             );
    code = [code stringByReplacingOccurrencesOfString:@"tableName" withString:tableName];
    [self.db executeUpdate:code];
}
- (void)resetDB {
    //得先删除其他的，再删除todoTable，不然可能有约束报错
    NSArray* tableNameArr = @[@"remindModeTable", @"addTodoIDTable", @"alterTodoIDTable", @"deleteTodoIDTable", @"todoTable"];
    for (NSString* tableName in tableNameArr) {
        [self dropTable:tableName];
    }
    [self initDataBase];
}

- (void)logRecordDataWithTableName:(NSString*)tableName {
    NSString* code;
    FMResultSet* set;
    code = OSTRING(
                   SELECT *
                       FROM tableName
                   );
    code = [code stringByReplacingOccurrencesOfString:@"tableName" withString:tableName];
    set = [self.db executeQuery:code];
    CCLog(@"%@",tableName);
    while ([set next]) {
        NSString* todoID = [set stringForColumn:@"todo_id"];
        CCLog(@"%@",todoID);
    }
}
@end

/*
 #ifdef DEBUG
 #define CyxbsMobileBaseURL_1 @"https://be-dev.redrock.cqupt.edu.cn/magipoke-todo"
 #define CyxbsMobileBaseURL_2 @"https://be-dev.redrock.cqupt.edu.cn/magipoke-todo"

 #else
 //#define CyxbsMobileBaseURL_1 @"https://be-prod.redrock.team/"
 //#define CyxbsMobileBaseURL_2 @"https://be-prod.redrock.team/"
 #define CyxbsMobileBaseURL_1 [[NSUserDefaults standardUserDefaults] objectForKey:@"baseURL"]
 #define CyxbsMobileBaseURL_2 [[NSUserDefaults standardUserDefaults] objectForKey:@"baseURL"]
 #endif
 */

