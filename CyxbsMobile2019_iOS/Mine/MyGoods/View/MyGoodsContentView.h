//
//  MyGoodsContentView.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/5/1.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MyGoodsContentViewDelegate <NSObject>

- (void)backButtonClicked;
- (void)didNotRecievedButtonClicked:(UIButton *)sender;
- (void)recievedButtonClicked:(UIButton *)sender;

@end

@interface MyGoodsContentView : UIView

@property (nonatomic, weak) id<MyGoodsContentViewDelegate> delegate;

/// 未领取按钮
@property (nonatomic, weak) UIButton *didNotRecievedButton;

/// 已领取按钮
@property (nonatomic, weak) UIButton *recievedButton;

/// 未领取列表
@property (nonatomic, weak) UITableView *didNotRecievedTableView;

/// 已领取列表
@property (nonatomic, weak) UITableView *recievedTableView;

@property (nonatomic, weak) UIScrollView *scrollView;

@end

NS_ASSUME_NONNULL_END
