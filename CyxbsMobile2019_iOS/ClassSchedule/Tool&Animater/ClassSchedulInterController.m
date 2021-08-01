//
//  ClassSchedulInterController.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/8/24.
//  Copyright © 2020 Redrock. All rights reserved.
//过渡手势管理者，作用：更新转场动画进度、在恰当的时机取消转场或者完成转场

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

//这个方法里面的所有魔法数据的来源：根据屏幕信息计算 + 手动调教修改(使用SE2调教)
- (void)updateAnimation:(UIPanGestureRecognizer *)sender {
    CGFloat rate = [sender translationInView:self.transitionContext.containerView].y/(3.296*SCREEN_HEIGHT);
    rate = fabs(rate);
    if (rate > 0.1) {
        rate *= (rate/0.1);
    }
//    CCLog(@"%.3f",rate);
    switch (sender.state) {
        case UIGestureRecognizerStateChanged:
            //更新转场动画进度
            [self updateInteractiveTransition:rate];
            if (rate > 0.5) {
                [self finishInteractiveTransition];
            }
            break;
        case UIGestureRecognizerStateEnded:
            if (rate > 0.025) {
                //完成转场动画
                [self finishInteractiveTransition];
            } else {
                //取消转场
                [self cancelInteractiveTransition];
            }
            break;
        
        default:
            //取消转场
            [self cancelInteractiveTransition];
            break;
    }
}

@end
