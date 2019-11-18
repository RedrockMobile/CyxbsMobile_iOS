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
    return 0.4;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    // 这里的from获取到的是tabBarViewController
    UITabBarController *tabBarVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    MineViewController *from;
    for (UIViewController *childVC in tabBarVC.childViewControllers) {
        if ([childVC isMemberOfClass:[MineViewController class]]) {
            from = (MineViewController *)childVC;
        }
    }
    UIViewController *to = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    [transitionContext.containerView addSubview:tabBarVC.view];
    [transitionContext.containerView addSubview:to.view];
    
    transitionContext.containerView.backgroundColor = [UIColor colorWithRed:240/255.0 green:242/255.0 blue:250/255.0 alpha:1];

    to.view.frame = CGRectMake(25, 667, MAIN_SCREEN_W - 50, MAIN_SCREEN_H - 100 - 24);
    [transitionContext.containerView layoutIfNeeded];
    
    if ([to isMemberOfClass:[EditMyInfoViewController class]]) {
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:1 initialSpringVelocity:15 options:UIViewAnimationOptionCurveEaseOut animations:^{
            tabBarVC.tabBar.hidden = YES;
//            from.view.frame = CGRectMake(41, 92, MAIN_SCREEN_W - 82, MAIN_SCREEN_H - 92 - 24);
            from.view.layer.affineTransform = CGAffineTransformMakeScale(0.8, 0.8);
            from.view.layer.anchorPoint = CGPointMake(0.5, 0.47);
            to.view.frame = CGRectMake(25, 100, MAIN_SCREEN_W - 50, MAIN_SCREEN_H - 100 - 24);
            from.view.layer.cornerRadius = 16;
            
            [transitionContext.containerView layoutIfNeeded];
        } completion:^(BOOL finished) {
            BOOL wasCanceled = [transitionContext transitionWasCancelled];
            [transitionContext completeTransition:!wasCanceled];
        }];
    } else {        // dismiss
        
    }
}

@end
