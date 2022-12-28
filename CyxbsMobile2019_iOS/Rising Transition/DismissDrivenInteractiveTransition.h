//
//  DismissDrivenInteractiveTransition.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/12/28.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DismissDrivenInteractiveTransition : UIPercentDrivenInteractiveTransition

- (instancetype)initWithPanGesture:(nullable UIPanGestureRecognizer *)panGesture;

@end

NS_ASSUME_NONNULL_END
