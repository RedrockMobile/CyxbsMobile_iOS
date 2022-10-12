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

@end
