//
//  SchedulePresenter.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/24.
//  Copyright © 2022 Redrock. All rights reserved.
//

/**SchedulePresenter业务线
 * 充当与路由的搭配业务
 * 
 */

#import <Foundation/Foundation.h>

#import "ScheduleRouterProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface SchedulePresenter : NSObject <
    RisingRouterHandler
>

@end

NS_ASSUME_NONNULL_END
