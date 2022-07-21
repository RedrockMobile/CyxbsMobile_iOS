//
//  FansAndFollowingSegmentView.m
//  CyxbsMobile2019_iOS
//
//  Created by p_tyou on 2021/9/17.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "FansAndFollowingSegmentView.h"
// category
#import "UIView+FrameTool.h"

@interface FansAndFollowingSegmentView ()

/// 存放按钮的数组
@property (nonatomic, strong) NSMutableArray <UIButton *> * buttonMAry;

@end

@implementation FansAndFollowingSegmentView

#pragma mark - initial

- (instancetype)initWithTitles:(NSArray<NSString *> *)titles
{
    self = [super init];
    if (self) {
        _titles = titles;
        _selectedIndex = 0;
        [self configureView];
    }
    return self;
}

+ (instancetype)segmentViewWithTitles:(NSArray<NSString *> *)titles
{
    return [[self alloc] initWithTitles:titles];
}

- (void)configureView {
    self.backgroundColor = [UIColor clearColor];
    
    self.buttonMAry = [NSMutableArray array];
    
    UIView * leftView = self;
    for (int i = 0; i < self.titles.count; i++) {
        UIButton * button = [self getNewButtonWithIndex:i];
        [self.buttonMAry addObject:button];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.height.mas_equalTo(self);
            make.width.mas_equalTo(self.mas_width).dividedBy(self.titles.count);
            make.left.mas_equalTo([leftView isEqual:self] ? leftView.mas_left : leftView.mas_right);
        }];
        leftView = button;
    }
    
    [self addSubview:self.sliderLinePart];
    [self.sliderLinePart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom);
        make.centerX.mas_equalTo(self.buttonMAry[0].mas_centerX);
    }];
}

#pragma mark - eventResponse action

- (void)clickButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(segmentView:alertWithIndex:)]) {
        [self.delegate segmentView:self alertWithIndex:[self.buttonMAry indexOfObject:sender]];
    }
}

#pragma mark - private

- (UIButton *)getNewButtonWithIndex:(NSInteger)index {
    UIButton * button = [[UIButton alloc] initWithFrame:(CGRectZero)];
    button.backgroundColor = [UIColor clearColor];
    [button setTitleColor:[UIColor dm_colorWithLightColor:RGBColor(21, 49, 91, 1) darkColor:RGBColor(223, 223, 227, 1)]
                 forState:(UIControlStateNormal)];
    [button setTitleColor:[UIColor dm_colorWithLightColor:RGBColor(21, 49, 91, 1) darkColor:RGBColor(223, 223, 227, 1)]
                 forState:(UIControlStateSelected)];
    [button addTarget:self
               action:@selector(clickButton:)
     forControlEvents:(UIControlEventTouchUpInside)];
    button.titleLabel.font = [UIFont fontWithName:PingFangSCMedium size:18];
    [button setTitle:self.titles[index] forState:(UIControlStateNormal)];
    return button;
}

#pragma mark - setter

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    self.buttonMAry[_selectedIndex].selected = NO;
    _selectedIndex = selectedIndex;
    self.buttonMAry[_selectedIndex].selected = YES;
    [self.sliderLinePart mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom);
        make.centerX.mas_equalTo(self.buttonMAry[_selectedIndex].mas_centerX);
    }];
}

#pragma mark - lazy

- (UIImageView *)sliderLinePart {
    if (_sliderLinePart == nil) {
        _sliderLinePart = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"选中效果"]];
        [_sliderLinePart sizeToFit];
    }
    return _sliderLinePart;
}

@end
