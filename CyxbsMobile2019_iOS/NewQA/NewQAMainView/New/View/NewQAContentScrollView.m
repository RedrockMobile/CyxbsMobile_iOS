//
//  NewQAContentScrollView.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/9/12.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "NewQAContentScrollView.h"

@implementation NewQAContentScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        self.clipsToBounds = NO;
    }
    return self;
}


- (void)setOffset:(CGPoint)offset
{
    _offset = offset;
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView* view = [super hitTest:point withEvent:event];
    BOOL hitHead = point.y < (HeadViewHeight - self.offset.y);
    if (hitHead || !view) {
        NSLog(@"no view");
        self.scrollEnabled = NO;
        if (!view) {
            for (UIView* subView in self.subviews) {
                if (subView.frame.origin.x == self.contentOffset.x) {
                    view = subView;
                }
            }
        }
        return view;
    }else{
        self.scrollEnabled = YES;
        return view;
    }
}


@end
