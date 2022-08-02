//
//  UIColor+Rising.h
//  ByteDanceCampus_Weather
//
//  Created by SSR on 2022/7/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - UIColor (Rising)

@interface UIColor (Rising)

/// 十六进制字符串获取颜色
/// @param color 16进制色值  支持@“#123456”、 @“0X123456”、 @“123456”三种格式
/// @param alpha 透明度
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;


/// 16进制数转color
/// @param hex 16进制数
/// @param alpha 透明度
+ (UIColor*)colorWith0xUInteger:(NSUInteger)hex
                          alpha:(CGFloat)alpha;


/// 用类方法对比两个color
/// @param oneColor 第一个color
/// @param anotherColor 第二个color
+ (BOOL)color:(UIColor *)oneColor isEquelToAnotherColor:(UIColor *)anotherColor;

/// 用成员方法对比两个color
/// @param anotherColor 另一个color
- (BOOL)isEquelToAnotherColor:(UIColor *)anotherColor;

/// 用255进制对比color
/// @param red 红
/// @param green 绿
/// @param blue 蓝
/// @param alpha 透明度
+ (UIColor *)xFF_R:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue Alpha:(CGFloat)alpha;

+ (UIColor *)any:(UIColor *)anyColor dark:(UIColor *)darkColor;

@end

NS_ASSUME_NONNULL_END
