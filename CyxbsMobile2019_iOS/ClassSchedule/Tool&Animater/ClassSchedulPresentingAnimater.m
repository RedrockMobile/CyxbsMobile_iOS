//
//  ClassSchedulPresentingAnimater.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/8/23.
//  Copyright © 2020 Redrock. All rights reserved.
//转场动画管理者，实现具体的转场动画代码

#import "ClassSchedulPresentingAnimater.h"
#import "ClassTabBarController.h"
#import "WYCClassBookViewController.h"

@implementation ClassSchedulPresentingAnimater

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext { 
    if([[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey] isMemberOfClass:[WYCClassBookViewController class]]){

        
        WYCClassBookViewController *to = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
        
        ClassTabBarController *from = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        to.topBarView.alpha = 0;
        to.fakeBar.alpha = 1;
        if(IS_IPHONEX){
            // 83 + 58 = 141
            [to.view setFrame:CGRectMake(0, MAIN_SCREEN_H - 141, MAIN_SCREEN_W, 58)];
        }else{
            //49 + 58 = 107
            [to.view setFrame:CGRectMake(0, MAIN_SCREEN_H - 107, MAIN_SCREEN_W, 58)];
        }
        to.view.clipsToBounds = YES;
        [transitionContext.containerView addSubview:to.view];
                
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:1 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseOut animations:^{
            to.topBarView.alpha = 1;
            to.fakeBar.alpha = 0;
//            from.view.layer.affineTransform = CGAffineTransformMakeScale(0.88, 0.88);
//            from.view.layer.cornerRadius = 16;
//            from.view.layer.masksToBounds = YES;
            [to.view setFrame:CGRectMake(0, 44, MAIN_SCREEN_W, MAIN_SCREEN_H - 44)];
            
        }completion:^(BOOL finished) {
            BOOL wasCancel = [transitionContext transitionWasCancelled];
            if(wasCancel){
                [to.view removeFromSuperview];
            }
            [transitionContext completeTransition:!wasCancel];
        }];
        
    }else{
        
        ClassTabBarController *to = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
        WYCClassBookViewController *from = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        
        from.topBarView.alpha = 1;
        from.fakeBar.alpha = 0;
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:1 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseOut animations:^{
            from.topBarView.alpha = 0;
            from.fakeBar.alpha = 1;
            if(IS_IPHONEX){
                // 83 + 58 = 141
                [from.view setFrame:CGRectMake(0, MAIN_SCREEN_H - 141, MAIN_SCREEN_W, 58)];
            }else{
                //49 + 58 = 107
                [from.view setFrame:CGRectMake(0, MAIN_SCREEN_H - 107, MAIN_SCREEN_W, 58)];
                from.view.clipsToBounds = YES;
            }
            
        }completion:^(BOOL finished) {
            BOOL wasCancel = [transitionContext transitionWasCancelled];
            if(!wasCancel){
                [from.view removeFromSuperview];
            }
            [transitionContext completeTransition:!wasCancel];
        }];
    }
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}


@end
