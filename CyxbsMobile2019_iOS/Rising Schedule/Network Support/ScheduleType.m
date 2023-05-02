//
//  ScheduleType.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/9/4.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleType.h"

#pragma mark - ClassScheduleRequestType

ScheduleModelRequestType const ScheduleModelRequestStudent = @"student";
ScheduleModelRequestType const ScheduleModelRequestCustom = @"custom";
ScheduleModelRequestType const ScheduleModelRequestTeacher = @"teacher";


ScheduleWidgetCacheKeyName const ScheduleWidgetCacheKeyMain = @"ScheduleWidgetCacheKeyMain";
ScheduleWidgetCacheKeyName const ScheduleWidgetCacheKeyCustom = @"ScheduleWidgetCacheKeyCustom";
ScheduleWidgetCacheKeyName const ScheduleWidgetCacheKeyOther = @"ScheduleWidgetCacheKeyOther";

ScheduleModelRequestType const requestTypeForString(NSString *str) {
    if ([str isEqualToString:ScheduleModelRequestStudent]) {
        return ScheduleModelRequestStudent;
    }
    if ([str isEqualToString:ScheduleModelRequestCustom]) {
        return ScheduleModelRequestCustom;
    }
    if ([str isEqualToString:ScheduleModelRequestTeacher]) {
        return ScheduleModelRequestTeacher;
    }
    return ScheduleModelRequestStudent;
}
