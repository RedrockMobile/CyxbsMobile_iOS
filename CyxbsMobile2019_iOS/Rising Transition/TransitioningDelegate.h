//
//  TransitioningDelegate.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/12/28.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RisingSingleClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface TransitioningDelegate : NSObject <
    UIViewControllerTransitioningDelegate
>

@property (nonatomic, weak) UIPanGestureRecognizer *panGestureIfNeeded;

/// default is 0.5
@property (nonatomic) NSTimeInterval transitionDurationIfNeeded;

@end

NS_ASSUME_NONNULL_END
