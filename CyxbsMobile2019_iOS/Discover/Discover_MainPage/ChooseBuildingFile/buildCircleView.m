//
//  buildCircleView.m
//  Query
//
//  Created by hzl on 2017/3/9.
//  Copyright © 2017年 c. All rights reserved.
//

#import "buildCircleView.h"

@implementation buildCircleView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    //根据bounds计算中心点
    CGRect bounds = self.bounds;
    CGPoint center;
    center.x = bounds.origin.x + bounds.size.width / 2.0;
    center.y = bounds.origin.y + bounds.size.height / 2.0;
    
    //计算圆形半径
    CGFloat radius = (MIN(bounds.size.width, bounds.size.height) / 2.0) - 1
    ;
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    
    //画圆
    [path addArcWithCenter:center radius:radius startAngle:0.0 endAngle:2.0 * M_PI clockwise:1];
    
    path.lineWidth = 1;
    
    [[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] setStroke];
    
    [path stroke];
}


@end
