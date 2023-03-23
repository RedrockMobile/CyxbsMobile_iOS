//
//  AnimatedTransitioningSupport.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/12/28.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "AnimatedTransitioningSupport.h"

@implementation RyAnimatedTransition

- (instancetype)init {
    self = [super init];
    if (self) {
        self.transitionDuration = 0.5;
    }
    return self;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    [self prepareForAnimateWithContext:transitionContext];
    [UIView
     animateWithDuration:[self transitionDuration:transitionContext]
     delay:0
     options:(UIViewAnimationOptionCurveLinear)
     animations:^{
        [self animatedForFinishedWithContext:transitionContext];
    }
     completion:^(BOOL finished) {
        [self completionWithWithContext:transitionContext];
    }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.transitionDuration;
}

#pragma mark - Method

- (void)prepareForAnimateWithContext:(id<UIViewControllerContextTransitioning>)context {
}

- (void)animatedForFinishedWithContext:(id<UIViewControllerContextTransitioning>)context {
}

- (void)completionWithWithContext:(id<UIViewControllerContextTransitioning>)context {
    [context completeTransition:!context.transitionWasCancelled];
}

@end

@implementation PresentAnimatedTransition

- (instancetype)init {
    self = [super init];
    if (self) {
        self.supportedTapOutsideBack = YES;
    }
    return self;
}

- (void)prepareForAnimateWithContext:(id<UIViewControllerContextTransitioning>)context {
    UIViewController *from = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *to = [context viewControllerForKey:UITransitionContextToViewControllerKey];
    
    [from beginAppearanceTransition:NO animated:YES];
    
    CGRect beginFrame = to.view.frame;
    beginFrame.origin.y = context.containerView.frame.origin.y + context.containerView.frame.size.height;
    
    [to.view setFrame:beginFrame];
    [context.containerView addSubview:to.view];
}

- (void)animatedForFinishedWithContext:(id<UIViewControllerContextTransitioning>)context {
    UIViewController *to = [context viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect endFrame = to.view.frame;
    endFrame.origin.y = context.containerView.frame.size.height - endFrame.size.height;
    
    [to.view setFrame:endFrame];
}

- (void)completionWithWithContext:(id<UIViewControllerContextTransitioning>)context {
    UIViewController *to = [context viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if([context transitionWasCancelled]){
        [to.view removeFromSuperview];
    } else {
        if (self.supportedTapOutsideBack) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:to action:@selector(dismissModalViewControllerAnimated:)];
            [context.containerView addGestureRecognizer:tap];
        }
    }
    [super completionWithWithContext:context];
}

@end

@implementation DismissAnimatedTransition

- (void)prepareForAnimateWithContext:(id<UIViewControllerContextTransitioning>)context {
    UIViewController *from = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *to = [context viewControllerForKey:UITransitionContextToViewControllerKey];
    
    [from beginAppearanceTransition:NO animated:YES];
    [to beginAppearanceTransition:YES animated:YES];
}

- (void)animatedForFinishedWithContext:(id<UIViewControllerContextTransitioning>)context {
    UIViewController *from = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    CGRect endFrame = from.view.frame;
    endFrame.origin.y = context.containerView.frame.origin.y + context.containerView.frame.size.height;
    
    from.view.frame = endFrame;
}

- (void)completionWithWithContext:(id<UIViewControllerContextTransitioning>)context {
    UIViewController *from = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
    if(![context transitionWasCancelled]){
        [from.view removeFromSuperview];
    }
    [super completionWithWithContext:context];
}

@end
