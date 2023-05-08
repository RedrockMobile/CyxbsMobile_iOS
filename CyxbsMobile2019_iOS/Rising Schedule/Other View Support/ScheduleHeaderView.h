//
//  ScheduleHeaderView.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/10/19.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ScheduleHeaderView;

#pragma mark - ScheduleHeaderViewDelegate

@protocol ScheduleHeaderViewDelegate <NSObject>

@optional

/// btn的SEL转换
/// - Parameters:
///   - view: 当前view
///   - btn: 操作的btn
- (void)scheduleHeaderView:(ScheduleHeaderView *)view didSelectedBtn:(UIButton *)btn;

/// 点击了双人图标，但自己不会发生变化
/// - Parameter view: 视图
- (void)scheduleHeaderViewDidTapDouble:(ScheduleHeaderView *)view;

- (void)scheduleHeaderViewDidTapInfo:(ScheduleHeaderView *)view;

@end

#pragma mark - ScheduleHeaderView

@interface ScheduleHeaderView : UIView

/// @"第n周"
@property (nonatomic, copy) NSString *title;

/// 回到本周 btn
@property (nonatomic) BOOL reBack;

/// 代理
@property (nonatomic, weak) id <ScheduleHeaderViewDelegate> delegate;

/// 绘制是否显示以及是单是双
/// 如果show为false，isSingle都没用
/// 默认为NO, NO
/// - Parameters:
///   - show: 是否展示
///   - isSingle: 是否单双
- (void)setShowMuti:(BOOL)show isSingle:(BOOL)isSingle;

/// 是否在展示
@property (nonatomic, readonly) BOOL isShow;

/// 是否单双
@property (nonatomic, readonly) BOOL isSingle;

@property (nonatomic) BOOL calenderEdit;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
