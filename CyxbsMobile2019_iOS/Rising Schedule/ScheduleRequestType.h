//
//  ScheduleRequestType.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/9/4.
//  Copyright © 2022 Redrock. All rights reserved.
//

#ifndef ScheduleRequestType_h
#define ScheduleRequestType_h

#pragma mark - ScheduleModelRequestType

typedef NSString * ScheduleModelRequestType;

// MARK: KEY

/// 学生
FOUNDATION_EXPORT ScheduleModelRequestType _Nonnull ScheduleModelRequestStudent;

/// 老师
FOUNDATION_EXPORT ScheduleModelRequestType _Nonnull ScheduleModelRequestTeacher;

/// 自定义
FOUNDATION_EXPORT ScheduleModelRequestType _Nonnull ScheduleModelRequestCustom;

// MARK: Method

/// 获取API
FOUNDATION_EXPORT NSString * _Nullable API_forScheduleModelRequestType(const ScheduleModelRequestType _Nonnull);

/// 获取KEY
FOUNDATION_EXPORT NSString * _Nullable KeyInParameterForScheduleModelRequestType(const ScheduleModelRequestType _Nonnull);

#endif /* ScheduleRequestType_h */
