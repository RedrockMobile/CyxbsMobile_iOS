//
//  TransitionManager.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/8/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "TransitionManager.h"
#import "ClassSchedulPresentingAnimater.h"
#import "ClassSchedulInterController.h"

@implementation TransitionManager
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    
    return [[ClassSchedulPresentingAnimater alloc] init];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [[ClassSchedulPresentingAnimater alloc] init];
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator{
    if(self.PGRToInitTransition==nil)return nil;
    return [[ClassSchedulInterController alloc] initWithPanGesture:self.PGRToInitTransition];
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator{
    if(self.PGRToInitTransition==nil)return nil;
    return [[ClassSchedulInterController alloc] initWithPanGesture:self.PGRToInitTransition];
}
@end
