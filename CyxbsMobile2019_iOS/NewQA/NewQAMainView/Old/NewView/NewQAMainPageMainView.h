//
//  NewQAMainPageMainView.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/7/14.
//  Copyright © 2021 Redrock. All rights reserved.
//

/*
 description
 这个页面是新版邮问的主要UI界面，是推荐（UILabel），后面将会和下方的帖子列表（UITableView）结合体
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewQAMainPageMainView : UIView

@property (nonatomic,strong) UIColor* textColor;    // 标题文字颜色

@property (nonatomic,assign) CGFloat titleHeight;  // 标题栏高度

@property (nonatomic,assign) BOOL canScroll;    // 是否可以滑动

// 传入父控制器和子控制器
- (void)setupViewControllerWithFatherVC:(UIViewController *)fatherVC AndChildVC:(UIViewController *)childVC;

@end

NS_ASSUME_NONNULL_END
