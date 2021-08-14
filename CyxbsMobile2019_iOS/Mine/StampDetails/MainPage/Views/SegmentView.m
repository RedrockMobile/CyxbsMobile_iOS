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

/// 存放按钮的数组
@property (nonatomic, strong) NSMutableArray <UIButton *> * buttonMAry;

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

- (void)configureView {
    self.buttonMAry = [NSMutableArray array];
    for (int i = 0; i < _titles.count; i++) {
        UIButton * button = [self getNewButtonWithIndex:i];
        [button setTitle:_titles[i] forState:(UIControlStateNormal)];
        [self addSubview:button];
        [self.buttonMAry addObject:button];
    }
}


#pragma mark - eventResponse action

- (void)clickButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(segmentView:alertWithIndex:)]) {
        [self.delegate segmentView:self alertWithIndex:[self indexWithTag:sender.tag]];
    }
}

#pragma mark - private

- (UIButton *)getNewButtonWithIndex:(NSInteger)index {
    UIButton * button = [[UIButton alloc] initWithFrame:(CGRectZero)];
    button.tag = [self tagWithIndex:index];
    [button setTitleColor:[UIColor colorNamed:@"21_49_91_0.8&240_240_242_0.8"]
                 forState:(UIControlStateNormal)];
    [button setTitleColor:[UIColor colorNamed:@"95_117_228_1&119_142_255_1"]
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
    self.buttonMAry[_selectedIndex].selected = NO;
    _selectedIndex = selectedIndex;
    self.buttonMAry[_selectedIndex].selected = YES;
    // 增加动画效果
    CAKeyframeAnimation *scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    NSArray *shapes = @[@1.1, @1.2, @1.2, @1.2, @1.1, @1];
    [scale setDuration:0.5];
    [scale setValues:shapes];
    [scale setRemovedOnCompletion:NO];
    [scale setFillMode:kCAFillModeBoth];
    [self.buttonMAry[_selectedIndex].layer addAnimation:scale forKey:@"transform.scale"];
}

@end
