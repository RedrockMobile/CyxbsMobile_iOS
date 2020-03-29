//
//  BaseTabBar.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/3/29.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "ClassTabBar.h"
#import "ClassScheduleTabBarView.h"

@implementation ClassTabBar

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        CGPoint hitPoint = [self convertPoint:point fromView:self];
        if (self.classScheduleTabBarView) {
            if (CGRectContainsPoint(self.classScheduleTabBarView.frame, hitPoint)) {
                view = self.classScheduleTabBarView;
            }
        }
    }
    return view;
}

@end
