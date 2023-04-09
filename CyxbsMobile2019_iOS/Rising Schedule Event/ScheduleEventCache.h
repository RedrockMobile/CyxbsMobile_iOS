//
//  ScheduleEventCache.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/4/8.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "ScheduleWidgetCache.h"

NS_ASSUME_NONNULL_BEGIN

typedef ScheduleWidgetCache ScheduleEventCache;

typedef NSString * ScheduleEventCacheEventName NS_STRING_ENUM;
FOUNDATION_EXTERN ScheduleEventCacheEventName const ScheduleEventCacheEventWidget;
FOUNDATION_EXPORT ScheduleEventCacheEventName const ScheduleEventCacheEventNotification;
FOUNDATION_EXTERN ScheduleEventCacheEventName const ScheduleEventCacheEventCalender;

@interface ScheduleWidgetCache (Event)

- (void)setFirstCache;

- (void)setKey:(NSString *)key forName:(ScheduleEventCacheEventName)name onStatus:(BOOL)isOn;

- (BOOL)statusForKey:(NSString *)key withName:(ScheduleEventCacheEventName)name;

@end

NS_ASSUME_NONNULL_END
