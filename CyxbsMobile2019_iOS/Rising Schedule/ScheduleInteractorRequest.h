//
//  ScheduleInteractorRequest.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/23.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ScheduleModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSString * ScheduleModelRequestType;

@interface ScheduleInteractorRequest : NSObject

#pragma mark - Method

/// 请求数据
/// @param requestDictionary 一种字典，记录如下
/// 1) 个人课表 @{student : @[@"2021215154"]}
/// 2) 多人课表 @{student : @[@"2021215154", @"2021215179"]}
/// 3) 老师课表 @{teacher : @[@"040107"]}
/// 4) 混合课表 @{student : @[@"2021215154"], teacher : @[@"040107"]}
/// @param success 成功返回
/// @param failure 失败返回
- (void)request:(NSDictionary
                 <ScheduleModelRequestType, NSArray
                 <NSString *> *> *)requestDictionary
        success:(void (^)(NSProgress *progress))success
        failure:(void (^)(NSError *error))failure;

@end

#pragma mark - ScheduleModelRequestType

/// 学生
FOUNDATION_EXPORT ScheduleModelRequestType student;

/// 老师
FOUNDATION_EXPORT ScheduleModelRequestType teacher;

/// 自定义
FOUNDATION_EXPORT ScheduleModelRequestType custom __deprecated_msg("待测试接口");

NS_ASSUME_NONNULL_END
