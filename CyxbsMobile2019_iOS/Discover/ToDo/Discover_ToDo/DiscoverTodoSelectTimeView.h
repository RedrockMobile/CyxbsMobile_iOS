//
//  DiscoverTodoSelectTimeView.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/8/8.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "DiscoverTodoSetRemindBasicView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DiscoverTodoSelectTimeViewDelegate <NSObject>

- (void)selectTimeViewSureBtnClicked:(NSDateComponents*)components;

- (void)selectTimeViewCancelBtnClicked;

@end
/// 选择提醒时间的VIew
@interface DiscoverTodoSelectTimeView : DiscoverTodoSetRemindBasicView
@property(nonatomic, weak)id <DiscoverTodoSelectTimeViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
