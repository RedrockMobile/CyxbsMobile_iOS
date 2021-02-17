//
//  SZHReleasView.h
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/1/27.
//  Copyright © 2021 Redrock. All rights reserved.
//
/**
    展示内容：发布动态页上半部分
 */
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SZHReleaseDelegate <NSObject>

/// 返回到上一个界面
- (void)pop;

/// 发布动态
- (void)releaseDynamic;

/// 添加图片
- (void)addPhotos;
@end
@interface SZHReleasView : UIView
/// 代理
@property (nonatomic, weak) id<SZHReleaseDelegate> delegate;

/// 发布动态文本内容输入框
@property (nonatomic, strong) UITextView *releaseTextView;

//显示字数的label
@property (nonatomic, strong) UILabel *numberOfTextLbl;

/// 提示文字
@property (nonatomic, strong) UILabel *placeHolderLabel;

/// 发布动态的按钮
@property (nonatomic, strong) UIButton *releaseBtn;

/// 添加图片按钮
@property (nonatomic, strong) UIButton *addPhotosBtn;
@end

NS_ASSUME_NONNULL_END
