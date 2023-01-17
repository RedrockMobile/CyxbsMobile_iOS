//
//  ScheduleWidgetCache.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/1/2.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "ScheduleWidgetCache.h"

#import "CyxbsWidgetSupport.h"

@implementation ScheduleWidgetCache

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

// mainID &otherID

- (void)setMainID:(ScheduleIdentifier *)mainID {
    [self _setID:mainID forKey:@"ScheduleIdentifier_MainID"];
}

- (void)setOtherID:(ScheduleIdentifier *)otherID {
    [self _setID:otherID forKey:@"ScheduleIdentifier_OtherID"];
}

- (ScheduleIdentifier *)mainID {
    return [self _getForKey:@"ScheduleIdentifier_MainID"];
}

- (ScheduleIdentifier *)otherID {
    return [self _getForKey:@"ScheduleIdentifier_OtherID"];
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

// private

- (void)_setID:(ScheduleIdentifier *)ID forKey:(NSString *)key {
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:CyxbsWidgetAppGroups];
    NSArray <NSString *> *ary = @[ID.type, ID.sno, @(ID.exp).stringValue, @(ID.iat).stringValue];
    [userDefaults setObject:[ary componentsJoinedByString:@"$%"] forKey:key];
}

- (ScheduleIdentifier *)_getForKey:(NSString *)key {
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:CyxbsWidgetAppGroups];
    NSArray <NSString *> *ary = [[userDefaults objectForKey:key] componentsSeparatedByString:@"$%"];
    ScheduleIdentifier *identifier = [ScheduleIdentifier identifierWithSno:ary[1] type:ary[0]];
    identifier.exp = ary[2].doubleValue;
    identifier.iat = ary[3].doubleValue;
    return identifier;
}

@end
