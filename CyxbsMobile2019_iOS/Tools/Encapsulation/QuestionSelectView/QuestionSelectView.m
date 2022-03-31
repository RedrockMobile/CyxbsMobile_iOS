//
//  QuestionSelectView.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/3/30.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "QuestionSelectView.h"

#pragma mark - _QuestionSelectViewDelegate

struct {
    
    /// questionSelectViewNeedAutoLay:
    unsigned int questionSelectViewNeedAutoLay : 1;
    
    /// questionSelectView:buttonUnselected:
    unsigned int buttonUnselected : 1;
    
    /// questionSelectView:buttonSelected:
    unsigned int buttonSelected : 1;
    
} _QuestionSelectViewDelegate;

#pragma mark - _QuestionSelectViewDataSource

struct {
    
    /// questionSelectView:buttonAtIndex:
    unsigned int buttonAtIndex : 1;
    
} _QuestionSelectViewDataSource;

#pragma mark - QuestionSelectView ()

@interface QuestionSelectView ()

/// 问题反馈的button
@property (nonatomic, strong) NSArray <__kindof QuestionButton *> *buttons;

/// 被选中的button
@property (nonatomic, nullable, weak) UIButton *selectedButton;

/// 是否自动布局
@property (nonatomic, getter = isAutoLay) BOOL autoLay;

@end

#pragma mark - QuestionSelectView

@implementation QuestionSelectView

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initializer];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initializer];
    }
    return self;
}

- (void)initializer {
    self.selectedButton = nil;
    self.autoLay = YES;
}

#pragma mark - Lazy

- (void)setDelegate:(id<QuestionSelectViewDelegate>)delegate {
    _delegate = delegate;
    
    [self set_QuestionSelectViewDelegate];
    
    [self handleQuestionSelectViewDelegate];
}

- (void)set_QuestionSelectViewDelegate {
    _QuestionSelectViewDelegate.questionSelectViewNeedAutoLay = [self.delegate respondsToSelector:@selector(questionSelectViewNeedAutoLay:)];
    _QuestionSelectViewDelegate.buttonUnselected = [self.delegate respondsToSelector:@selector(questionSelectView:buttonUnselected:)];
    _QuestionSelectViewDelegate.buttonSelected = [self.delegate respondsToSelector:@selector(questionSelectView:buttonSelected:)];
}

- (void)setDataSourse:(id<QuestionSelectViewDataSource>)dataSourse {
    _dataSourse = dataSourse;
    
    [self set_QuestionSelectViewDataSource];
    
    [self handleQuestionSelectViewDataSource];
}

- (void)set_QuestionSelectViewDataSource {
    _QuestionSelectViewDataSource.buttonAtIndex = [self.dataSourse respondsToSelector:@selector(set_QuestionSelectViewDataSource)];
}

#pragma mark - <QuestionSelectViewDelegate>

- (void)handleQuestionSelectViewDelegate {
    if (_QuestionSelectViewDelegate.questionSelectViewNeedAutoLay) {
        self.autoLay = [self.delegate questionSelectViewNeedAutoLay:self];
    }
}

#pragma mark - <QuestionSelectViewDataSource>

- (void)handleQuestionSelectViewDataSource {
    // 创建并初始化布局
    [self removeSubviews];
    NSMutableArray <__kindof QuestionButton *> *btnMA = NSMutableArray.array;
    NSUInteger count = [self.dataSourse numberOfButtonsInQuestionSelectView:self];
    
    for (NSUInteger i = 0; i < count; i++) {
        QuestionButton *btn = nil;
        if (_QuestionSelectViewDataSource.buttonAtIndex) {
            // Source
            btn = [self.dataSourse questionSelectView:self buttonAtIndex:i];
            btn.target = i;
            [btn addTarget:self action:@selector(btnSelected:) forControlEvents:UIControlEventTouchUpInside];
            [btnMA addObject:btn];
            
            [self addSubview:btn];
        }
    }
    self.buttons = [btnMA copy];
    
    // default UI
    CGFloat widthCount = 0;
    for (NSUInteger i = 0; i < count; i++) {
        UIView *btn = self.buttons[i];
        // UI
        btn.top = 0;
        btn.height = self.height;
        if (i == 0) {
            btn.left = 0;
        } else {
            btn.left = self.buttons[i - 1].right;
        }
        widthCount += btn.width;
    }
    // more UI
    if (self.isAutoLay) {
        CGFloat gap = (self.width - widthCount) / self.buttons.count;
        for (NSUInteger i = 1; i < self.buttons.count; i++) {
            self.buttons[i].left = self.buttons[i - 1].right + gap;
        }
    }
}

#pragma mark - Method

- (void)removeSubviews {
    for (UIView *view in self.buttons) {
        [view removeFromSuperview];
    }
    self.buttons = nil;
}

#pragma mark - SEL

- (void)btnSelected:(QuestionButton *)btn {
    if (btn == self.selectedButton) {
        return;
    }
    btn.selected = YES;
    // 设置被选中状态
    if (_QuestionSelectViewDelegate.buttonSelected) {
        [self.delegate questionSelectView:self buttonSelected:btn];
    }
    // 如果当前有选中button，则掉用buttonUnselected
    if (self.selectedButton && _QuestionSelectViewDelegate.buttonUnselected) {
        // 憋管这个警告，我tm设置了if条件的
        [self.delegate questionSelectView:self buttonUnselected:self.selectedButton];
    }
    self.selectedButton = btn;
    // 告知被选中代理
    if (self.delegate) {
        [self.delegate questionSelectView:self selectedButtonAtIndex:btn.target];
    }
}

@end
