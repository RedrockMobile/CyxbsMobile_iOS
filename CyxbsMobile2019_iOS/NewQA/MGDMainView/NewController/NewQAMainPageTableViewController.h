//
//  NewQAMainPageTableViewController.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/7/14.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostItem.h"
#import "GroupItem.h"
#import "StarPostModel.h"
#import "FollowGroupModel.h"
#import "ShieldModel.h"
#import "DeletePostModel.h"
#import "ReportModel.h"
#import "FuncView.h"
#import "SelfFuncView.h"
#import "ReportView.h"
#import "ShareView.h"
#import "YYZTopicDetailVC.h"
#import "ClassTabBar.h"
#import "PostTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol NewQAMainPageViewScrollViewDelegate <NSObject>

@optional

- (void)NewQAMainPageViewDidScroll:(CGFloat)scrollY;    // 监控滑动的方法

@end

@interface NewQAMainPageTableViewController : UIViewController

@property (nonatomic,copy) void(^NewQAMainPageScrollBlock)(CGFloat scrollY); // 监控滑动的block

@property (nonatomic, strong) UITableView *tableView;   // 帖子列表
@property (nonatomic, strong) PostItem *item;   //  帖子的模型
@property (nonatomic, strong) NSMutableArray *tableArray;
@property (nonatomic, weak) id<NewQAMainPageViewScrollViewDelegate>delegate; // 监控滑动的代理

@property (nonatomic, strong) NSMutableArray *topicArray;

@property (nonatomic, strong) StarPostModel *starpostmodel; //  点赞的请求model
@property (nonatomic, strong) FollowGroupModel *followgroupmodel;   // 关注圈子的请求model
@property (nonatomic, strong) ShieldModel *shieldmodel;     // 屏蔽的请求model
@property (nonatomic, strong) DeletePostModel *deletepostmodel;     //  删除自己帖子的请求model
@property (nonatomic, strong) ReportModel *reportmodel;     // 举报的请求model

@property (nonatomic, strong) NSMutableDictionary *itemDic;    //获取cell里item数据的NSDictionary

@property (nonatomic, strong) UIView *backViewWithGesture;  // 背景蒙版
@property (nonatomic, strong) FuncView *popView;    //  多功能View--他人
@property (nonatomic, strong) SelfFuncView *selfPopView;    //  多功能View--自己
@property (nonatomic, strong) ReportView *reportView;   //  举报页面
@property (nonatomic, strong) ShareView *shareView;     //  分享页面

@property (nonatomic, assign) BOOL isShowedReportView;  // 举报view是否已经显示

//缓存cell高度的数组
@property (nonatomic,strong) NSMutableArray *heightArray;


- (void)showBackViewWithGesture;

- (void)loadData;

- (void)refreshData;

@end

NS_ASSUME_NONNULL_END
