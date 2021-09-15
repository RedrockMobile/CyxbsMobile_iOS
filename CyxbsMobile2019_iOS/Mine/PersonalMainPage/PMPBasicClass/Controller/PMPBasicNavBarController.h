//
//  PMPBasicViewController.h
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/9/14.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 直接继承使用
 * 在控制器的 viewDidLoad 方法中写:
 * self.view.backgroundColor = [UIColor colorNamed:@"white&black"];
 * self.VCTitleStr = @"";
 * self.splitLineColor = [UIColor colorNamed:@"45_45_45_0.2&230_230_230_0.4"];
 * self.titleFont = [UIFont fontWithName:PingFangSCBold size:22];
 * self.splitLineHidden = YES;
 */
@interface PMPBasicNavBarController : UIViewController

/// 设置这个属性自动完成顶部自定义导航条的设置
@property (nonatomic,copy)NSString *VCTitleStr;
/// 是否隐藏分割线，default is NO
@property (nonatomic, assign, getter=isSplitLineHidden) BOOL splitLineHidden;
/// 标题字体 Font， default is [UIFont fontWithName:PingFangSCSemibold size:21]
@property (nonatomic, strong) UIFont * titleFont;
/// 标题颜色，default is Red:21 green:49 blue:91 alpha:1
@property (nonatomic, strong) UIColor * titleColor;
/// 导航栏的颜色 默认为和控制器 view 颜色一样
@property (nonatomic, strong) UIColor * topBarBackgroundColor;
/// 导航栏是否隐藏 默认为 NO
@property (nonatomic, assign, getter=isTopBarViewHidden) BOOL topBarViewHidden;
/// 分割线的颜色
@property (nonatomic, strong) UIColor * splitLineColor;

/// 整个导航栏的高度，包括状态栏和内容的高度
/// 状态栏是根据机型不同而变化
/// 内容高度固定为 44
- (CGFloat)getTopBarViewHeight;

/// 返回按钮的点击方法
- (void)backBtnClicked:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
