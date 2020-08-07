//
//  WYCClassAndRemindDataModel.h
//  MoblieCQUPT_iOS
//
//  Created by 王一成 on 2019/3/8.
//  Copyright © 2019年 Orange-W. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpClient.h"
#define URL @"https://cyxbsmobile.redrock.team/api/kebiao"

@interface WYCClassAndRemindDataModel : NSObject
/**
 weekArray的结构：
        @[
            //某周的课表信息数组
            @[
                //某节课的信息字典
                @{
                    @"begin_lesson":@"1",
                        .....
                    @"week":@[@2,@3,@5,......@17].
                },
                @{},
                @{}
            ],
            @[@{}, @{}, @{} ],      
            @[@{}, @{}, @{} ],
        ]
*/
@property (nonatomic, strong) NSMutableArray *weekArray;
@property (nonatomic, strong) NSMutableArray *remindArray;

- (void)getClassBookArray:(NSString *)stu_Num;
- (void)getClassBookArrayFromNet:(NSString *)stu_Num;


- (void)getRemind:(NSString *)stuNum idNum:(NSString *)idNum;
- (void)getRemindFromNet:(NSString *)stuNum idNum:(NSString *)idNum;
- (void)deleteRemind:(NSString *)stuNum idNum:(NSString *)idNum remindId:(NSNumber *)remindId;

-(void)parsingClassBookData:(NSArray*)array;
@end

//1.
//WYCClassAndRemindDataModel *model = [[WYCClassAndRemindDataModel alloc] init];

//2.
//模拟从storyBoard加载课表时对model的操作
//model.weekArray = [@[[responseObject objectForKey:@"data"]]mutableCopy];
//[model parsingClassBookData:lessonOfAllPeople];
//[model setValue:@"YES" forKey:@"remindDataLoadFinish"];
//[model setValue:@"YES" forKey:@"classDataLoadFinish"];
