//
//  UIControl+MGD.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/3/14.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

// 利用runtime去防止按钮多次点击的问题

NS_ASSUME_NONNULL_BEGIN

@interface UIControl (MGD)

// 点击事件的间隔
@property (nonatomic, assign) NSTimeInterval canTapEventInterval;

// 是否忽略点击事件，不响应
@property (nonatomic, assign) BOOL ignoreEvent;

@end

NS_ASSUME_NONNULL_END
