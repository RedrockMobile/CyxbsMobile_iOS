//
//  MineHeaderView.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/10/30.
//  Copyright © 2019 Redrock. All rights reserved.
//个人主页面的tableView顶部的一大块View都是这个类，这个类会被设置成tableView的headview

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 代理设置成个人主页面的控制器
@protocol MineHeaderViewDelegate <NSObject>

/// 点击编辑个人信息按钮后调用
- (void)editButtonClicked;

/// 点击签到框框内的 “签到按钮” 后调用
- (void)checkInButtonClicked;

/// 点击签到框框内的 “动态” 后调用
- (void)articleNumBtnClicked;

/// 点击签到框框内的 “评论” 后调用
- (void)remarkNumBtnClicked;

/// 点击签到框框内的 “获赞” 后调用
- (void)praiseNumBtnClicked;

@end

@interface MineHeaderView : UIView

/// 头像ImageVIew
@property (nonatomic, weak) UIImageView *headerImageView;

/// 昵称Label
@property (nonatomic, weak) UILabel *nicknameLabel;

/// 个性签名Label
@property (nonatomic, weak) UILabel *introductionLabel;

/// 编辑按钮
@property (nonatomic, weak) UIButton *editButton;

/// 签到天数Label
@property (nonatomic, weak) UILabel *signinDaysLabel;

/// 签到按钮
@property (nonatomic, weak) UIButton *checkInButton;


/// 评论数量按钮
@property(nonatomic,strong) UIButton *remarkNumBtn;

/// 动态数量按钮
@property(nonatomic,strong) UIButton *articleNumBtn;

/// 获赞数量按钮
@property (nonatomic, weak) UIButton *praiseNumBtn;

/// 代理设置成个人主页面的控制器
@property (nonatomic, weak)id <MineHeaderViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
