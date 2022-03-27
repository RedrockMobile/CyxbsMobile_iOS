//
//  UIColor+Helper.m
//  MoblieCQUPT_iOS
//
//  Created by GQuEen on 16/5/7.
//  Copyright © 2016年 Orange-W. All rights reserved.
//

#import "UIColor+Helper.h"

@implementation UIColor (Helper)

+ (UIColor *)handleRandomColorStr:(NSString *)randomColorStr {
    return [self handleRandomColorStr:randomColorStr withLightModel:0];
}

+ (UIColor *)handleRandomColorStr:(NSString *)randomColorStr withLightModel:(NSInteger)model
{
    NSArray *array = [randomColorStr componentsSeparatedByString:@","];
    if (array.count > 2) {
        NSString *red = array[0];
        NSString *green = array[1];
        NSString *blue = array[2];
        if (model == 0) {
            return RGBColor(red.floatValue, green.floatValue, blue.floatValue, 1);
        }else if (model == 1) {
            return RGBColor(red.floatValue, green.floatValue, blue.floatValue, 0.7);
        }
    }
    
    return [UIColor lightGrayColor];
}

@end
