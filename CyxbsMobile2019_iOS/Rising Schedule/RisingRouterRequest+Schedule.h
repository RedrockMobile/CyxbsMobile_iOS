//
//  RisingRouterRequest+Schedule.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/9/4.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "RisingRouterRequest.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ScheduleRouterProtocol;

@interface RisingRouterRequest (Schedule)

+ (instancetype)requestWithScheduleBolck:(void (^ _Nullable)(id <ScheduleRouterProtocol> make))block;

@end

NS_ASSUME_NONNULL_END
