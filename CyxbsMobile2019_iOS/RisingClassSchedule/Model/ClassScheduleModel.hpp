//
//  ClassScheduleModel.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/2.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <array>

#import "SchoolLesson.h"

#import "ClassScheduleModelDelegate.h"

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

/// 快速表
/// 0 : 无课
/// 1 : 其他人单
/// 2 : 其他人多
/// 3 : 自定义单
/// 4 : 自定义多
/// 5 : 单人课单
/// 6 : 单人课多
@property (nonatomic, readonly) std::array <std::array <std::array <int, 13>, 8>, 25> fastAry;

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

- (void)append:(SchoolLesson *)lesson __deprecated_msg("测试中");

@end

#pragma mark - ClassScheduleRequestType

/// 学生
FOUNDATION_EXPORT ClassScheduleRequestType student;

/// 自定义
FOUNDATION_EXPORT ClassScheduleRequestType custom __deprecated_msg("不知道接口");

/// 老师
FOUNDATION_EXPORT ClassScheduleRequestType teacher;

NS_ASSUME_NONNULL_END
