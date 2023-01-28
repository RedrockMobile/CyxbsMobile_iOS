//
//  ScheduleNeedsSupport.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/1/26.
//  Copyright © 2023 Redrock. All rights reserved.
//

#ifndef ScheduleNeedsSupport_h
#define ScheduleNeedsSupport_h

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSTimeZone *CQTimeZone(void);
FOUNDATION_EXPORT NSCalendar *ScheduleCalendar(void);
FOUNDATION_EXPORT NSLocale *CNLocale(void);

FOUNDATION_EXPORT NSUInteger ScheduleWeekOfComponentsWeek(NSUInteger week);

#endif /* ScheduleNeedsSupport_h */
