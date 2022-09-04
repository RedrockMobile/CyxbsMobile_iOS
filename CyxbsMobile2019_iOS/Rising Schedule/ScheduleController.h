//
//  ScheduleController.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/24.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SchedulePresenter;

@interface ScheduleController : UIViewController

/// 掉用者
@property (nonatomic, weak) SchedulePresenter *presenter;

/// 新增事务手势
/// (默认为NO）
@property (nonatomic) BOOL allowCustomPan;

@end

NS_ASSUME_NONNULL_END
