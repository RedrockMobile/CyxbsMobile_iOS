//
//  EditMyInfoView.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/2/14.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "EditMyInfoView.h"

@implementation EditMyInfoView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGPoint convertedPoint = [self convertPoint:point toView:self.backButton];
    if (CGRectContainsPoint(self.backButton.bounds, convertedPoint)) {
        return YES;
    }
    return [super pointInside:point withEvent:event];
}

@end
