//
//  RyCycleView.h
//  RisingW
//
//  Created by SSR on 2023/1/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RyCycleView : UIView

// keyed 2 more, and not strong priperty, origin be used
- (void)setCycleView:(__kindof UIView *)cycleView;

// animateDuration with a scroll, defualt is 2
@property (nonatomic) NSTimeInterval animateDuration;

// stop when scroll is down a cycle,, defualt is 2
@property (nonatomic) NSTimeInterval dwellTime;

// direction which cycleView scroll, defualt is UISwipeGestureRecognizerDirectionLeft
// unsupport option
@property (nonatomic) UISwipeGestureRecognizerDirection direction;

@end

NS_ASSUME_NONNULL_END
