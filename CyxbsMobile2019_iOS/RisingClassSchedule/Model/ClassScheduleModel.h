//
//  ClassScheduleModel.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/2.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SchoolLesson.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSString * ClassScheduleRequestType;

#pragma mark - ClassScheduleModel

@interface ClassScheduleModel : NSObject

/// 开始的时间
@property (nonatomic, readonly) NSDate *startDate;

/// 当周
@property (nonatomic, readonly) NSUInteger nowWeek;

/// 课程
@property (nonatomic, readonly) NSArray <NSArray <SchoolLesson *> *> *classModel;

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
                 <ClassScheduleRequestType, NSArray
                 <NSString *> *> *)requestDictionary
        success:(void (^)(NSProgress *progress))success
        failure:(void (^)(NSError *error))failure;

- (void)append:(SchoolLesson *)lesson __deprecated_msg("还没写");

@end

#pragma mark - ClassScheduleRequestType

/// 学生
FOUNDATION_EXPORT ClassScheduleRequestType student;

/// 老师
FOUNDATION_EXPORT ClassScheduleRequestType teacher;

NS_ASSUME_NONNULL_END
