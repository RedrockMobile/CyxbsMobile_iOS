//
//  TransitioningDelegate.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/12/28.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TransitioningDelegate : NSObject <
    UIViewControllerTransitioningDelegate
>

// animated support

/// default is 0.5
@property (nonatomic) NSTimeInterval transitionDurationIfNeeded;

/// default is true
@property (nonatomic) BOOL supportedTapOutsideBackWhenPresent;

// driven interactive support

/// default is nil
@property (nonatomic, weak) UIPanGestureRecognizer *panGestureIfNeeded;

/// default is UIEdgeInsetsZero
@property (nonatomic) UIEdgeInsets panInsetsIfNeeded;

@end

NS_ASSUME_NONNULL_END
