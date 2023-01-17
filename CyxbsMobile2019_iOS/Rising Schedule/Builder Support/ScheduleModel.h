//
//  ScheduleModel.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/2.
//  Copyright © 2022 Redrock. All rights reserved.
//

/**课表ScheduleModel模型
 * 通过Array只保存指针的机制，达到数据只有**n类**个
 * 会在不同的下标子array保存相同的数据模型
 * 非常注意这点，在维护的时候尽量使用combine模型
 * combine模型声明了一系列好用的模型数据
 * 我们会根据sno与combineType建立map表
 *
 * 不同的数据都应该为不同的combine模型
 */

#import "ScheduleMapModel.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - ScheduleModel

@interface ScheduleModel : ScheduleMapModel

/// 开始的时间
@property (nonatomic, readonly, nonnull) NSDate *startDate;

/// 当周(0代表整周)
@property (nonatomic, readonly) NSUInteger nowWeek;

@property (nonatomic, readonly) NSArray <NSArray <NSIndexPath *> *> *courseIdxPaths;

/// 当前在上课/最近一次要上的课
/// 如果今天课程结束了，就会返回nil
@property (nonatomic, readonly, nullable) ScheduleCourse *nowCourse;

@property (nonatomic, readonly) CGFloat percentOfLocation;

/// 返回同一时间段的所有重复课程
/// 传进来的idxPath，至少week和location位置有值
- (NSArray <ScheduleCourse *> *)coursesWithLocationIdxPath:(NSIndexPath *)idxPath;

@end

NS_ASSUME_NONNULL_END
