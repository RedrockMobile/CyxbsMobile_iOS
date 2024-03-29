//
//  ToDoDetailReminedTimeView.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/9/18.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "ToDoDetailCurrencyView.h"
@interface ToDoDetailCurrencyView()

@end
@implementation ToDoDetailCurrencyView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1] darkColor:[UIColor colorWithHexString:@"#000000" alpha:1]];
        [self setUI];
    }
    return self;
}

- (void)setUI{
    
    [self addSubview:self.titleLbl];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
    }];
    
    [self addSubview:self.botttomDividerView];
    [self.botttomDividerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.8267, 1));
    }];
    
}

- (void)clickMaskBtn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeInvaliePrompt)]) {
        [self.delegate changeInvaliePrompt];
    }
}

#pragma mark- getter
- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
        _titleLbl.font = [UIFont fontWithName:PingFangSCMedium size:18];
    }
    return _titleLbl;
}

- (UIView *)botttomDividerView{
    if (!_botttomDividerView) {
        _botttomDividerView = [[UIView alloc] initWithFrame:CGRectZero];
        _botttomDividerView.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#BDCCE5" alpha:0.2] darkColor:[UIColor colorWithHexString:@"#F8F9FC" alpha:0.1]];
    }
    return _botttomDividerView;
}

- (UIButton *)maskBtn{
    if (!_maskBtn) {
        _maskBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _maskBtn.backgroundColor = [UIColor clearColor];
        [_maskBtn addTarget:self action:@selector(clickMaskBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _maskBtn;
}

@end
