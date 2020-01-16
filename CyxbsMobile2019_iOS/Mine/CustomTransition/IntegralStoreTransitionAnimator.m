//
//  IntegralStoreTransitionAnimator.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/1/16.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "IntegralStoreTransitionAnimator.h"
#import "CheckInViewController.h"
#import "IntegralStoreViewController.h"

@implementation IntegralStoreTransitionAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.7;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    if ([[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey] isMemberOfClass:[CheckInViewController class]]) {
        IntegralStoreViewController *to = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

        to.view.frame = CGRectMake(0, MAIN_SCREEN_H - 89 - 30 + 16, MAIN_SCREEN_W, MAIN_SCREEN_H);
        to.view.backgroundColor = [UIColor clearColor];
        [transitionContext.containerView addSubview:to.view];

        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:1 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            to.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:242/255.0 blue:247/255.0 alpha:1];
            to.view.frame = CGRectMake(0, 0, MAIN_SCREEN_W, MAIN_SCREEN_H);
        } completion:^(BOOL finished) {
            BOOL wasCanceled = [transitionContext transitionWasCancelled];
            if (wasCanceled) {
                [to.view removeFromSuperview];
            }
            [transitionContext completeTransition:!wasCanceled];
        }];
        
    } else {
        IntegralStoreViewController *from = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        CheckInViewController *to = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:1 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            from.view.backgroundColor = [UIColor clearColor];
            from.view.frame = CGRectMake(0, MAIN_SCREEN_H - 89 - 30 + 16, MAIN_SCREEN_W, MAIN_SCREEN_H);
        } completion:^(BOOL finished) {
//            [transitionContext.containerView addSubview:to.view];

            [transitionContext completeTransition:YES];
        }];
    }
    
}

@end
