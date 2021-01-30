//
//  NewQAMainPageViewController.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/12/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FuncView.h"
#import "ReportView.h"
#import "ShareView.h"
#import "TopFollowView.h"
#import "RecommendedTableView.h"
#import "SearchBtn.h"
#import "RecommendedTableView.h"
#import "GroupItem.h"
#import "ReportView.h"
#import "ShareView.h"
#import "FuncView.h"
#import "PostItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewQAMainPageViewController : UIViewController
///背景蒙版
@property (nonatomic, strong) UIView *backViewWithGesture;

///多功能View
@property (nonatomic, strong) FuncView *popView;

///举报页面
@property (nonatomic, strong) ReportView *reportView;

///分享页面
@property (nonatomic, strong) ShareView *shareView;


///搜索按钮，点击后弹出搜索详情页面
@property (nonatomic, strong) SearchBtn *searchBtn;

///我的关注模块
@property (nonatomic, strong) TopFollowView *topFollowView;

///推荐列表
@property (nonatomic, strong) RecommendedTableView *recommendedTableView;

///推荐文字
@property (nonatomic, strong) UILabel *recommendedLabel;

///推荐tableView
@property (nonatomic, strong) RecommendedTableView *tableView;

///发布按钮
@property (nonatomic, strong) UIButton *publishBtn;

///整体滑动的ScrollView
@property (nonatomic, strong) UIScrollView *backScrollView;


@end

NS_ASSUME_NONNULL_END

