//
//  TopFollowView.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/12/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupBtn.h"
#import "GroupModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol TopFollowViewDelegate <NSObject>

///点击跳转到圈子广场
- (void)FollowGroups;
///点击跳转到具体的圈子里去
- (void)ClickedGroupBtn:(GroupBtn *)sender;

@optional
- (void) reloadTopFollowViewWithArray:(NSMutableArray *)array;

- (void)removeTopFollowView;

@end

@interface TopFollowView : UIView

///未关注圈子时的按钮
@property (nonatomic, strong) UIButton *followBtn;

///关注的圈子的scrollView
@property (nonatomic, strong) UIScrollView *groupsScrollView;

@property (nonatomic, strong) UILabel *myFollowLab;

@property (nonatomic, weak) id<TopFollowViewDelegate> delegate;

- (void)loadViewWithArray:(NSMutableArray *)dataArray;

- (void)loadTopFollowViewWithGroup:(NSMutableArray *)dataArray;

- (void)startAnimationWith:(NSMutableArray *)dataArray;

//- (instancetype)initWithFrame:(CGRect)frame And:(NSMutableArray *)dataArray;

@end

NS_ASSUME_NONNULL_END
