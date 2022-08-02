//
//  UIColor+Rising.m
//  ByteDanceCampus_Weather
//
//  Created by SSR on 2022/7/28.
//

#import "UIColor+Rising.h"

#import <UIColor+DarkModeKit.h>

#pragma mark - UIColor (Rising)

@implementation UIColor (Rising)

+ (UIColor *)colorWithHexString:(NSString *)hexColor
                          alpha:(CGFloat)opacity {
    NSAssert(opacity < 0 || opacity > 1, @"透明度应在[0,1]区间范围");
    
    //删除字符串中的空格
    NSString *cString = [[hexColor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6){
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"]){
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"]){
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6){
        NSAssert([cString length] == 6, @"%@应该只有6位长度", cString);
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f)
                           green:((float)g / 255.0f)
                            blue:((float)b / 255.0f)
                           alpha:opacity];
}

+ (UIColor*)colorWith0xUInteger:(NSUInteger)hex
                          alpha:(CGFloat)alpha {
    NSAssert((hex & 0x1000000) >= 1, @"这个数不合法，请检查");
    NSAssert(alpha < 0 || alpha > 1, @"透明度应在[0,1]区间范围");
    
    float r, g, b, a;
    a = alpha;
    b = hex & 0x0000FF;
    hex = hex >> 8;
    g = hex & 0x0000FF;
    hex = hex >> 8;
    r = hex;

    return [UIColor
            colorWithRed:r / 255.0f
                   green:g / 255.0f
                    blue:b / 255.0f
                   alpha:a];
}

+ (BOOL)color:(UIColor *)oneColor isEquelToAnotherColor:(UIColor *)anotherColor {
    NSParameterAssert(oneColor);
    NSParameterAssert(anotherColor);
    
    return (CGColorEqualToColor(oneColor.CGColor, anotherColor.CGColor));
}

- (BOOL)isEquelToAnotherColor:(UIColor *)anotherColor {
    NSParameterAssert(anotherColor);
    
    return (CGColorEqualToColor(self.CGColor, anotherColor.CGColor));
}

+ (UIColor *)xFF_R:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue Alpha:(CGFloat)alpha {
    NSAssert(!(red >= 0 && red <= 255), @"应取在[0,255]直接");
    NSAssert(!(green >= 0 && green <= 255), @"应取在[0,255]直接");
    NSAssert(!(blue >= 0 && blue <= 255), @"应取在[0,255]直接");
    NSAssert(alpha < 0 || alpha > 1, @"透明度应在[0,1]区间范围");
    
    return [UIColor colorWithRed:red / 255 green:green / 255 blue:blue / 255 alpha:alpha];
}

@end
