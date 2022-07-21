//
//  QASearchResultRootView.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/12/11.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "QASearchResultRootView.h"
#import "QAVerticalScrollView.h"
#import "UIView+FrameTool.h"

@interface QASearchResultRootView ()<UIGestureRecognizerDelegate, UIScrollViewDelegate>
///上下滑动的ScrollView
@property (nonatomic, strong) QAVerticalScrollView *verticalScroll;

///左右滑动的scroll
@property (nonatomic, strong) UIScrollView *horizontalScrollView;

@property (nonatomic, assign) CGFloat maxOffset;

/// table是否可以滑动
@property (nonatomic, assign) BOOL tableCanScroll;
@property (nonatomic, assign) BOOL isHaveKnoweledge;    //是否有重邮知识库
@end
@implementation QASearchResultRootView
- (instancetype)initWithFrame:(CGRect)frame IsHaveKnoweledge:(BOOL)isHaveKnoweledge{
    self = [super initWithFrame:frame];
    if (self) {
        self.isHaveKnoweledge = isHaveKnoweledge;
        self.segementBtnTextAry = @[@"内容", @"用户"];
        [self setUI];
    }
    return self;
}

#pragma mark -private methonds
-(void)setUI{
    [self addSubview:self.verticalScroll];
    [self.verticalScroll addSubview:self.topView];

    [self.verticalScroll addSubview:self.horizontalScrollView];
}

#pragma mark -Delegate
///允许多手势识别器同时识别手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.horizontalScrollView){
        //设置横线的动画
        //算比例
        double currentLocation = scrollView.contentOffset.x/SCREEN_WIDTH;
        NSLog(@"%f",currentLocation);
        self.topView.segementBarView.selectedImageView.x =  SCREEN_WIDTH * 0.112 + 36 * self.segementBtnTextAry.count * currentLocation;
    }
}

#pragma mark -getter
- (CGFloat)maxOffset{
    _maxOffset = self.topView.maxOffsetHeight;
    return _maxOffset;
}

- (QAVerticalScrollView *)verticalScroll{
    if (!_verticalScroll) {
        _verticalScroll = [[QAVerticalScrollView alloc] initWithFrame:self.frame];
        _verticalScroll.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT + self.maxOffset);
        _verticalScroll.delegate = self;
    }
    return _verticalScroll;
}

- (QASearchResultTopView *)topView{
    if (!_topView) {
        _topView = [[QASearchResultTopView alloc] initWithFrame:CGRectZero AndTextAry:self.segementBtnTextAry IsHaveQAKnowledge:self.isHaveKnoweledge];
        _topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _topView.viewHeight);
    }
    return _topView;
}

- (UIScrollView *)horizontalScrollView{
    if (!_horizontalScrollView) {
        _horizontalScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.topView.maxY, SCREEN_WIDTH, SCREEN_HEIGHT - self.topView.viewHeight + self.topView.maxOffsetHeight)];
        _horizontalScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * self.segementBtnTextAry.count, _horizontalScrollView.height);
        _horizontalScrollView.pagingEnabled = YES;  //开启分页模式
        _horizontalScrollView.bounces = NO;
        _horizontalScrollView.showsHorizontalScrollIndicator = NO;
        _horizontalScrollView.delegate = self;
    }
    return _horizontalScrollView;
}
@end
