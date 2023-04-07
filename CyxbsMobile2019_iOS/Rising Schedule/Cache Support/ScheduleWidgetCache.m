//
//  ScheduleWidgetCache.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/1/2.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "ScheduleWidgetCache.h"

#import "CyxbsWidgetSupport.h"

ScheduleWidgetCacheKeyName const ScheduleWidgetCacheKeyMain = @"ScheduleWidgetCacheKeyMain";
ScheduleWidgetCacheKeyName const ScheduleWidgetCacheKeyCustom = @"ScheduleWidgetCacheKeyCustom";
ScheduleWidgetCacheKeyName const ScheduleWidgetCacheKeyOther = @"ScheduleWidgetCacheKeyOther";

@implementation ScheduleWidgetCache {
    NSMutableDictionary <NSString *, ScheduleIdentifier *> *_keyCache;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _keyCache = NSMutableDictionary.dictionary;
    }
    return self;
}

/* KEY */

- (void)setKey:(ScheduleIdentifier *)key withKeyName:(ScheduleWidgetCacheKeyName)keyname usingSupport:(BOOL)support {
    if (support) {
        NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:CyxbsWidgetAppGroups];
        NSArray <NSString *> *ary = @[key.type, key.sno, @(key.exp).stringValue, @(key.iat).stringValue];
        [userDefaults setObject:[ary componentsJoinedByString:@"$%"] forKey:keyname];
    } else {
        [_keyCache setObject:key forKey:keyname];
    }
}

- (ScheduleIdentifier *)getKeyWithKeyName:(ScheduleWidgetCacheKeyName)keyname usingSupport:(BOOL)support {
    if (support) {
        NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:CyxbsWidgetAppGroups];
        NSArray <NSString *> *ary = [[userDefaults objectForKey:keyname] componentsSeparatedByString:@"$%"];
        if (ary == nil || ary.count != 4) {
            return nil;
        }
        ScheduleIdentifier *identifier = [ScheduleIdentifier identifierWithSno:ary[1] type:ary[0]];
        identifier.exp = ary[2].doubleValue;
        identifier.iat = ary[3].doubleValue;
        return identifier;
    } else {
        return [_keyCache objectForKey:keyname];
    }
}

#pragma mark - NSUserDefault

// widgetSection

- (void)setWidgetSection:(NSInteger)widgetSection {
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:CyxbsWidgetAppGroups];
    [userDefaults setInteger:widgetSection forKey:@"ScheduleIdentifier_WidgetSection"];
}

- (NSInteger)widgetSection {
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:CyxbsWidgetAppGroups];
    return [userDefaults integerForKey:@"ScheduleIdentifier_WidgetSection"];
}

// beDouble

- (void)setBeDouble:(BOOL)beDouble {
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:CyxbsWidgetAppGroups];
    [userDefaults setBool:beDouble forKey:@"ScheduleIdentifier_BeDouble"];
}

- (BOOL)beDouble {
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:CyxbsWidgetAppGroups];
    return [userDefaults boolForKey:@"ScheduleIdentifier_BeDouble"];
}


// allowedLocalCache

- (void)setAllowedLocalCache:(BOOL)allowedLocalCache {
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:CyxbsWidgetAppGroups];
    [userDefaults setBool:allowedLocalCache forKey:@"ScheduleIdentifier_AllowedLocalCache"];
}

- (BOOL)allowedLocalCache {
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:CyxbsWidgetAppGroups];
    return [userDefaults boolForKey:@"ScheduleIdentifier_AllowedLocalCache"];
}

// isFromWebView

- (void)setIsFromWebView:(BOOL)isFromWebView {
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:CyxbsWidgetAppGroups];
    [userDefaults setBool:isFromWebView forKey:@"ScheduleIdentifier_isFromWebView"];
}

- (BOOL)isFromWebView {
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:CyxbsWidgetAppGroups];
    return [userDefaults boolForKey:@"ScheduleIdentifier_isFromWebView"];
}

@end
