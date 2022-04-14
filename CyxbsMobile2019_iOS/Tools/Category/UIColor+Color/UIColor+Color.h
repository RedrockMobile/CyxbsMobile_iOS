//
//  UIColor+Color.h
//  Encapsulation
//
//  Created by SSR on 2022/2/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - UIColor (Color)

@interface UIColor (Color)

/**16进制颜色转换为UIColor*/
//+ (UIColor *)colorWithHexString:(NSString *)hexColor
//                          alpha:(float)opacity;

/**十六进制数值转换为UIColor*/
//+ (UIColor*)colorWith0xUInteger:(NSUInteger)hex
//                          alpha:(CGFloat)alpha;

/**类方法比较两个color*/
+ (BOOL)color:(UIColor *)oneColor isEquelToAnotherColor:(UIColor *)anotherColor;

/**成员方法比较两个color*/
- (BOOL)isEquelToAnotherColor:(UIColor *)anotherColor;

/**0xFF即255为原的color*/
+ (UIColor *)xFF_R:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue Alpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
