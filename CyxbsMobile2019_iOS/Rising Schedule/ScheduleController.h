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
 * 在视图加载后，重新赋值掉用者可以瞬间reload
 * 当然，使用self.presenter = self.presenter也可以触发
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SchedulePresenter;

@interface ScheduleController : UIViewController

/// 掉用者
@property (nonatomic, strong) SchedulePresenter *presenter;

/// 新增事务手势
/// (默认为NO）
@property (nonatomic) BOOL allowCustomPan; // TODO: gesture when pan empty collection view

@end

NS_ASSUME_NONNULL_END
