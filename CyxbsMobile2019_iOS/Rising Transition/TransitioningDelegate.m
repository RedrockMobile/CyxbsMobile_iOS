//
//  TransitioningDelegate.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/12/28.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "TransitioningDelegate.h"

#import "PresentAnimatedTransition.h"
#import "DismissAnimatedTransition.h"

#import "PresentDrivenInteractiveTransition.h"
#import "DismissDrivenInteractiveTransition.h"

@implementation TransitioningDelegate

- (instancetype)init {
    self = [super init];
    if (self) {
        self.transitionDurationIfNeeded = 0.5;
    }
    return self;
}

// Animation Supported

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    PresentAnimatedTransition *transition = [[PresentAnimatedTransition alloc] init];
    transition.transitionDuration = self.transitionDurationIfNeeded;
    return transition;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    DismissAnimatedTransition *transition = [[DismissAnimatedTransition alloc] init];
    transition.transitionDuration = self.transitionDurationIfNeeded;
    return transition;
}

// Interactive Supported

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator{
    if(self.panGestureIfNeeded) {
        PresentDrivenInteractiveTransition *transition = [[PresentDrivenInteractiveTransition alloc] initWithPanGesture:self.panGestureIfNeeded];
        return transition;
    }
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator{
    if(self.panGestureIfNeeded) {
        DismissDrivenInteractiveTransition *transition = [[DismissDrivenInteractiveTransition alloc] initWithPanGesture:self.panGestureIfNeeded];
        return transition;
    }
    return nil;
}

@end
