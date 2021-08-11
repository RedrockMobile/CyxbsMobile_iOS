//
//  SegmentView.m
//  Details
//
//  Created by Edioth Jin on 2021/8/5.
//

#import "SegmentView.h"
// category
#import "UIView+FrameTool.h"

@interface SegmentView ()

@end

@implementation SegmentView

#pragma mark - initial

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *> *)titles
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titles = titles;
        [self configureView];
    }
    return self;
}

+ (instancetype)segmentViewWithFrame:(CGRect)frame titles:(NSArray<NSString *> *)titles
{
    return [[self alloc] initWithFrame:frame titles:titles];
}


#pragma mark - eventResponse action

- (void)clickButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(segmentView:alertWithIndex:)]) {
        [self.delegate segmentView:self alertWithIndex:[self indexWithTag:sender.tag]];
    }
}

#pragma mark - configure

- (void)configureView {
    for (int i = 0; i < _titles.count; i++) {
        UIButton * button = [self getNewButtonWithIndex:i];
        [button setTitle:_titles[i] forState:(UIControlStateNormal)];
        [self addSubview:button];
    }
}

#pragma mark - private

- (UIButton *)getNewButtonWithIndex:(NSInteger)index {
    UIButton * button = [[UIButton alloc] initWithFrame:(CGRectZero)];
    button.tag = [self tagWithIndex:index];
    [button setTitleColor:[UIColor colorNamed:@"21_49_91_0.8"]
                 forState:(UIControlStateNormal)];
    [button setTitleColor:[UIColor colorNamed:@"95_117_228_1"]
                 forState:(UIControlStateSelected)];
    [button addTarget:self
               action:@selector(clickButton:)
     forControlEvents:(UIControlEventTouchUpInside)];
    
    //设置button的frame
    CGFloat buttonWidth = [UIScreen mainScreen].bounds.size.width / _titles.count;
    button.width = buttonWidth;
    button.height = self.height;
    button.y = 0;
    button.x = buttonWidth * index;
    
    return button;
}

- (NSInteger)tagWithIndex:(NSInteger)index {
    return 1000 + index;
}
- (NSInteger)indexWithTag:(NSInteger)tag {
    return tag - 1000;
}

#pragma mark - setter

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self configureView];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    for (UIButton * button in self.subviews) {
        button.selected = (button.tag == [self tagWithIndex:selectedIndex])? YES: NO;
        [UIView animateWithDuration:0.5 animations:^{
            button.titleLabel.font = [UIFont fontWithName:PingFangSCMedium size:(button.tag == [self tagWithIndex:selectedIndex] ? 16 : 14)];
        }];
    }
}

@end
