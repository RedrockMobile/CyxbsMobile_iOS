//
//  MineSegmentedView.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/1/22.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "MineSegmentedView.h"
#import "MineQATableViewController.h"

@interface MineSegmentedView () <UIScrollViewDelegate>

@property (nonatomic, weak) UIView *segmentedBar;
@property (nonatomic, copy) NSArray<UIButton *> *segmentedButtons;
@property (nonatomic, weak) UIImageView *sliderView;
@property (nonatomic, weak) UIScrollView *scrollView;

@end

@implementation MineSegmentedView

- (instancetype)initWithChildViewControllers:(NSArray *)childViewControllers {
    if (self = [super init]) {
        self.childViewControllers = [childViewControllers mutableCopy];
        
        UIView *segmentedBar = [[UIView alloc] init];
        if (@available(iOS 11.0, *)) {
            segmentedBar.backgroundColor = [UIColor colorNamed:@"Mine_QA_HeaderBarColor"];
        } else {
            // Fallback on earlier versions
        }
        [self addSubview:segmentedBar];
        self.segmentedBar = segmentedBar;
        
        NSInteger controllersCount = childViewControllers.count;
        NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:controllersCount];
        for (int i = 0; i < controllersCount; i++) {
            UIButton *segmentedButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [segmentedButton setTitle:self.childViewControllers[i].subTittle forState:UIControlStateNormal];
            if (@available(iOS 11.0, *)) {
                [segmentedButton setTitleColor:[UIColor colorNamed:@"Mine_QA_TitleLabelColor"] forState:UIControlStateNormal];
            } else {
                // Fallback on earlier versions
            }
            
            if (i == 1) {
                segmentedButton.alpha = 0.5;
            }
            
            segmentedButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 18];
            [segmentedButton addTarget:self action:@selector(segmentedButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [tmp addObject:segmentedButton];
            [self.segmentedBar addSubview:segmentedButton];
        }
        self.segmentedButtons = tmp;
        
        UIImageView *sliderView = [[UIImageView alloc] init];
        sliderView.image = [UIImage imageNamed:@"分页滑条"];
        sliderView.contentMode = UIViewContentModeScaleToFill;
        [self.segmentedBar addSubview:sliderView];
        self.sliderView = sliderView;
        
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.backgroundColor = self.backgroundColor;
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
        make.top.equalTo(self.segmentedBar.mas_bottom).offset(-4);
        make.centerX.equalTo(self.segmentedButtons[0]);
        make.height.equalTo(@4);
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
    
    if (offsetPercent == 0) {
        // 选中第一个
        self.segmentedButtons[0].alpha = 1;
        self.segmentedButtons[1].alpha = 0.5;
    } else if (offsetPercent == 1) {
        self.segmentedButtons[1].alpha = 1;
        self.segmentedButtons[0].alpha = 0.5;
    }
}


- (void)segmentedButtonClicked:(UIButton *)sender {
    if ([sender isEqual:self.segmentedButtons[0]]) {
        self.segmentedButtons[0].alpha = 1;
        self.segmentedButtons[1].alpha = 0.5;
        [self.scrollView scrollToLeft];
    } else {
        self.segmentedButtons[1].alpha = 1;
        self.segmentedButtons[0].alpha = 0.5;
        [self.scrollView scrollToRight];
    }
}

@end
