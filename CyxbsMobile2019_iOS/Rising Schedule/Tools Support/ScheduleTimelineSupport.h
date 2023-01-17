//
//  ScheduleTimelineSupport.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/12/28.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SchedulePartTimeline : NSObject

/// dateComponents for `from`, default is nil;
@property (nonatomic, copy) NSDateComponents *fromComponents;

/// dateComponents for `to`, default is nil;
@property (nonatomic, copy) NSDateComponents *toComponents;

- (instancetype)initWithFastBlock:(void (^)(NSDateComponents *from, NSDateComponents *to))block;

@end




typedef NSString * ScheduleTimelineSuiteName NS_STRING_ENUM;

@interface ScheduleTimeline : NSObject

@property (class, readonly, strong) ScheduleTimeline *standardTimeLine;

/// return `- initWithSuiteName: nil`
- (instancetype)init;

/// if `ScheduleTimelineStandard`, return standardTimeLine
/// - Parameter suitename: a kind of Timeline type
- (nullable instancetype)initWithSuiteName:(nullable ScheduleTimelineSuiteName)suitename;

- (NSUInteger)count;

/// you can use Subscript like `timeline[1]`
/// - Parameter index: a number in`[0, count)`
- (SchedulePartTimeline *)objectAtIndexedSubscript:(NSUInteger)idx;

- (CGFloat)percentWithDateComponents:(NSDateComponents *)compnents;

@end

FOUNDATION_EXPORT ScheduleTimelineSuiteName const ScheduleTimelineStandard;

FOUNDATION_EXPORT ScheduleTimelineSuiteName const ScheduleTimelineNoon __deprecated_msg("未规划的");

FOUNDATION_EXPORT ScheduleTimelineSuiteName const ScheduleTimelineNight __deprecated_msg("未规划的");

FOUNDATION_EXPORT ScheduleTimelineSuiteName const ScheduleTimelineNoonAndNight __deprecated_msg("未规划的");


NS_ASSUME_NONNULL_END
