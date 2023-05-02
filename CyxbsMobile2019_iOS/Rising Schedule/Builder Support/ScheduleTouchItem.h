//
//  ScheduleTouchItem.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/1/26.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScheduleCombineItemSupport.h"
#import "ScheduleCourse.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScheduleTouchItem : NSObject <NSCopying, NSSecureCoding>

/// 连立的课程，会通过一系列算法得到下面的所有数据
@property (nonatomic, strong, nullable) ScheduleCombineItem *combining;

/// 开始的时间，nil表示不可用
@property (nonatomic, readonly, nullable, copy) NSDate *startDate;

/// 当周(0代表整周)，有可能为负数
@property (nonatomic, readonly) NSInteger nowWeek;

/// 表示最后一周是哪一周。如果为0，则表示不可用
@property (nonatomic, readonly) NSUInteger lastSection;

/// 当前正在上课/下一节课/当天已经没有课
@property (nonatomic, readonly, nullable) ScheduleCourse *floorCourse;

@end

NS_ASSUME_NONNULL_END
