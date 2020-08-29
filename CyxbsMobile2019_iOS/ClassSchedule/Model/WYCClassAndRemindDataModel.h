//
//  WYCClassAndRemindDataModel.h
//  MoblieCQUPT_iOS
//
//  Created by 王一成 on 2019/3/8.
//  Copyright © 2019年 Orange-W. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpClient.h"
#import "NoteDataModel.h"
#define URL @"https://cyxbsmobile.redrock.team/api/kebiao"
@protocol WYCClassAndRemindDataModelDelegate <NSObject>
- (void)ModelDataLoadSuccess:(id)model;
- (void)ModelDataLoadFailure;
//- (void)ModelDataLoadSu:(id)model;
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
//@property (nonatomic, strong) NSMutableArray *weekArray;
@property (nonatomic, strong) NSMutableArray *remindArray;
@property (nonatomic, weak)id<WYCClassAndRemindDataModelDelegate>delegate;

/// 有序的全部课表，/// orderlySchedulArray[i][j][k]代表（第i周）的（星期j+1）的（第k+1节大课）
/// ,orderlySchedulArray[i][j][k]是一个数组
@property (nonatomic,strong)NSMutableArray *orderlySchedulArray;
/// 备忘模型数组
@property (nonatomic, strong)NSMutableArray <NoteDataModel*>*noteDataModelArray;
//- (void)getClassBookArray:(NSString *)stu_Num;

/// 网络请求获取他人课表，不把课表数据存入本地
/// @param stu_Num 学号
- (void)getClassBookArrayFromNet:(NSString *)stu_Num;

/// 网络请求获取自己课表，会把课表数据存入本地
/// @param stu_Num 学号
//- (void)getPersonalClassBookArrayFromNet:(NSString *)stu_Num;

- (void)getClassBookArrayFromNetWithInfoDict:(NSArray*)infoDictArray;
- (void)getPersonalClassBookArrayWithStuNum:(NSString*)stuNum;
//下面三个方法没用上
//- (void)getRemind:(NSString *)stuNum idNum:(NSString *)idNum;
//- (void)getRemindFromNet:(NSString *)stuNum idNum:(NSString *)idNum;
//- (void)deleteRemind:(NSString *)stuNum idNum:(NSString *)idNum remindId:(NSNumber *)remindId;

/// 查老师课表要用的方法
/// @param parameters @{
///    @"teaName":@"陈希明",
///    @"tea":@"020101"
/// };
- (void)getTeaClassBookArrayFromNet:(NSDictionary*)parameters;

//-(void)parsingClassBookData:(NSArray*)array;

//-(void)loadFinish;

- (void)addNoteDataWithModel:(NoteDataModel*)model;
- (void)deleteNoteDataWithModel:(NoteDataModel*)model;

@end


//1.
//WYCClassAndRemindDataModel *model = [[WYCClassAndRemindDataModel alloc] init];

//2.
//模拟从storyBoard加载课表时对model的操作
//model.weekArray = [@[[responseObject objectForKey:@"data"]]mutableCopy];
//[model parsingClassBookData:lessonOfAllPeople];
//[model setValue:@"YES" forKey:@"remindDataLoadFinish"];
//[model setValue:@"YES" forKey:@"classDataLoadFinish"];
