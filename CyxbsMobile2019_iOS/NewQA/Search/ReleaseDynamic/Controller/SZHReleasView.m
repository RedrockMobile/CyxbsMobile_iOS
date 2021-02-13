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
        //设置背景颜色
        if (@available(iOS 11.0, *)) {
            self.backgroundColor = [UIColor colorNamed:@"SZH发布动态主板颜色"];
        } else {
            // Fallback on earlier versions
        }
        //添加控件
        [self addTopBarView];
        [self addTextView];
        [self addAddPhotosBtn];
    }
    return self;
}


#pragma mark- 设置各种控件
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
        make.top.equalTo(self).offset(MAIN_SCREEN_H * 0.0572);
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
        [_releaseBtn setTitle:@"发布" forState:UIControlStateNormal];
        [_releaseBtn setTitle:@"发布" forState:UIControlStateDisabled];
        _releaseBtn.titleLabel.font = [UIFont fontWithName:PingFangSCBold size:13];
        [_releaseBtn addTarget:self.delegate action:@selector(releaseDynamic) forControlEvents:UIControlEventTouchUpInside];
        _releaseBtn.layer.cornerRadius = MAIN_SCREEN_W * 0.0411;
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

/// 添加文本内容：包括TextView、placeholde的label、记录字数的label
- (void)addTextView{
    //textView
        //1.属性设置
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
        //2.frame
    [self addSubview:self.releaseTextView];
    [self.releaseTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.topSeparationView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W, MAIN_SCREEN_H * 0.1574));
    }];
    
    //placeHolder
        //1.属性设置
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
        //2.frame
    [self.releaseTextView addSubview:self.placeHolderLabel];
    [self.placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.releaseTextView).offset(MAIN_SCREEN_W * 0.0413);
        make.top.equalTo(self.releaseTextView).offset(MAIN_SCREEN_H * 0.0225);
        make.height.mas_equalTo(15.5);
    }];
    
    //记录字数的label
        //1.属性设置
    if (_numberOfTextLbl == nil) {
        _numberOfTextLbl = [[UILabel alloc] init];
        _numberOfTextLbl.font = [UIFont fontWithName:@"PingFangSC-Medium" size:10.92];
        if (@available(iOS 11.0, *)) {
            _numberOfTextLbl.textColor = [UIColor colorNamed:@"SZHHistoryCellLblColor"];
        } else {
            // Fallback on earlier versions
        }
    }
    //2.frame
    [self addSubview:self.numberOfTextLbl];
    [self.numberOfTextLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.releaseTextView);
        make.right.equalTo(self.releaseBtn);
        make.height.mas_equalTo(11);
    }];
}

/// 添加照片的按钮
- (void)addAddPhotosBtn{
    UIButton *button = [[UIButton alloc] init];
    [button setBackgroundImage:[UIImage imageNamed:@"添加图片背景"] forState:UIControlStateNormal];
    button.layer.cornerRadius = 10;
    button.layer.masksToBounds = YES;
    [button addTarget:self.delegate action:@selector(addPhotos) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.releaseTextView.mas_bottom).offset(7);
        make.left.equalTo(self).offset(16);
        make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W * 0.296, MAIN_SCREEN_W * 0.296));
    }];
    
    //添加中心的小图片框
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"相机"];
    [button addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(button.mas_centerX);
        make.bottom.equalTo(button.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(28, 28));
    }];
    
    //下方的label
    UILabel *label = [[UILabel alloc] init];
    label.text = @"添加图片";
    label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    if (@available(iOS 11.0, *)) {
        label.textColor = [UIColor colorNamed:@"SZH发布动态提示文字颜色"];
    } else {
        // Fallback on earlier versions
    }
    [button addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageView);
        make.top.equalTo(imageView.mas_bottom).offset(13.5);
        make.height.mas_equalTo(11.5);
    }];
    
    self.addPhotosBtn = button;
    
}
@end
