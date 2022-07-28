//
//  DynamicDetailTopBarView.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/4/15.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "DynamicDetailTopBarView.h"
@interface DynamicDetailTopBarView()
/// 标题的label
@property (nonatomic, strong) UILabel *titleLbl;

/// 返回的透明按钮
@property (nonatomic, strong) UIButton *backbtn;

///返回的图标箭头
@property (nonatomic, strong) UIImageView *backIconImageView;

/// 底部的分割线
@property (nonatomic, strong) UIView *bottomDividerView;
@end
@implementation DynamicDetailTopBarView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1] darkColor:[UIColor colorWithHexString:@"#000000" alpha:1]];
        [self addSomeConstraints];
    }
    return self;
}

#pragma mark- private methods
/// 给这些控件添加一些约束
- (void)addSomeConstraints{
    [self addSubview:self.titleLbl];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    
    [self addSubview:self.backIconImageView];
    [self.backIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(MAIN_SCREEN_W * 0.0427);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(7 * WScaleRate_SE, 14 * HScaleRate_SE));
    }];
    
//    self.backbtn.backgroundColor = [UIColor redColor];
    [self addSubview:self.backbtn];
    [self.backbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.mas_equalTo(MAIN_SCREEN_W * 0.0427 * 4);
    }];
    
    
    [self addSubview:self.bottomDividerView];
    [self.bottomDividerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(1);
    }];
}


#pragma mark- getter
- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.text = @"详情";
        _titleLbl.font = [UIFont fontWithName:PingFangSCBold size:21 * fontSizeScaleRate_SE];
        _titleLbl.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
    }
    return _titleLbl;
}

- (UIButton *)backbtn{
    if (!_backbtn) {
        _backbtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _backbtn.backgroundColor = [UIColor clearColor];
        
        [_backbtn addTarget:self.delegate action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backbtn;
}

- (UIImageView *)backIconImageView{
    if (!_backIconImageView) {
        _backIconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _backIconImageView.image = [UIImage imageNamed:@"返回的小箭头"];
    }
    return _backIconImageView;
}

- (UIView *)bottomDividerView{
    if (!_bottomDividerView) {
        _bottomDividerView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomDividerView.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#E3E8ED" alpha:1] darkColor:[UIColor colorWithHexString:@"#343434" alpha:1]];
    }
    return _bottomDividerView;
}
@end
