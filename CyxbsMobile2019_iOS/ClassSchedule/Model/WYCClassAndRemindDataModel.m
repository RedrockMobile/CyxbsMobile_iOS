//
//  WYCClassAndRemindDataModel.m
//  MoblieCQUPT_iOS
//
//  Created by 王一成 on 2019/3/8.
//  Copyright © 2019年 Orange-W. All rights reserved.
//

#import "WYCClassAndRemindDataModel.h"
@interface WYCClassAndRemindDataModel()
//[responseObject objectForKey:@"data"]
@property (nonatomic, strong)NSArray *rowDataArray;
@property (nonatomic, strong)AFHTTPSessionManager *httpSeManager;
@end

@implementation WYCClassAndRemindDataModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.httpSeManager = [[AFHTTPSessionManager alloc] init];
    }
    return self;
}

/// 查个人课表用这个方法,它会先加载本地数据，再调去用getPersonalClassBookArrayFromNet方法来网络请求数据
/// @param stuNum 学号
- (void)getPersonalClassBookArrayWithStuNum:(NSString*)stuNum{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
//    [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/lesson.plist"];
    NSString *lessonPath = [path stringByAppendingPathComponent:@"lesson.plist"];
    NSArray *rowDataArray = [NSArray arrayWithContentsOfFile:lessonPath];
    if(rowDataArray!=nil){
        self.rowDataArray = rowDataArray;
        [self parseClassBookData:self.rowDataArray];
        [self.delegate ModelDataLoadSuccess:self];
    }
    
    [self getPersonalClassBookArrayFromNet:stuNum];
}

/// 查同学课表用这个方法来网络请求
/// @param stu_Num 学号
- (void)getClassBookArrayFromNet:(NSString *)stu_Num{
    NSDictionary *parameters = @{@"stu_num":stu_Num};
    
    [[HttpClient defaultClient] requestWithPath:URL method:HttpRequestPost parameters:parameters prepareExecute:nil progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *lessonArray = [responseObject objectForKey:@"data"];
        
        [self parseClassBookData:lessonArray];
        
        [self.delegate ModelDataLoadSuccess:self];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self.delegate ModelDataLoadFailure];
    }];
    
}

/// 通过网络请求获取个人课表数据用这个方法，如果请求的数据和本地不一样且请求数据非空那么刷新课表
/// @param stuNum 学号
- (void)getPersonalClassBookArrayFromNet:(NSString *)stuNum{
    
    NSDictionary *parameters = @{@"stu_num":stuNum};
    
    [[HttpClient defaultClient] requestWithPath:URL method:HttpRequestPost parameters:parameters prepareExecute:nil progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *lessonArray = [responseObject objectForKey:@"data"];
        
        if(lessonArray==nil){
            [self.delegate ModelDataLoadFailure];
            return;
        }
        
        if([lessonArray isEqualToArray:self.rowDataArray])return;
        
        
        //保存获取的课表数据到文件
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        
        NSString *lessonPath = [path stringByAppendingPathComponent:@"lesson.plist"];
        
        [lessonArray writeToFile:lessonPath atomically:YES];

        [self parseClassBookData:lessonArray];
        
        [self.delegate ModelDataLoadSuccess:self];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self.delegate ModelDataLoadFailure];
    }];
}

/// 查老师课表用这个方法来网络请求
/// @param parameters 参数结构： @{ @"teaName": name, @"tea": teaNum }
- (void)getTeaClassBookArrayFromNet:(NSDictionary*)parameters{
    
    [[HttpClient defaultClient] requestWithPath:TEAkebiaoAPI method:HttpRequestPost parameters:parameters prepareExecute:nil progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
        NSArray *lessonArray = [responseObject objectForKey:@"data"];
        
        
        [self parseClassBookData:lessonArray];
        [self.delegate ModelDataLoadSuccess:self];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self.delegate ModelDataLoadFailure];
    }];
    
}

/// 解析未经处理的课表数据
/// @param array 结构同[responseObject objectForKey:@"data"]
- (void)parseClassBookData:(NSArray *)array{
    //整学期
    if(_orderlySchedulArray!=nil){
        for (NSMutableArray *week in self.orderlySchedulArray) {
            for (NSMutableArray *day in week) {
                for (NSMutableArray *lesson in day) {
                    [lesson removeAllObjects];
                }
            }
        }
    }
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

- (NSMutableArray *)orderlySchedulArray{
    if(_orderlySchedulArray==nil){
        //整学期
        NSMutableArray *whole = [NSMutableArray array];
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
            [whole addObject:week];
        }
        _orderlySchedulArray = whole;
    }
    return _orderlySchedulArray;
}

///添加备忘模型
- (void)addNoteDataWithModel:(NoteDataModel*)model{
    [self.noteDataModelArray addObject:model];
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *remindPath = [path stringByAppendingPathComponent:@"remind.plist"];
    //取出noteDataModelArray中所有模型的noteDataDict
    
    NSArray *rowData = [self.noteDataModelArray valueForKeyPath:@"noteDataDict"];
    
    //把所有的noteDataDict写入文件
    [rowData writeToFile:remindPath atomically:YES];
}

///删除备忘模型
- (void)deleteNoteDataWithModel:(NoteDataModel*)model{
    [self.noteDataModelArray removeObject:model];
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *remPath = [path stringByAppendingPathComponent:@"remind.plist"];
    NSMutableArray *rowData = [NSMutableArray arrayWithContentsOfFile:remPath];
    [rowData removeObject:model.noteDataDict];
    [rowData writeToFile:remPath atomically:YES];
}

/// 备忘模型数组的懒加载
- (NSMutableArray *)noteDataModelArray{
    if(_noteDataModelArray==nil){
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *remPath = [path stringByAppendingPathComponent:@"remind.plist"];
        NSArray *rowData = [NSMutableArray arrayWithContentsOfFile:remPath];
        NSMutableArray *modelArray = [NSMutableArray array];
        for (NSDictionary *noteDataDict in rowData) {
            [modelArray addObject:[[NoteDataModel alloc]initWithNoteDataDict:noteDataDict]];
        }
        
        _noteDataModelArray = modelArray;
        
        if(_noteDataModelArray==nil){
            _noteDataModelArray = [@[] mutableCopy];
        }
    }
    return _noteDataModelArray;
}

/// 没课约查多人课表用底下的这两个方法
/// @param infoDictArray n个人的信息字典组成的数组，信息只用到了@"stuNum"对应的value

//方法1，信号量+队列组
- (void)getClassBookArrayFromNetWithInfoDictArr2:(NSArray*)infoDictArray{
    //用GCD实现多人的课表的请求,把请求到的课表数据都放入lessonOfAllPeople
    
    HttpClient *client = [HttpClient defaultClient];
    //用来存储多人课表数组的数组
    __block NSMutableArray *lessonOfAllPeople = [infoDictArray mutableCopy];

    //infoDict是infoDictArray的数组元素
    NSDictionary *infoDict;
    
    //创建一个队列组
    dispatch_group_t group = dispatch_group_create();
    //创建一个并行队列
    dispatch_queue_t que = dispatch_queue_create("weData1", DISPATCH_QUEUE_CONCURRENT);
    //创建一个信号量，这里把信号量的创建放在这里和放在dispatch_group_async里面是等价的，
    //因为wait和signal是一一对应的，在其他地方有可能会不等价，
    //因为第x层循环的wait收到的信号有可能是第y层循环发出的
    //验证方法：在wait后面加上代码：NSLog(@"%@",lessonOfAllPeople[i]);
    //会发现有时候打印出来的并不是课表数据
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    __block BOOL isAllSuccess = YES;
    
    int count = (int)infoDictArray.count,i;
    for (i=0; i<count; i++) {
        infoDict = infoDictArray[i];
        dispatch_group_async(group, que, ^{
            [client requestWithPath:kebiaoAPI method:HttpRequestPost parameters:@{@"stuNum":infoDict[@"stuNum"]} prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                
                //课表数据全部放入lessonOfAllPeople
                lessonOfAllPeople[i] = [responseObject objectForKey:@"data"];
                
                dispatch_semaphore_signal(semaphore);
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                isAllSuccess = NO;
                
                dispatch_semaphore_signal(semaphore);
            }];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
     });
    }
        
    //完成group的任务后执行block里的内容
    dispatch_group_notify(group, que, ^{
        if(isAllSuccess==YES){
            NSMutableArray *tmp = [[NSMutableArray alloc] init];
            for (NSArray *lessonDataArr in lessonOfAllPeople) {
                [tmp addObjectsFromArray:lessonDataArr];
            }
            [self parseClassBookData:tmp];
            [self.delegate ModelDataLoadSuccess:self];
        }else{
            [self.delegate ModelDataLoadFailure];
        }
    });
}
//方法2，信号量+栅栏函数
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
            [self.httpSeManager POST:kebiaoAPI parameters:@{@"stuNum":infoDict[@"stuNum"]} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                lessonOfAllPeople[i] = [responseObject objectForKey:@"data"];
                
                dispatch_semaphore_signal(semaphore);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                isAllSuccess = NO;
                dispatch_semaphore_signal(semaphore);
            }];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
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
@end
