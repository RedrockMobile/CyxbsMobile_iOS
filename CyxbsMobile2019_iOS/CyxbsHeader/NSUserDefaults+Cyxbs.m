//
//  NSUserDefaults+Cyxbs.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/11/5.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "NSUserDefaults+Cyxbs.h"

@implementation NSUserDefaults (Cyxbs)

+ (NSUserDefaults *)widgetUserDefaults {
    static  NSUserDefaults *_widget;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _widget = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.mredrock.cyxbs.widget"];
    });
    return _widget;
}

@end
