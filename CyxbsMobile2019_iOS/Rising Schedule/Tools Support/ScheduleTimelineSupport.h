//
//  ScheduleTimelineSupport.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/12/28.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SchedulePartTimeline : NSObject <NSCopying>

@property (nonatomic, copy) NSString *title;

/// dateComponents for `from`
@property (nonatomic, copy) NSDateComponents *fromComponents;

/// dateComponents for `to`
@property (nonatomic, copy) NSDateComponents *toComponents;

@end





typedef NS_OPTIONS(NSUInteger, ScheduleTimelineType) {
    ScheduleTimelineSimple = 1 << 0,
    ScheduleTimelineNoon = 1 << 1,
    ScheduleTimelineNight = 1 << 2,
    
    ScheduleTimelineSimpleNoon = (ScheduleTimelineSimple | ScheduleTimelineNoon),
    ScheduleTimelineSimpleNight = (ScheduleTimelineSimple | ScheduleTimelineNight),
    ScheduleTimelineAll = (ScheduleTimelineSimple | ScheduleTimelineNoon | ScheduleTimelineNight)
};

@interface ScheduleTimeline : NSObject

/// default is ScheduleTimelineSimple
@property (nonatomic) ScheduleTimelineType type;

- (NSUInteger)count;
- (SchedulePartTimeline *)objectAtIndexedSubscript:(NSUInteger)idx;

+ (SchedulePartTimeline *)partTimeLineForOriginRange:(NSRange)range;

- (NSRange)layoutRangeWithOriginRange:(NSRange)range;

- (CGFloat)percentWithComponents:(NSDateComponents *)componets;

@end



NS_ASSUME_NONNULL_END
