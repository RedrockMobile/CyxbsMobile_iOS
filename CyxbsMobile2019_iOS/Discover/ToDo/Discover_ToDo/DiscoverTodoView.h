//
//  DiscoverTodoView.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/8/6.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TodoDataModel.h"

NS_ASSUME_NONNULL_BEGIN
@class DiscoverTodoView;
/// 发现页的todo，上面显示了会显示三个事项
@protocol DiscoverTodoViewDelegate <NSObject>
/// 加号按钮点击后调用
- (void)addBtnClickedTodoView:(DiscoverTodoView*)todoView;
- (void)todoView:(DiscoverTodoView*)todoView didAlterWithModel:(TodoDataModel*)model;
- (void)localBtnClickedTodoView:(DiscoverTodoView*)todoView;
- (void)cloudBtnClickedTodoView:(DiscoverTodoView*)todoView;
@end

@class DiscoverTodoView;

@protocol DiscoverTodoViewDataSource <NSObject>

- (NSArray<TodoDataModel*>*)dataModelToShowForDiscoverTodoView:(DiscoverTodoView*)view;

@end

@interface DiscoverTodoView : UIView

/// 代理会设置成DiscoverViewController
@property(nonatomic, weak)id <DiscoverTodoViewDelegate> delegate;
@property(nonatomic, weak)id <DiscoverTodoViewDataSource> dataSource;

- (void)reloadData;
- (void)showConflictWithServerTime:(NSInteger)serverTime localTime:(NSInteger) localTime;
- (void)removeConflictView;
@end

NS_ASSUME_NONNULL_END
