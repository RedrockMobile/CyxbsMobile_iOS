//
//  ScheduleWidgetCache.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/1/2.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "ScheduleShareCache.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScheduleWidgetCache : ScheduleShareCache

/* Memenry Cache */

@property (nonatomic, copy) ScheduleIdentifier *nonatomicMainID;
@property (nonatomic, copy) ScheduleIdentifier *nonatomicOtherID;

/* UserDefault Cache */

@property ScheduleIdentifier *mainID;
@property ScheduleIdentifier *otherID;

@property NSInteger widgetSection;

@property BOOL beDouble;

@property BOOL allowedLocalCache;

@end

NS_ASSUME_NONNULL_END
