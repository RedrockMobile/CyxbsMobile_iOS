//
//  RyTrottingHorseLampLabel.m
//  ScrollText
//
//  Created by SSR on 2023/3/21.
//

#import "RyTrottingHorseLampLabel.h"

@interface _RyTrottingHorseLampLabelAnimationContext : NSObject <RyTrottingHorseLampLabelAnimationContext>

@property (nonatomic) UIAccessibilityScrollDirection direction;

@property (nonatomic) CFTimeInterval hoverDuration;

@property (nonatomic) CFTimeInterval animationDuration;

@property (nonatomic) CGFloat spacing;

@end

@implementation _RyTrottingHorseLampLabelAnimationContext

- (void)setDirection:(UIAccessibilityScrollDirection)direction {
    if (direction == UIAccessibilityScrollDirectionNext
        || direction == UIAccessibilityScrollDirectionPrevious) {
        direction = UIAccessibilityScrollDirectionLeft;
    }
    _direction = direction;
}

@end





@implementation RyTrottingHorseLampLabel {
    UILabel *_lab1, *_lab2;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        _lab1 = [[UILabel alloc] init];
        _lab2 = [[UILabel alloc] init];
        [self addSubview:_lab1];
        [self addSubview:_lab2];
    }
    return self;
}

- (void)initLabelWithBlock:(void (NS_NOESCAPE ^)(UILabel * _Nonnull))makeLabel {
    makeLabel(_lab1);
    makeLabel(_lab2);
}

- (void)animationPrepare:(void (NS_NOESCAPE ^)(id<RyTrottingHorseLampLabelAnimationContext> _Nonnull))prepare {
    [_lab1.layer removeAnimationForKey:@"RyTrottingHorseLampLabelAnimation"];
    [_lab2.layer removeAnimationForKey:@"RyTrottingHorseLampLabelAnimation"];
    
    _RyTrottingHorseLampLabelAnimationContext *context = [[_RyTrottingHorseLampLabelAnimationContext alloc] init];
    prepare(context);
    
    CGRect rect = { CGPointZero, _lab1.bounds.size };
    if (context.spacing + _lab1.bounds.size.width <= self.bounds.size.width) {
        _lab1.frame = _lab2.frame = rect;
        return;
    }
    
    [_lab1.layer addAnimation:[self _createAnimationWithContext:context idx:1] forKey:@"RyTrottingHorseLampLabelAnimation"];
    [_lab2.layer addAnimation:[self _createAnimationWithContext:context idx:2] forKey:@"RyTrottingHorseLampLabelAnimation"];
}

- (CAAnimation *)_createAnimationWithContext:(_RyTrottingHorseLampLabelAnimationContext *)context idx:(NSInteger)idx{
    CGSize size = _lab1.bounds.size;
    
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    animation1.duration = context.hoverDuration;
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    animation2.duration = context.animationDuration;
    animation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation2.beginTime = animation1.duration;

    
    animation1.fromValue = @(idx == 1 ? 0 : size.width + context.spacing);
    animation1.toValue = animation1.fromValue;
    
    animation2.fromValue = animation1.toValue;
    animation2.toValue = @(idx == 1 ? -size.width - context.spacing : 0);
    
    CAAnimationGroup *group = CAAnimationGroup.animation;
    group.duration = context.hoverDuration + context.animationDuration;
    group.animations = @[animation1, animation2];
    group.repeatCount = HUGE_VALF;
    
    return group;
}

@end
