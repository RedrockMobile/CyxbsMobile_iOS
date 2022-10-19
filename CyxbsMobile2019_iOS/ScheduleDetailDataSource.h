//
//  ScheduleDetailDataSource.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/10/18.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ScheduleCourse.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScheduleDetailDataSource : NSObject

- (instancetype)datasourceWithCourses:(NSArray <ScheduleCourse *> *)courses;

@end

NS_ASSUME_NONNULL_END
