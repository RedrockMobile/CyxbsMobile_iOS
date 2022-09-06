//
//  ScheduleRouterProtocol.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/9/4.
//  Copyright © 2022 Redrock. All rights reserved.
//

/**ScheduleRouterProtocol协议
 * 需要到课表业务的请引入这个协议
 * 并且只能使用RisingRouterRequest
 * 请查看“RisingRouterRequest+Schedule.h”扩展提供的API
 */

#import <Foundation/Foundation.h>

#import "RisingRouterRequest+Schedule.h"

#import "ScheduleRequestType.h"

NS_ASSUME_NONNULL_BEGIN

/// 路由名
static NSString *ScheduleRouterName = @"SchedulePresenter";

#pragma mark - ScheduleRouterProtocol

@protocol ScheduleRouterProtocol <NSObject>

@required

/// 是否需要事务手势
- (id <ScheduleRouterProtocol> (^) (BOOL))allowCustomPan;

/// 是否第一次需要事务
- (id <ScheduleRouterProtocol> (^) (BOOL))needCustomFirst;

/// 是否是push布局
- (id <ScheduleRouterProtocol> (^) (BOOL))isPushStyle;

/// 设置请求学生信息
- (id <ScheduleRouterProtocol> (^)
   (NSDictionary
    <ScheduleModelRequestType, NSArray
    <NSString *> *> *))request;

@end

NS_ASSUME_NONNULL_END
