//
//  MGDClickLayer.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/7/16.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "MGDClickLayer.h"

@interface MGDClickLayer()

@property(nonatomic, strong)CALayer *maskLayer;

@end

@implementation MGDClickLayer

-(instancetype)init {
    if ([super init]) {
        self.animationDuration = 0.5;
        self.clicked = false;
    }
    return self;
}

-(CALayer *)maskLayer {
    if (_maskLayer == nil) {
        _maskLayer = [[CALayer alloc]init];
    }
    return _maskLayer;
}

-(void)startAnimation {
    CAKeyframeAnimation  *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    anim.duration  = 0.2;
    anim.values = @[@0.4, @1, @0.9, @1];
    anim.calculationMode = kCAAnimationCubic;
    [self.maskLayer addAnimation:anim forKey:@"scale"];
}

-(void)layoutSublayers {
    [super layoutSublayers];
    self.maskLayer.frame = self.bounds;
    self.mask = self.maskLayer;
}

@end
