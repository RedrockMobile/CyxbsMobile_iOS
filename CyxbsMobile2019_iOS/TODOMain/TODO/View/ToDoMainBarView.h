//
//  ToDoMainBarView.h
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/8/21.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@protocol ToDoMainBarViewDelegate <NSObject>

/// 跳回到上一个界面
- (void)pop;

/// 添加待办事项
- (void)addMatter;

@end

/**
 todo首页的一个bar
 */
@interface ToDoMainBarView : UIView
@property (nonatomic, weak) id<ToDoMainBarViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
