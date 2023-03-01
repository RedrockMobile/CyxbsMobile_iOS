//
//  ScheduleCustomViewController.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/1/18.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ScheduleCourse.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScheduleCustomViewController : UIViewController

@property (nonatomic, strong) ScheduleCourse *courseIfNeeded;

@end

NS_ASSUME_NONNULL_END
