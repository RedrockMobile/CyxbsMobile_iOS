//
//  JHPageController.m
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/10/9.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "JHPageController.h"
// subview
#import "JHMenuView.h"
#import "PMPGestureScrollView.h"

@interface JHPageController ()
<JHMenuViewDelegate,
UIScrollViewDelegate>

@property (nonatomic, strong) JHMenuView * menuView;

/// 控制器的容器
@property (nonatomic, strong) PMPGestureScrollView * scrollView;

@end

@implementation JHPageController

- (instancetype)initWithTitles:(NSArray *)titles
                   Controllers:(NSArray *)controllers
{
    self = [super init];
    if (self) {
        _titles = titles;
        _controllers = controllers;
        _menuHeight = 56;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureView];
}

- (void)configureView {
    [self.view addSubview:self.menuView];
    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.width.mas_equalTo(self.view);
        make.height.mas_equalTo(self.menuHeight);
    }];
    // 这一段代码为了设置圆角
    [self.view layoutIfNeeded];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.menuView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(16, 16)].CGPath;
    self.menuView.layer.mask = shapeLayer;
    
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.menuView.mas_bottom);
    }];

    UIView * leftView = self.scrollView;
    for (UIViewController * vc in self.controllers) {
        [self.scrollView addSubview:vc.view];
        [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.top.mas_equalTo(self.scrollView);
            make.width.height.mas_equalTo(self.scrollView);
            if ([leftView isEqual:self.scrollView]) {
                make.left.mas_equalTo(leftView.mas_left);
            } else {
                make.left.mas_equalTo(leftView.mas_right);
            }
            if ([vc isEqual:self.controllers.lastObject]) {
                make.right.mas_equalTo(self.scrollView.mas_right);
            }
        }];
        leftView = vc.view;
    }
}

#pragma mark - menu view delegate

- (void)itemClickedIndex:(NSUInteger)index {
    [UIView animateWithDuration:0.5
                     animations:^{
        self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width * index, 0);
    }];
}

#pragma mark - scrollview

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 判断当前滑动到哪一个控制器了,改变的界限就是宽度是否超过了屏幕的一半
    NSInteger currentIndex = floor((scrollView.contentOffset.x / scrollView.frame.size.width) + 0.5);
    self.menuView.selectedIndex = currentIndex;
    
}

#pragma mark - lazy

- (PMPGestureScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[PMPGestureScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = false;
        _scrollView.showsHorizontalScrollIndicator = false;
    }
    return _scrollView;
}

- (JHMenuView *)menuView {
    if (_menuView == nil) {
        _menuView = [[JHMenuView alloc] initWithTitles:self.titles
                                             ItemStyle:JHMenuItemStyleLine];
        _menuView.backgroundColor =
        [UIColor dm_colorWithLightColor:UIColor.whiteColor darkColor:RGBColor(29, 29, 29, 1)];
        _menuView.delegate = self;
    }
    return _menuView;
}

@end
