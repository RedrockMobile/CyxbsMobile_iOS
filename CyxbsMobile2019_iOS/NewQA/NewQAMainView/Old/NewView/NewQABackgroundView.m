//
//  NewQABackgroundView.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/8/17.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "NewQABackgroundView.h"
#import "NewQAMainVC.h"
#import "NewQATopView.h"
#import "NewQARecommenTableView.h"
#import "NewQAFocusTableView.h"

@implementation NewQABackgroundView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}


#pragma mark - 重载系统的hitTest方法

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    NewQAMainVC *currentVC = (NewQAMainVC *)self.nextResponder;
    currentVC.printPoint = point;
    if ([self.topView pointInside:point withEvent:event]) {
        self.scrollView.scrollEnabled = NO;
        if (self.scrollView.contentOffset.x < SCREEN_WIDTH *0.5) {
            return self.recommendView;
        } else {
            return self.focusView;
        }
    } else {
        self.scrollView.scrollEnabled = YES;
        return [super hitTest:point withEvent:event];
    }
}


#pragma mark - 添加手势的相应方法

- (void)tapGestureAction:(UITapGestureRecognizer *)gesture
{
    CGPoint point = [gesture locationInView:self.topView];
    if (CGRectContainsPoint(self.topView.leftBtnFrame, point)) {
        if (self.scrollView.contentOffset.x > 0.5 * SCREEN_WIDTH) {
            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
            self.topView.selectedItemIndex = 0;
        }
    } else if (CGRectContainsPoint(self.topView.rightBtnFrame, point)) {
        if (self.scrollView.contentOffset.x < 0.5 * SCREEN_WIDTH) {
            [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
            self.topView.selectedItemIndex = 1;
        }
    }
}


@end
