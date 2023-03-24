//
//  ScheduleNeedsSupport.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/1/26.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "ScheduleNeedsSupport.h"

#import "UIColor+Rising.h"

NSTimeZone *CQTimeZone() {
    return [NSTimeZone timeZoneWithName:@"Asia/Chongqing"];
}

NSLocale *CNLocale() {
    return [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
}

@implementation NSCalendar (schedule)

+ (NSCalendar *)republicOfChina {
    return [NSCalendar calendarWithIdentifier:NSCalendarIdentifierRepublicOfChina];;
}

@end


@implementation NSDateComponents (schedule)

- (NSUInteger)scheduleWeekday {
    return (self.weekday + 6) % 8 + (self.weekday + 6) / 8;
}

@end


@implementation UIView (SameDrawUI)

- (void)addGradientBlueLayer {
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = self.bounds;
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(1, 1);
    gl.colors = @[
        
        (__bridge id)UIColorRGBA255(72, 65, 226, 1).CGColor,
        (__bridge id)UIColorRGBA255(93, 93, 247, 1).CGColor
    ];
    gl.locations = @[@(0),@(1.0f)];
    [self.layer addSublayer: gl];
}

@end
