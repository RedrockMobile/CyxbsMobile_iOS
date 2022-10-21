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

#import <Foundation/Foundation.h>

#import "ScheduleCombineModel.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - ScheduleModel

@interface ScheduleModel : NSObject

/// 开始的时间
@property (nonatomic, readonly, nonnull) NSDate *startDate;

/// 当周
/// 0代表整周
/// setter里面为once
@property (nonatomic) NSUInteger nowWeek;

/// 当前在上课/最近一次要上的课
/// 如果今天课程结束了，就会返回nil
@property (nonatomic, readonly, nullable) ScheduleCourse *nowCourse __deprecated_msg("还没写");

/// 主学号(如果是双人课表，则会以这个进行判断)
/// (而事务则是由ScheduleCombineType去判断)
@property (nonatomic, copy) NSString *sno __deprecated_msg("没用到");

#pragma mark !!!: - 需要重构

/// 课程数组
@property (nonatomic, readonly, nonnull) NSMutableArray <NSMutableArray <ScheduleCourse *> *> *courseAry;

/// 连立一个模型
/// 如果已经根据id连立，则取消该次连立
/// @param model 连立模型
- (void)combineModel:(ScheduleCombineModel *)model;

/// 再次建立联系
/// 如果没有找到，debug会报错
/// 如果模型进行了修改，也使用该方法绑定
/// @param identifier 唯一key值
- (void)recombineWithIdentifier:(NSString *)identifier;

/// 取消连立一个模型
/// 这里不会直接取消内存，你可以根据当时combine的sno再次建立链接
/// @param model 连立模型
- (void)separateModel:(ScheduleCombineModel *)model;

- (NSArray <ScheduleCourse *> *)coursesWithCourse:(ScheduleCourse *)course inWeek:(NSInteger)inweek;

@end

NS_ASSUME_NONNULL_END
