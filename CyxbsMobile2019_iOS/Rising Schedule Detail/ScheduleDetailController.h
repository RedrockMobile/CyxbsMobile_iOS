//
//  ScheduleDetailController.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/10/16.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ScheduleCourse.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScheduleDetailController : UIViewController

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithCourses:(NSArray <ScheduleCourse *> *)courses;

/// a selector
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
