//
//  NewQAMainVC.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/8/17.
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
#import "NewQAMainTableView.h"
#import "NewQASelectorView.h"
#import "PostModel.h"
#import "NewQARecommenTableView.h"
#import "NewQAFollowTableView.h"
#import "HotSearchModel.h"
#import "PostTableViewCellFrame.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewQAMainVC : UIViewController

@property (nonatomic, assign) CGPoint printPoint;
@property (nonatomic, strong) NewQARecommenTableView *recommenTableView;   // 推荐TableView
@property (nonatomic, strong) NewQAFollowTableView *focusTableView;   // 关注TableView

@property (nonatomic, strong) NSMutableArray *recommenArray;   // 推荐列表数据源数组
@property (nonatomic, strong) NSMutableArray *recommenheightArray;  // 推荐列表高度数组
@property (nonatomic, assign) NSInteger recommenPage;   // 推荐页面的page

@property (nonatomic, strong) NSMutableArray *focusArray;   // 关注列表的数据源数组
@property (nonatomic, strong) NSMutableArray *focusheightArray;     // 关注列表高度数组
@property (nonatomic, assign) NSInteger focusPage;  // 关注页面的page

@property (nonatomic, strong) StarPostModel *starpostmodel; //  点赞的请求model
@property (nonatomic, strong) FollowGroupModel *followgroupmodel;   // 关注圈子的请求model
@property (nonatomic, strong) ShieldModel *shieldmodel;     // 屏蔽的请求model
@property (nonatomic, strong) DeletePostModel *deletepostmodel;     //  删除自己帖子的请求model
@property (nonatomic, strong) ReportModel *reportmodel;     // 举报的请求model
@property (nonatomic, strong) PostModel *postmodel;
@property (nonatomic, strong) HotSearchModel *hotWordModel;

@property (nonatomic, strong) NSMutableArray *hotWordsArray;
@property (nonatomic, strong) NSMutableDictionary *itemDic;    //获取cell里item数据的NSDictionary

@property (nonatomic, strong) UIView *backViewWithGesture;  // 背景蒙版
@property (nonatomic, strong) FuncView *popView;    //  多功能View--他人
@property (nonatomic, strong) SelfFuncView *selfPopView;    //  多功能View--自己
@property (nonatomic, strong) ReportView *reportView;   //  举报页面
@property (nonatomic, strong) ShareView *shareView;     //  分享页面

@property (nonatomic, assign) BOOL isShowedReportView;  // 举报view是否已经显示

@property (nonatomic, strong) PostItem *item;

@property (nonatomic, strong) NSMutableArray *topicArray;

@property (nonatomic, assign) BOOL isNeedFresh;

- (void)showBackViewWithGesture;

@end

NS_ASSUME_NONNULL_END
