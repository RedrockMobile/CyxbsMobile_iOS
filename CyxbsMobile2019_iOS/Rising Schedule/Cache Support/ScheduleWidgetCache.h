//
//  ScheduleWidgetCache.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/1/2.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "ScheduleShareCache.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSString * ScheduleWidgetCacheKeyName;
FOUNDATION_EXTERN ScheduleWidgetCacheKeyName const ScheduleWidgetCacheKeyMain;
FOUNDATION_EXTERN ScheduleWidgetCacheKeyName const ScheduleWidgetCacheKeyOther;

@interface ScheduleWidgetCache : ScheduleShareCache

/* Key Support */

- (void)setKey:(ScheduleIdentifier *)key withKeyName:(ScheduleWidgetCacheKeyName)keyname usingSupport:(BOOL)support;
- (nullable ScheduleIdentifier *)getKeyWithKeyName:(ScheduleWidgetCacheKeyName)keyname usingSupport:(BOOL)support;

/* Widget Support */

@property NSInteger widgetSection;

@property BOOL beDouble;

@property BOOL allowedLocalCache;

@end

NS_ASSUME_NONNULL_END
