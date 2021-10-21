//
//  YearBtnsView.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/9/3.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "YearBtnsView.h"

@interface YearBtnsView ()
@property(nonatomic, strong)UIButton* selectedBtn;
@property(nonatomic, strong)UIColor* selectedBackgroundColor;
@property(nonatomic, strong)UIColor* unSelectedBackgroundColor;
@property(nonatomic, strong)UIScrollView* scrollView;
@property(nonatomic, strong)UIView* scrollViewContentView;
@end

@implementation YearBtnsView
- (instancetype)init {
    self = [super init];
    if (self) {
        self.selectedBackgroundColor = [UIColor colorNamed:@"237_244_253&34_34_34"];
        self.unSelectedBackgroundColor = [UIColor colorNamed:@"246_249_254&50_50_50"];
        [self addScrollView];
        [self addYearBtns];
        //
        //
    }
    return self;
}
- (void)addScrollView {
    //++++++++++++++++++添加scrollViewView++++++++++++++++++++  Begain
    UIScrollView* scrollView = [[UIScrollView alloc] init];
    self.scrollView = scrollView;
    [self addSubview:scrollView];
    
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    //++++++++++++++++++添加scrollViewView++++++++++++++++++++  End
    
    //++++++++++++++++++添加scrollViewContentView++++++++++++++++++++  Begain
    UIView* contentView = [[UIView alloc] init];
    [scrollView addSubview:contentView];
    self.scrollViewContentView = contentView;
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
    }];
    //++++++++++++++++++添加scrollViewContentView++++++++++++++++++++  Begain
}

- (void)addYearBtns {
    NSInteger year = [[NSCalendar currentCalendar] component:NSCalendarUnitYear fromDate:[NSDate date]];
    UIButton* btn;
    MASViewAttribute* anchor = self.scrollViewContentView.mas_left;
    CGFloat offset = 0;
    for (int i=0; i<4; i++) {
        btn = [self getStdYearBtnWithYear:year+i];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.scrollViewContentView);
            make.left.equalTo(anchor).offset(offset);
        }];
        anchor = btn.mas_right;
        offset = 0.03466666667*SCREEN_WIDTH;
        if (i==0) {
            [self selectYearWithBtn:btn];
        }
    }
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.scrollViewContentView);
    }];
}

- (UIButton*)getStdYearBtnWithYear:(NSInteger)year {
    UIButton* btn = [[UIButton alloc] init];
    [self.scrollViewContentView addSubview:btn];
    
    [btn setTitleColor:[UIColor colorNamed:@"21_49_91&240_240_242"] forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor colorNamed:@"156_169_189&131_131_133"] forState:UIControlStateNormal];
    
    btn.layer.cornerRadius = 0.01908866995*SCREEN_HEIGHT;
    btn.tag = year;
    [btn setTitle:[NSString stringWithFormat:@"%ld",year] forState:UIControlStateNormal];
    
    btn.backgroundColor = _unSelectedBackgroundColor;
    btn.selected = NO;
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0.09359605911*SCREEN_HEIGHT);
        make.height.mas_equalTo(0.0381773399*SCREEN_HEIGHT);
    }];
    
    [btn addTarget:self action:@selector(selectYearWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}


- (void)selectYearWithBtn:(UIButton*)yearBtn {
    //更新旧的btn的状态
    if (self.selectedBtn!=nil) {
        self.selectedBtn.backgroundColor = _unSelectedBackgroundColor;
        self.selectedBtn.selected = NO;
    }
    self.selectedBtn = yearBtn;
    
    //更新新的btn的状态
    yearBtn.backgroundColor = _selectedBackgroundColor;
    yearBtn.selected = YES;
    [self.delegate yearBtnsView:self didSelectedYear:yearBtn.tag];
}

- (void)setDelegate:(id<YearBtnsViewDelegate>)delegate {
    _delegate = delegate;
    [delegate yearBtnsView:self didSelectedYear:self.selectedBtn.tag];
}

- (NSInteger)selectedYear {
    return self.selectedBtn.tag;
}
@end
