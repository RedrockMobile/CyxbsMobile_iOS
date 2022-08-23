//
//  ScheduleModel.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/2.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ScheduleCourse.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - ScheduleModel

@interface ScheduleModel : NSObject

/// 开始的时间
@property (nonatomic, readonly) NSDate *startDate;

/// 当周
/// 0代表整周
@property (nonatomic, readonly) NSUInteger nowWeek;

/// 课程
@property (nonatomic, readonly) NSArray <NSArray <ScheduleCourse *> *> *courseAry;

@end

NS_ASSUME_NONNULL_END
