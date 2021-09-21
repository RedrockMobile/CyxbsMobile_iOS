//
//  ToDoDetailRepeatView.h
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/9/18.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "ToDoDetailCurrencyView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ToDoDetailRepeatViewDelegate <NSObject, ToDoDetailCurrencyViewDelegate>

/// 选择重复的模式
- (void)chooseRepeatStytle;
@end

/**
 这是设置重复模式的一个View
 主要有一个带点击手势的标题、一个点击后可以设置重复模式的labl、一个分割线、一个设置点击无效的按钮
 */
@interface ToDoDetailRepeatView : ToDoDetailCurrencyView

@property (nonatomic, weak) id<ToDoDetailRepeatViewDelegate> delegate;

/// 当重复为空时出现“设置重复提醒”文字的label
@property (nonatomic, strong) UILabel *repeatLbl;

/// 展示重复的scrollerView
@property (nonatomic, strong) UIScrollView *repeatContentScrollView;

/// 设置repeatScrollView上面的label布局
/// @param arrary 传入的label
- (void)relayoutLblsByArray:(NSArray *)arrary;
@end

NS_ASSUME_NONNULL_END
