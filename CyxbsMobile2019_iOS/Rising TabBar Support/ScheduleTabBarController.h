//
//  ScheduleTabBarController.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/10/12.
//  Copyright © 2022 Redrock. All rights reserved.
//

/**标准型App中，都会自定义UITabBarController
 * 所有关于TabBar的Cotroller都在这里管理
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ScheduleTabBar;

@interface ScheduleTabBarController : UITabBarController

@property (nonatomic, getter=isScheduleBarHidden) BOOL scheduleBarHidden;

- (void)presentScheduleControllerWithPan:(UIPanGestureRecognizer * _Nullable)pan completion:(void (^ __nullable)(UIViewController *vc))completion;

- (void)presentControllerWhatIfNeeded;

- (void)reloadScheduleBar;

@end

NS_ASSUME_NONNULL_END
