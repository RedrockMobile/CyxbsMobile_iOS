//
//  TopBarBasicViewController.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/12/18.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NothingStateView.h"


NS_ASSUME_NONNULL_BEGIN

/// 带有一个顶部导航条的基类
/// 用来继承的
@interface TopBarBasicViewController : UIViewController

/// 导航栏的标题
/// 设置这个属性自动完成顶部自定义导航条的设置
@property (nonatomic,copy)NSString *VCTitleStr;
/// 顶部的bar
@property (nonatomic,strong)UIView *topBarView;
/// 是否隐藏分割线，default is NO
@property (nonatomic, assign, getter=isSplitLineHidden) BOOL splitLineHidden;
/// 标题字体 Font
@property (nonatomic, strong) UIFont * font;

/// 整个导航条的高度，包括状态栏和内容的高度
/// 状态栏是根据机型不同而变化
/// 内容高度固定为 44
- (CGFloat)getTopBarViewHeight;

@end

NS_ASSUME_NONNULL_END
