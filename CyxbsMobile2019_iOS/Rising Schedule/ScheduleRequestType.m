//
//  ScheduleRequestType.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/9/4.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleRequestType.h"

#pragma mark - ClassScheduleRequestType

ScheduleModelRequestType const ScheduleModelRequestStudent = @"student";

ScheduleModelRequestType const ScheduleModelRequestCustom = @"custom";

ScheduleModelRequestType const ScheduleModelRequestTeacher = @"teacher";

NSString *KeyInParameterForScheduleModelRequestType(ScheduleModelRequestType type) {
    NSCParameterAssert(type);
    
    static NSDictionary *KeyDictionary;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        KeyDictionary = @{
            ScheduleModelRequestStudent : @"stu_num",
            ScheduleModelRequestTeacher : @"tea",
            ScheduleModelRequestCustom : @"stu_num"
        };
    });
    
    NSCParameterAssert(KeyDictionary[type]);
    
    return KeyDictionary[type];
}
