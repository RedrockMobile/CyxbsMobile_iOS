//
//  LZWeekScrollView.m
//  MoblieCQUPT_iOS
//
//  Created by 李展 on 2017/8/25.
//  Copyright © 2017年 Orange-W. All rights reserved.
//

#import "LZWeekScrollView.h"
@interface LZWeekScrollView()
@property (nonatomic, strong) NSMutableArray <UIButton *> *btnArray;
@property (nonatomic, strong) UIView *sliderView;
@property (nonatomic, assign) CGFloat titleBtnWidth;
@property (nonatomic, assign) NSInteger currentIndex;
@end


@implementation LZWeekScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)scrollToIndex:(NSInteger)index{
    [self clickBtn:self.btnArray[index]];
}

- (instancetype)initWithFrame:(CGRect)frame andTitles:(NSArray<NSString *> *)titles{
    self = [self initWithFrame:frame];
    if(self){
        self.titles = titles;
        self.titleBtnWidth = frame.size.width/titles.count;
        if (titles.count >= 5) {
            self.titleBtnWidth = frame.size.width/5;
        }
        self.contentSize = CGSizeMake(titles.count*self.titleBtnWidth, frame.size.height);
        self.bounces = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        _btnArray = [NSMutableArray<UIButton *> array];
        for (int i = 0; i < titles.count; i ++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i*self.titleBtnWidth, 0, self.titleBtnWidth, frame.size.height);
            [btn setTitle:titles[i] forState:UIControlStateNormal];
            btn.tag = i;
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"7097FA"] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            [_btnArray addObject:btn];
        }
        [_btnArray firstObject].selected = YES;
        
        _sliderView = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height-2, self.titleBtnWidth, 2)];
        _sliderView.backgroundColor = [UIColor colorWithHexString:@"7097FA"];
        [self addSubview:self.sliderView];
        
    }
    return self;
}

- (void)clickBtn:(UIButton *)sender {
    NSInteger currentIndex = sender.tag;
    if (currentIndex != self.currentIndex) {
        self.btnArray[self.currentIndex].selected = NO;
        self.currentIndex = currentIndex;
        [UIView animateWithDuration:0.2f animations:^{
            _sliderView.frame = CGRectMake(currentIndex * _titleBtnWidth, self.height - 2, _titleBtnWidth, 2);
            if (self.btnArray[currentIndex].frame.origin.x < self.width/2) {
                [self setContentOffset:CGPointMake(0, 0) animated:YES];
            } else if (self.contentSize.width - self.btnArray[currentIndex].frame.origin.x <= self.width/2) {
                [self setContentOffset:CGPointMake(self.btnArray.count*_titleBtnWidth-self.width, 0) animated:YES];
            } else {
                [self setContentOffset:CGPointMake(self.btnArray[currentIndex].frame.origin.x-self.width/2+self.titleBtnWidth/2, 0) animated:YES];
            }
            
        } completion:nil];
        if ([self.eventDelegate respondsToSelector:@selector(eventWhenTapAtIndex:)]) {
            [self.eventDelegate eventWhenTapAtIndex:currentIndex];
        }
        self.btnArray[self.currentIndex].selected = YES;
    }
}

- (NSString *)currentIndexTitle{
    return self.titles[_currentIndex];
}

@end
