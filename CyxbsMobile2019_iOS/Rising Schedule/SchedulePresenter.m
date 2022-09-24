//
//  SchedulePresenter.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/24.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "SchedulePresenter.h"

#pragma mark - SchedulePresenter

@implementation SchedulePresenter

- (instancetype)init {
    self = [super init];
    if (self) {
        self.delegateService = [[ScheduleServiceDelegate alloc] init];
        self.dataSourceService = [ScheduleServiceDataSource dataSourceServiceWithModel:self.delegateService.model];
    }
    return self;
}

/// 识别码注入
/// @param request 识别码：查询类型和学号
- (void)parameterWithRequest:(ScheduleRequestDictionary *)request {
    self.delegateService.parameterIfNeeded = request;
}

- (UIViewController *)controllerWithStylePush:(BOOL)push panAllowed:(BOOL)pan {
    ScheduleController *controller = [[ScheduleController alloc] initWithPresenter:self];
    controller.hidesBottomBarWhenPushed = YES;
    controller.isPushStyle = push;
    self.controller = controller;
    return controller;
}













#pragma mark - RisingRouterHandler

+ (NSArray<NSString *> *)routerPath {
    return @[
        ScheduleRouterName
    ];
}

+ (void)responseRequest:(RisingRouterRequest *)request completion:(RisingRouterResponseBlock)completion {
    NSDictionary *params = request.parameters;
    
    // schedule presenter
    SchedulePresenter *presenter = [[SchedulePresenter alloc] init];
    
    // router response
    RisingRouterResponse *response = [[RisingRouterResponse alloc] init];
    
    __block UIViewController *vc;
    BOOL pushSyle = YES;
    BOOL pan = NO;
    ScheduleRequestDictionary *dic;
    if (params[@"pushStyle"]) {
        vc = presenter.controller;
        pushSyle = [params[@"pushStyle"] boolValue];
    }
    if (params[@"panAllowed"]) {
        vc = presenter.controller;
        pan = [params[@"panAllowed"] boolValue];
    }
    if (params[@"request"]) {
        dic = params[@"request"];
    }
    
    vc = [presenter controllerWithStylePush:pushSyle panAllowed:pan];
    [presenter parameterWithRequest:dic];
    
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
