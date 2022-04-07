//
//  SSRTopBarBaseView.h
//  SSRSwipe
//
//  Created by SSR on 2022/4/6.
//

#import <UIKit/UIKit.h>

#import "UIView+Frame.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - ENUM (SSRTopBarBaseViewTitleLabLay)

typedef NS_ENUM(NSUInteger, SSRTopBarBaseViewTitleLabLay) {
    SSRTopBarBaseViewTitleLabLayMiddle,// 放在中间
    SSRTopBarBaseViewTitleLabLayDefault = SSRTopBarBaseViewTitleLabLayMiddle,
    SSRTopBarBaseViewTitleLabLayLeft// 与button贴贴
};

#pragma mark - SSRTopBarBaseView

/// 被push过后的一个基类TopBarView
@interface SSRTopBarBaseView : UIView

/// 可用的视图，所有子视图应该加载这上面
@property (nonatomic, strong) UIView *safeView;

/// 是否应该有条线，线的底部将对齐此Bar底部，默认有
@property (nonatomic, setter = shouldHaveLine:) BOOL hadLine;

// MARK: Init

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

/// 指定高度就可以了，具体效果见UI
/// @param height 可用视图的高度
- (instancetype)initWithSafeViewHeight:(CGFloat)height;

// MARK: Method

/// 设置标题样式（默认样式如下）（只会有一个哟）
/// [UIFont fontWithName:PingFangSCSemibold size:22]
/// [UIColor colorNamed:@"color21_49_91&#F0F0F2"]
/// @param title 标题
/// @param titleLay 放置位置
/// @param setTitleLab 如果不是默认，你可以设置，但frame会根据titleLay改变
- (void)addTitle:(NSString *)title
    withTitleLay:(SSRTopBarBaseViewTitleLabLay)titleLay
       withStyle:(void (^ _Nullable) (UILabel *))setTitleLab;

/// 单击返回按钮做的事（一般为返回上一个控制器）
/// @param target 应该为控制器
/// @param action 应该为返回上一个控制器事件
- (void)addBackButtonTarget:(id)target action:(SEL)action;

@end

NS_ASSUME_NONNULL_END
