//
//  UIControl+MGD.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/3/14.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "UIControl+MGD.h"
#import <objc/runtime.h>

@implementation UIControl (MGD)

static const char *UIControl_canTapEventInterval = "UIControl-canTapEventInterval";

static const char *UIControl_ignoreEvent = "UIControl_ignoreEvent";

- (NSTimeInterval)canTapEventInterval {
    return [objc_getAssociatedObject(self, UIControl_canTapEventInterval) doubleValue];
}

- (void)setCanTapEventInterval:(NSTimeInterval)canTapEventInterval {
    objc_setAssociatedObject(self, UIControl_canTapEventInterval, @(canTapEventInterval), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)ignoreEvent {
    return [objc_getAssociatedObject(self, UIControl_ignoreEvent) boolValue];
}

- (void)setIgnoreEvent:(BOOL)ignoreEvent {
    objc_setAssociatedObject(self, UIControl_ignoreEvent, @(ignoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)load {
    Method A = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    Method B = class_getInstanceMethod(self, @selector(__BanRepeated_sendAction:to:forEvent:));
    
    method_exchangeImplementations(A, B);
}

- (void)__BanRepeated_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if (self.ignoreEvent) return;
    if (self.canTapEventInterval > 0) {
        self.ignoreEvent = YES;
        [self performSelector:@selector(setIgnoreEvent:) withObject:@(NO) afterDelay:self.canTapEventInterval];
    }
    
    [self __BanRepeated_sendAction:action to:target forEvent:event];
}

@end
