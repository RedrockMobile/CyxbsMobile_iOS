//
//  ScheduleController.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/24.
//  Copyright © 2022 Redrock. All rights reserved.
//

/**ScheduleController课表控制器
 * 由于Presenter和Controller之间持有关系，
 * controller强持有presenter，而presenter弱持有controller
 * 创建一个SchedulePresenter以保证此controller的数据与代理
 * SchedulePresenter负责所有的**驱动管理**
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SchedulePresenter;

@interface ScheduleController : UIViewController

/// 掉用者
@property (nonatomic, strong, readonly) SchedulePresenter *presenter;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

/// 创建并持有掉用者
/// @param presenter 掉用者
- (instancetype)initWithPresenter:(SchedulePresenter *)presenter;

@end

NS_ASSUME_NONNULL_END
