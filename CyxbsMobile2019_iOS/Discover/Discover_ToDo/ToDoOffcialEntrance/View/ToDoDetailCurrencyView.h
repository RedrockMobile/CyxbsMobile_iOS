//
//  ToDoDetailReminedTimeView.h
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/9/18.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol  ToDoDetailCurrencyViewDelegate <NSObject>
/// 更改无效的提示
- (void)changeInvaliePrompt;
@end

/**
这是提醒时间、重复、备注三个view的基类
 主要包含：
 设置标题的label
 分割线
 一个透明的遮罩View，当状态是已完成的情况下，点击这个透明的View会触发设置无效
 */
@interface ToDoDetailCurrencyView : UIView

/// 在已完成状态下点击的遮罩btn
@property (nonatomic, strong) UIButton *maskBtn;

/// 设置标题的label
@property (nonatomic, strong) UILabel *titleLbl;

/// 底部的分割线
@property (nonatomic, strong) UIView *botttomDividerView;

@property (nonatomic, weak) id<ToDoDetailCurrencyViewDelegate> delegate;

///暴露给子类，让子类可以覆写前调用父类的方法
- (void)setUI;
@end

NS_ASSUME_NONNULL_END
