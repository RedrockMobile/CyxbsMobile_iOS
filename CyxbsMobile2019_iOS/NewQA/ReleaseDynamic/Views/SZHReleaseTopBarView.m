//
//  SZHReleaseTopBarView.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/2/22.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "SZHReleaseTopBarView.h"

@implementation SZHReleaseTopBarView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self addTopBarView];
    }
    return self;
}

/// 添加顶部的bar的视图控件：包括左边返回按钮、中间标题，右边发布按钮
- (void)addTopBarView{
    //左边的按钮：此处由按钮和图片构成
        //图片
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    backImage.image = [UIImage imageNamed:@"返回的小箭头"];
    [self addSubview:backImage];
    [backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(MAIN_SCREEN_W * 0.0427);
        make.bottom.equalTo(self.mas_top).offset(NVGBARHEIGHT);
        make.size.mas_equalTo(CGSizeMake(7, 14));
    }];
    
        //按钮
    if (_leftBtn == nil) {
        _leftBtn = [[UIButton alloc] init];
//        _leftBtn.backgroundColor = [UIColor redColor];
            //让代理跳回到上一个界面
        [_leftBtn addTarget:self.delegate action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    }
    [self addSubview:self.leftBtn];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.bottom.equalTo(self).offset(-MAIN_SCREEN_W * 0.0427);
        make.width.mas_equalTo(MAIN_SCREEN_W * 0.0427 * 4);
    }];
    
    //标题label
        //1.属性
    if (_titleLbl == nil) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.text = @"发布动态";
//        _titleLbl.font = [UIFont fontWithName:@"PingFangSC-Medium" size:21];
        _titleLbl.font = [UIFont fontWithName:PingFangSCSemibold size:21];
        if (@available(iOS 11.0, *)) {
            _titleLbl.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
        } else {
            // Fallback on earlier versions
        }
    }
        //2.frame
    [self addSubview:self.titleLbl];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(backImage);
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
        //设置字体，如果机型是全面屏，则字号放大
        if(MAIN_SCREEN_H > 667){
            _releaseBtn.titleLabel.font = [UIFont fontWithName:PingFangSCBold size:16];
        }else{
            _releaseBtn.titleLabel.font = [UIFont fontWithName:PingFangSCBold size:13];
        }
        [_releaseBtn addTarget:self.delegate action:@selector(releaseDynamic) forControlEvents:UIControlEventTouchUpInside];
        if (@available(iOS 11.0, *)) {
            self.releaseBtn.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#AEBCD5" alpha:1] darkColor:[UIColor colorWithHexString:@"#5A5A5A" alpha:1]];
        } else {
            // Fallback on earlier versions
        }
    }
        //2.frame
    [self addSubview:self.releaseBtn];
    [self.releaseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLbl);
        make.right.equalTo(self).offset(-MAIN_SCREEN_W *0.0413);
        make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W * 0.1573, MAIN_SCREEN_H * 0.042));
    }];
    _releaseBtn.layer.cornerRadius = MAIN_SCREEN_H * 0.021;
    
    //底部的分割条
        //1.属性设置
    if (_topSeparationView == nil) {
        _topSeparationView = [[UIView alloc] init];
        if (@available(iOS 11.0, *)) {
            _topSeparationView.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#E2E8EE" alpha:1] darkColor:[UIColor colorWithHexString:@"#252525" alpha:1]];
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
