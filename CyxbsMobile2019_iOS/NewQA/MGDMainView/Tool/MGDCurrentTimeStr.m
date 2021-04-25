//
//  MGDCurrentTimeStr.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/4/23.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "MGDCurrentTimeStr.h"

@implementation MGDCurrentTimeStr

// 获取当前时间戳
+ (NSString *)currentTimeStr{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time=[date timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.f", time];
    return timeString;
}

@end
