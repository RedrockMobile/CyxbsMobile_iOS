//
//  ScheduleInteractorMain.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/9/4.
//  Copyright © 2022 Redrock. All rights reserved.
//

/**ScheduleInteractorMain主业务线
 * 主要布局所有的视图与交互
 * 主业务线会掉用其他业务
 * 应将控制器controller赋值
 */

#import <UIKit/UIKit.h>

#import "ScheduleModel.h"

#import "ScheduleRequestType.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScheduleInteractorMain : NSObject <
    UICollectionViewDelegate,
    UICollectionViewDataSource
>

/// 控制器
@property (nonatomic, weak) UIViewController *controller;

/// 以双人课表显示视图(默认NO)
@property (nonatomic) BOOL showWithDifferentStu;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

/// 创建业务
/// @param view 视图
/// @param model 模型
/// @param dic 数据
+ (instancetype)interactorWithCollectionView:(UICollectionView *)view
                               scheduleModel:(ScheduleModel *)model
                                     request:(NSDictionary
                                              <ScheduleModelRequestType, NSArray
                                              <NSString *> *> *)dic;

@end

NS_ASSUME_NONNULL_END
