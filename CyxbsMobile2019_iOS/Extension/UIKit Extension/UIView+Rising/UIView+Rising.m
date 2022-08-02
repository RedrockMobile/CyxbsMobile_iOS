//
//  UIView+Rising.m
//  ByteDanceCampus_Weather
//
//  Created by SSR on 2022/7/25.
//

#import "UIView+Rising.h"

#import "UIView+YYAdd.h"

#pragma mark - UIView (Rising)

@implementation UIView (Rising)

// frme.origin

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

// frame.origin.x

- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x {
    return self.frame.origin.x;
}

// frame.origin.y

- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

#pragma mark Super

/**父控件的顶部*/
- (CGFloat)SuperTop {
    return 0;
}

/**父控件的左边*/
- (CGFloat)SuperLeft {
    return 0;
}

/**父控件的右边*/
- (CGFloat)SuperRight {
    return self.width;
}

/**父控件的底部*/
- (CGFloat)SuperBottom{
    return self.height;
}

/**父控件的顶点：(0 , 0)*/
- (CGPoint)SuperOrigin {
    return CGPointMake(0, 0);
}

/**父控件的中心：(width / 2, height / 2)*/
- (CGPoint)SuperCenter {
    return CGPointMake(self.width / 2, self.height / 2);
}

- (CGRect)SuperFrame {
    return CGRectMake(0, 0, self.width, self.height);
}

#pragma mark Layout

/**距离左边某点(x,0)多少距离*/
- (UIView *)stretchLeft_toPointX:(CGFloat)left offset:(CGFloat)leftSpace {
    self.width += self.x - left - leftSpace;
    self.x = left + leftSpace;
    return self;
}

/**距离上面某点(0,x)多少距离*/
- (UIView *)stretchTop_toPointY:(CGFloat)top offset:(CGFloat)topSpace {
    self.height += self.y - top - topSpace;
    self.y = top + topSpace;
    return self;
}

/**距离右边某点(x,0)多少距离*/
- (UIView *)stretchRight_toPointX:(CGFloat)right offset:(CGFloat)rightSpace {
    self.width = right - self.x - rightSpace;
    return self;
}

/**距离底部某点(0,x)多少距离*/
- (UIView *)stretchBottom_toPointY:(CGFloat)bottom offset:(CGFloat)bottomSpace {
    self.height = bottom - self.y - bottomSpace;
    return self;
}

@end
