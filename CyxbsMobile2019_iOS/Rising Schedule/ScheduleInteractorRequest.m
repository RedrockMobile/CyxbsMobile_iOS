//
//  ScheduleInteractorRequest.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/23.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleInteractorRequest.h"

#pragma mark - ClassScheduleRequestType

ScheduleModelRequestType student = @"student";

ScheduleModelRequestType custom = @"custom";

ScheduleModelRequestType teacher = @"teacher";

#pragma mark - ScheduleInteractorRequest

@implementation ScheduleInteractorRequest

#pragma mark - Init

+ (instancetype)requestBindingModel:(ScheduleModel *)model {
    if (!model) {
        NSParameterAssert(model);
        model = [[ScheduleModel alloc] init];
    }
    
    ScheduleInteractorRequest *request = [[self alloc] init];
    request->_bindModel = model;
    
    return request;
}

#pragma mark - Method

- (void)request:(NSDictionary
                 <ScheduleModelRequestType,NSArray
                 <NSString *> *> *)requestDictionary
        success:(void (^)(void))success
        failure:(void (^)(NSError * _Nonnull))failure {
    
    __block NSDictionary *APIDictionary;
    __block NSDictionary *KeyDictionary;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        APIDictionary = @{
            student : RisingSchedule_POST_stuSchedule_API,
            teacher : RisingSchedule_POST_teaSchedule_API,
            custom : RisingSchedule_POST_perTransaction_API
        };
        
        KeyDictionary = @{
            student : @"stu_num",
            teacher : @"tea",
            custom : @"stu_num"
        };
    });
        
    [requestDictionary enumerateKeysAndObjectsUsingBlock:^(ScheduleModelRequestType _Nonnull key, NSArray<NSString *> * _Nonnull obj, BOOL * __unused stop) {
        
        for (NSString *num in obj) {
            
            [HttpTool.shareTool
             request:APIDictionary[key]
             type:HttpToolRequestTypePost
             serializer:HttpToolRequestSerializerHTTP
             bodyParameters:@{
                KeyDictionary[key] : num.copy
            }
             progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable object) {
                
                NSArray *lessonAry = [object objectForKey:@"data"];
                
                BOOL check = (!object || !lessonAry || lessonAry.count == 0);
                if (check) {
                    NSAssert(check, @"\n🔴%s data : %@", __func__, lessonAry);
                }
                
                NSString *stuNum = object[@"stuNum"];
                NSInteger nowWeek = [object[@"nowWeek"] longValue];
                self.bindModel.nowWeek = nowWeek;
                
                for (NSDictionary *courceDictionary in lessonAry) {
                    
                    ScheduleCourse *course = [[ScheduleCourse alloc] initWithDictionary:courceDictionary];
                    course.sno = stuNum.copy;
                    
                    [self.bindModel appendCourse:course];
                }
                
                if (success) {
                    success();
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
