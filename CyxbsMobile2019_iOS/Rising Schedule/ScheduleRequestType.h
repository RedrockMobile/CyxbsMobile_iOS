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

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**MARK: ScheduleModelRequestType
 * a kind of STRING ENUM
 * ScheduleRequestDictionary sames as:
 * @{
 *      ScheduleModelRequestStudent : @[
 *          @"2021215154",
 *          @"2021215179"],
 *      ScheduleModelRequestTeacher : @[
 *          @"040107"],
 *      ScheduleModelRequestCustom : @[@""]
 * }
 */

typedef NSString * ScheduleModelRequestType NS_STRING_ENUM;

typedef NSDictionary
    <ScheduleModelRequestType, NSArray
    <NSString *> *> ScheduleRequestDictionary;

// MARK: KEY

/// 学生
FOUNDATION_EXPORT ScheduleModelRequestType const ScheduleModelRequestStudent;

/// 老师
FOUNDATION_EXPORT ScheduleModelRequestType const ScheduleModelRequestTeacher;

/// 自定义 mutable
FOUNDATION_EXPORT ScheduleModelRequestType const ScheduleModelRequestCustom;

NS_ASSUME_NONNULL_END

#endif /* ScheduleRequestType_h */
