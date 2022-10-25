//
//  ScheduleRequestType.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/9/4.
//  Copyright © 2022 Redrock. All rights reserved.
//

/**ScheduleModelRequestType请求式
 * 为了满足各种业务，这里成列了各种KEY
 * KEY为所有有关课表展示业务的请求
 */

#ifndef ScheduleRequestType_h
#define ScheduleRequestType_h

NS_ASSUME_NONNULL_BEGIN

#pragma mark - ScheduleModelRequestType

typedef NSString * ScheduleModelRequestType NS_STRING_ENUM;

typedef NSDictionary
    <ScheduleModelRequestType, NSArray
    <NSString *> *> ScheduleRequestDictionary;

// MARK: KEY

/// 学生
FOUNDATION_EXPORT ScheduleModelRequestType const ScheduleModelRequestStudent;

/// 老师
FOUNDATION_EXPORT ScheduleModelRequestType const ScheduleModelRequestTeacher;

/// 自定义
FOUNDATION_EXPORT ScheduleModelRequestType const ScheduleModelRequestCustom;

// MARK: Method

/// 获取API
FOUNDATION_EXPORT NSString * _Nullable API_forScheduleModelRequestType(const ScheduleModelRequestType _Nonnull);

/// 获取KEY
FOUNDATION_EXPORT NSString * _Nullable KeyInParameterForScheduleModelRequestType(const ScheduleModelRequestType _Nonnull);

NS_ASSUME_NONNULL_END


#endif /* ScheduleRequestType_h */
