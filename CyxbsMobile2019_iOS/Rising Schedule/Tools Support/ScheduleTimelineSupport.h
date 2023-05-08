//
//  ScheduleTimelineSupport.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/12/28.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**SchedulePartTimeline
 * `weekday, hour, minute, second` are all rights
 * within `others are wrong`
 * weekday is true in [1, 7]
 */

@interface SchedulePartTimeline : NSObject <NSCopying>

@property (nonatomic, copy) NSString *title;

/// dateComponents for `from`
@property (nonatomic, copy) NSDateComponents *fromComponents;

/// dateComponents for `to`
@property (nonatomic, copy) NSDateComponents *toComponents;

@end



typedef NS_ENUM(NSUInteger, ScheduleTimelineType) {
    ScheduleTimelineSimple,
    ScheduleTimelineNoon,
    ScheduleTimelineNight,
    ScheduleTimelineNoonAndNight
};

@interface ScheduleTimeline : NSObject

/// default is ScheduleTimelineSimple
@property (nonatomic) ScheduleTimelineType type;

/// [12, 14]
- (NSUInteger)count;

/// position: [1, 14] or null
- (nullable SchedulePartTimeline *)partTimelineAtPosition:(NSUInteger)position;

/// location: [1, 14];  lenth: [1, 14]
- (NSRange)layoutRangeWithOriginRange:(NSRange)range;

@property (nonatomic, readonly) CGFloat percent;

- (void)setSectionMdFrom:(NSDate *)date section:(NSUInteger)section;
@property (nonatomic, copy) NSDate *sectionMd;

@end

NS_ASSUME_NONNULL_END





#if __has_include("ScheduleCourse.h")
#import "ScheduleCourse.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScheduleTimeline (ScheduleCourse)

+ (SchedulePartTimeline *)partTimeLineWithCouse:(ScheduleCourse *)course;

@end

NS_ASSUME_NONNULL_END

#endif
