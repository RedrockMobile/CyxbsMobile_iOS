//
//  ToDoDetailReminderTimeView.h
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/9/18.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToDoDetailCurrencyView.h"
NS_ASSUME_NONNULL_BEGIN

@protocol ToDoDetailReminderTimeViewDelegate <NSObject, ToDoDetailCurrencyViewDelegate>

/// 设置提醒时间
- (void)setReminderTime;

@end
/**
 此类继承自ToDoDetailCurrencyView，进行提醒时间设置
 */
@interface ToDoDetailReminderTimeView : ToDoDetailCurrencyView

@property (nonatomic, weak) id<ToDoDetailReminderTimeViewDelegate> delegate;

/// 设置提醒时间的label，会为其添加手势，触发点击事件
@property (nonatomic, strong) UILabel *reminderTimeLbl;
@end

NS_ASSUME_NONNULL_END
