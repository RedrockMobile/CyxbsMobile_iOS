//
//  SchedulePresenter.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/24.
//  Copyright © 2022 Redrock. All rights reserved.
//

/**SchedulePresenter驱动器
 * - 充当与路由的搭配业务，路由的类引入@"ScheduleRouterProtocol.h"
 * - 控制器驱动： controller
 * - 数据源驱动： dataSourceService
 * - 代理源驱动： delegateService
 */

#import <Foundation/Foundation.h>

#import "ScheduleController.h"

#import "ScheduleServiceDataSource.h"

#import "ScheduleServiceDelegate.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - SchedulePresenter

@interface SchedulePresenter : NSObject 

/// 控制器（不用赋值，会自动生成）
@property (nonatomic, weak) ScheduleController *controller;

/// dataSource业务
@property (nonatomic, readonly) ScheduleServiceDataSource *dataSourceService;

/// 响应式业务
@property (nonatomic, readonly) ScheduleServiceDelegate *delegateService;

/// 重设模型数据
@property (nonatomic, strong) ScheduleModel *model;

@end

NS_ASSUME_NONNULL_END