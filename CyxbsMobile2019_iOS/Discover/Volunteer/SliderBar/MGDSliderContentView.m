//
//  MGDSliderContentView.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/11/11.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "MGDSliderContentView.h"

@interface MGDSliderContentView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) MGDSliderContentViewScrollCallback callback;

@property (nonatomic, strong) NSMutableArray *contentsVC;
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation MGDSliderContentView

- (void)willMoveToSuperview:(UIView *)newSuperview {
    _currentIndex = 0;
    [self initScrollView];
    [self initContentView];
    
}

- (NSMutableArray *)contentsVC {
    if (!_contentsVC) {
        _contentsVC = [NSMutableArray array];
        NSInteger num = [self.dataSource numOfContentView];
        for (int i = 0;i < num; i++) {
            UIViewController *VC = [self.dataSource sliderContentView:self viewControllerForIndex:i];
            [_contentsVC addObject:VC];
        }
    }
    return _contentsVC;
}

- (void)sliderContentViewScrollFinished:(MGDSliderContentViewScrollCallback)callback {
    _callback = callback;
}

- (void)scrollSliderContentViewToIndex:(NSInteger)index {
    self.currentIndex = index;
    [self.scrollView scrollRectToVisible:CGRectMake(index * CGRectGetWidth(_scrollView.frame), 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame)) animated:YES];
}

- (void)initScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    [self addSubview:_scrollView];
    _scrollView = scrollView;
}

- (void)initContentView {
    for (UIViewController *vc in self.contentsVC) {
        NSUInteger index = [self.contentsVC indexOfObject:vc];
        vc.view.frame = CGRectMake(index * CGRectGetWidth(_scrollView.frame), 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame));
        [_scrollView addSubview:vc.view];
    }
    _scrollView.contentSize = CGSizeMake([_contentsVC count] * CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame));
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    NSUInteger index = offsetX / CGRectGetWidth(_scrollView.frame);
    self.currentIndex = index;
    _callback(index);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}


@end
