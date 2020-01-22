//
//  MineSegmentedView.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/1/22.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "MineSegmentedView.h"

@interface MineSegmentedView () <UIScrollViewDelegate>

@property (nonatomic, weak) UIView *segmentedBar;
@property (nonatomic, copy) NSArray *segmentedButtons;
@property (nonatomic, weak) UIImageView *sliderView;
@property (nonatomic, weak) UIScrollView *scrollView;

@end

@implementation MineSegmentedView

- (instancetype)initWithChildViewControllers:(NSArray *)childViewControllers {
    if (self = [super init]) {
        self.childViewControllers = [childViewControllers mutableCopy];
        
        UIView *segmentedBar = [[UIView alloc] init];
        segmentedBar.backgroundColor = [UIColor whiteColor];
        [self addSubview:segmentedBar];
        self.segmentedBar = segmentedBar;
        
        NSInteger controllersCount = childViewControllers.count;
        NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:controllersCount];
        for (int i = 0; i < controllersCount; i++) {
            UIButton *segmentedButton = [UIButton buttonWithType:UIButtonTypeSystem];
            [segmentedButton setTitle:self.childViewControllers[i].title forState:UIControlStateNormal];
            [segmentedButton setTitleColor:[UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
            segmentedButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 18];
            [tmp addObject:segmentedButton];
            [self.segmentedBar addSubview:segmentedButton];
        }
        self.segmentedButtons = tmp;
        
        UIImageView *sliderView = [[UIImageView alloc] init];
        sliderView.backgroundColor = [UIColor blueColor];
        [self.segmentedBar addSubview:sliderView];
        self.sliderView = sliderView;
        
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.backgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:252/255.0 alpha:1];
        scrollView.pagingEnabled = YES;
        scrollView.contentSize = CGSizeMake(MAIN_SCREEN_W * self.childViewControllers.count, 0);
        scrollView.delegate = self;
        scrollView.showsHorizontalScrollIndicator = 0;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        for (int i = 0; i < self.childViewControllers.count; i++) {
            [self.scrollView addSubview:self.childViewControllers[i].view];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [self.segmentedBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(TOTAL_TOP_HEIGHT - 16);
        make.leading.equalTo(self);
        make.height.equalTo(@50);
        make.width.equalTo(@(MAIN_SCREEN_W));
    }];
    self.segmentedBar.layer.cornerRadius = 16;
    
    int i = 0;
    CGFloat buttonWidth = MAIN_SCREEN_W / (self.segmentedButtons.count);
    for (UIButton *button in self.segmentedButtons) {
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.segmentedBar).offset(i * buttonWidth);
            make.top.equalTo(self.segmentedBar).offset(16);
            make.height.equalTo(@32);
            make.width.equalTo(@(buttonWidth));
        }];
        i++;
    }
    
    [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentedBar.mas_bottom).offset(-3);
        make.centerX.equalTo(self.segmentedButtons[0]);
        make.height.equalTo(@3);
        make.width.equalTo(@57);
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self);
        make.top.equalTo(self.segmentedBar.mas_bottom);
    }];
    
    for (int i = 0; i < self.childViewControllers.count; i++) {
        [self.childViewControllers[i].view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@(i * MAIN_SCREEN_W));
            make.width.equalTo(@(MAIN_SCREEN_W));
            make.bottom.equalTo(self);
            make.top.equalTo(self.segmentedBar.mas_bottom);
        }];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetPercent = scrollView.contentOffset.x / MAIN_SCREEN_W;
    CGFloat buttonWidth = MAIN_SCREEN_W / (self.segmentedButtons.count);
    
    self.sliderView.layer.affineTransform = CGAffineTransformMakeTranslation(buttonWidth * offsetPercent, 0);
}

@end
