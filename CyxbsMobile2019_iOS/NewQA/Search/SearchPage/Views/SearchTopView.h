//
//  SearchTopView.h
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/1/25.
//  Copyright © 2021 Redrock. All rights reserved.
//
/**
 - 最顶层，含有返回btn，搜索框的视图
 - 在“搜索初始页”和“搜索结果页使用”
 */
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol SearchTopViewDelegate <NSObject>


/// 返回按钮跳回到“邮圈界面”
- (void)jumpBack;

@end

@interface SearchTopView : UIView
/// 代理
@property (nonatomic, strong) id<SearchTopViewDelegate>delegate;

/// 点击返回到“邮圈界面”的按钮
@property (nonatomic, strong) UIButton *backBtn;

/// 搜索框内的放大镜图标
@property (nonatomic, strong) UIImageView *searchIcon;

/// 搜索输入框
@property (nonatomic, strong) UITextField *searchTextfield;

/// 轮播的palceholder数组，里面有三个元素，网络请求获取
@property (nonatomic, strong) NSArray *placeholderArray;

@property (nonatomic, strong) UIImageView *searchFieldBackgroundView;
@end

NS_ASSUME_NONNULL_END
