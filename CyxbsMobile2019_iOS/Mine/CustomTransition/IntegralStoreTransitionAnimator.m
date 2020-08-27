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
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    if ([[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey] isMemberOfClass:[CheckInViewController class]]) {
        IntegralStoreViewController *to = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        CheckInViewController *from = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

        if (IS_IPHONEX) {
            to.view.frame = CGRectMake(0, MAIN_SCREEN_H - 104 - 50 + 16, MAIN_SCREEN_W, MAIN_SCREEN_H);
        } else {
            to.view.frame = CGRectMake(0, MAIN_SCREEN_H - 89 - 30 + 16, MAIN_SCREEN_W, MAIN_SCREEN_H);
        }
        [transitionContext.containerView addSubview:to.view];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:1 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseOut animations:^{
            to.view.frame = CGRectMake(0, 0, MAIN_SCREEN_W, MAIN_SCREEN_H);
            if (@available(iOS 11.0, *)) {
                to.contentView.storeView.backgroundColor = [UIColor colorNamed:@"Mine_Store_BackgroundColor"];
            } else {
                to.contentView.storeView.backgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:252/255.0 alpha:1.0];
            }
            to.contentView.storeCollectionView.backgroundColor = to.contentView.storeView.backgroundColor;
            from.contentView.layer.affineTransform = CGAffineTransformMakeScale(0.87, 0.87);
            from.contentView.layer.cornerRadius = 16;
            from.contentView.clipsToBounds = YES;
        } completion:^(BOOL finished) {
            BOOL wasCanceled = [transitionContext transitionWasCancelled];
            if (wasCanceled) {
                [to.view removeFromSuperview];
            }
            [transitionContext completeTransition:!wasCanceled];
        }];
        
    } else {
        CheckInViewController *to = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

        IntegralStoreViewController *from = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:1 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseOut animations:^{
            if (IS_IPHONEX) {
                from.view.frame = CGRectMake(0, MAIN_SCREEN_H - 104 - 50 + 16, MAIN_SCREEN_W, MAIN_SCREEN_H);
            } else {
                from.view.frame = CGRectMake(0, MAIN_SCREEN_H - 89 - 30 + 16, MAIN_SCREEN_W, MAIN_SCREEN_H);
            }
            if (@available(iOS 11.0, *)) {
                from.contentView.storeView.backgroundColor = [UIColor colorNamed:@"Mine_CheckIn_StoreViewColor"];
            } else {
                from.contentView.storeView.backgroundColor = [UIColor whiteColor];
            }
            from.contentView.storeCollectionView.backgroundColor = from.contentView.storeView.backgroundColor;
            to.contentView.layer.affineTransform = CGAffineTransformMakeScale(1, 1);
            to.contentView.layer.cornerRadius = 0;
        } completion:^(BOOL finished) {
            BOOL wasCanceled = [transitionContext transitionWasCancelled];
            if (!wasCanceled) {
                [from.view removeFromSuperview];
            }
            [transitionContext completeTransition:!wasCanceled];
        }];
    }
    
}

@end
