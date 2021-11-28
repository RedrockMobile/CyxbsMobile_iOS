//
//  NewQATopView.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/8/17.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "NewQATopView.h"

@interface NewQATopView()

@property (nonatomic, strong) UIView *bottomBackView;
@property (nonatomic, strong) UIImageView *leftCircleView;
@property (nonatomic, strong) UIImageView *rightCircleView;

@end

@implementation NewQATopView

- (void)setItemHeight:(CGFloat)itemHeight
{
    _itemHeight = itemHeight;
    
    _backImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _backImageView.layer.masksToBounds = YES;
    _backImageView.image = [UIImage imageNamed:@"NewQATopImage"];
    [self addSubview:_backImageView];
    
    _leftCircleView = [[UIImageView alloc] init];
    _leftCircleView.layer.masksToBounds = YES;
    _leftCircleView.backgroundColor = [UIColor clearColor];
    _leftCircleView.image = [UIImage imageNamed:@"NewQATopLeftCircleImage"];
    [_backImageView addSubview:_leftCircleView];
    _rightCircleView = [[UIImageView alloc] init];
    _rightCircleView.layer.masksToBounds = YES;
    _rightCircleView.backgroundColor = [UIColor clearColor];
    _rightCircleView.image = [UIImage imageNamed:@"NewQATopRightCircleImage"];
    [_backImageView addSubview:_rightCircleView];
    [_leftCircleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backImageView.mas_top).mas_offset(12);
        make.left.mas_equalTo(self.backImageView.mas_left);
        make.width.mas_equalTo([UIImage imageNamed:@"NewQATopLeftCircleImage"].size.width);
        make.height.mas_equalTo([UIImage imageNamed:@"NewQATopLeftCircleImage"].size.height);
    }];
    
    [_rightCircleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backImageView.mas_top).mas_offset(30);
        make.right.mas_equalTo(self.backImageView.mas_right);
        make.width.mas_equalTo([UIImage imageNamed:@"NewQATopRightCircleImage"].size.width);
        make.height.mas_equalTo([UIImage imageNamed:@"NewQATopRightCircleImage"].size.height);
    }];
    
    //slider
    _tableSliderBackView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - _itemHeight, SCREEN_WIDTH, HScaleRate_SE * 54)];
    _tableSliderBackView.backgroundColor = [UIColor colorNamed:@"TableViewBackColor"];
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
    
    // 两个按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    leftBtn.frame = CGRectMake(WScaleRate_SE * 17, HScaleRate_SE * 10, WScaleRate_SE * 40, HScaleRate_SE * 28);
    [leftBtn setTitle:@"推荐" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor colorNamed:@"NewQAMainVCBtnColor"] forState:UIControlStateNormal];
    [leftBtn.titleLabel setFont:[UIFont fontWithName:PingFangSCMedium size:18*fontSizeScaleRate_SE]];
    [leftBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [leftBtn addTarget:self action:@selector(clickTitleLeft) forControlEvents:UIControlEventTouchUpInside];
    [_tableSliderBackView addSubview:leftBtn];
    _leftBtn = leftBtn;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    rightBtn.frame = CGRectMake(WScaleRate_SE * 76, HScaleRate_SE * 10, WScaleRate_SE * 40, HScaleRate_SE * 28);
    [rightBtn setTitle:@"关注" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor colorNamed:@"NewQAMainVCBtnColor"] forState:UIControlStateNormal];
    rightBtn.titleLabel.alpha = 0.8;
    [rightBtn.titleLabel setFont:[UIFont fontWithName:PingFangSCMedium size:14*fontSizeScaleRate_SE]];
    [rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [rightBtn addTarget:self action:@selector(clickTitleRight) forControlEvents:UIControlEventTouchUpInside];
    [_tableSliderBackView addSubview:rightBtn];
    _rightBtn = rightBtn;
    
    self.leftBtnFrame = leftBtn.frame;
    self.rightBtnFrame = rightBtn.frame;
}

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

- (void)clickTitleRight {
    NSLog(@"right");
    _sliderLinePart.frame = CGRectMake(WScaleRate_SE * 76 , HScaleRate_SE * 44, _sliderWidth, _sliderHeight);
    _leftBtn.titleLabel.alpha = 0.8;
    [_leftBtn.titleLabel setFont:[UIFont fontWithName:PingFangSCMedium size:14*fontSizeScaleRate_SE]];
    _rightBtn.titleLabel.alpha = 1;
    [_rightBtn.titleLabel setFont:[UIFont fontWithName:PingFangSCMedium size:18*fontSizeScaleRate_SE]];
}

- (void)clickTitleLeft {
    NSLog(@"left");
    _sliderLinePart.frame = CGRectMake(WScaleRate_SE * 17 , HScaleRate_SE * 44, _sliderWidth, _sliderHeight);
    _leftBtn.titleLabel.alpha = 1;
    [_leftBtn.titleLabel setFont:[UIFont fontWithName:PingFangSCMedium size:18*fontSizeScaleRate_SE]];
    _rightBtn.titleLabel.alpha = 0.8;
    [_rightBtn.titleLabel setFont:[UIFont fontWithName:PingFangSCMedium size:14*fontSizeScaleRate_SE]];
}

@end
