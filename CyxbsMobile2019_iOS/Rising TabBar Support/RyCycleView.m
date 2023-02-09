//
//  RyCycleView.m
//  RisingW
//
//  Created by SSR on 2023/1/13.
//

#import "RyCycleView.h"

@implementation RyCycleView {
    __kindof UIView *_view1, *_view2;
    BOOL _animate;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.clipsToBounds = YES;
        self.animateDuration = 2;
        self.dwellTime = 2;
        self.direction = UISwipeGestureRecognizerDirectionLeft;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_animation)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self _check];
}

- (void)setCycleView:(__kindof UIView *)cycleView {
    [_view1 removeFromSuperview];
    [_view2 removeFromSuperview];
    
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
    _view1 = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:cycleView]];
    _view2 = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:cycleView]];
    #pragma clang diagnostic pop
    
    CGRect rect = _view1.frame;
    rect.origin = CGPointMake(0, 0);
    _view1.frame = rect;
    [self _check];
    [self addSubview:_view1];
    [self addSubview:_view2];
    self.direction = _direction;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.dwellTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self _animation];
    });
}

- (void)setDirection:(UISwipeGestureRecognizerDirection)direction {
    if (!_animate) {
        _view2.hidden = YES;
        return;
    }
    _direction = direction;
    CGRect rect = _view1.frame;
    if (_direction & UISwipeGestureRecognizerDirectionLeft) {
        rect.origin.x = rect.size.width;
    }
    if (_direction & UISwipeGestureRecognizerDirectionRight) {
        rect.origin.x = - rect.size.width;
    }
    if (_direction & UISwipeGestureRecognizerDirectionUp) {
        rect.origin.y = rect.size.height;
    }
    if (_direction & UISwipeGestureRecognizerDirectionDown) {
        rect.origin.y = -rect.size.height;
    }
    _view2.frame = rect;
}

#pragma mark - Private

- (void)_check {
    _animate = YES;
    _view2.hidden = NO;
    if (self.direction & (UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight)) {
        if (_view1.frame.size.width <= self.frame.size.width) {
            _animate = NO;
            _view2.hidden = YES;
        }
    }
    if (self.direction & (UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown)) {
        if (_view1.frame.size.height <= self.frame.size.height) {
            _animate = NO;
            _view2.hidden = YES;
        }
    }
}

- (void)_animation {
    if (_animate) {
        [UIView
         animateWithDuration:self.animateDuration
         animations:^{
            self->_view2.frame = self->_view1.frame;
            CGRect final = self->_view1.frame;
            if (self.direction == UISwipeGestureRecognizerDirectionLeft) {
                final.origin.x = -final.size.width;
            }
            if (self.direction == UISwipeGestureRecognizerDirectionRight) {
                final.origin.x = final.size.width;
            }
            if (self.direction == UISwipeGestureRecognizerDirectionUp) {
                final.origin.y = -final.size.height;
            }
            if (self.direction == UISwipeGestureRecognizerDirectionDown) {
                final.origin.y = final.size.height;
            }
            self->_view1.frame = final;
        }
         completion:^(BOOL finished) {
            if (finished) {
                __kindof UIView *t = self->_view1;
                self->_view1 = self->_view2;
                self->_view2 = t;
                self.direction = self->_direction;
                __weak RyCycleView *ry = self;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.dwellTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    RyCycleView *sry = ry;
                    [sry _animation];
                });
            }
        }];
    }
}

@end
