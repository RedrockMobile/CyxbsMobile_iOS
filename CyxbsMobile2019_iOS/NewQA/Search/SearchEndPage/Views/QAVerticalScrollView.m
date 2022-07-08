//
//  VerticalScrollView.m
//  NewSearchSeconthTry
//
//  Created by 石子涵 on 2021/11/20.
//

#import "QAVerticalScrollView.h"

@implementation QAVerticalScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorNamed:@"241_243_248&45_45_45"];
        //设置全屏时距离顶部无空白
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.bounces = NO;
    }
    return self;
}

///允许多手势识别器同时识别手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

@end
