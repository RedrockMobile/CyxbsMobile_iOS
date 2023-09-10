//
//  CenterView.h
//  CyxbsMobile2019_iOS
//
//  Created by 宋开开 on 2023/3/15.
//  Copyright © 2023 Redrock. All rights reserved.
//

// 此类为游乐园界面View
#import <UIKit/UIKit.h>
#import "CenterPromptBoxView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CenterView : UIView

/// 顶部提示框
@property (nonatomic, strong) CenterPromptBoxView *centerPromptBoxView;

/// 美食图片
@property (nonatomic, strong) UIImageView *foodImg;

/// 美食按钮
@property (nonatomic, strong) UIButton *foodBtn;

/// 表态图片
@property (nonatomic, strong) UIImageView *biaoTaiImg;

/// 表态按钮
@property (nonatomic, strong) UIButton *biaoTaiBtn;

/// 活动图片
@property (nonatomic, strong) UIImageView *activityNotifyImg;

/// 活动按钮
@property (nonatomic, strong) UIButton *activityNotifyBtn;

@end

NS_ASSUME_NONNULL_END
