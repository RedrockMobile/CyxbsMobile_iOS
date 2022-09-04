//
//  RisingRouterRequest+Schedule.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/9/4.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "RisingRouterRequest+Schedule.h"

#import "ScheduleRouterProtocol.h"

@implementation RisingRouterRequest (Schedule)

+ (instancetype)requestWithScheduleBolck:(void (^)(id<ScheduleRouterProtocol> _Nonnull))block {
    NSMutableDictionary *dic = NSMutableDictionary.dictionary;
    RisingRouterRequest *request = [RisingRouterRequest requestWithRouterPath:ScheduleRouterName parameters:dic];
    
    return request;
}

@end
