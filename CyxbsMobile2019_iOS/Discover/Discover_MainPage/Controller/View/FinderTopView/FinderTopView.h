//
//  FinderTopView.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/4/10.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// "发现"顶视图，直接init
@interface FinderTopView : UIView

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

/// 单击了签到
/// @param target 应为控制器
/// @param action 应跳转到签到
- (void)addSignBtnTarget:(id)target action:(SEL)action;

/// 单击了我的消息
/// @param target 应为控制器
/// @param action 应跳转到我的消息
- (void)addMessageBtnTarget:(id)target action:(SEL)action;

@end

NS_ASSUME_NONNULL_END
