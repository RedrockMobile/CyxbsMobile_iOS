//
//  DiscoverTodoSetRemindBasicView.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/8/8.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 设置提醒时间、和重复提醒的View的superclass，包含一个紫色三角形、一个取消按钮、一个确定按钮、一个分割线
@interface DiscoverTodoSetRemindBasicView : UIView

/// 紫色三角形
@property(nonatomic, strong)UIImageView* tipView;

/// 取消按钮
@property(nonatomic, strong)UIButton* cancelBtn;

/// 确定按钮
@property(nonatomic, strong)UIButton* sureBtn;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
