//
//  EditMyInfoPersentDrivenController.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/11/19.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "EditMyInfoPercentDrivenController.h"

@interface EditMyInfoPercentDrivenController ()

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) id<UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, assign) float lastTranslationY;

@end

@implementation EditMyInfoPercentDrivenController

- (instancetype)initWithPanGesture:(UIPanGestureRecognizer *)panGesture {
    if (self = [super init]) {
        self.panGesture = panGesture;
        [self.panGesture addTarget:self action:@selector(updatePersentOfAnimation:)];
    }
    return self;
}

//- (void)dealloc
//{
//    [self.panGesture removeTarget:self action:@selector(updatePersentOfAnimation:)];
//}

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    self.transitionContext = transitionContext;
    [super startInteractiveTransition:transitionContext];
}

- (void)updatePersentOfAnimation:(UIPanGestureRecognizer *)panGesture {
    CGFloat percent = [self percentForGesture:panGesture];
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            break;
            
        case UIGestureRecognizerStateChanged:
            [self updateInteractiveTransition:percent / 5];
            
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

- (CGFloat)percentForGesture:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self.transitionContext.containerView];
    
    _lastTranslationY = translation.y;
    
    CGFloat percent = translation.y / MAIN_SCREEN_H;
    
    return percent;
}

- (CGFloat)velocityForGesture:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self.transitionContext.containerView];
    return translation.y;
}

@end
