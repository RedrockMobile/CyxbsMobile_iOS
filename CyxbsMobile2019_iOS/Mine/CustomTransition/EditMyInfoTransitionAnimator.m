//
//  EditMyInfoTransitionAnimator.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/11/17.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "EditMyInfoTransitionAnimator.h"
#import "EditMyInfoViewController.h"
#import "MineViewController.h"

@implementation EditMyInfoTransitionAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    // present的时候获取到的from是UITabBarController
    UIViewController *from = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    // dismiss的时候获取到的to是UITabBarController
    UIViewController *to = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if ([from isMemberOfClass:[UITabBarController class]]) {
        [transitionContext.containerView addSubview:to.view];
        
        to.view.frame = CGRectMake(25, 667, MAIN_SCREEN_W - 50, MAIN_SCREEN_H - 100 - 24);
        [transitionContext.containerView layoutIfNeeded];
        
        MineViewController *mineVC;
        for (UIViewController *childVC in from.childViewControllers) {
            if ([childVC isMemberOfClass:[MineViewController class]]) {
                mineVC = (MineViewController *)childVC;
            }
        }
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:1 initialSpringVelocity:15 options:UIViewAnimationOptionCurveEaseOut animations:^{
            ((UITabBarController *)from).tabBar.hidden = YES;
            mineVC.contentView.layer.affineTransform = CGAffineTransformMakeScale(0.8, 0.8);
            mineVC.contentView.layer.anchorPoint = CGPointMake(0.5, 0.47);
            mineVC.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:242/255.0 blue:250/255.0 alpha:1];
            mineVC.view.userInteractionEnabled = NO;
            
            to.view.frame = CGRectMake(25, 100, MAIN_SCREEN_W - 50, MAIN_SCREEN_H - 100 - 24);
            
            
            [transitionContext.containerView layoutIfNeeded];
        } completion:^(BOOL finished) {
            BOOL wasCanceled = [transitionContext transitionWasCancelled];
            [transitionContext completeTransition:!wasCanceled];
        }];
    } else {        // dismiss
        /*
            to: UITabBarViewController
            from: EditMyInfoViewController
         */
        
        MineViewController *mineVC;
        for (UIViewController *childVC in to.childViewControllers) {
            if ([childVC isMemberOfClass:[MineViewController class]]) {
                mineVC = (MineViewController *)childVC;
            }
        }
        
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:1 initialSpringVelocity:15 options:UIViewAnimationOptionCurveEaseOut animations:^{
            ((UITabBarController *)to).tabBar.hidden = NO;
            
            from.view.frame = CGRectMake(25, 667, MAIN_SCREEN_W - 50, MAIN_SCREEN_H - 100 - 24);
            mineVC.contentView.layer.anchorPoint = CGPointMake(0.5, 0.5);
            mineVC.contentView.layer.affineTransform = CGAffineTransformMakeScale(1, 1);
            mineVC.view.userInteractionEnabled = YES;
            
            [transitionContext.containerView layoutIfNeeded];
        } completion:^(BOOL finished) {
            [from.view removeFromSuperview];
            BOOL wasCanceled = [transitionContext transitionWasCancelled];
            [transitionContext completeTransition:!wasCanceled];
        }];
    }
}

@end
