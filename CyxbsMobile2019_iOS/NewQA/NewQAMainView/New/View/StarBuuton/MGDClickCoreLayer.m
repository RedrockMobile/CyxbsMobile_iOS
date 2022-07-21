//
//  MGDClickCoreLayer.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/7/16.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "MGDClickCoreLayer.h"

@interface MGDClickCoreLayer() <CAAnimationDelegate>

@property(nonatomic, strong)NSMutableArray* circleLayers;
@property(nonatomic, strong)NSMutableArray* smallCircleLayers;
@property(nonatomic, strong)CADisplayLink* displaylink;

@end

@implementation MGDClickCoreLayer
-(instancetype)initFrame:(CGRect )frame params:(MGDClickParams *)params {
    self = [[MGDClickCoreLayer alloc]init];
    self.frame = frame;
    self.params = params;
    [self addCircles];
    return self;
}


-(NSMutableArray *)circleLayers{
    if (_circleLayers == nil) {
        _circleLayers = [NSMutableArray new];
    }
    return _circleLayers;
}
-(NSMutableArray *)smallCircleLayers {
    if (_smallCircleLayers == nil) {
        _smallCircleLayers = [NSMutableArray new];
    }
    return _smallCircleLayers;
}
-(void)setParams:(MGDClickParams *)params {
    _params = params;
}
-(void)addCircles {
    CGFloat startAngle = 0.f;
    CGFloat angle = M_PI*2/self.params.circleCount + startAngle;
    if (self.params.circleCount%2 != 0) {
        startAngle = M_PI * 2.0 - (angle / self.params.circleCount);
    }
    
    CGFloat radius = self.frame.size.width/2 * self.params.circleDistanceMultiple;
    for (int i = 0; i < self.params.circleCount; i++) {
        CAShapeLayer *bigShine = [CAShapeLayer new];
        CGFloat  bigWidth = self.frame.size.width*0.15;
        if (self.params.circleSize != 0) {
            bigWidth = self.params.circleSize;
        }
        CGPoint center = [self getShineCenter: startAngle + angle*i radius:radius];
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:bigWidth startAngle: 0 endAngle:M_PI * 2 clockwise:false];
        bigShine.path = path.CGPath;
      
        
        int index = arc4random()%self.params.colorRandom.count;
        bigShine.fillColor = self.params.colorRandom[index].CGColor;
        
        [self addSublayer:bigShine];
        [self.circleLayers addObject:bigShine];
        
        CGFloat smallShineOffsetAngle = 20;
        CAShapeLayer *smallShine = [CAShapeLayer new];
        CGFloat smallWidth = bigWidth*0.66;
        CGPoint smallCenter = [self getShineCenter:startAngle + angle * i -smallShineOffsetAngle * M_PI/180 radius:radius-bigWidth];
        UIBezierPath *smallPath = [UIBezierPath bezierPathWithArcCenter:smallCenter radius:smallWidth startAngle:0 endAngle:M_PI * 2.0 clockwise:false];
        smallShine.path = smallPath.CGPath;
    
        int smallIndex = arc4random()%self.params.colorRandom.count;
        smallShine.fillColor = self.params.colorRandom[smallIndex].CGColor;
        
        [self addSublayer:smallShine];
        [self.smallCircleLayers addObject:smallShine];
    }
}
-(CGPoint )getShineCenter:(CGFloat) angle radius:(CGFloat)radius {
    CGFloat cenx = CGRectGetMidX(self.bounds);
    CGFloat ceny = CGRectGetMidY(self.bounds);
    int multiple = 0;
    if (angle >= 0 && angle <= 90 * M_PI/180) {
        multiple = 1;
    }else if (angle <= M_PI && angle > 90 * M_PI/180) {
        multiple = 2;
    }else if (angle > M_PI && angle <= 270 * M_PI/180) {
        multiple = 3;
    }else {
        multiple = 4;
    }
    
    CGFloat resultAngel = multiple*(90 * M_PI/180) - angle;
    CGFloat a = sin(resultAngel)*radius;
    CGFloat b = cos(resultAngel)*radius;
    if (multiple == 1) {
        return CGPointMake(cenx+b, ceny-a);
    }else if (multiple == 2) {
        return CGPointMake(cenx+a, ceny+b);
    }else if (multiple == 3) {
        return CGPointMake(cenx-b, ceny+a);
    }else {
        return CGPointMake(cenx-a, ceny-b);
    }
}

-(void)startAnimation {
    CGFloat startAngle = 0.f;
    float radius = self.frame.size.width/2 * self.params.circleDistanceMultiple*1.4;
    CGFloat angle = M_PI * 2 / self.params.circleCount + startAngle;
    if (self.params.circleCount%2 != 0) {
        startAngle = M_PI * 2.0 - (angle / self.params.circleCount);
    }
    
    for (int i = 0; i < self.params.circleCount; i++) {
        CAShapeLayer *bigShine = self.circleLayers[i];
        CABasicAnimation *bigAnim = [self getAngleAnim:bigShine angle:startAngle + angle * i radius:radius];
        CAShapeLayer *smallShine = self.smallCircleLayers[i];
        CGFloat radiusSub = self.frame.size.width*0.15*0.66;
        if (self.params.circleSize !=0) {
            radiusSub = self.params.circleSize*0.66;
        }
        CABasicAnimation *smallAnim = [self getAngleAnim:smallShine angle:startAngle + angle * i - self.params.smallCircleOffsetAngle * M_PI /180  radius: radius-radiusSub];
        
        [bigShine addAnimation:bigAnim forKey:@"path"];
        [smallShine addAnimation:smallAnim forKey:@"path"];
        
        if (self.params.enableFlashing) {
            CABasicAnimation *bigFlash = [self getFlashAnim];
            CABasicAnimation *smallFlash = [self getFlashAnim];
            [bigShine addAnimation:bigFlash forKey:@"bigFlash"];
            [smallShine addAnimation:smallFlash forKey:@"smallFlash"];
        }
    }
    
    CABasicAnimation *angleAnim = [CABasicAnimation animationWithKeyPath: @"transform.rotation"];
    angleAnim.duration = self.params.animationDuration  * 0.87;
    angleAnim.timingFunction =  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear];
    angleAnim.fromValue = @0;
    angleAnim.toValue = @(self.params.circleTurnAngle*M_PI/180);
    angleAnim.delegate = self;
    [self addAnimation:angleAnim forKey:@"rotate"];
    if (self.params.enableFlashing) {
        [self startFlash];
    }
}
-(void)startFlash {
    self.displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(flashAction)];
    if (@available(iOS 10.0, *)) {
        self.displaylink.preferredFramesPerSecond = 10;
    }else{
        self.displaylink.frameInterval = 6;
    }
    [self.displaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}
-(void)flashAction {
    for (int i = 0; i <self.params.circleCount ; i++) {
        CAShapeLayer *bigShine = self.circleLayers[i];
        CAShapeLayer *smallShine = self.smallCircleLayers[i];
        int index1 = arc4random()%self.params.colorRandom.count;
        bigShine.fillColor = self.params.colorRandom[index1].CGColor;
        int index2 = arc4random()%self.params.colorRandom.count;
        smallShine.fillColor = self.params.colorRandom[index2].CGColor;
    }
}
-(CABasicAnimation *)getFlashAnim {
    CABasicAnimation *flash= [CABasicAnimation animationWithKeyPath:@"path"];
    flash.fromValue = @1;
    flash.toValue = @0;
    double duration = (arc4random()%20+60)/1000;
    flash.duration = duration;
    flash.repeatCount = MAXFLOAT;
    flash.removedOnCompletion  = false;
    flash.autoreverses = true;
    flash.fillMode = kCAFillModeForwards;
    return flash;
}
-(CABasicAnimation *)getAngleAnim:(CAShapeLayer *)shine angle:(CGFloat)angle radius:(CGFloat)radius {
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"path"];
    anim.duration = self.params.animationDuration * 0.87;
    anim.fromValue = (__bridge id _Nullable)(shine.path);
    CGPoint center = [self getShineCenter:angle radius:radius];
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:0.1 startAngle:0 endAngle:M_PI * 2.0  clockwise:false];
    anim.toValue = (__bridge id _Nullable)(path.CGPath);
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    anim.removedOnCompletion = false;
    anim.fillMode = kCAFillModeForwards;
    return anim;
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        [self.displaylink invalidate];
        self.displaylink = nil;
        [self removeAllAnimations];
        [self removeFromSuperlayer];
    }
}

@end

