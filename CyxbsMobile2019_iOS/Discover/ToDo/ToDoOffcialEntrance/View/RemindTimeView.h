//
//  RemindTimeView.h
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/8/24.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscoverTodoSetRemindBasicView.h"
NS_ASSUME_NONNULL_BEGIN
@protocol RemindTimeViewDelegate <NSObject>

- (void)selectTimeViewSureBtnClicked:(NSDateComponents*)components;

- (void)selectTimeViewCancelBtnClicked;

@end

/// 事项详情页点击提醒时间后会弹出
@interface RemindTimeView : UIView
@property (nonatomic, weak) id<RemindTimeViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
