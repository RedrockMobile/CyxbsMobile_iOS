//
//  MGDCircleLayer.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/7/16.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "MGDCircleLayer.h"
@interface MGDCircleLayer()<CAAnimationDelegate>
@property(nonatomic, strong)CAShapeLayer *shapeLayer;
@property(nonatomic, strong)CADisplayLink *displaylink;
@end

@implementation MGDCircleLayer
-(instancetype)init {
    if ([super init]) {
        [self initLayers];
    }
    return self;
}
-(CAShapeLayer *)shapeLayer {
    if (_shapeLayer == nil) {
        _shapeLayer = [CAShapeLayer new];
    }
    return _shapeLayer;
}
-(void)initLayers {
    self.shapeLayer.fillColor = [UIColor whiteColor].CGColor;
    self.shapeLayer.lineWidth = 0;
    [self addSublayer:self.shapeLayer];
}

-(void)startAnimation {
    CABasicAnimation *anim =  [CABasicAnimation   animationWithKeyPath:@"path"];
    anim.duration = self.params.animationDuration * 0.1;
    CGSize size =  self.frame.size;
    UIBezierPath *fromPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(size.width/2, size.height/2) radius:1 startAngle:0 endAngle:M_PI * 2.0 clockwise:false];
    UIBezierPath *toPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(size.width/2, size.height/2) radius:size.width/2 * 1.5  startAngle:0 endAngle:M_PI * 2.0 clockwise:false];
    anim.delegate = self;
    
    anim.fromValue = (__bridge id _Nullable)(fromPath.CGPath);
    anim.toValue = (__bridge id _Nullable)(toPath.CGPath);
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    anim.removedOnCompletion= NO;
    anim.fillMode = kCAFillModeForwards;
    [self.shapeLayer addAnimation:anim forKey:@"path"];
    if (self.params.enableFlashing) {
        [self startFlash];
    }
    
}
-(void)startFlash {
    self.displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(flashAction)];
    if (@available(iOS 10.0, *)) {
        self.displaylink.preferredFramesPerSecond = 6;
    }else{
        self.displaylink.frameInterval = 10;
    }
    [self.displaylink addToRunLoop: [NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

-(void)flashAction {
    int index = arc4random()%self.params.colorRandom.count;
    self.shapeLayer.strokeColor = self.params.colorRandom[index].CGColor;
    
}
#pragma mark CAAnimationDelegate
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        [self.displaylink invalidate];
        self.displaylink = nil;
        [self.shapeLayer removeAllAnimations];
        MGDClickCoreLayer *angleLayer = [[MGDClickCoreLayer alloc]initFrame:self.bounds params:self.params];
        [self addSublayer:angleLayer];
        [angleLayer startAnimation];
        self.endAnim();
    }
}
@end
