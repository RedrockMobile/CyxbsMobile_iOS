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
            self.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1] darkColor:[UIColor colorWithHexString:@"#000000" alpha:1]];
        } else {
            // Fallback on earlier versions
        }
        //添加控件
//        [self addTopBarView];
        [self addTextView];
        [self addAddPhotosBtn];
    }
    return self;
}


#pragma mark- 设置各种控件
/// 添加文本内容：包括TextView、placeholde的label、记录字数的label
- (void)addTextView{
    //textView
        //1.属性设置
    if (_releaseTextView == nil) {
        _releaseTextView = [[UITextView alloc] init];
        _releaseTextView.font = [UIFont fontWithName:PingFangSCBold size:16];
        if (@available(iOS 11.0, *)) {
            _releaseTextView.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
            _releaseTextView.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1] darkColor:[UIColor colorWithHexString:@"#000000" alpha:1]];
        } else {
            // Fallback on earlier versions
        }
    }
        //2.frame
    [self addSubview:self.releaseTextView];
    [self.releaseTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W - 32, MAIN_SCREEN_H * 0.1574));
    }];
    
    //placeHolder
        //1.属性设置
    if (_placeHolderLabel == nil) {
        _placeHolderLabel = [[UILabel alloc] init];
        _placeHolderLabel.text = @"分享你的新鲜事～";
        _placeHolderLabel.font = [UIFont fontWithName:@"PingFangSC-Bold" size:16];
        if (@available(iOS 11.0, *)) {
            _placeHolderLabel.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#AEBCD5" alpha:1] darkColor:[UIColor colorWithHexString:@"#838383" alpha:1]];
        } else {
            // Fallback on earlier versions
        }
    }
        //2.frame
    [self.releaseTextView addSubview:self.placeHolderLabel];
    [self.placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.releaseTextView).offset(MAIN_SCREEN_W * 0.0413);
        make.left.equalTo(self.releaseTextView);
        make.top.equalTo(self.releaseTextView).offset(MAIN_SCREEN_H * 0.0225);
        make.height.mas_equalTo(15.5);
    }];
    
    //记录字数的label
        //1.属性设置
    if (_numberOfTextLbl == nil) {
        _numberOfTextLbl = [[UILabel alloc] init];
        _numberOfTextLbl.font = [UIFont fontWithName:@"PingFangSC-Medium" size:10.92];
        if (@available(iOS 11.0, *)) {
            _numberOfTextLbl.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#60718D" alpha:1] darkColor:[UIColor colorWithHexString:@"#838484" alpha:1]];
        } else {
            // Fallback on earlier versions
        }
    }
    //2.frame
    [self addSubview:self.numberOfTextLbl];
    [self.numberOfTextLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.releaseTextView);
        make.right.equalTo(self).offset(-MAIN_SCREEN_W *0.0413);
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
        label.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#AEBCD5" alpha:1] darkColor:[UIColor colorWithHexString:@"#838383" alpha:1]];
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
