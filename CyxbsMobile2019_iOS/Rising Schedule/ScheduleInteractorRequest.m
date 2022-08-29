//
//  ScheduleInteractorRequest.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/23.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleInteractorRequest.h"

#pragma mark - ClassScheduleRequestType

ScheduleModelRequestType ScheduleModelRequestStudent = @"student";

ScheduleModelRequestType ScheduleModelRequestCustom = @"custom";

ScheduleModelRequestType ScheduleModelRequestTeacher = @"teacher";

#pragma mark - ScheduleInteractorRequest

@implementation ScheduleInteractorRequest

#pragma mark - Method

+ (void)request:(NSDictionary
                 <ScheduleModelRequestType,NSArray
                 <NSString *> *> *)requestDictionary
        success:(void (^)(ScheduleCombineModel *))success
        failure:(void (^)(NSError * _Nonnull))failure {
    
    static NSDictionary *APIDictionary;
    static NSDictionary *KeyDictionary;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        APIDictionary = @{
            ScheduleModelRequestStudent : RisingSchedule_POST_stuSchedule_API,
            ScheduleModelRequestTeacher : RisingSchedule_POST_teaSchedule_API,
            ScheduleModelRequestCustom : RisingSchedule_POST_perTransaction_API
        };
        
        KeyDictionary = @{
            ScheduleModelRequestStudent : @"stu_num",
            ScheduleModelRequestTeacher : @"tea",
            ScheduleModelRequestCustom : @"stu_num"
        };
    });
        
    [requestDictionary enumerateKeysAndObjectsUsingBlock:^(ScheduleModelRequestType _Nonnull key, NSArray<NSString *> * _Nonnull obj, BOOL * __unused stop) {
        
        for (NSString *num in obj) {
            
            [HttpTool.shareTool
             request:APIDictionary[key]
             type:HttpToolRequestTypePost
             serializer:HttpToolRequestSerializerHTTP
             bodyParameters:@{
                KeyDictionary[key] : num.copy,
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
                ScheduleCombineModel *model =
                [ScheduleCombineModel
                 combineWithSno:stuNum
                 type:([key isEqualToString:ScheduleModelRequestCustom] ?
                       ScheduleCombineCustom :
                       ScheduleCombineSystem)];
                
                for (NSDictionary *courceDictionary in lessonAry) {
                    
                    ScheduleCourse *course = [[ScheduleCourse alloc] initWithDictionary:courceDictionary];
                    course.sno = stuNum.copy;
                    
                    [model.courseAry addObject:course];
                }
                
                
                if (success) {
                    success(model);
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

- (void)requestCustomSuccess:(void (^)(void))success
                     failure:(void (^)(NSError * _Nonnull))failure {
    return
    [self.class request:@{ScheduleModelRequestCustom : @[@"Rising"]} success:^(ScheduleCombineModel * _Nonnull combineModel) {
        self->_customCombineModel = combineModel;
        if (success) {
            success();
        }
    } failure:failure];
}

- (void)appendCustom:(ScheduleCourse *)course
             success:(void (^)(void))success
             failure:(void (^)(NSError *error))failure {
    
}

- (void)editCustom:(ScheduleCourse *)course
           success:(void (^)(void))success
           failure:(void (^)(NSError * _Nonnull))failure {
    
}

- (void)deleteCustom:(ScheduleCourse *)course
             success:(void (^)(void))success
             failure:(void (^)(NSError * _Nonnull))failure {
    
}

@end
