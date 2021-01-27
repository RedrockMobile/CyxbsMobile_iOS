//
//  SZHReleasView.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/1/27.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "SZHReleasView.h"
@interface SZHReleasView()
@property (nonatomic, strong) UITextView *textView;

/// 左边返回的button
@property (nonatomic, strong) UIButton *leftBtn;

@property (nonatomic, strong) UILabel *titleLbl;        //中间的label

/// 顶部的分割条
@property (nonatomic, strong)UIView *topSeparationView;
@end
@implementation SZHReleasView
- (instancetype)init{
    self = [super init];
    if (self) {
        if (@available(iOS 11.0, *)) {
            self.backgroundColor = [UIColor colorNamed:@"SZH发布动态主板颜色"];
        } else {
            // Fallback on earlier versions
        }
    }
    return self;
}

- (void)layoutSubviews{
    //左边的返回按钮
    [self addSubview:self.leftBtn];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(MAIN_SCREEN_W * 0.0427);
        make.top.equalTo(self).offset(MAIN_SCREEN_H * 0.0572);
        make.size.mas_equalTo(CGSizeMake(7, 14));
    }];
    
    //中间的标题
    [self addSubview:self.titleLbl];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.leftBtn);
        make.height.mas_equalTo(20);
    }];
    
    //发布按钮
    [self addSubview:self.releaseBtn];
    [self.releaseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLbl);
        make.right.equalTo(self).offset(-MAIN_SCREEN_W *0.0413);
        make.size.mas_equalTo(CGSizeMake(59, 28));
    }];
    
    //分割条
    [self addSubview:self.topSeparationView];
    [self.topSeparationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.titleLbl.mas_bottom).offset(MAIN_SCREEN_H * 0.018);
        make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W, 1));
    }];
    
    //文本输入内容
    [self addSubview:self.releaseTextView];
    [self.releaseTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.topSeparationView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W, MAIN_SCREEN_H * 0.1574));
    }];
    
    //提示文字label
    [self.releaseTextView addSubview:self.placeHolderLabel];
    [self.placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.releaseTextView).offset(MAIN_SCREEN_W * 0.0413);
        make.top.equalTo(self.releaseTextView).offset(MAIN_SCREEN_H * 0.0225);
        make.height.mas_equalTo(15.5);
    }];
    
    //显示字数的label
    [self addSubview:self.numberOfTextLbl];
    [self.numberOfTextLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.releaseTextView);
        make.right.equalTo(self.releaseBtn);
        make.height.mas_equalTo(11);
    }];
    
}

#pragma mark- getter
- (UIButton *)leftBtn{
    if (_leftBtn == nil) {
        _leftBtn = [[UIButton alloc] init];
        [_leftBtn setBackgroundImage:[UIImage imageNamed:@"返回的小箭头"] forState:UIControlStateNormal];
            //让代理跳回到上一个界面
        [_leftBtn addTarget:self.delegate action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}
- (UILabel *)titleLbl{
    if (_titleLbl == nil) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.text = @"发布动态";
        _titleLbl.font = [UIFont fontWithName:PingFangSCHeavy size:21];
        if (@available(iOS 11.0, *)) {
            _titleLbl.textColor = [UIColor colorNamed:@"SZHHotHistoryKnowledgeLblColor"];
        } else {
            // Fallback on earlier versions
        }
    }
    return _titleLbl;
}
- (UIButton *)releaseBtn{
    if (_releaseBtn == nil) {
        _releaseBtn = [[UIButton alloc] init];
            //最开始文本内容为空时设置为禁用
        _releaseBtn.enabled = NO;
        [_releaseBtn setTitle:@"发布" forState:UIControlStateNormal];
        [_releaseBtn setTitle:@"发布" forState:UIControlStateDisabled];
        _releaseBtn.titleLabel.font = [UIFont fontWithName:PingFangSCBold size:13];
        if (_releaseBtn.state == UIControlStateDisabled) {
            if (@available(iOS 11.0, *)) {
                _releaseBtn.backgroundColor = [UIColor colorNamed:@"SZH发布动态按钮禁用背景颜色"];
            } else {
                // Fallback on earlier versions
            }
        }else{
            _releaseBtn.backgroundColor = [UIColor blueColor];
        }
        [_releaseBtn addTarget:self.delegate action:@selector(releaseDynamic) forControlEvents:UIControlEventTouchUpInside];
        _releaseBtn.layer.cornerRadius = MAIN_SCREEN_W * 0.0411;
    }
    return _releaseBtn;
}
- (UIView *)topSeparationView{
    if (_topSeparationView == nil) {
        _topSeparationView = [[UIView alloc] init];
        if (@available(iOS 11.0, *)) {
            _topSeparationView.backgroundColor = [UIColor colorNamed:@"SZH分割条颜色"];
        } else {
            // Fallback on earlier versions
        }
    }
    return _topSeparationView;
}
- (UITextView *)releaseTextView{
    if (_releaseTextView == nil) {
        _releaseTextView = [[UITextView alloc] init];
        _releaseTextView.font = [UIFont fontWithName:PingFangSCBold size:16];
        if (@available(iOS 11.0, *)) {
            _releaseTextView.textColor = [UIColor colorNamed:@"SZHHotHistoryKnowledgeLblColor"];
            _releaseTextView.backgroundColor = [UIColor colorNamed:@"SZH发布动态主板颜色"];
        } else {
            // Fallback on earlier versions
        }
    }
    return  _releaseTextView;
}
- (UILabel *)placeHolderLabel{
    if (_placeHolderLabel == nil) {
        _placeHolderLabel = [[UILabel alloc] init];
        _placeHolderLabel.text = @"分享你的新鲜事～";
        _placeHolderLabel.font = [UIFont fontWithName:@"PingFangSC-Bold" size:16];
        if (@available(iOS 11.0, *)) {
            _placeHolderLabel.textColor = [UIColor colorNamed:@"SZH发布动态提示文字颜色"];
        } else {
            // Fallback on earlier versions
        }
    }
    return _placeHolderLabel;
}
- (UILabel *)numberOfTextLbl{
    if (_numberOfTextLbl == nil) {
        _numberOfTextLbl = [[UILabel alloc] init];
        _numberOfTextLbl.text = @"0/500";
        _numberOfTextLbl.font = [UIFont fontWithName:@"PingFangSC-Medium" size:10.92];
        if (@available(iOS 11.0, *)) {
            _numberOfTextLbl.textColor = [UIColor colorNamed:@"SZHHistoryCellLblColor"];
        } else {
            // Fallback on earlier versions
        }
    }
    return _numberOfTextLbl;
}
@end
