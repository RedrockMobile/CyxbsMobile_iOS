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

@protocol WYCClassAndRemindDataModelDelegate <NSObject>

- (void)ModelDataLoadSuccess;
- (void)ModelDataLoadFailure;

@end

@interface WYCClassAndRemindDataModel : NSObject
//创建后要对writeToFile进行赋值，代表网络请求后是否把数据写入文件
@property (nonatomic, assign) BOOL writeToFile;
/**
 weekArray的结构：
 weekArray[i]是第i周的课表数据，weekArray[0]是整学期的课表数据，weekArray[i].count代表第i周有多少节课
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
@property (nonatomic, weak)id<WYCClassAndRemindDataModelDelegate>delegate;

- (void)getClassBookArray:(NSString *)stu_Num;
- (void)getClassBookArrayFromNet:(NSString *)stu_Num;


- (void)getRemind:(NSString *)stuNum idNum:(NSString *)idNum;
- (void)getRemindFromNet:(NSString *)stuNum idNum:(NSString *)idNum;
- (void)deleteRemind:(NSString *)stuNum idNum:(NSString *)idNum remindId:(NSNumber *)remindId;

-(void)parsingClassBookData:(NSArray*)array;
-(void)loadFinish;
@end

//1.
//WYCClassAndRemindDataModel *model = [[WYCClassAndRemindDataModel alloc] init];

//2.
//模拟从storyBoard加载课表时对model的操作
//model.weekArray = [@[[responseObject objectForKey:@"data"]]mutableCopy];
//[model parsingClassBookData:lessonOfAllPeople];
//[model setValue:@"YES" forKey:@"remindDataLoadFinish"];
//[model setValue:@"YES" forKey:@"classDataLoadFinish"];
