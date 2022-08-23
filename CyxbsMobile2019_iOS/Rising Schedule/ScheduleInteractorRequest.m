//
//  ScheduleInteractorRequest.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/23.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleInteractorRequest.h"

#pragma mark - ClassScheduleRequestType

ScheduleModelRequestType student = @"stu_num";

ScheduleModelRequestType custom = @"custom";

ScheduleModelRequestType teacher = @"tea";

@implementation ScheduleInteractorRequest

- (void)request:(NSDictionary
                 <ScheduleModelRequestType,NSArray
                 <NSString *> *> *)requestDictionary
        success:(void (^)(NSProgress *progress))success
        failure:(void (^)(NSError * _Nonnull))failure {
    
    __block NSDictionary *apiDic = @{
        student : RisingSchedule_POST_stuSchedule_API,
        teacher : RisingSchedule_POST_teaSchedule_API,
        custom : RisingSchedule_POST_perTransaction_API
    };
    
    __block NSInteger count = 0;
    __block NSInteger current = 0;
    
    [requestDictionary enumerateKeysAndObjectsUsingBlock:^(ScheduleModelRequestType  _Nonnull key, NSArray<NSString *> * _Nonnull obj, BOOL * _Nonnull stop) {
        
        for (NSString *num in obj) {
            count += 1;
            
            [HttpTool.shareTool
             request:apiDic[key]
             type:HttpToolRequestTypePost
             serializer:HttpToolRequestSerializerHTTP
             bodyParameters:@{
                key : num
            }
             progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
                current += 1;
                
//                [self onceSave:object];
                
                NSArray *lessonAry = [object objectForKey:@"data"];
                NSString *stuNum = object[@"stuNum"];
                
                for (NSDictionary *oneLessonDic in lessonAry) {
                    for (NSNumber *weekOfLesson in oneLessonDic[@"week"]) {
                        // 1.先copy一份，确保dic为一节课的所有信息
                        NSMutableDictionary *ScheduleCourseDic = oneLessonDic.mutableCopy;
                        
                        ScheduleCourseDic[@"week"] = weekOfLesson;
                        ScheduleCourseDic[@"sno"] = stuNum;
                        if ([key isEqualToString:custom]) {
                            ScheduleCourseDic[@"type"] = @"自定义";
                        }
                        
                        // 2.转模型，并实现快速表
                        ScheduleCourse *lesson = [[ScheduleCourse alloc] initWithDictionary:ScheduleCourseDic];
                        
                        /// int a[25][7][12];
                        /// for (int i = 0; i < lesson.period.lenth; i++) {
                        ///     if object[@"stunum"] = usertool.stu
                        ///     self.a[lesson.inSection][lesson.inWeek][lesson.period.location + i] = TODO
                        /// }
                        
                        // WCDB存
                        // TODO: [self saveLesson:lesson];
                        NSString *currentNum = (count == 1 ? stuNum : UserItemTool.defaultItem.stuNum);
                        
//                        [self.model[weekOfLesson.unsignedLongValue] addObject:lesson];
                    }
                    // 整周课表的存储
                    NSMutableDictionary *ScheduleCourseDic = oneLessonDic.mutableCopy;
                    
                    ScheduleCourseDic[@"week"] = @0ull;
                    ScheduleCourseDic[@"sno"] = stuNum;
                    if ([key isEqualToString:custom]) {
                        ScheduleCourseDic[@"type"] = @"自定义";
                    }
                    
                    ScheduleCourse *lesson = [[ScheduleCourse alloc] initWithDictionary:ScheduleCourseDic];
                    
                    // WCDB存
                    // TODO: [self saveLesson:lesson];
                    NSString *currentNum = (count == 1 ? stuNum : UserItemTool.defaultItem.stuNum);
                    
//                    [self.model[0] addObject:lesson];
                }
                
                if (success) {
                    NSProgress *progress = [[NSProgress alloc] init];
                    progress.totalUnitCount = count;
                    progress.completedUnitCount = current;
                    success(progress);
                }
            }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
            }];
        }
    }];
}

@end
