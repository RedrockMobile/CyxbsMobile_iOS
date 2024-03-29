//
//  DiscoverTodoTableViewAnimationView.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/9/5.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "DiscoverTodoTableViewAnimationView.h"


@interface DiscoverTodoTableViewAnimationView () {
    //圆圈半径
    CGFloat radius;
    //圆心
    CGPoint center;
    //直线起点
    CGPoint straightLineStart;
    //直线长度
    CGFloat straightLineLength;
    //直线颜色
    UIColor* lineColor;
    //总共的动画时间
    CGFloat totalAnimationTime;
    //圆圈动画占用的时间
    CGFloat timeOfCircle;
    //当前的动画时间
    CGFloat currentAnimationTime;
}
@property(nonatomic, strong)NSTimer *timer;
@property(nonatomic, strong)void (^completion)(void);
@end

@implementation DiscoverTodoTableViewAnimationView
- (instancetype)initWithCellFrame:(CGRect)cellRect labelFrame:(CGRect)labelFrame {
    self = [super initWithFrame:cellRect];
    if (self) {
        self.timer = [NSTimer timerWithTimeInterval:0.02 target:self selector:@selector(refresh) userInfo:nil repeats:YES];
        self.backgroundColor = [UIColor clearColor];
        //在init时计算好下面的数据，避免在drawRect:中重复计算
        radius = 0.02266666667*SCREEN_WIDTH;
        straightLineLength = labelFrame.size.width + 0.05*SCREEN_WIDTH;
        timeOfCircle = 0.4;
        totalAnimationTime = timeOfCircle + (straightLineLength)/(1.5*SCREEN_WIDTH) + 0.3;
        CCLog(@"%.2f, %.2f, %.2f",2*M_PI*radius, straightLineLength, timeOfCircle/totalAnimationTime);
        center = CGPointMake(labelFrame.origin.x-radius-0.02666666667*SCREEN_WIDTH, labelFrame.origin.y + labelFrame.size.height/2);
        straightLineStart = CGPointMake(center.x + radius, center.y);
        lineColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
    }
    return self;
}
- (void)begainAnimationWithCompletionBlock:(void(^)(void))completion {
    self.completion = completion;
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}


- (void)refresh {
    currentAnimationTime += 0.02;
    [self setNeedsDisplay];
    if (currentAnimationTime >= totalAnimationTime) {
        [self.timer invalidate];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"打勾"]];
        [self addSubview:imgView];
        [imgView setFrame:CGRectMake(0, 0, 2*radius, 2*radius)];
        imgView.center = center;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self removeFromSuperview];
            self.completion();
            self.completion = nil;
        });
    }
}

- (void)drawRect:(CGRect)rect {
    CGFloat endAngle;
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    if (currentAnimationTime <= timeOfCircle) {
        endAngle = currentAnimationTime/timeOfCircle * 2*M_PI;
        [path addArcWithCenter:center radius:radius startAngle:0.314 endAngle:endAngle clockwise:YES];
    }else {
        //得先绘制弧形，再绘制直线，不然绘制出的线条会是闭合的，原因未知，待研究。
        endAngle = 2*M_PI;
        [path addArcWithCenter:center radius:radius startAngle:0.314 endAngle:endAngle clockwise:YES];
        [path moveToPoint:straightLineStart];
        CGFloat rate = (currentAnimationTime-timeOfCircle)/(totalAnimationTime-timeOfCircle);
        [path addLineToPoint:CGPointMake(center.x + radius + rate*straightLineLength, center.y)];
    }
    
    [lineColor setStroke];
    [path setLineWidth:1.7];
    [path setLineJoinStyle:kCGLineJoinRound];
    [path stroke];
}

@end
