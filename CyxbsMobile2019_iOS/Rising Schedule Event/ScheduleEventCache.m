//
//  ScheduleEventCache.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/4/8.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "ScheduleEventCache.h"
#import "CyxbsWidgetSupport.h"

ScheduleEventCacheEventName const ScheduleEventCacheEventWidget = @"ScheduleEventCacheEventWidget";
ScheduleEventCacheEventName const ScheduleEventCacheEventNotification = @"ScheduleEventCacheEventNotification";
ScheduleEventCacheEventName const ScheduleEventCacheEventCalender = @"ScheduleEventCacheEventCalender";

@implementation ScheduleWidgetCache (Event)

- (void)setFirstCache {
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:CyxbsWidgetAppGroups];
    if (![userDefaults boolForKey:@"ScheduleWidgetCache_isFirst"]) {
        ScheduleIdentifier *main = [self getKeyWithKeyName:ScheduleWidgetCacheKeyMain usingSupport:YES];
        if (main) {
            [self setKey:main.key forName:ScheduleEventCacheEventWidget onStatus:YES];
        }
        
        ScheduleIdentifier *other = [self getKeyWithKeyName:ScheduleWidgetCacheKeyCustom usingSupport:YES];
        if (other) {
            [self setKey:other.key forName:ScheduleEventCacheEventWidget onStatus:YES];
        }
        
        [userDefaults setBool:YES forKey:@"ScheduleWidgetCache_isFirst"];
    }
}

- (void)setKey:(NSString *)key forName:(ScheduleEventCacheEventName)name onStatus:(BOOL)isOn {
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:CyxbsWidgetAppGroups];
    [userDefaults setBool:isOn forKey:[key stringByAppendingString:name]];
}

- (BOOL)statusForKey:(NSString *)key withName:(ScheduleEventCacheEventName)name {
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:CyxbsWidgetAppGroups];
    return [userDefaults boolForKey:[key stringByAppendingString:name]];
}

@end
