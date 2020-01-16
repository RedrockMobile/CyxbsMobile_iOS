//
//  IntegralStorePercentDrivenController.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/1/16.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "IntegralStorePercentDrivenController.h"
#import "CheckInViewController.h"

@interface IntegralStorePercentDrivenController ()

@property (nonatomic, strong) id<UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, assign) float lastTranslationY;

@end

@implementation IntegralStorePercentDrivenController

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
    
//    _lastTranslationY = translation.y;
    
    // 如果是下拉
    if ([[self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey] isMemberOfClass:[CheckInViewController class]]) {
        CGFloat percent = translation.y / MAIN_SCREEN_H;
        if (percent > 0) {
            return percent;
        } else {
            return 0;
        }
    } else {
        return - translation.y / MAIN_SCREEN_H;
    }
    
}

@end
