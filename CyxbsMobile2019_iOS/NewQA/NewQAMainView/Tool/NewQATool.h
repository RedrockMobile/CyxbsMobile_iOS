//
//  NewQATool.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/7/29.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewQATool : NSObject

+ (CGFloat)widthOfString:(NSString *)string WithFont:(UIFont *)font;

+ (CGFloat)heightOfString:(NSString *)string WithFont:(UIFont *)font;

@end

NS_ASSUME_NONNULL_END
