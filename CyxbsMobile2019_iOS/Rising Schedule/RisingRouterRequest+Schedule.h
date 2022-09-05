//
//  RisingRouterRequest+Schedule.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/9/4.
//  Copyright © 2022 Redrock. All rights reserved.
//

/**RisingRouterRequest (Schedule)课表业务扩展
 * 路由的类引入@"ScheduleRouterProtocol.h"
 * 这个类不需要被直接引入
 */

#import "RisingRouterRequest.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ScheduleRouterProtocol;

#pragma mark - RisingRouterRequest (Schedule)

@interface RisingRouterRequest (Schedule)

/// 课表业务，不传入则默认
/// 记录如下：
/// 1) 个人课表
/// 2) 事务课表
/// 3) 需要手势
/// @param block 业务block
+ (instancetype)requestWithScheduleBolck:(void (^ _Nullable)(id <ScheduleRouterProtocol> make))block;

@end

NS_ASSUME_NONNULL_END
