//
//  NewQATool.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/7/29.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "NewQATool.h"

@implementation NewQATool

+ (CGFloat)widthOfString:(NSString *)string WithFont:(UIFont *)font{
    NSDictionary *attributes = @{NSFontAttributeName:font};     //字体属性，设置字体的font
    CGSize maxSize = CGSizeMake(MAXFLOAT,0);
    CGSize size = [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return ceil(size.width);
}

+ (CGFloat)heightOfString:(NSString *)string WithFont:(UIFont *)font {
    NSDictionary *attributes = @{NSFontAttributeName:font};     //字体属性，设置字体的font
    CGSize maxSize = CGSizeMake(MAXFLOAT,1000);
    CGSize size = [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return ceil(size.height);
}

@end
