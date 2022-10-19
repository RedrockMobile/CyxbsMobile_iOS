//
//  SameDrawUI.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/10/19.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "SameDrawUI.h"

#import "RisingExtension.h"

@implementation UIView (SameDrawUI)

- (void)addGradientBlueLayer {
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = self.frame;
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(1, 1);
    gl.colors = @[
        (__bridge id)UIColorHex(#4841E2).CGColor,
        (__bridge id)UIColorHex(#5D5DF7).CGColor
    ];
    gl.locations = @[@(0),@(1.0f)];
    [self.layer addSublayer: gl];
}

@end
