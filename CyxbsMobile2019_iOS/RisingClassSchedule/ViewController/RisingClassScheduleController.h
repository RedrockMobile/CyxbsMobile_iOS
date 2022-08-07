//
//  ClassBookController.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/6/3.
//  Copyright © 2022 Redrock. All rights reserved.
//

/**重构的课表
 * 6.13日已完成基本操作
 * >>> 未完成装饰
 * >>> 未完成多人，以及老师
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - ClassBookController

@interface RisingClassScheduleController : UIViewController <
    RisingRouterHandler
>

- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
