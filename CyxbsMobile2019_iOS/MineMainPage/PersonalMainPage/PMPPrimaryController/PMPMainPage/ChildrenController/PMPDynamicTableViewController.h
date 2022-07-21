//
//  PMPDynamicTableViewController.h
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/9/27.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMPDynamicTableViewCell.h"
#import "UIViewController+CanScroll.h"
// views
#import "ShareView.h"
#import "FuncView.h"
#import "SelfFuncView.h"
#import "ReportView.h"
// models
#import "StarPostModel.h"
#import "FollowGroupModel.h"
#import "ShieldModel.h"
#import "ReportModel.h"
#import "DeletePostModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PMPDynamicTableViewController : UITableViewController

@property (nonatomic, strong) StarPostModel *starpostmodel; //  点赞的请求model
@property (nonatomic, strong) FollowGroupModel *followgroupmodel;   // 关注圈子的请求model
@property (nonatomic, strong) ShieldModel *shieldmodel;     // 屏蔽的请求model
@property (nonatomic, strong) ReportModel *reportmodel;     // 举报的请求model
@property (nonatomic, strong) DeletePostModel *deletepostmodel;     //  删除自己帖子的请求model

@property (nonatomic, strong) UIView *backViewWithGesture;  // 背景蒙版
@property (nonatomic, strong) FuncView *popView;    //  多功能View--他人
@property (nonatomic, strong) SelfFuncView *selfPopView;    //  多功能View--自己
@property (nonatomic, strong) ReportView *reportView;   //  举报页面
@property (nonatomic, strong) ShareView *shareView;     //  分享页面

- (void)showBackViewWithGesture;

- (instancetype)initWithStyle:(UITableViewStyle)style
                        redid:(NSString *)redid;

@end

NS_ASSUME_NONNULL_END
