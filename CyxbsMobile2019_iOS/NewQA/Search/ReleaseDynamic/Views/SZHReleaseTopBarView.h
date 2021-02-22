//
//  SZHReleaseTopBarView.h
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/2/22.
//  Copyright © 2021 Redrock. All rights reserved.
//
/**
 发布动态界面上的自定义navigationBar
 */
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol SZHReleaseTopBarViewDelegate <NSObject>

/// 返回到上一个界面
- (void)pop;

/// 发布动态
- (void)releaseDynamic;

@end
@interface SZHReleaseTopBarView : UIView
@property id<SZHReleaseTopBarViewDelegate> delegate;
/// 发布动态的按钮
@property (nonatomic, strong) UIButton *releaseBtn;

/// 左边返回的button
@property (nonatomic, strong) UIButton *leftBtn;

@property (nonatomic, strong) UILabel *titleLbl;        //中间的label

/// 顶部的分割条
@property (nonatomic, strong)UIView *topSeparationView;
@end

NS_ASSUME_NONNULL_END
