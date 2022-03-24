//
//  UIColor+Helper.h
//  MoblieCQUPT_iOS
//
//  Created by GQuEen on 16/5/7.
//  Copyright © 2016年 Orange-W. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Helper)

+ (UIColor *)handleRandomColorStr:(NSString *)randomColorStr;
+ (UIColor *)handleRandomColorStr:(NSString *)randomColorStr withLightModel:(NSInteger)model;

@end
