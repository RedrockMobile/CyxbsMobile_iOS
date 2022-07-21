//
//  PMPGestureScrollView.m
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/11/8.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "PMPGestureScrollView.h"

@implementation PMPGestureScrollView

//返回YES，则可以多个手势一起触发方法，返回NO则为互斥（比如外层UIScrollView名为mainScroll内嵌的UIScrollView名为subScroll，当我拖动subScroll时，mainScroll是不会响应手势的（多个手势默认是互斥的），当下面这个代理返回YES时，subScroll和mainScroll就能同时响应手势，同时滚动，这符合我这里的需求）
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.view.class isEqual:PMPGestureScrollView.class]) {
        return false;
    }
    return YES;
}

@end
