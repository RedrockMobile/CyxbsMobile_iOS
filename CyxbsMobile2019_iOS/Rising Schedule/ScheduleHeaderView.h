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

@end

#pragma mark - ScheduleHeaderView

@interface ScheduleHeaderView : UIView

/// @"第n周"
@property (nonatomic, copy) NSString *inSection;

/// image
@property (nonatomic) BOOL isSingle;

/// 回到本周 btn
@property (nonatomic) BOOL reBack;

/// 代理
@property (nonatomic, weak) id <ScheduleHeaderViewDelegate> delegate;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
