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
        self.delegateInteractor = [[ScheduleInteractorDelegate alloc] init];
        self.dataSourceInteractor = [[ScheduleInteractorDataSource alloc] init];
        
        self.dataSourceInteractor.model = self.delegateInteractor.model;
    }
    return self;
}

- (void)parameterWithRequest:(ScheduleRequestDictionary *)request {
    self.delegateInteractor.parameterIfNeeded = request;
}

- (UIViewController *)controllerWithStylePush:(BOOL)push panAllowed:(BOOL)pan {
    ScheduleController *controller = [[ScheduleController alloc] initWithPresenter:self];
    controller.hidesBottomBarWhenPushed = YES;
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
    
    // requestModel in parameter
    NSMutableDictionary *dic =
    params[@"requestModel"]
    ? [params[@"requestModel"] mutableCopy]
    : @{
        ScheduleModelRequestStudent : @[UserItemTool.defaultItem.stuNum]
    }.mutableCopy;
    if (params[@"custom"]) {
        dic[ScheduleModelRequestCustom] = @[@"Rising"];
    }
        
    // view controller
    ScheduleController *vc = [[ScheduleController alloc] initWithPresenter:self];
    presenter.controller = vc;

    vc.hidesBottomBarWhenPushed = YES;
    vc.isPushStyle = params[@"pushStyle"] ? [params[@"pushStyle"] boolValue] : YES;
    
    // router response
    RisingRouterResponse *response = [[RisingRouterResponse alloc] init];
    
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
