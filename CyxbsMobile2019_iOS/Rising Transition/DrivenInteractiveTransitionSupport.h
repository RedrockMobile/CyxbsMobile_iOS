//
//  DrivenInteractiveTransitionSupport.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/12/28.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 抽象基类，直接使用会导致无法实现
@interface RyDrivenInteractiveTransition : UIPercentDrivenInteractiveTransition

/// 实际pan手势的有效距离，可在重写`- percentOfPan:withContext:`时使用
@property (nonatomic) UIEdgeInsets panInsets;
// containerView.frame.size.width - self.panInsets.right;
@property (nonatomic, readonly) CGFloat contextSafeBottom;
// containerView.frame.size.height - self.panInsets.bottom;
@property (nonatomic, readonly) CGFloat contextSafeRight;

- (instancetype)initWithPanGesture:(nullable UIPanGestureRecognizer *)panGesture;

/// 子类必须实现该方法
- (CGFloat)percentOfPan:(UIPanGestureRecognizer *)pan withContext:(id<UIViewControllerContextTransitioning>)context;

/// 若子类不复写，则默认超过30%完成动画，否则取消
- (BOOL)finishWhenEnded:(UIPanGestureRecognizer *)pan withContext:(id<UIViewControllerContextTransitioning>)context;

@end

@interface PresentDrivenInteractiveTransition : RyDrivenInteractiveTransition

@end

@interface DismissDrivenInteractiveTransition : RyDrivenInteractiveTransition

@end

NS_ASSUME_NONNULL_END
