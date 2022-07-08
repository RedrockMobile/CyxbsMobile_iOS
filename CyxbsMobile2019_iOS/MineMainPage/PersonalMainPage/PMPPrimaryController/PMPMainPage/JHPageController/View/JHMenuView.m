//
//  JHMenuView.m
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/10/9.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "JHMenuView.h"

@interface JHMenuView ()

/// menu item的容器
@property (nonatomic, strong) UIScrollView * scrollView;

@property (nonatomic, copy) NSArray <JHMenuItem *> * menuItems;

@property (nonatomic, strong) UIView * bottomLineView;

@end

@implementation JHMenuView

#pragma mark - init

- (instancetype)initWithTitles:(NSArray<NSString *> *)titles
                     ItemStyle:(JHMenuViewItemStyle)menuViewItemStyle {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _titles = titles;
        _menuViewItemStyle = menuViewItemStyle;
        _selectedIndex = 0;
        [self setupView];
    }
    return self;
}

- (void)setupView {
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(self);
    }];
    
    /// 创建所有的按钮
    NSMutableArray * tempMAry = [NSMutableArray array];
    for (NSUInteger i = 0; i < self.titles.count; i++) {
        [tempMAry addObject:[self getMenuItemWithIndex:i]];
    }
    self.menuItems = tempMAry;
    
    UIView * leftView = self.scrollView;
    for (JHMenuItem * item in self.menuItems) {
        [self.scrollView addSubview:item];
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.height.bottom.mas_equalTo(self.scrollView);
            make.width.mas_equalTo(self.scrollView.mas_width).multipliedBy(1. / self.menuItems.count);
            if ([leftView isEqual:self.scrollView]) {
                make.left.mas_equalTo(leftView.mas_left);
            } else {
                make.left.mas_equalTo(leftView.mas_right);
            }
            if ([item isEqual:self.menuItems.lastObject]) {
                make.right.mas_equalTo(self.scrollView.mas_right);
            }
        }];
        leftView = item;
    }
    self.menuItems[_selectedIndex].selected = YES;
    
    if (self.menuViewItemStyle == JHMenuItemStyleLine) {
        [self addSubview:self.sliderLinePart];
        [self.sliderLinePart mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_bottom);
            make.centerX.mas_equalTo(self.menuItems[_selectedIndex].mas_centerX);
        }];
    }
    
    [self addSubview:self.bottomLineView];
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo(1);
    }];
}

#pragma mark - private method

- (JHMenuItem *)getMenuItemWithIndex:(NSUInteger)index{
    JHMenuItem * item = [[JHMenuItem alloc] initWithIndex:index];
    // 设置颜色
    [item setTitleColorforStateNormal:[UIColor dm_colorWithLightColor:RGBColor(21, 49, 91, 1) darkColor:RGBColor(240, 240, 242, 1)]
                     forStateSelected:[UIColor dm_colorWithLightColor:RGBColor(21, 49, 91, 1) darkColor:RGBColor(240, 240, 242, 1)]];
    [item setTitle:self.titles[index] forState:UIControlStateNormal];
    // 点击事件
    [item addTarget:self
             action:@selector(itemClicked:)
   forControlEvents:UIControlEventTouchUpInside];
    return item;
}

#pragma mark - event response

/// 点击方法
- (void)itemClicked:(JHMenuItem *)item {
    if ([self.delegate respondsToSelector:@selector(itemClickedIndex:)]) {
        [self.delegate itemClickedIndex:item.index];
    }
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    if (_selectedIndex == selectedIndex) {
        return;
    }
    self.menuItems[_selectedIndex].selected = NO;
    _selectedIndex = selectedIndex;
    self.menuItems[_selectedIndex].selected = YES;
    if (self.menuViewItemStyle == JHMenuItemStyleLine) {
        [self.sliderLinePart mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_bottom);
            make.centerX.mas_equalTo(self.menuItems[_selectedIndex].mas_centerX);
        }];
    }
}

#pragma mark - lazy

- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor clearColor];
    }
    return _scrollView;
}

- (UIImageView *)sliderLinePart {
    if (_sliderLinePart == nil) {
        _sliderLinePart = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"选中效果"]];
        [_sliderLinePart sizeToFit];
    }
    return _sliderLinePart;
}

- (UIView *)bottomLineView {
    if (_bottomLineView == NULL) {
        UIView * view = [[UIView alloc] init];
        view.backgroundColor =
        [UIColor dm_colorWithLightColor:RGBColor(42, 78, 132, 0.1) darkColor:RGBColor(74, 80, 102, 0.4)];
        _bottomLineView = view;
    }
    return _bottomLineView;
}

@end
