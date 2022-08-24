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
 * 非常注意这点，在维护的时候尽量使用提供的进行维护
 * 没课约也可以采取这个模型，且按需求书写业务逻辑
 */

#import <Foundation/Foundation.h>

#import "ScheduleCourse.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - ScheduleModel

@interface ScheduleModel : NSObject

/// 开始的时间
@property (nonatomic, readonly, nonnull) NSDate *startDate;

/// 唯一标识，记录如下
/// 1) 仅用于本地缓存业务，且为DB的路径
/// 2) identifier的算法请自行解决
/// 3) 没课约可用identifier算法进行缓存业务
@property (nonatomic, copy) NSString *identifier;

/// 当周
/// 0代表整周
/// setter里面为once
@property (nonatomic) NSUInteger nowWeek;

/// 课程数组
@property (nonatomic, readonly, nonnull) NSMutableArray <NSMutableArray <ScheduleCourse *> *> *courseAry;

/// 新增一类课，同时在整周添加
/// @param course 课程
- (void)appendCourse:(ScheduleCourse *)course;

/// 删除一类课，同时在整周删除
/// @param course 课程
- (void)removeCourse:(ScheduleCourse *)course;

@end

NS_ASSUME_NONNULL_END
