//
//  NewQASelectorView.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/9/12.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "NewQASelectorView.h"

@implementation NewQASelectorView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _tableSliderBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HScaleRate_SE * 54)];
        _tableSliderBackView.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1] darkColor:[UIColor colorWithHexString:@"#1D1D1D" alpha:1]];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_tableSliderBackView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(28,28)];
        //创建 layer
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _tableSliderBackView.bounds;
        //赋值
        maskLayer.path = maskPath.CGPath;
        _tableSliderBackView.layer.mask = maskLayer;
        _tableSliderBackView.userInteractionEnabled = YES;
        [self addSubview:_tableSliderBackView];
        //创建底部滑条
        _sliderWidth = WScaleRate_SE * 40;
        _sliderHeight = HScaleRate_SE * 3;
        _sliderLinePart = [[UIImageView alloc] initWithFrame:CGRectMake(WScaleRate_SE * 17,  HScaleRate_SE * 44, _sliderWidth, _sliderHeight)];
        _sliderLinePart.image = [UIImage imageNamed:@"分页滑条"];
        [_tableSliderBackView addSubview:_sliderLinePart];
        
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        leftBtn.frame = CGRectMake(WScaleRate_SE * 17, HScaleRate_SE * 10, WScaleRate_SE * 45, HScaleRate_SE * 28);
        [leftBtn setTitle:@"推荐" forState:UIControlStateNormal];
        [leftBtn setTitleColor:[UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]] forState:UIControlStateNormal];
        [leftBtn.titleLabel setFont:[UIFont fontWithName:PingFangSCMedium size:18*fontSizeScaleRate_SE]];
        [leftBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//        [leftBtn addTarget:self action:@selector(clickTitleLeft) forControlEvents:UIControlEventTouchUpInside];
        [_tableSliderBackView addSubview:leftBtn];
        _leftBtn = leftBtn;
        
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        rightBtn.frame = CGRectMake(WScaleRate_SE * 76, HScaleRate_SE * 10, WScaleRate_SE * 45, HScaleRate_SE * 28);
        [rightBtn setTitle:@"关注" forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]] forState:UIControlStateNormal];
        rightBtn.titleLabel.alpha = 0.8;
        [rightBtn.titleLabel setFont:[UIFont fontWithName:PingFangSCMedium size:14*fontSizeScaleRate_SE]];
        [rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//        [rightBtn addTarget:self action:@selector(clickTitleRight) forControlEvents:UIControlEventTouchUpInside];
        [_tableSliderBackView addSubview:rightBtn];
        _rightBtn = rightBtn;
        
        self.leftBtnFrame = leftBtn.frame;
        self.rightBtnFrame = rightBtn.frame;
    }
    return self;
}

- (void)dealloc
{
    
}

#pragma mark - Event Response
- (void)setSelectedItemIndex:(NSInteger)selectedItemIndex
{
    _selectedItemIndex = selectedItemIndex;
    if (selectedItemIndex == 0) {
        _leftBtn.titleLabel.alpha = 1;
        [_leftBtn.titleLabel setFont:[UIFont fontWithName:PingFangSCMedium size:18*fontSizeScaleRate_SE]];
        _rightBtn.titleLabel.alpha = 0.8;
        [_rightBtn.titleLabel setFont:[UIFont fontWithName:PingFangSCMedium size:14*fontSizeScaleRate_SE]];
    }
    else {
        _leftBtn.titleLabel.alpha = 0.8;
        [_leftBtn.titleLabel setFont:[UIFont fontWithName:PingFangSCMedium size:14*fontSizeScaleRate_SE]];
        _rightBtn.titleLabel.alpha = 1;
        [_rightBtn.titleLabel setFont:[UIFont fontWithName:PingFangSCMedium size:18*fontSizeScaleRate_SE]];
    }
}

#pragma mark - Private Method

#pragma mark - Setters And Getters


//- (void)clickTitleRight {
//    NSLog(@"right");
//    _sliderLinePart.frame = CGRectMake(WScaleRate_SE * 76 , HScaleRate_SE * 44, _sliderWidth, _sliderHeight);
//    _leftBtn.titleLabel.alpha = 0.8;
//    [_leftBtn.titleLabel setFont:[UIFont fontWithName:PingFangSCMedium size:14*fontSizeScaleRate_SE]];
//    _rightBtn.titleLabel.alpha = 1;
//    [_rightBtn.titleLabel setFont:[UIFont fontWithName:PingFangSCMedium size:18*fontSizeScaleRate_SE]];
//    _selectedItemIndex = 1;
//}
//
//- (void)clickTitleLeft {
//    NSLog(@"left");
//    _sliderLinePart.frame = CGRectMake(WScaleRate_SE * 17 , HScaleRate_SE * 44, _sliderWidth, _sliderHeight);
//    _leftBtn.titleLabel.alpha = 1;
//    [_leftBtn.titleLabel setFont:[UIFont fontWithName:PingFangSCMedium size:18*fontSizeScaleRate_SE]];
//    _rightBtn.titleLabel.alpha = 0.8;
//    [_rightBtn.titleLabel setFont:[UIFont fontWithName:PingFangSCMedium size:14*fontSizeScaleRate_SE]];
//    _selectedItemIndex = 0;
//}

@end
