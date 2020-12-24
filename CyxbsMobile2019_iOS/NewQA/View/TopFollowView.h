//
//  TopFollowView.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/12/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol TopFollowViewDelegate <NSObject>

///点击关注你喜欢的圈子
- (void)FollowGroups;
///点击跳转到具体的圈子里去
- (void)printClick:(UIButton *)sender;

@end

@interface TopFollowView : UIView

///未关注圈子时的按钮
@property (nonatomic, strong) UIButton *followBtn;

///关注的圈子的scrollView
@property (nonatomic, strong) UIScrollView *groupsScrollView;

@property (nonatomic, strong) UILabel *myFollowLab;

@property (nonatomic, weak) id<TopFollowViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame And:(NSMutableArray *)dataArray;

@end

NS_ASSUME_NONNULL_END
