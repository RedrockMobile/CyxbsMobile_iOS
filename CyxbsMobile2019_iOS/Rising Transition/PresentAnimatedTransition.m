//
//  PresentAnimatedTransition.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/12/28.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "PresentAnimatedTransition.h"

@implementation PresentAnimatedTransition

- (instancetype)init {
    self = [super init];
    if (self) {
        self.transitionDuration = 0.5;
    }
    return self;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    // 获取要跳转过去的 VC
    UIViewController *to = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
    UIViewController *from = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
#pragma clang diagnostic pop
    
    CGRect frame = to.view.frame, beginFrame = frame, endFrame = frame;
    beginFrame.origin.y = transitionContext.containerView.frame.origin.y + transitionContext.containerView.frame.size.height;
    endFrame.origin.y = transitionContext.containerView.frame.size.height - frame.size.height;
    
    [to.view setFrame:beginFrame];
    [transitionContext.containerView addSubview:to.view];
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:(UIViewAnimationOptionCurveLinear) animations:^{
        [to.view setFrame:endFrame];
    }completion:^(BOOL finished) {
        BOOL wasCancel = [transitionContext transitionWasCancelled];
        if(wasCancel){
            [to.view removeFromSuperview];
        } else {
            [transitionContext.containerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:to action:@selector(dismissModalViewControllerAnimated:)]];
        }
        [transitionContext completeTransition:!wasCancel];
    }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.transitionDuration;
}

@end
