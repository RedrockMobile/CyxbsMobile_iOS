//
//  SchedulePresenter.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/24.
//  Copyright © 2022 Redrock. All rights reserved.
//

/**SchedulePresenter业务线
 * 充当与路由的搭配业务
 * 路由的类引入@"ScheduleRouterProtocol.h"
 * 路由名：ScheduleRouterName
 * 参数：请使用RisingRouterRequest
 */

#import <Foundation/Foundation.h>

#import "ScheduleController.h"

#import "ScheduleInteractorMain.h"

#import "ScheduleRouterProtocol.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - SchedulePresenter

@interface SchedulePresenter : NSObject <
    RisingRouterHandler
>

/// 控制器
@property (nonatomic, weak) ScheduleController *controller;

/// 请求
@property (nonatomic, strong) NSDictionary *firstRequetDic;

/// 主业务(由控制器创建)
@property (nonatomic, strong, nullable) ScheduleInteractorMain *interactoerMain;

@end

NS_ASSUME_NONNULL_END
