//
//  GYYImageChooseCollectionViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by 郭蕴尧 on 2021/1/28.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "GYYImageChooseCollectionViewCell.h"

@implementation GYYImageChooseCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.photoImageView = [[SZHPhotoImageView alloc] init];
        self.photoImageView.delegate = self;
        [self addSubview:self.photoImageView];
        
        //约束图片框
        [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self addAddPhotosBtn];
    }
    return self;
}

/// 添加照片的按钮
- (void)addAddPhotosBtn{
    
    UIButton *button = [[UIButton alloc] init];
    [button setBackgroundImage:[UIImage imageNamed:@"添加图片背景"] forState:UIControlStateNormal];
    button.layer.cornerRadius = 10;
    button.layer.masksToBounds = YES;
    button.userInteractionEnabled = NO;
    
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
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
    
    self.addNewPhotoButton = button;
    
}
#pragma mark -- SZHPhotoImageViewDelegate
- (void)clearPhotoImageView:(UIImageView *)imageView{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageDelegateAction:)]) {
        [self.delegate imageDelegateAction:self];
    }
    
}
@end
