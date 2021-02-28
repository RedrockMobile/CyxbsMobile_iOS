//
//  MineViewController.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/10/21.
//  Copyright © 2019 Redrock. All rights reserved.
//个人页面的主控制器

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface MineViewController : UIViewController


/// 自定义转场动画要用到contentView
@property (nonatomic, strong) UIView *contentView;

/// 用于编辑界面的返回
@property (nullable, nonatomic, strong) UIPanGestureRecognizer *panGesture;

- (void)loadUserData;

@end

NS_ASSUME_NONNULL_END
