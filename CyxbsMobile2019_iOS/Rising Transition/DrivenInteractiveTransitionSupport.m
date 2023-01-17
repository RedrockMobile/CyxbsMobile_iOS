//
//  DrivenInteractiveTransitionSupport.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/12/28.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "DrivenInteractiveTransitionSupport.h"

@implementation RyDrivenInteractiveTransition {
    id<UIViewControllerContextTransitioning> _context;
}

- (instancetype)initWithPanGesture:(UIPanGestureRecognizer *)panGesture {
    if (panGesture == nil) {
        return nil;
    }
    self = [super init];
    if (self) {
        [panGesture addTarget:self action:@selector(_update:)];
    }
    return self;
}

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    [super startInteractiveTransition:transitionContext];
    _context = transitionContext;
}

- (void)_update:(UIPanGestureRecognizer *)pan {
    CGFloat percent = [self percentOfPan:pan withContext:_context];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: break;
            
        case UIGestureRecognizerStateChanged:
            [self updateInteractiveTransition:percent];
            break;
            
        case UIGestureRecognizerStateEnded:
            if ([self finishWhenEnded:pan withContext:_context]) {
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

- (CGFloat)contextSafeRight {
    return _context.containerView.frame.size.width - self.panInsets.right;
}

- (CGFloat)contextSafeBottom {
    return _context.containerView.frame.size.height - self.panInsets.bottom;
}

- (CGFloat)percentOfPan:(UIPanGestureRecognizer *)pan withContext:(id<UIViewControllerContextTransitioning>)context {
    return 0;
}

- (BOOL)finishWhenEnded:(UIPanGestureRecognizer *)pan withContext:(id<UIViewControllerContextTransitioning>)context {
    return [self percentOfPan:pan withContext:context] >= 0.3;
}

@end

@implementation PresentDrivenInteractiveTransition

- (CGFloat)percentOfPan:(UIPanGestureRecognizer *)pan withContext:(id<UIViewControllerContextTransitioning>)context {
    CGPoint point = [pan locationInView:context.containerView];
    if (point.y >= self.contextSafeBottom) {
        return 0;
    }
    if (point.y <= self.panInsets.top) {
        return 1;
    }
    CGFloat fullH = self.contextSafeBottom - self.panInsets.top;
    CGFloat onH = self.contextSafeBottom - point.y;
    return onH / fullH;
}

- (BOOL)finishWhenEnded:(UIPanGestureRecognizer *)pan withContext:(id<UIViewControllerContextTransitioning>)context {
    return [super finishWhenEnded:pan withContext:context];
}

@end

@implementation DismissDrivenInteractiveTransition

- (CGFloat)percentOfPan:(UIPanGestureRecognizer *)pan withContext:(id<UIViewControllerContextTransitioning>)context {
    CGPoint point = [pan locationInView:context.containerView];
    if (point.y >= self.contextSafeBottom) {
        return 1;
    }
    if (point.y <= self.panInsets.top) {
        return 0;
    }
    CGFloat fullH = self.contextSafeBottom - self.panInsets.top;
    CGFloat onH = point.y - self.panInsets.top;
    return onH / fullH;
}

- (BOOL)finishWhenEnded:(UIPanGestureRecognizer *)pan withContext:(id<UIViewControllerContextTransitioning>)context {
    return [super finishWhenEnded:pan withContext:context];
}

@end
