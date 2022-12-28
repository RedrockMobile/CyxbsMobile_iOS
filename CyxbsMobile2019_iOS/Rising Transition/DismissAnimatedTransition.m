//
//  DismissAnimatedTransition.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/12/28.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "DismissAnimatedTransition.h"

@implementation DismissAnimatedTransition

- (instancetype)init {
    self = [super init];
    if (self) {
        self.transitionDuration = 0.5;
    }
    return self;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *to = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *from = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    CGRect endFrame = to.view.frame;
    endFrame.origin.y = transitionContext.containerView.frame.origin.y + transitionContext.containerView.frame.size.height;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:(UIViewAnimationOptionCurveLinear) animations:^{
        to.view.frame = endFrame;
    }completion:^(BOOL finished) {
        BOOL wasCancel = [transitionContext transitionWasCancelled];
        if(!wasCancel){
            [from.view removeFromSuperview];
        }
        [transitionContext completeTransition:!wasCancel];
    }];
    
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.transitionDuration;
}

@end
