//
//  ScheduleNeedsSupport.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/1/26.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "ScheduleNeedsSupport.h"

NSTimeZone *CQTimeZone() {
    return [NSTimeZone timeZoneWithName:@"Asia/Chongqing"];
}

NSCalendar *ScheduleCalendar() {
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierRepublicOfChina];
    return calendar;
}

NSLocale *CNLocale() {
    return [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
}

NSUInteger ScheduleWeekOfComponentsWeek(NSUInteger week) {
    return (week + 6) % 8 + (week + 6) / 8;;
}
