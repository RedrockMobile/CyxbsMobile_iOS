//
//  SZHReleaseTopBarView.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/2/22.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "SZHReleaseTopBarView.h"

@implementation SZHReleaseTopBarView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addTopBarView];
    }
    return self;
}

/// 添加顶部的bar的视图控件：包括左边返回按钮、中间标题，右边发布按钮
- (void)addTopBarView{
    //左边的按钮
        //1.属性设置
    if (_leftBtn == nil) {
        _leftBtn = [[UIButton alloc] init];
        [_leftBtn setBackgroundImage:[UIImage imageNamed:@"返回的小箭头"] forState:UIControlStateNormal];
            //让代理跳回到上一个界面
        [_leftBtn addTarget:self.delegate action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    }
        //2.frame
    [self addSubview:self.leftBtn];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(MAIN_SCREEN_W * 0.0427);
//        make.top.equalTo(self).offset(MAIN_SCREEN_H * 0.0572);
//        make.top.equalTo(self);
//        make.top.equalTo(self).offset(MAIN_SCREEN_H * 0.0286);
        make.bottom.equalTo(self.mas_top).offset(NVGBARHEIGHT);
        make.size.mas_equalTo(CGSizeMake(7, 14));
    }];
    
    //标题label
        //1.属性
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
        //2.frame
    [self addSubview:self.titleLbl];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.leftBtn);
        make.height.mas_equalTo(20);
    }];
    
    //发布按钮
        //1.属性设置
    if (_releaseBtn == nil) {
        _releaseBtn = [[UIButton alloc] init];
        //最开始设置禁用
        _releaseBtn.userInteractionEnabled = NO;
        [_releaseBtn setTitle:@"发布" forState:UIControlStateNormal];
        [_releaseBtn setTitle:@"发布" forState:UIControlStateDisabled];
        _releaseBtn.titleLabel.font = [UIFont fontWithName:PingFangSCBold size:13];
        [_releaseBtn addTarget:self.delegate action:@selector(releaseDynamic) forControlEvents:UIControlEventTouchUpInside];
        _releaseBtn.layer.cornerRadius = MAIN_SCREEN_W * 0.0411;
        if (@available(iOS 11.0, *)) {
            self.releaseBtn.backgroundColor =  [UIColor colorNamed:@"SZH发布动态按钮禁用背景颜色"];
        } else {
            // Fallback on earlier versions
        }
    }
        //2.frame
    [self addSubview:self.releaseBtn];
    [self.releaseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLbl);
        make.right.equalTo(self).offset(-MAIN_SCREEN_W *0.0413);
        make.size.mas_equalTo(CGSizeMake(59, 28));
    }];
    
    //底部的分割条
        //1.属性设置
    if (_topSeparationView == nil) {
        _topSeparationView = [[UIView alloc] init];
        if (@available(iOS 11.0, *)) {
            _topSeparationView.backgroundColor = [UIColor colorNamed:@"SZH分割条颜色"];
        } else {
            // Fallback on earlier versions
        }
    }
        //2.frame
    [self addSubview:self.topSeparationView];
    [self.topSeparationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.titleLbl.mas_bottom).offset(MAIN_SCREEN_H * 0.018);
        make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W, 1));
    }];
}
@end
