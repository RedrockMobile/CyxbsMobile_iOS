//
//  WYCClassAndRemindDataModel.m
//  MoblieCQUPT_iOS
//
//  Created by 王一成 on 2019/3/8.
//  Copyright © 2019年 Orange-W. All rights reserved.
//

#import "WYCClassAndRemindDataModel.h"
#import "LocalNotiManager.h"
//[responseObject objectForKey:@"data"]
@interface WYCClassAndRemindDataModel()
@property (nonatomic, strong)NSArray *rowDataArray;
@property (nonatomic, strong)AFHTTPSessionManager *afhttpSeMan;
@end

@implementation WYCClassAndRemindDataModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.rowDataArray = [NSArray arrayWithContentsOfFile:rowDataArrPath];
        
        self.afhttpSeMan = [AFHTTPSessionManager manager];
        
        //清除旧的课表数据，等过几版后，去掉这个代码
        [self clear];
    }
    return self;
}

//@"Documents/lesson.plist"
//@"Documents/remind.plist"
//清除旧的课表数据，等过几版后，去掉这个代码
- (void)clear{
//    NSLog(@"%@",[[NSFileManager defaultManager] subpathsAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]]);
    NSFileManager *man = [NSFileManager defaultManager];
    
    //删除课表数据
    [man removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/lesson.plist"] error:nil];
    
    //移动备忘数据
    [man moveItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/remind.plist"] toPath:remDataArrPath error:nil];
    
//    NSLog(@"%@",[[NSFileManager defaultManager] subpathsAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]]);
}

/// 查个人课表用这个方法,它会先加载本地数据，再调去用getPersonalClassBookArrayFromNet方法来网络请求数据
/// @param stuNum 学号
- (void)getPersonalClassBookArrayWithStuNum:(NSString*)stuNum{
    //先取出本地的课表数据
    self.orderlySchedulArray = [NSMutableArray arrayWithContentsOfFile:parsedDataArrPath];
    
    //如果本地存储的课表数据非空，那么通知代理数据加载成功
    if(self.orderlySchedulArray!=nil){
        [self.delegate ModelDataLoadSuccess:self];
    }
    
    //再通过网络请求获取课表数据，如果请求的数据和本地不一样且请求数据非空那么通知代理数据加载成功
    [self getPersonalClassBookArrayFromNet:stuNum];
}


/// 通过网络请求获取个人课表数据用这个方法，如果请求的数据和本地不一样且请求数据非空那么刷新课表
/// @param stuNum 学号
- (void)getPersonalClassBookArrayFromNet:(NSString *)stuNum{
    NSDictionary *paramDict = @{@"stu_num":stuNum};
    
    [self.afhttpSeMan POST:kebiaoAPI parameters:paramDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        CCLog(@"ke%@",responseObject);
        //拿到课表数据
        NSArray *rowLessonDataArr = responseObject[@"data"];
        
        //储存当前周数，计算开学日期
        [self storeDate:[NSString stringWithFormat:@"%@",responseObject[@"nowWeek"]]];
        
        //如果没有数据，或者数据和本地数据一样，那么return
        if (rowLessonDataArr==nil||[rowLessonDataArr isEqualToArray:self.rowDataArray]) {
            return;
        }
        
        //保存未解析的课表数据
        [rowLessonDataArr writeToFile:rowDataArrPath atomically:YES];
        
        //解析课表数据
        [self parseClassBookData:rowLessonDataArr];
        
        //保存已解析的课表数据到文件
        [self.orderlySchedulArray writeToFile:parsedDataArrPath atomically:YES];
        
        //通知代理数据加载完毕
        [self.delegate ModelDataLoadSuccess:self];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        CCLog(@"ke%@",error);
        //通知代理数据加载失败
        [self.delegate ModelDataLoadFailure];
    }];
}

/// 查同学课表用这个方法来网络请求
/// @param stu_Num 学号
- (void)getClassBookArrayFromNet:(NSString *)stu_Num{
    NSDictionary *parameters = @{@"stu_num":stu_Num};
    
    [self.afhttpSeMan POST:kebiaoAPI parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        //拿到课表数据
        NSArray *lessonArray = [responseObject objectForKey:@"data"];
        
        //解析课表数据
        [self parseClassBookData:lessonArray];
        
        //通知代理数据加载成功
        [self.delegate ModelDataLoadSuccess:self];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //通知代理数据加载失败
        [self.delegate ModelDataLoadFailure];
    }];
}


/// 查老师课表用这个方法来网络请求
/// @param parameters 参数结构： @{ @"teaName": name, @"tea": teaNum }
- (void)getTeaClassBookArrayFromNet:(NSDictionary*)parameters{
    [self.afhttpSeMan POST:TEAkebiaoAPI parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        //拿到课表数据
        NSArray *lessonArray = [responseObject objectForKey:@"data"];
        
        //解析课表数据
        [self parseClassBookData:lessonArray];
        
        //通知代理数据加载成功
        [self.delegate ModelDataLoadSuccess:self];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //通知代理数据加载失败
        [self.delegate ModelDataLoadFailure];
    }];
}

///添加备忘模型
- (void)addNoteDataWithModel:(NoteDataModel*)model{
    [self.noteDataModelArray addObject:model];
    
    //利用KVC获取备忘数组
    NSArray *rowData = [self.noteDataModelArray valueForKeyPath:@"noteDataDict"];
    
    //把所有的noteDataDict写入文件
    [rowData writeToFile:remDataArrPath atomically:YES];
}

///删除备忘模型
- (void)deleteNoteDataWithModel:(NoteDataModel*)model{
    
    [self.noteDataModelArray removeObject:model];
    
    NSMutableArray *rowData = [NSMutableArray arrayWithContentsOfFile:remDataArrPath];
    
    [rowData removeObject:model.noteDataDict];
    
    [rowData writeToFile:remDataArrPath atomically:YES];
}

/// 备忘模型数组的懒加载
- (NSMutableArray *)noteDataModelArray{
    if(_noteDataModelArray==nil){
        NSArray *rowData = [NSMutableArray arrayWithContentsOfFile:remDataArrPath];
        NSMutableArray *modelArray = [NSMutableArray array];
        for (NSDictionary *noteDataDict in rowData) {
            //添加本地通知
            NoteDataModel *model = [[NoteDataModel alloc]initWithNoteDataDict:noteDataDict];
            [modelArray addObject:model];
            if([model.notiBeforeTime isEqual:@"不提醒"])continue;
            for (NSNumber *weekNum in model.weeksArray) {
                for (NSDictionary *timeDict in model.timeDictArray) {
                    [LocalNotiManager setLocalNotiWithWeekNum:weekNum.intValue weekDay:[timeDict[@"weekNum"] intValue] lesson:[timeDict[@"lessonNum"] intValue] before:model.notiBeforeTimeLenth titleStr:model.noteTitleStr subTitleStr:nil bodyStr:model.noteDetailStr ID:[NSString stringWithFormat:@"%@.%d.%@.%@",model.noteID,weekNum.intValue,timeDict[@"weekNum"],timeDict[@"lessonNum"]]];
                }
            }
        }
        
        _noteDataModelArray = modelArray;
        
        if(_noteDataModelArray==nil){
            _noteDataModelArray = [@[] mutableCopy];
        }
    }
    return _noteDataModelArray;
}

/// 没课约查多人课表用底下的这个方法
/// @param infoDictArray n个人的信息字典组成的数组，信息只用到了@"stuNum"对应的value
//信号量+栅栏函数
- (void)getClassBookArrayFromNetWithInfoDictArr:(NSArray*)infoDictArray{
    
    //用来存储多人课表数组的数组
    __block NSMutableArray *lessonOfAllPeople = [infoDictArray mutableCopy];
    
    //创建一个并行队列
    dispatch_queue_t que = dispatch_queue_create("weDate2", DISPATCH_QUEUE_CONCURRENT);
    
    //创建一个信号量，这里把信号量的创建放在这里和放在dispatch_group_async里面是等价的，
    //因为wait和signal是一一对应的，在其他地方有可能会不等价，
    //因为第x层循环的wait收到的信号有可能是第y层循环发出的
    //验证方法：在wait后面加上代码：NSLog(@"%@",lessonOfAllPeople[i]);
    //会发现有时候打印出来的并不是课表数据
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    //infoDict是infoDictArray的数组元素
    NSDictionary *infoDict;
    
    __block BOOL isAllSuccess = YES;
    
    int i,count = (int)infoDictArray.count;
    for (i=0; i<count; i++) {
        infoDict = infoDictArray[i];
        dispatch_async(que, ^{
            [self.afhttpSeMan POST:kebiaoAPI parameters:@{@"stuNum":infoDict[@"stuNum"]} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                lessonOfAllPeople[i] = [responseObject objectForKey:@"data"];
                
                dispatch_semaphore_signal(semaphore);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                isAllSuccess = NO;
                dispatch_semaphore_signal(semaphore);
            }];
            dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, 15 * NSEC_PER_SEC));
        });
    }
    
    dispatch_barrier_async(que, ^{
        if(isAllSuccess==YES){
            NSMutableArray *tmp = [[NSMutableArray alloc] init];
            for (NSArray *arr in lessonOfAllPeople) {
                [tmp addObjectsFromArray:arr];
            }
            [self parseClassBookData:tmp];
            [self.delegate ModelDataLoadSuccess:self];
        }else{
            [self.delegate ModelDataLoadFailure];
        }
    });
}

//MARK:-数据解析&处理
/// 解析未经处理的课表数据
/// @param array 结构同[responseObject objectForKey:@"data"]
- (void)parseClassBookData:(NSArray *)array{
    //初始化orderlySchedulArray
    [self initOrderlySchedulArray];
    NSNumber *hash_day,*hash_lesson;
    NSArray *weeks;
    for (NSDictionary *couseDataDict in array) {
        weeks = couseDataDict[@"week"];
        hash_day = couseDataDict[@"hash_day"];
        hash_lesson = couseDataDict[@"hash_lesson"];
        //为整学期页的设置数据
        [self.orderlySchedulArray[0][hash_day.intValue][hash_lesson.intValue] addObject:couseDataDict];
        
        //为后面有课的周设置数据
        for (NSNumber *weekNum in weeks) {
            [self.orderlySchedulArray[weekNum.intValue][hash_day.intValue][hash_lesson.intValue] addObject:couseDataDict];
        }
    }
}

//初始化orderlySchedulArray
- (void)initOrderlySchedulArray{
    //如果非空，那么清空
    if(self.orderlySchedulArray!=nil){
        for (NSMutableArray *week in self.orderlySchedulArray) {
            for (NSMutableArray *day in week) {
                for (NSMutableArray *lesson in day) {
                    [lesson removeAllObjects];
                }
            }
        }
    }else{
        //如果为空那么创建
        //整学期
        self.orderlySchedulArray = [NSMutableArray array];
        for (int i=0; i<26; i++) {
            //某一周
            NSMutableArray *week = [NSMutableArray array];
            for (int j=0; j<7; j++) {
                //某一周的某一天
                NSMutableArray *day = [NSMutableArray array];
                for (int k=0; k<6; k++) {
                    //某一周的某一天的某一节课，它是数组
                    NSMutableArray *aLesson = [NSMutableArray array];
                    [day addObject:aLesson];
                }
                [week addObject:day];
            }
            [self.orderlySchedulArray addObject:week];
        }
    }
}

//储存当前周数，计算开学日期
- (void)storeDate:(NSString*)week {
    NSDate *now = NSDate.now;
    
    NSDateComponents *nowComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:now];
//    unit
    NSInteger weekday = nowComponents.weekday;
    if (weekday==1) {
        weekday = 7;
    }else {
        weekday--;
    }
    
    NSInteger todaySecond = (((nowComponents.hour*60)+nowComponents.minute)*60)+nowComponents.second;
    
    NSInteger ortherDatSecond = ((week.longValue-1)*7+weekday-1)*86400;
    //startDate指向开学日期那天的凌晨1秒
//    NSDate *startDate = [now dateByAddingSeconds:1-(todaySecond+ortherDatSecond)];
        NSDate *startDate = [[NSDate alloc] initWithTimeInterval:1-(todaySecond+ortherDatSecond) sinceDate:now];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:startDate];
    
    [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%ld-%02ld-%02ld",components.year,components.month,components.day] forKey:DateStartKey_NSString];
    
    [[NSUserDefaults standardUserDefaults] setValue:week forKey:nowWeekKey_NSString];
}

@end

//    {
//    "begin_lesson" = 1;
//    classroom = 3212;
//    course = "\U5927\U5b66\U751f\U804c\U4e1a\U53d1\U5c55\U4e0e\U5c31\U4e1a\U6307\U5bfc1";
//    "course_num" = B1220060;
//    day = "\U661f\U671f\U4e00";
//    "hash_day" = 0;
//    "hash_lesson" = 0;
//    lesson = "\U4e00\U4e8c\U8282";
//    period = 2;
//    rawWeek = "1-8\U5468";
//    teacher = "\U9648\U65ed";
//    type = "\U5fc5\U4fee";
//    week =                 (
//    1,
//    2,
//    3,
//    4,
//    5,
//    6,
//    7,
//    8
//    );
//    weekBegin = 1;
//    weekEnd = 8;
//    weekModel = all;
//    }

//
///// 通过网络请求获取个人课表数据用这个方法，如果请求的数据和本地不一样且请求数据非空那么刷新课表
///// @param stuNum 学号
//- (void)getPersonalClassBookArrayFromNet1:(NSString *)stuNum{
//
//    NSDictionary *parameters = @{@"stu_num":stuNum};
//
//    [[HttpClient defaultClient] requestWithPath:URL method:HttpRequestPost parameters:parameters prepareExecute:nil progress:^(NSProgress *progress) {
//
//    } success:^(NSURLSessionDataTask *task, id responseObject) {
//
//        NSArray *lessonArray = [responseObject objectForKey:@"data"];
//
//        if(lessonArray==nil){
//            [self.delegate ModelDataLoadFailure];
//            return;
//        }
//
//        if([lessonArray isEqualToArray:self.rowDataArray])return;
//
//
//        //保存获取的课表数据到文件
//        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
//
//        NSString *lessonPath = [path stringByAppendingPathComponent:@"lesson.plist"];
//
//        [lessonArray writeToFile:lessonPath atomically:YES];
//
//        [self parseClassBookData:lessonArray];
//
//        [self.delegate ModelDataLoadSuccess:self];
//
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//
//        [self.delegate ModelDataLoadFailure];
//    }];
//}

//- (void)getPersonalClassBookArrayWithStuNum1:(NSString*)stuNum{
//    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
////    [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/lesson.plist"];
//    NSString *lessonPath = [path stringByAppendingPathComponent:@"lesson.plist"];
//    NSArray *rowDataArray = [NSArray arrayWithContentsOfFile:lessonPath];
//    if(rowDataArray!=nil){
//        self.rowDataArray = rowDataArray;
//        [self parseClassBookData:self.rowDataArray];
//        [self.delegate ModelDataLoadSuccess:self];
//    }
//
//    [self getPersonalClassBookArrayFromNet:stuNum];
//}


////方法1，信号量+队列组
//- (void)getClassBookArrayFromNetWithInfoDictArr2:(NSArray*)infoDictArray{
//    //用GCD实现多人的课表的请求,把请求到的课表数据都放入lessonOfAllPeople
//
//    HttpClient *client = [HttpClient defaultClient];
//    //用来存储多人课表数组的数组
//    __block NSMutableArray *lessonOfAllPeople = [infoDictArray mutableCopy];
//
//    //infoDict是infoDictArray的数组元素
//    NSDictionary *infoDict;
//
//    //创建一个队列组
//    dispatch_group_t group = dispatch_group_create();
//    //创建一个并行队列
//    dispatch_queue_t que = dispatch_queue_create("weData1", DISPATCH_QUEUE_CONCURRENT);
//    //创建一个信号量，这里把信号量的创建放在这里和放在dispatch_group_async里面是等价的，
//    //因为wait和signal是一一对应的，在其他地方有可能会不等价，
//    //因为第x层循环的wait收到的信号有可能是第y层循环发出的
//    //验证方法：在wait后面加上代码：NSLog(@"%@",lessonOfAllPeople[i]);
//    //会发现有时候打印出来的并不是课表数据
//    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
//
//    __block BOOL isAllSuccess = YES;
//
//    int count = (int)infoDictArray.count,i;
//    for (i=0; i<count; i++) {
//        infoDict = infoDictArray[i];
//        dispatch_group_async(group, que, ^{
//            [client requestWithPath:kebiaoAPI method:HttpRequestPost parameters:@{@"stuNum":infoDict[@"stuNum"]} prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//
//                //课表数据全部放入lessonOfAllPeople
//                lessonOfAllPeople[i] = [responseObject objectForKey:@"data"];
//
//                dispatch_semaphore_signal(semaphore);
//            } failure:^(NSURLSessionDataTask *task, NSError *error) {
//                isAllSuccess = NO;
//
//                dispatch_semaphore_signal(semaphore);
//            }];
//            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//     });
//    }
//
//    //完成group的任务后执行block里的内容
//    dispatch_group_notify(group, que, ^{
//        if(isAllSuccess==YES){
//            NSMutableArray *tmp = [[NSMutableArray alloc] init];
//            for (NSArray *lessonDataArr in lessonOfAllPeople) {
//                [tmp addObjectsFromArray:lessonDataArr];
//            }
//            [self parseClassBookData:tmp];
//            [self.delegate ModelDataLoadSuccess:self];
//        }else{
//            [self.delegate ModelDataLoadFailure];
//        }
//    });
//}

