//
//  AnimatedTransitioningSupport.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/12/28.
//  Copyright © 2022 Redrock. All rights reserved.
//

/**
 * 单击空白地方支持调用` - dismissModalViewControllerAnimated`
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RyAnimatedTransition : NSObject <UIViewControllerAnimatedTransitioning>

// default is 0.5
@property (nonatomic) NSTimeInterval transitionDuration;

- (void)prepareForAnimateWithContext:(id<UIViewControllerContextTransitioning>)context;

- (void)animatedForFinishedWithContext:(id<UIViewControllerContextTransitioning>)context;

- (void)completionWithWithContext:(id<UIViewControllerContextTransitioning>)context NS_REQUIRES_SUPER;

@end

@interface PresentAnimatedTransition : RyAnimatedTransition

/// default is true
@property (nonatomic) BOOL supportedTapOutsideBack;

@end

@interface DismissAnimatedTransition : RyAnimatedTransition

@end

NS_ASSUME_NONNULL_END
