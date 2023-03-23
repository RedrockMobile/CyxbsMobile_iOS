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

#import "ScheduleTouchItem.h"
#import "ScheduleDetailPartContext.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - ScheduleModel

@interface ScheduleModel : ScheduleMapModel

@property (nonatomic, readonly) NSUInteger showWeek;

@property (nonatomic, readonly) ScheduleTouchItem *touchItem;

@property (nonatomic, readonly) NSArray <NSArray <NSIndexPath *> *> *courseIdxPaths;

/// 返回同一时间段的所有重复课程
/// 传进来的idxPath，至少week和location位置有值
- (NSArray <ScheduleDetailPartContext *> *)contextsWithLocationIdxPath:(NSIndexPath *)idxPath;

- (void)changeCustomTo:(ScheduleCombineItem *)item;

@end

NS_ASSUME_NONNULL_END
