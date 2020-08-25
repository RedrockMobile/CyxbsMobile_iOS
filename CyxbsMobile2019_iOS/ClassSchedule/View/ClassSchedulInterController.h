//
//  ClassSchedulInterController.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/8/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClassSchedulInterController : UIPercentDrivenInteractiveTransition

- (instancetype)initWithPanGesture:(UIPanGestureRecognizer *)panGesture;
@end

NS_ASSUME_NONNULL_END
