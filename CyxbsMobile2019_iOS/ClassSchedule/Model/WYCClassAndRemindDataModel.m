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


- (void)getClassBookArray:(NSString *)stu_Num{
    //如果有缓存，则从缓存加载数据
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *lessonPath = [path stringByAppendingPathComponent:@"lesson.plist"];
    NSArray *array = [NSMutableArray arrayWithContentsOfFile:lessonPath];
    
    if (array) {
        self.weekArray = [[NSMutableArray alloc]init];
        [self.weekArray addObject:array];
        
        [self parsingClassBookData:array];
        
        self.classDataLoadFinish = YES;
        [self loadFinish];
    }else{
        
        [self getClassBookArrayFromNet:stu_Num];
    }
}
- (void)getClassBookArrayFromNet:(NSString *)stu_Num{
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
        
        self.classDataLoadFinish = YES;
        [self loadFinish];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"WYCClassBookModelLoadErrorCode:%@",error);
        self.classDataLoadFinish = NO;
        [self loadFinish];
    }];
    
}
-(void)parsingClassBookData:(NSArray*)array{
    
    for (int weeknum = 1; weeknum <= 25; weeknum++) {
        NSMutableArray *tmp = [[NSMutableArray alloc]init];
        
        for (int i = 0; i < array.count; i++) {
            
            NSArray *week = [array[i] objectForKey:@"week"];
            
            
            for (int j = 0;j < week.count; j++) {
                NSNumber *k = week[j];
                
                if (weeknum == k.intValue) {
                    [tmp addObject:array[i]];
                }
            }
        }
        
        [_weekArray addObject:tmp];
        
        
    }
    
    
}


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
    self.remindDataLoadFinish = nil;
    
    NSDictionary *parameters = @{@"stuNum":stuNum,@"idNum":idNum};
    
    [[HttpClient defaultClient] requestWithPath:GETREMINDAPI method:HttpRequestPost parameters:parameters prepareExecute:nil progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
       
        NSArray *dataArray = [responseObject objectForKey:@"data"];
  
        //保存获取的备忘数据到文件
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *remindPath = [path stringByAppendingPathComponent:@"remind.plist"];
        NSMutableArray *reminds = [responseObject objectForKey:@"data"];
        [reminds writeToFile:remindPath atomically:YES];
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ModelDataLoadSuccess" object:nil];
    }
    if (self.classDataLoadFinish == NO&&self.remindDataLoadFinish == NO) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ModelDataLoadFailure" object:nil];
    }
    
}
@end

