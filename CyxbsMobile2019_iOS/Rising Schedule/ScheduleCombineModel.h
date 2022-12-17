//
//  ScheduleCombineModel.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/28.
//  Copyright © 2022 Redrock. All rights reserved.
//

/**ScheduleCombineModel绑定模型
 * 利用这个模型，在多人查询，可以特别特别快的展示出数据，
 * 实现用户对视觉感知度的提升，性能也能达到不重复请求解决问题
 */

#import <Foundation/Foundation.h>

#import "NSIndexPath+Schedule.h"

#import "ScheduleCourse.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - ScheduleCombineModel

@interface ScheduleCombineModel : NSObject

/// 学号，可以确定唯一性
@property (nonatomic, copy, readonly) NSString *sno;

/// 绑定类型，由“系统”/“自定义”决定
@property (nonatomic, copy, readonly) ScheduleModelRequestType requestType;

/// 当周
@property (nonatomic) NSInteger nowWeek;

/// 唯一标识
/// (计算属性：combineType + sno)
@property (nonatomic, readonly) NSString *identifier;

/// 课程信息
/// when you - setCourseAry:, the transMap will immediately show
@property (nonatomic, strong, null_resettable) NSArray <ScheduleCourse *> *courseAry;

/// 由courseAry转换成map
/// key对象来源于NSIndexPath+Schedule，采用strong，hash/isEqual粒度为location
/// value对象来源于courseAry，采用week
@property (nonatomic, strong, readonly) NSMapTable <NSIndexPath *, ScheduleCourse *> *transMap;

//- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

/// 建立连立模型
/// @param sno 学号
/// @param type 方式
- (instancetype)initWithSno:(NSString *)sno type:(ScheduleModelRequestType)type;

@end





/// !!!: 由于各种原因，这里建议查看飞书云文档
#pragma mark - ScheduleCombineModel (XXHB)

#ifndef XXHB

@interface ScheduleCombineModel (XXHB)

/// 缓存
@property (nonatomic, readonly, copy, class) NSString *path __deprecated_msg("⚠️");

/// 替换缓存
- (void)replace __deprecated_msg("⚠️");

/// 从缓存中取
- (void)awake __deprecated_msg("⚠️");

@end

#endif

NS_ASSUME_NONNULL_END
