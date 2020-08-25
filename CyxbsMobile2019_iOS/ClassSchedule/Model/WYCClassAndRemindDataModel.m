//
//  WYCClassAndRemindDataModel.m
//  MoblieCQUPT_iOS
//
//  Created by 王一成 on 2019/3/8.
//  Copyright © 2019年 Orange-W. All rights reserved.
//

#import "WYCClassAndRemindDataModel.h"
@interface WYCClassAndRemindDataModel()
//课表
@property (nonatomic, assign) BOOL classDataLoadFinish;
@property (nonatomic, assign) BOOL remindDataLoadFinish;
//备忘
@end

@implementation WYCClassAndRemindDataModel

///从本地加载课表数据
- (void)getClassBookArray{
    //如果有缓存，则从缓存加载数据
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *lessonPath = [path stringByAppendingPathComponent:@"lesson.plist"];
    NSArray *array = [NSMutableArray arrayWithContentsOfFile:lessonPath];
    
    if (array) {
        self.weekArray = [[NSMutableArray alloc]init];
        [self.weekArray addObject:array];
        
        [self parsingClassBookData:array];
        
        [self.delegate ModelDataLoadSuccess];
    }else{
        
        [self.delegate ModelDataLoadFailure];
    }
}

- (void)getClassBookArrayFromNet:(NSString *)stu_Num{
    self.classDataLoadFinish = NO;
    self.weekArray = [[NSMutableArray alloc]init];
    
    NSDictionary *parameters = @{@"stu_num":stu_Num};
    
    [[HttpClient defaultClient] requestWithPath:URL method:HttpRequestPost parameters:parameters prepareExecute:nil progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
        NSArray *lessonArray = [responseObject objectForKey:@"data"];
        
        if(self.writeToFile==YES){
            [UserDefaultTool saveValue:responseObject forKey:@"lessonResponse"];
            //保存获取的课表数据到文件
            NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
            NSString *lessonPath = [path stringByAppendingPathComponent:@"lesson.plist"];
            [lessonArray writeToFile:lessonPath atomically:YES];
        }
        
        // 共享数据
        NSUserDefaults *shared = [[NSUserDefaults alloc]initWithSuiteName:kAPPGroupID];
        [shared setObject:responseObject forKey:@"lessonResponse"];
        [shared synchronize];
        
        
        
        [self.weekArray addObject:lessonArray];
        [self parsingClassBookData:lessonArray];
        
        [self.delegate ModelDataLoadSuccess];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self.delegate ModelDataLoadFailure];
    }];
    
}

- (void)getPersonalClassBookArrayFromNet:(NSString *)stu_Num{
    self.classDataLoadFinish = NO;
    self.weekArray = [[NSMutableArray alloc]init];
    
    NSDictionary *parameters = @{@"stu_num":stu_Num};
    
    [[HttpClient defaultClient] requestWithPath:URL method:HttpRequestPost parameters:parameters prepareExecute:nil progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        

        NSArray *lessonArray = [responseObject objectForKey:@"data"];

        [UserDefaultTool saveValue:responseObject forKey:@"lessonResponse"];
        //保存获取的课表数据到文件
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *lessonPath = [path stringByAppendingPathComponent:@"lesson.plist"];
        [lessonArray writeToFile:lessonPath atomically:YES];

        
        // 共享数据
        NSUserDefaults *shared = [[NSUserDefaults alloc]initWithSuiteName:kAPPGroupID];
        [shared setObject:responseObject forKey:@"lessonResponse"];
        [shared synchronize];
        
        
        
        [self.weekArray addObject:lessonArray];
        [self parsingClassBookData:lessonArray];
        
        [self.delegate ModelDataLoadSuccess];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self getClassBookArray];
    }];
}
///解析课表数据
-(void)parsingClassBookData:(NSArray*)array{
    int i;
    for (i=0; i<25; i++) {
        [_weekArray addObject:[@[]mutableCopy]];
    }
    NSArray *week;
    NSNumber *num;
    for (NSDictionary *infoForALesson in array) {
        week = infoForALesson[@"week"];
        for (i=0; i<week.count; i++) {
            num = week[i];
            [_weekArray[num.intValue] addObject:infoForALesson];
        }
    }
    
}
//输入要求：[responseObject objectForKey:@"data"]
- (void)parseClassBookData:(NSArray *)array{
    NSNumber *hash_day,*hash_lesson;
    NSArray *weeks;
    for (NSDictionary *couseDataDict in array) {
        weeks = couseDataDict[@"week"];
        hash_day = couseDataDict[@"hash_day"];
        hash_lesson = couseDataDict[@"hash_lesson"];
        for (NSNumber *weekNum in weeks) {
            [self.orderlySchedulArray[weekNum.intValue][hash_day.intValue][hash_lesson.intValue] addObject:couseDataDict];
        }
    }
}
- (NSMutableArray *)orderlySchedulArray{
    if(_orderlySchedulArray==nil){
        //整学期
        NSMutableArray *whole = [NSMutableArray array];
        for (int i=0; i<25; i++) {
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
            [modelArray addObject:[[NoteDataModel alloc]initWithNotoDataDict:noteDataDict]];
        }
        
        _noteDataModelArray = modelArray;
        
        if(_noteDataModelArray==nil){
            _noteDataModelArray = [@[] mutableCopy];
        }
    }
    return _noteDataModelArray;
}
@end


//没有用上的备忘方法：
/**
//备忘
- (void)getRemind:(NSString *)stuNum idNum:(NSString *)idNum{
    //如果有缓存，则从缓存加载数据
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *remindPath = [path stringByAppendingPathComponent:@"remind.plist"];
    NSArray *array = [NSMutableArray arrayWithContentsOfFile:remindPath];
    
    if (array) {
        self.remindArray = [[NSMutableArray alloc]init];
        
        [self parsingRemindData:array];
        
        self.remindDataLoadFinish = YES;
        [self loadFinish];
    }else{
        
        [self getRemindFromNet:stuNum idNum:idNum];
    }
}
- (void)getRemindFromNet:(NSString *)stuNum idNum:(NSString *)idNum{
    self.remindArray = [[NSMutableArray alloc]init];
    self.remindDataLoadFinish = NO;
    
    NSDictionary *parameters = @{@"stuNum":stuNum,@"idNum":idNum};
    
    [[HttpClient defaultClient] requestWithPath:GETREMINDAPI method:HttpRequestPost parameters:parameters prepareExecute:nil progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
       
        NSArray *dataArray = [responseObject objectForKey:@"data"];
  
        //保存获取的备忘数据到文件
        if(self.writeToFile==YES){
            NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
            NSString *remindPath = [path stringByAppendingPathComponent:@"remind.plist"];
            NSMutableArray *reminds = [responseObject objectForKey:@"data"];
            [reminds writeToFile:remindPath atomically:YES];
        }
        //解析备忘数据
        [self parsingRemindData:dataArray];
        self.remindDataLoadFinish = YES;
        [self loadFinish];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"WYCRemindModelRemindLoadFailure:%@",error);
        self.remindDataLoadFinish = NO;
        [self loadFinish];
    }];
    
}
//解析数据
-(void)parsingRemindData:(NSArray *)array{
    _remindArray = [[NSMutableArray alloc]initWithCapacity:25];
    for (int i = 0; i < 25; i++) {
        _remindArray[i] = [@[] mutableCopy];
    }
    
    
    
    for (int i = 0; i < array.count; i++) {
        NSArray *date = [array[i] objectForKey:@"date"];
        
        for (int time = 0; time < date.count; time++) {
            
            
            NSNumber *hash_day = [date[time] objectForKey:@"day"];
            NSNumber *hash_lesson = [date[time] objectForKey:@"class"];
            NSNumber *period = [NSNumber numberWithInt:2];
            NSMutableDictionary *tmp = [array[i] mutableCopy];
            
            [tmp setObject:hash_day forKey:@"hash_day"];
            [tmp setObject:hash_lesson forKey:@"hash_lesson"];
            [tmp setObject:period forKey:@"period"];
            
            NSArray *weekArray = [date[time] objectForKey:@"week"];
            for (int week = 0; week < weekArray.count; week++) {
                NSNumber *weekNum = weekArray[week];
                [_remindArray[weekNum.integerValue-1] addObject:tmp];
            }
        }
        
    }
    
    
}

- (void)deleteRemind:(NSString *)stuNum idNum:(NSString *)idNum remindId:(NSNumber *)remindId{
    NSDictionary *parameters = @{@"stuNum":stuNum,@"idNum":idNum,@"id":remindId};
    
    [[HttpClient defaultClient] requestWithPath:DELETEREMINDAPI method:HttpRequestPost parameters:parameters prepareExecute:nil progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
        NSNumber *result = [responseObject objectForKey:@"status"];
        if (result.integerValue == 200) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RemindDeleteSuccess" object:nil];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"NoteDeleteFailure:%@",error);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RemindDeleteFailure" object:nil];
        
    }];
    
}

-(void)loadFinish{
    if (self.classDataLoadFinish == YES&&self.remindDataLoadFinish == YES) {
        [self.delegate ModelDataLoadSuccess];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"ModelDataLoadSuccess" object:nil];
    }
    if (self.classDataLoadFinish == NO&&self.remindDataLoadFinish == NO) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"ModelDataLoadFailure" object:nil];
        [self.delegate ModelDataLoadFailure];
    }
    
}
*/
