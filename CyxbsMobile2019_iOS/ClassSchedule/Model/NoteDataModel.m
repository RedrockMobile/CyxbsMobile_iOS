//
//  NoteDataModel.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/8/21.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "NoteDataModel.h"

@implementation NoteDataModel
- (instancetype)initWithNotoDataDict:(NSDictionary*)noteDataDict{
    self = [super init];
    if(self){
        self.noteDataDict = noteDataDict;
        self.noteTitleStr = noteDataDict[@"noteTitleStr"];
        self.noteDetailStr = noteDataDict[@"noteDetailStr"];
        self.notiBeforeTime = noteDataDict[@"notiBeforeTime"];
        self.weeksStrArray = noteDataDict[@"weeksStrArray"];
        self.timeStrDictArray = noteDataDict[@"timeStrDictArray"];
        
        self.weeksArray = [self transferWSAWithArray:self.weeksStrArray];
        
        self.timeDictArray = [self transferTSDAWithArray:self.timeStrDictArray];
        
        self.noteID = [self getNoteID];
        
        NSLog(@"%@",self.noteID);
        
    }
    return self;
}
/// @[@4,@1,@18]代表第4、1、18周的备忘，0代表整学期
- (NSArray*)transferWSAWithArray:(NSArray*)weeksStrArray{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *standStrArray = @[@"整学期", @"第一周", @"第二周", @"第三周", @"第四周", @"第五周", @"第六周", @"第七周", @"第八周", @"第九周", @"第十周", @"第十一周", @"第十二周", @"第十三周", @"第十四周", @"第十五周", @"第十六周", @"第十七周", @"第十八周", @"第十九周", @"第二十周", @"第二十一周",];
    
    NSDictionary *transfer = [self getTransferWithStrArray:standStrArray];
    
    for (NSString *str in weeksStrArray) {
        [array addObject:transfer[str]];
    }
    
    return array;
}

/// @[
///     @{@"weekNum":@0,  @"lessonNum":@2},
///     @{@"weekNum":@1,  @"lessonNum":@0}
/// ]
///代表某周的周一 第3节大课和周二的第一节大课的备忘
- (NSArray*)transferTSDAWithArray:(NSArray*)timeStrDictArray{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *standLessonStrArr = @[@"一二节课",@"三四节课",@"五六节课",@"七八节课",@"九十节课",@"十一十二节课"];
    NSArray *standWeekStrArr =
    @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
    
    NSDictionary *lessonTransfer = [self getTransferWithStrArray:standLessonStrArr];
    NSDictionary *weekTransfer = [self getTransferWithStrArray:standWeekStrArr];
    
    for (NSDictionary *timeStrDict in timeStrDictArray) {
        [array addObject:@{
            @"weekNum":weekTransfer[timeStrDict[@"weekString"]],
            @"lessonNum":lessonTransfer[timeStrDict[@"lessonString"]],
        }];
    }
    
    return array;
}

- (NSDictionary*)getTransferWithStrArray:(NSArray*)strArray{
    NSMutableDictionary *transfer = [NSMutableDictionary dictionary];
    int count = (int)strArray.count,i;
    
    for (i=0; i<count; i++) {
        [transfer setValue:[NSNumber numberWithInt:i] forKey:strArray[i]];
    }
    
    return transfer;
}
//@{@"weekString":@"",  @"lessonString":@""}

- (NSString*)getNoteID{
    NSDate *now = [NSDate date];
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    NSDate *Thurs = [formate dateFromString:@"2020-01-01"];
        
        
        formate.dateFormat = @"yyyy-M-d";
    //    NSString *today = [formate stringFromDate:[NSDate date]];
        
        NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

        
        NSDateComponents *compsday = [calender components:NSCalendarUnitDay fromDate:Thurs toDate:now options:0];
        
        //得到2020和今日隔了几天
        long interval = [compsday day];
    
    formate.dateFormat = @"MMddHHmmss";
    return [NSString stringWithFormat:@"%ld%@",interval,[formate stringFromDate:now]];
    
}
@end
