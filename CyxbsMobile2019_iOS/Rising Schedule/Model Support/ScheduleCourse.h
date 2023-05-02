//
//  ScheduleCourse.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/23
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ScheduleType.h"

NS_ASSUME_NONNULL_BEGIN

@class ScheduleTimeline;

/**MARK: ScheduleCourse
 * 一类课程的体现，具体表现在`inSections`
 * 注意，不满足`NSCopying`协议
 */

@interface ScheduleCourse : NSObject <NSSecureCoding>

// !!!: Time

/// 在星期几1-7
@property (nonatomic) NSInteger inWeek;

/// 所在周散列表
@property (nonatomic, copy) NSIndexSet *inSections;

/// 第几-几节课，中午为4-5，晚上为8-9
@property (nonatomic) NSRange period;
/// 几点 - 几点
@property (nonatomic, readonly) NSString *timeStr;

// !!!: Source

/// 课程名
@property (nonatomic, copy) NSString *course;
/// 课程别名（以后可能要用到）
@property (nonatomic, copy) NSString *courseNike;

/// 地点
@property (nonatomic, copy) NSString *classRoom;

/// 地点别名（以后可能要用到）
@property (nonatomic, copy) NSString *classRoomNike;

/// 课程号
@property (nonatomic, copy) NSString *courseID;

/// 循环周期
@property (nonatomic, copy) NSString *rawWeek;

/// 选修类型
@property (nonatomic, copy) NSString *type;

/// 老师
@property (nonatomic, copy) NSString *teacher;

/// @“xx节”
@property (nonatomic, copy) NSString *lesson;

#pragma mark - Method

/// 根据字典来赋值
/// @param dic 字典（这里必须看文档，注意使用）
- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
