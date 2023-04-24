//
//  RyTrottingHorseLampLabel.h
//  ScrollText
//
//  Created by SSR on 2023/3/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RyTrottingHorseLampLabelAnimationContext <NSObject>

//@property (nonatomic) UIAccessibilityScrollDirection direction;

@property (nonatomic) CFTimeInterval hoverDuration;

@property (nonatomic) CFTimeInterval animationDuration;

@property (nonatomic) CGFloat spacing;

@end

@interface RyTrottingHorseLampLabel : UIView

- (void)initLabelWithBlock:(void (NS_NOESCAPE ^)(UILabel *label))makeLabel;

- (void)animationPrepare:(void (NS_NOESCAPE ^)(id <RyTrottingHorseLampLabelAnimationContext> context))prepare;

@end

NS_ASSUME_NONNULL_END
