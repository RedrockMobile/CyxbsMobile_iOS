//
//  ClassSchedulInterController.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/8/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "ClassSchedulInterController.h"
#import "WYCClassBookViewController.h"
@interface ClassSchedulInterController()

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) id<UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, assign) float lastTranslationY;

@end

@implementation ClassSchedulInterController

- (instancetype)initWithPanGesture:(UIPanGestureRecognizer *)panGesture {
    if (self = [super init]) {
        self.panGesture = panGesture;
        [self.panGesture addTarget:self action:@selector(updateAnimation:)];
    }
    return self;
}

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    self.transitionContext = transitionContext;
    [super startInteractiveTransition:transitionContext];
}

- (void)updateAnimation:(UIPanGestureRecognizer *)sender {
    CGFloat percent = [self gesturePercent:sender];
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            break;
            
        case UIGestureRecognizerStateChanged:
            [self updateInteractiveTransition:percent / 4];
            
            break;
            
        case UIGestureRecognizerStateEnded:
            if (percent > 0.1) {
                [self finishInteractiveTransition];
            } else {
                [self cancelInteractiveTransition];
            }
            break;
        
        default:
            [self cancelInteractiveTransition];
            break;
    }
}

- (CGFloat)gesturePercent:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:self.transitionContext.containerView];
    
    // 如果是下拉
    if ([[self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey] isMemberOfClass:[UINavigationController class]]) {
        CGFloat percent = translation.y / 667;
        if (percent > 0) {
            return percent;
        } else {
            return 0;
        }
    } else {
        return - translation.y / 667;
    }
    
}

@end
