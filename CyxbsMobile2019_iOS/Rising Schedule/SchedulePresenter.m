//
//  SchedulePresenter.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/24.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "SchedulePresenter.h"

#pragma mark - SchedulePresenter ()

@interface SchedulePresenter ()

@end

@implementation SchedulePresenter

#pragma mark - RisingRouterHandler

+ (NSArray<NSString *> *)routerPath {
    return @[
        ScheduleRouterName
    ];
}

+ (void)responseRequest:(RisingRouterRequest *)request completion:(RisingRouterResponseBlock)completion {
    
    RisingRouterResponse *response = [[RisingRouterResponse alloc] init];
    
    ScheduleController *vc = [[self alloc] init];
    NSDictionary *params = request.parameters;
    
    switch (request.requestType) {
        case RouterRequestController: {
            response.responseController = vc;
        }
        case RouterRequestPush: {
            
            UINavigationController *nav = (request.requestController ? request.requestController : RisingRouterRequest.useTopController).navigationController;
            
            (nav ? [nav pushViewController:vc animated:YES] :
                   (response.errorCode = RouterWithoutNavagation));
            
        } break;
            
        case RouterRequestParameters: {
        } break;
    }
    
    if (completion) {
        completion(response);
    }
}

@end

@implementation RisingRouterRequest (ScheduleRouterProtocol)



@end
