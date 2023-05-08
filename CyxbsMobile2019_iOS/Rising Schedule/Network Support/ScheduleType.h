//
//  ScheduleType.h
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

FOUNDATION_EXPORT ScheduleModelRequestType const ScheduleModelRequestStudent; // 请求学生
FOUNDATION_EXPORT ScheduleModelRequestType const ScheduleModelRequestTeacher; // 请求老师
FOUNDATION_EXPORT ScheduleModelRequestType const ScheduleModelRequestCustom; // 请求事务

FOUNDATION_EXPORT ScheduleModelRequestType const ScheduelModelRequestTypeForString(NSString *str);



typedef NSString * ScheduleWidgetCacheKeyName NS_STRING_ENUM;
FOUNDATION_EXTERN ScheduleWidgetCacheKeyName const ScheduleWidgetCacheKeyMain;
FOUNDATION_EXPORT ScheduleWidgetCacheKeyName const ScheduleWidgetCacheKeyCustom;
FOUNDATION_EXTERN ScheduleWidgetCacheKeyName const ScheduleWidgetCacheKeyOther;

typedef NS_ENUM(NSUInteger, ScheduleModelShowType) {
    ScheduleModelShowGroup = 0,
    ScheduleModelShowSingle = 1,
    ScheduleModelShowDouble = 2
};

NS_ASSUME_NONNULL_END

#endif /* ScheduleRequestType_h */
