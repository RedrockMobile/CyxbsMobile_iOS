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

@interface EditMyInfoTransitionAnimator ()

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@end

@implementation EditMyInfoTransitionAnimator

- (instancetype)initWithPanGesture:(UIPanGestureRecognizer *)panGesture {
    if (self = [super init]) {
        _panGesture = panGesture;
    }
    return self;
}

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
        
        to.view.frame = CGRectMake(25, MAIN_SCREEN_H, MAIN_SCREEN_W - 50, MAIN_SCREEN_H - 100 - 24);
        [transitionContext.containerView layoutIfNeeded];
        
        MineViewController *mineVC;
        for (UINavigationController *childVC in from.childViewControllers) {
            if ([childVC.viewControllers[0] isMemberOfClass:[MineViewController class]]) {
                mineVC = (MineViewController *)childVC.viewControllers[0];
            }
        }
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:1 initialSpringVelocity:15 options:UIViewAnimationOptionCurveEaseOut animations:^{
            ((UITabBarController *)from).tabBar.alpha = 0;
            mineVC.contentView.layer.affineTransform = CGAffineTransformMakeScale(0.8, 0.8);
            mineVC.contentView.layer.cornerRadius = 16;
            if (IS_IPHONEX) {
                mineVC.contentView.layer.anchorPoint = CGPointMake(0.5, 0.49);
            } else if (IS_IPHONESE) {
                mineVC.contentView.layer.anchorPoint = CGPointMake(0.5, 0.428);
            } else {
                mineVC.contentView.layer.anchorPoint = CGPointMake(0.5, 0.47);
            }
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
        for (UINavigationController *childVC in to.childViewControllers) {
            if ([childVC.viewControllers[0] isMemberOfClass:[MineViewController class]]) {
                mineVC = (MineViewController *)childVC.viewControllers[0];
            }
        }
        
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:1 initialSpringVelocity:15 options:UIViewAnimationOptionCurveEaseOut animations:^{
            ((UITabBarController *)to).tabBar.alpha = 1;
            
            from.view.frame = CGRectMake(25, MAIN_SCREEN_H, MAIN_SCREEN_W - 50, MAIN_SCREEN_H - 100 - 24);
            mineVC.contentView.layer.anchorPoint = CGPointMake(0.5, 0.5);
            mineVC.contentView.layer.affineTransform = CGAffineTransformMakeScale(1, 1);
            mineVC.contentView.layer.cornerRadius = 0;
            mineVC.view.userInteractionEnabled = YES;
            
            [transitionContext.containerView layoutIfNeeded];
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
