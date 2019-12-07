//
//  DateModle.m
//  ChatBotTest
//
//  Created by 王一成 on 2018/8/30.
//  Copyright © 2018年 wyc. All rights reserved.
//

#import "DateModle.h"

@implementation DateModle
+(instancetype)initWithStartDate:(NSString *)startDate{
    DateModle *dateModel = [[DateModle alloc]init];
    [dateModel initCalculateDate:startDate];
    return dateModel;
}
-(void)initCalculateDate:(NSString *)startDate{
    //从字符串转换日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy.MM.d"];
    NSDate *resDate = [formatter dateFromString:startDate];
    [self calculateNowWeek:resDate];
    //初始化日期数组
    _dateArray = [[NSMutableArray alloc]init];
    int n = 0;
    for (int i = 1 ; i < 26; i++) {
        //建立临时数组，保存一个星期的数据
        NSMutableArray *tmpArray = [[NSMutableArray alloc]init];
        
        for (int j = 0; j < 7; j++) {
            
            //获得从开始日期算起的第n天的日期
            NSDate *nowDate = [[NSDate alloc]initWithTimeInterval:86400*n sinceDate:resDate];
            
            //提取月和日
            NSArray *arr = [self getMonthAndDay:nowDate];
            
            //每日的数据包装成一个字典，包含月和日
            NSDictionary *monthAndDay = @{@"month":arr[0],@"day":arr[1]};
            
            //将每日的数据添加到相应星期的临时数组里
            [tmpArray addObject:monthAndDay];
            
            //往后算一天
            n++;
            
        }
        
        //按星期保存
        [_dateArray addObject:tmpArray];
    }
    
}

-(NSArray *)getMonthAndDay:(NSDate *)date{
    NSMutableArray *arr = [[NSMutableArray alloc]initWithCapacity:2];
    //提取月、日
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|
    NSCalendarUnitDay;//获取日期的元素。
    
    NSDateComponents *d = [cal components:unitFlags fromDate:date];//把要从date中获取的unitFlags标示的日期元素存放在NSDateComponents类型的d里面；
    //然后就可以从d中获取具体的年月日了；
    //NSInteger year = [d year];
    NSInteger month = [d month];
    NSInteger day  =  [d day];
    arr[0] = [NSNumber numberWithInteger:month];
    arr[1] = [NSNumber numberWithInteger:day];
    //NSLog(@"y:%ld,m:%ld,d:%ld",(long)year,(long)month,(long)day);
    
    return arr;
}
-(void)calculateNowWeek:(NSDate *)Date{
    
    //计算当前是第几周
    NSInteger beginTime=[Date timeIntervalSince1970];
    NSDate *now = [NSDate date];
    NSInteger nowTime = [now timeIntervalSince1970];
    double day = (float)(nowTime - beginTime)/(float)86400/(float)7;
    NSInteger nowWeek = (int)ceil(day);
    if(nowWeek < 0){
        nowWeek = 0;
    }
    self.nowWeek = [NSNumber numberWithInteger:nowWeek];
    [UserDefaultTool saveValue:self.nowWeek forKey:@"nowWeek"];
    NSLog(@"nowweek:%ld",(long)nowWeek);
}
@end
