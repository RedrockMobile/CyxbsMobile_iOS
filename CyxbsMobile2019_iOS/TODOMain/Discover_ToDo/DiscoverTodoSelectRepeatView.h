//
//  DiscoverTodoSelectRepeatView.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/8/8.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "DiscoverTodoSetRemindBasicView.h"
#import "TodoDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@class DiscoverTodoSelectRepeatView;

@protocol DiscoverTodoSelectRepeatViewDelegate <NSObject>

- (void)selectRepeatViewSureBtnClicked:(DiscoverTodoSelectRepeatView*)view;
- (void)selectRepeatViewCancelBtnClicked;
@end
/// 选择重复提醒的view
@interface DiscoverTodoSelectRepeatView : DiscoverTodoSetRemindBasicView

/// 日期数组
@property (nonatomic, strong)NSMutableArray* dateArr;

/// 重复模式，枚举
@property (nonatomic, assign)TodoDataModelRepeatMode repeatMode;

@property (nonatomic, weak)id <DiscoverTodoSelectRepeatViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
