//
//  DynamicDetailMainVC.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/4/16.
//  Copyright © 2021 Redrock. All rights reserved.
//

//tool
#import "MGDRefreshTool.h"      //表格的刷新控件
#import "UIColor+SYColor.h"
#import "UIScrollView+Empty.h"

//VC
#import "DynamicDetailMainVC.h"
#import "zhPopupController.h"
#import "DynamicDetailAddPhotoController.h"
#import "YYZTopicDetailVC.h"    //圈子详情页


//Views
#import "DynamicDetailTopBarView.h"   //替代navigationBar的视图
#import "DynamicSpecificCell.h"
#import "DynamicDetailComentTableCell.h"
#import "FuncView.h"                    //多功能的view
#import "ReportView.h"                  //举报的View
#import "ShareView.h"                   //分享的View
#import "LYEmptyView.h"
#import "DKSKeyboardView.h"             //评论输入框
#import "SHPopMenu.h"                   //点击评论cell的弹窗
#import "DeleteArticleTipView.h"
#import "SelfFuncView.h"                //如果cell是自己的弹出的View

//Models
#import "DynamicDetailRequestDataModel.h"
#import "DynamicDetailViewModel.h"
#import "DynamicDetailCommentTableCellModel.h"  //评论cell的model
#import "StarPostModel.h"   //动态点赞的网络请求的model
#import "ReportModel.h"     //举报的网络请求的model
#import "FollowGroupModel.h"//关注圈子的网络请求的model
#import "ShieldModel.h"     //屏蔽的网络请求的model

@interface DynamicDetailMainVC ()<DynamicDetailTopBarViewDelegate,UITableViewDelegate,UITableViewDataSource,DynamicSpecificCellDelegate,FuncViewProtocol,ReportViewDelegate,ShareViewDelegate,UITextFieldDelegate,DKSKeyboardDelegate,SelfFuncViewProtocol,UITextViewDelegate

>
///替代navigationBar的视图
@property (nonatomic, strong) DynamicDetailTopBarView *topBarView;

@property (nonatomic, strong) DynamicSpecificCell *dynamicSpecifiCell;
/// table的头视图
@property (nonatomic, strong) UIView *tableHeaderView;

/// 评论的Table
@property (nonatomic, strong) UITableView *commentTable;

/// 无评论时放置的ScrollView
@property (nonatomic, strong) UIScrollView *scrollView;
/// 无评论时放置在底部的图片
@property (nonatomic, strong) UIView *noCommentView;


/// 如果动态是自己的多能功View
@property (nonatomic, strong) SelfFuncView *selfPopView;
///多功能View
@property (nonatomic, strong) FuncView *popView;
/// 点击多功能view后会出现的背景蒙版
@property (nonatomic, strong) UIView *backViewWithGesture;
/// 举报页面
@property (nonatomic, strong) ReportView *reportView;
@property (nonatomic, strong) ShareView *shareView;

/// 输入框
@property(nonatomic, strong) DKSKeyboardView *inputView;

/// 回收键盘的view
@property (nonatomic, strong) UIView *hideKeyBoardView;
/// 网络请求完成前的加载的Hud
@property (nonatomic, strong) MBProgressHUD *waiLoadHud;

/// 评论table的数据源数组
@property (nonatomic, strong)NSMutableArray *commentTableDataAry;

/// 存储一级评论cell的高度的数组
@property (nonatomic, strong) NSMutableArray *oneLeveCommentHeight;
///存储二级评论cell的高度的数组
@property (nonatomic, strong) NSMutableArray *twoLevelCommentHeight;


/// 请求数据的model
@property (nonatomic, strong) DynamicDetailRequestDataModel *requestModel;
/// 动态信息的数据model
@property (nonatomic, strong) DynamicDetailViewModel *dynamicDataModel;

///
@property (nonatomic, strong) DynamicDetailCommentTableCellModel *actionCommentModel;

/// table头视图的高度
@property (nonatomic, assign) double tableHedaerViewHeight;

/// 请求动态信息数据失败
@property (nonatomic, assign) BOOL isGetDynamicDataFailure;
/// 请求评论数据信息失败
@property (nonatomic, assign) BOOL isGetCommentDtaFailure;

/// 是否已经显示举报的View
@property (nonatomic, assign) BOOL isShowedReportView;
/// 是否举报评论
@property (nonatomic, assign) BOOL isReportComment;
/// 发布评论时是否是一级评论
@property (nonatomic, assign) BOOL isCommentFirstLevel;
/// 是否是第一次网络请求后进入这个界面
@property (nonatomic, assign) BOOL isFirstEnter;
/// 是否是动态详情页
@property (nonatomic, assign) BOOL isDynamicDetailVC;
@end

@implementation DynamicDetailMainVC

#pragma mark- life cicrle
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化设置
    self.isReportComment = YES;
    self.isCommentFirstLevel = YES;
    self.isFirstEnter = YES;
    self.isDynamicDetailVC = YES;
    self.isShowedReportView = NO;
    
    self.view.backgroundColor = [UIColor colorNamed:@"255_255_255&0_0_0"];
    self.commentTableDataAry = [NSMutableArray array];
    self.oneLeveCommentHeight = [NSMutableArray array];
    self.twoLevelCommentHeight = [NSMutableArray array];
    
    self.waiLoadHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.waiLoadHud.labelText = @"正在加载中...";
    [self getDataFirst];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;//隐藏tabbar
    self.navigationController.navigationBar.hidden = YES;//隐藏nav_bar
    if (self.isFirstEnter != YES) {
        [self rebuildFrameByComentCount];
    }
    //注册通知中心
    //监听键盘将要消失、出现，以此来动态的设置举报View的上下移动
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reportViewKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reportViewKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

//移除通知中心，防止其在其他界面被调用
- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark- private methonds
/// 设置各个控件的frame
- (void)buildFrame{
    if (self.isGetDynamicDataFailure == YES || self.isGetCommentDtaFailure == YES) {
        return;
    }
    
    [self.waiLoadHud hide:YES];
    
    [self.view addSubview:self.topBarView];

    //无评论时的布局策略：底部为一个scrollView，scrollView的滑动高度为动态信息页和无评论的view的高度总和
    if (self.commentTableDataAry.count <= 0) {
        [self setFrameWhenNoComent];
    }else{
        [self setFrameWhenHaveComents];
    }

}

///当有评论的时候设置UI
- (void)setFrameWhenHaveComents{
    //有评论时的布局策略：动态详情信息为评论table的头视图
    //评论的table
    [self.view addSubview:self.commentTable];
    [self.commentTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.topBarView.mas_bottom);
        make.bottom.equalTo(self.view).offset(-54);
    }];
    //添加头视图
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_W, 200)];
    view.backgroundColor = [UIColor redColor];
    self.dynamicSpecifiCell.frame = CGRectMake(0, 0, MAIN_SCREEN_W, [self.dynamicDataModel getModelHeight]);
    self.dynamicSpecifiCell.dynamicDataModel = self.dynamicDataModel;
    
    self.commentTable.tableHeaderView = self.dynamicSpecifiCell;
    [self.commentTable addSubview:self.dynamicSpecifiCell];
    
    [self.view addSubview:self.inputView];  //输入框
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(IS_IPHONE8 ? 54 : 70);
        make.bottom.equalTo(self.view);
    }];
}
///当没有评论的时候设置UI
- (void)setFrameWhenNoComent{
    //底层的scrollView
    [self.view addSubview:self.scrollView];
//        self.scrollView.backgroundColor = [UIColor redColor];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.topBarView.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom).offset(-70);
        make.width.equalTo(self.view);
    }];
        //设置scrollView的contentsize动态改变
    self.scrollView.contentSize = CGSizeMake(MAIN_SCREEN_W, [self.dynamicDataModel getModelHeight] + MAIN_SCREEN_H * 0.251 + 10);
    
    self.dynamicSpecifiCell.dynamicDataModel = self.dynamicDataModel;
    [self.scrollView addSubview:self.dynamicSpecifiCell];
    [self.dynamicSpecifiCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.top.equalTo(self.scrollView);
        make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W, [self.dynamicDataModel getModelHeight]));
    }];
    
    [self.scrollView addSubview:self.noCommentView];
    [self.noCommentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scrollView);
        make.top.equalTo(self.dynamicSpecifiCell.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W * 0.445, MAIN_SCREEN_H * 0.251));
    }];
    
    [self.view addSubview:self.inputView];  //输入框
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(IS_IPHONE8 ? 54 : 70);
        make.bottom.equalTo(self.view);
    }];
}

#pragma mark- 网络请求
///第一次请求动态和评论信息
- (void)getDataFirst{
    self.isGetCommentDtaFailure = YES;
    self.isGetDynamicDataFailure = YES;
    DynamicDetailRequestDataModel *requestModel = [[DynamicDetailRequestDataModel alloc] init];
    
    //动态信息
    //动态信息的数据model
    DynamicDetailViewModel *model = [[DynamicDetailViewModel alloc] init];
        //网络请求
    [requestModel requestDynamicDetailDataWithDynamic_id:[self.post_id intValue] Sucess:^(NSDictionary * _Nonnull dic) {
        //数据请求成功先进行赋值
        [model setValuesForKeysWithDictionary:dic];
        //获取该cell的缓存高度
        [model getModelHeight];
        self.dynamicSpecifiCell.dynamicDataModel = model;
        self.dynamicDataModel = model;
        self.isGetDynamicDataFailure = NO;
        [self buildFrame];
        } Failure:^{
            self.isGetDynamicDataFailure = YES;
            [self getDataFailure];
        }];
    
    //请求评论的数据
    [requestModel getCommentDataWithPost_id:self.post_id.intValue Sucess:^(NSArray * _Nonnull commentAry) {
        //模型数组
        [self.commentTableDataAry addObjectsFromArray:[DynamicDetailCommentTableCellModel mj_objectArrayWithKeyValuesArray:commentAry]];
        
        //高度数组
        for (int i = 0; i < commentAry.count; i++) {
            NSMutableArray *muteAry = [NSMutableArray array];
            [self.twoLevelCommentHeight addObject:muteAry];
        }
        
        self.isGetCommentDtaFailure = NO;
        [self buildFrame];
    } Failure:^{
        self.isGetCommentDtaFailure = YES;
        [self getDataFailure];
    }];
}

///第一次进入页面网络请求失败
- (void)getDataFailure{
    [self.waiLoadHud hide:YES];
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"请检查网络";
    [hud hide:YES afterDelay:1];
    [self.navigationController popViewControllerAnimated:YES];
}

///添加或者删除评论后调用的方法
- (void)rebuildFrameByComentCount{
    DynamicDetailRequestDataModel *requestModel = [[DynamicDetailRequestDataModel alloc] init];
    //请求评论的数据
    [requestModel getCommentDataWithPost_id:self.post_id.intValue Sucess:^(NSArray * _Nonnull commentAry) {
        //移除原所有数据
        [self.commentTableDataAry removeAllObjects];
        [self.oneLeveCommentHeight removeAllObjects];
        [self.twoLevelCommentHeight removeAllObjects];
        //向评论列表数据源数组添加元素
        [self.commentTableDataAry addObjectsFromArray:[DynamicDetailCommentTableCellModel mj_objectArrayWithKeyValuesArray:commentAry]];

        //高度数组
        for (int i = 0; i < commentAry.count; i++) {
            NSMutableArray *muteAry = [NSMutableArray array];
            [self.twoLevelCommentHeight addObject:muteAry];
        }
        
        [self.view removeAllSubviews];
        [self buildFrame];
        [self.commentTable reloadData];
        
        //请求动态信息的数据,更新评论数量
        DynamicDetailViewModel *model = [[DynamicDetailViewModel alloc] init];
        [requestModel requestDynamicDetailDataWithDynamic_id:[self.post_id intValue] Sucess:^(NSDictionary * _Nonnull dic) {
            //数据请求成功先进行赋值
            [model setValuesForKeysWithDictionary:dic];
            //获取该cell的缓存高度
            [model getModelHeight];
            self.dynamicSpecifiCell.dynamicDataModel = model;
            self.dynamicDataModel = model;
            self.dynamicSpecifiCell.commendBtn.countLabel.text = [NSString stringWithFormat:@"%@",model.comment_count];
            } Failure:^{
            }];
    } Failure:^{
        [self.commentTable.mj_header endRefreshing];
        [NewQAHud showHudWith:@"啊哦，网络跑路了" AddView:self.view.window];
        }];
}

#pragma mark- event respomse
///点击多功能按钮之后出现的所有的视图消失
- (void)dismissBackViewWithGesture {
    [self.popView removeFromSuperview];
    [self.shareView removeFromSuperview];
    [self.selfPopView removeFromSuperview];
    self.isShowedReportView = NO;
    [self.reportView.textView resignFirstResponder];
    [self.reportView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    [self.inputView.textView resignFirstResponder]; //收回键盘
}
/// 分享成功后调用
- (void)shareSuccessful {
    [self.popView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
//    self.backViewWithGesture.alpha = 0;
    [NewQAHud showHudWith:@"  已复制链接，可以去分享给小伙伴了～  " AddView:self.view];
    
    HttpClient *client = [HttpClient defaultClient];
    //完成围观吃瓜任务
    [client.httpSessionManager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[UserItem defaultItem].token] forHTTPHeaderField:@"authorization"];
    [client.httpSessionManager POST:TASK parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSString *target = @"围观吃瓜";
        NSData *data = [target dataUsingEncoding:NSUTF8StringEncoding];
        [formData appendPartWithFormData:data name:@"title"];
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            NSLog(@"成功了");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshPage" object:nil];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"失败了");
        }];
}
///删除评论
- (void)deleteAction:(int)comment_id{
    DeleteArticleTipView *tipView = [[DeleteArticleTipView alloc] initWithDeleteBlock:^{
        DynamicDetailRequestDataModel *model = [[DynamicDetailRequestDataModel alloc] init];
        [model deleteCommentWithId:comment_id Sucess:^{
            [NewQAHud showHudWith:@"删除成功" AddView:self.view];
            [self rebuildFrameByComentCount];
            
        } Failure:^{
            [NewQAHud showHudWith:@"删除失败，请重试" AddView:self.view];
        }];
    }];
    tipView.titleLabel.text = @"确定删除此条评论？";
    [self.view addSubview:tipView];
    
}
/// 收回键盘
- (void)dismissBottomKeyBoard{
    [self.inputView.textView resignFirstResponder];
    [self.hideKeyBoardView removeFromSuperview];
}
///键盘将要出现时，若举报页面已经显示则上移
- (void)reportViewKeyboardWillShow:(NSNotification *)notification{
    //获取键盘上移时长
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    //获取键盘的高度
    CGRect keyBoardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeitht = keyBoardFrame.size.height;
    //仅仅是动态详情页才会使用下方法
    if (self.isDynamicDetailVC == YES) {
        [UIView animateWithDuration:duration animations:^{
            [self.inputView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.view);
                make.height.mas_equalTo(IS_IPHONE8 ? (54-28 + self.inputView.originTextViewSize.height) : (70-28 + self.inputView.originTextViewSize.height));
                make.bottom.equalTo(self.view).offset(-keyboardHeitht);
            }];
            [self.view layoutIfNeeded];
        }];
    }
    //如果举报页面已经出现，就将举报View上移动
    if (self.isShowedReportView == YES) {
        
        [UIView animateWithDuration:duration animations:^{
            [self.reportView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.view);
                make.bottom.equalTo(self.inputView.mas_top).offset(self.inputView.size.height);
                make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W - MAIN_SCREEN_W*2*0.1587, MAIN_SCREEN_W * 0.6827 * 329/256));
            }];
            [self.view layoutIfNeeded];
        }];
    }else{
        //否则出现一个透明的View，点击后就可以让键盘收回
        NSDictionary *userInfo = notification.userInfo;
        CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat keyBoardHeight = endFrame.size.height;
        self.hideKeyBoardView.frame = CGRectMake(0, 0, MAIN_SCREEN_W , MAIN_SCREEN_H - keyBoardHeight - 70);
        [self.view.window addSubview:self.hideKeyBoardView];
    }
    
}
///键盘将要消失，若举报页面已经显示则使其下移
- (void)reportViewKeyboardWillHide:(NSNotification *)notification{
    //获取键盘上移时长
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    if (self.isDynamicDetailVC == YES) {
        [UIView animateWithDuration:duration animations:^{
            [self.inputView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.view);
                make.height.mas_equalTo(IS_IPHONE8 ? (54-28 + self.inputView.originTextViewSize.height) : (70-28 + self.inputView.originTextViewSize.height));
                make.bottom.equalTo(self.view);
            }];
            [self.view layoutIfNeeded];
        }];
    }
   
    //如果举报页面已经出现，让其浮动
    if (self.isShowedReportView == YES) {
        [UIView animateWithDuration:duration animations:^{
            [self.reportView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.view);
                make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W - MAIN_SCREEN_W*2*0.1587, MAIN_SCREEN_W * 0.6827 * 329/256));
            }];
            [self.view layoutIfNeeded];
        }];
    }
}
#pragma mark- Delegate

//MARK:=================================DynamicDetailTopBarViewDelegate==========================
- (void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}

//MARK:======================================动态信息cell的代理方法================
/**
 点击多功能按钮
 逻辑：接收到cell里传来的多功能按钮的frame，在此frame上放置多功能View，同时加上蒙版
*/
- (void)clickedFuncBtn:(UIButton *)btn{
    UIWindow *desWindow = self.view.window;
    CGRect frame = [btn convertRect:btn.bounds toView:desWindow];
    [self.view.window addSubview:self.backViewWithGesture];
    //添加背景蒙版
    if (self.dynamicDataModel.is_self.intValue == 1) {
        self.selfPopView.frame = CGRectMake(frame.origin.x - SCREEN_WIDTH * 0.27, frame.origin.y + 10, SCREEN_WIDTH * 0.3057, SCREEN_WIDTH * 0.3057 * 105/131.5* 1/3);
        [self.view.window addSubview:self.selfPopView];
    }else{
        self.popView.frame =  CGRectMake(frame.origin.x - SCREEN_WIDTH * 0.27, frame.origin.y + 10, SCREEN_WIDTH * 0.3057, SCREEN_WIDTH * 0.3057 * 105/131.5);
        //添加弹出的view
        [self.view.window addSubview:self.popView];
    }
}
///点击点赞按钮 先在本地改变UI，再将数据传入后端
- (void)clickedStarBtn:(FunctionBtn *)btn{
    //改变本地UI
    if (btn.selected == YES) {
        btn.selected = NO;
        btn.iconView.image = [UIImage imageNamed:@"未点赞"];
        btn.countLabel.text = [NSString stringWithFormat:@"%d",[btn.countLabel.text intValue] - 1];
        btn.countLabel.textColor = [UIColor colorNamed:@"FuncBtnColor"];
    }else{
        btn.enabled = NO;
        btn.selected = YES;
        btn.iconView.image = [UIImage imageNamed:@"点赞"];
        btn.countLabel.text = [NSString stringWithFormat:@"%d",[btn.countLabel.text intValue] + 1];
        btn.countLabel.textColor = [UIColor colorNamed:@"countLabelColor"];
    }
    //数据传入后端
    StarPostModel *model = [[StarPostModel alloc] init];
    [model starPostWithPostID:[NSNumber numberWithString:self.post_id]];
    
    //延迟0.5秒后将按钮设置为可用
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        btn.enabled = YES;
    });
}
///点击评论按钮，直接添加一级评论
- (void)clickedCommentBtn{
    self.isCommentFirstLevel = YES;
    [self.inputView startInputAction];
}
///点击分享按钮
- (void)clickedShareBtn:(FunctionBtn *)btn{
    [self.view.window addSubview:self.backViewWithGesture];
    [self.view.window addSubview:self.shareView];
    [self.shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.window.mas_top).mas_offset(SCREEN_HEIGHT * 460/667);
        make.left.right.bottom.mas_equalTo(self.view.window);
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ClickedShareBtn" object:nil userInfo:nil];
    //此处还需要修改
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString *shareURL = [NSString stringWithFormat:@"https://fe-prod.redrock.team/zscy-youwen-share/#/dynamic?id=%@",self.post_id];
    pasteboard.string = shareURL;
}

//MARK:======================================多功能View的代理方法======================================
///点击关注按钮
- (void)ClickedStarGroupBtn:(UIButton *)sender {
    FollowGroupModel *model = [[FollowGroupModel alloc] init];
    [model FollowGroupWithName:self.dynamicDataModel.topic];
    if ([sender.titleLabel.text isEqualToString:@"关注圈子"]) {
        [model setBlock:^(id  _Nonnull info) {
            if (![info isKindOfClass:[NSError class]]) {
                if ([info[@"status"] isEqualToNumber:[NSNumber numberWithInt:200]]) {
                    //关注圈子成功后的操作
                    [self.popView removeFromSuperview];
                    [self.backViewWithGesture removeFromSuperview];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshNewQAMainViewController" object:nil userInfo:nil];
                    [NewQAHud showHudWith:@"  关注圈子成功  " AddView:self.view];
                }else  {
                    [self.popView removeFromSuperview];
                    [self.backViewWithGesture removeFromSuperview];
                    [NewQAHud showHudWith:@"  操作失败  " AddView:self.view];
                }
            }else {
                [self.popView removeFromSuperview];
                [self.backViewWithGesture removeFromSuperview];
                [NewQAHud showHudWith:@"  操作失败  " AddView:self.view];
            }
        }];
    } else if ([sender.titleLabel.text isEqualToString:@"取消关注"]) {
        [model setBlock:^(id  _Nonnull info) {
            if (![info isKindOfClass:[NSError class]]) {
                if ([info[@"status"] isEqualToNumber:[NSNumber numberWithInt:200]]) {
                    //取消关注成功的操作
                    [self.popView removeFromSuperview];
                    [self.backViewWithGesture removeFromSuperview];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshNewQAMainViewController" object:nil userInfo:nil];
                    [NewQAHud showHudWith:@"  取消关注圈子成功  " AddView:self.view];
                }else  {
                    [self.popView removeFromSuperview];
                    [self.backViewWithGesture removeFromSuperview];
                    [NewQAHud showHudWith:@"  操作失败  " AddView:self.view];
                }
            }else {
                [self.popView removeFromSuperview];
                [self.backViewWithGesture removeFromSuperview];
                [NewQAHud showHudWith:@"  操作失败  " AddView:self.view];
            }
        }];
    }
}
///点击屏蔽按钮
- (void)ClickedShieldBtn:(UIButton *)sender {
    ShieldModel *model = [[ShieldModel alloc] init];
    [model ShieldPersonWithUid:self.dynamicDataModel.uid];
    [model setBlock:^(id  _Nonnull info) {
        if ([info[@"info"] isEqualToString:@"success"]) {
            [self.popView removeFromSuperview];
            [self.backViewWithGesture removeFromSuperview];
            [NewQAHud showHudWith:@"  将不再推荐该用户的动态给你  " AddView:self.view];
        }
    }];
}
///点击举报按钮
- (void)ClickedReportBtn:(UIButton *)sender  {
    [self.view.window addSubview:self.reportView];
    [self.reportView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W - MAIN_SCREEN_W*2*0.1587, MAIN_SCREEN_W * 0.6827 * 329/256));
    }];
    self.isShowedReportView = YES;  //标记转为已经显示举报
    [self.popView removeFromSuperview];

    //此方式进入创建举报view为从动态的多功能按钮进入，只能是举报动态
    self.isReportComment = NO;
}

//MARK:=====================是自己的动态的多功能View的代理方法================
- (void)ClickedDeletePostBtn:(UIButton *)sender{
//    [self.selfPopView removeFromSuperview];
//    [self.backViewWithGesture removeFromSuperview];
//    [[DynamicDetailRequestDataModel new] deletSelfDynamicWithID:self.dynamicDataModel.post_id.intValue Success:^{
//            [NewQAHud showHudWith:@"  已经删除该帖子 " AddView:self.view];
////            [self.navigationController popToRootViewControllerAnimated:YES];
//        [self.navigationController popViewControllerAnimated:YES];
//        } Failure:^{
//            [NewQAHud showHudWith:@" 网络开小差了 " AddView:self.view];
//        }];
}

//MARK:======================================举报页面的代理方法======================================
/// 举报页面点击确定按钮
- (void)ClickedSureBtn {
    //隐藏视图
    [self.reportView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    
    self.isShowedReportView = NO; //标记转为未显示
    //收回键盘
    [self.reportView.textView resignFirstResponder];
    
    //如果不是举报评论，此时举报的id为chushihuaid：动态的id
    if (self.isReportComment == NO) {
        ReportModel *model = [[ReportModel alloc] init];
        [model ReportWithPostID:self.reportView.postID WithModel:[NSNumber numberWithInt:0] AndContent:self.reportView.textView.text];
        [model setBlock:^(id  _Nonnull info) {
            //举报成功后的操作
            [self.popView removeFromSuperview];
            [NewQAHud showHudWith:@"  举报成功  " AddView:self.view];
        }];
    }else{
        //举报评论时，在添加举报视图的时候就已经将举报的id更换了要举报的评论的id
        DynamicDetailRequestDataModel *model = [[DynamicDetailRequestDataModel alloc] init];
        [model reportCommentWithId:[self.reportView.postID intValue] Content:self.reportView.textView.text Sucess:^{
                    //举报成功后的操作
                    [self.popView removeFromSuperview];
                    [NewQAHud showHudWith:@"  举报成功  " AddView:self.view];
                } Failure:^{
                    [NewQAHud showHudWith:@"举报失败，请重试" AddView:self.view];
                }];
        //还原初始化设置
        self.isReportComment = NO;
        self.reportView.postID = [NSNumber numberWithInt:[self.post_id intValue]];;
    }
    self.reportView.textView.text = @"";
}
///举报页面点击取消按钮
- (void)ClickedCancelBtn {
    if (!self.isReportComment == NO) {
        //还原初始化设置
        self.isReportComment = NO;
        self.reportView.postID = [NSNumber numberWithInt:[self.post_id intValue]];
    }
    self.reportView.textView.text = @"";
    
    //隐藏视图
    [self.reportView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    
    self.isShowedReportView = NO; //标记转为未显示
    //收回键盘
    [self.reportView.textView resignFirstResponder];
}

//MARK:======================================分享View的代理方法======================================
///点击取消
- (void)ClickedCancel {
    [self.shareView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
//    self.backViewWithGesture.alpha = 0;
}
///点击分享QQ空间
- (void)ClickedQQZone {
    [self.shareView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
//    self.backViewWithGesture.alpha = 0;
    [self shareSuccessful];
}
///点击分享朋友圈
- (void)ClickedVXGroup {
    [self.shareView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
//    self.backViewWithGesture.alpha = 0;
    [self shareSuccessful];
}
///点击分享QQ
- (void)ClickedQQ {
    [self.shareView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
//    self.backViewWithGesture.alpha = 0;
    [self shareSuccessful];
}
///点击分享微信好友
- (void)ClickedVXFriend {
    [self.shareView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
//    self.backViewWithGesture.alpha = 0;
    [self shareSuccessful];
}
///点击分享复制链接
- (void)ClickedUrl {
    [self.shareView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
//    self.backViewWithGesture.alpha = 0;
    [self shareSuccessful];
}

//MARK:======================================DKSKeyboardDelegate===============================
//发送的文案
- (void)textViewContentText:(NSString *)textStr {
    [self reportComment:textStr];
    [self.hideKeyBoardView removeFromSuperview];
    [self.inputView.textView resignFirstResponder];
}
///选择图片
- (void)leftButtonClick:(NSString *)textStr{
    [self.hideKeyBoardView removeFromSuperview];
    [self.view endEditing:YES];
    self.isFirstEnter = NO;
    
    DynamicDetailAddPhotoController *commentVC = [[DynamicDetailAddPhotoController alloc] init];
    if (self.isCommentFirstLevel != YES) {
        commentVC.isFirstCommentLevel = NO;
    }else{
        commentVC.isFirstCommentLevel = YES;
    }
    commentVC.post_id = [self.post_id intValue];
    if (self.actionCommentModel.comment_id > 0) {
        commentVC.reply_id = self.actionCommentModel.comment_id;
    }
    commentVC.tampComment = textStr;
    [self.navigationController pushViewController:commentVC animated:YES];
}
///发送按钮
- (void)rightButtonClick:(NSString *)textStr{
    [self reportComment:textStr];
    [self.hideKeyBoardView removeFromSuperview];
}
- (void)reportComment:(NSString *)textStr{
    
    //设置参数
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:textStr forKey:@"content"];
    [param setObject:self.post_id forKey:@"post_id"];
    //当不是一级评论的时候才加回复id作为二级评论
    if (self.isCommentFirstLevel != YES) {
        [param setObject:@(self.actionCommentModel.comment_id) forKey:@"reply_id"];
    }

    [[HttpClient defaultClient]requestWithPath:New_QA_Comment_Release method:HttpRequestPost parameters:param prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"status"] intValue] == 200) {
            [NewQAHud showHudWith:@"  发布评论成功  " AddView:self.view];
            
            //清除文字内容，收回键盘
            self.inputView.textView.text = @"";
            self.inputView.originTextViewSize = CGSizeMake(MAIN_SCREEN_W*0.665, 38);
            //更新textView的高度
            [self.inputView.textView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(self.inputView.originTextViewSize);
            }];
            [self.inputView.textView resignFirstResponder];
            
            [self rebuildFrameByComentCount];
            
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [NewQAHud showHudWith:@"  发布评论失败，请重试  " AddView:self.view];
    }];
    
    //初始化设置
    self.isCommentFirstLevel = YES;
    
    HttpClient *client = [HttpClient defaultClient];
    //完成能说会道任务
    [client.httpSessionManager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[UserItem defaultItem].token] forHTTPHeaderField:@"authorization"];
    [client.httpSessionManager POST:TASK parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSString *target = @"能说会道";
        NSData *data = [target dataUsingEncoding:NSUTF8StringEncoding];
        [formData appendPartWithFormData:data name:@"title"];
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            NSLog(@"成功了");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshPage" object:nil];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"失败了");
        }];
}

//MARK:UITextViewDelegate
//实现return按钮的方法 + 限制输入字数
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //限制字数
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange offset:0];
    //如果有高亮部分，并且字数小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        if (offsetRange.location < 200) {
            return YES;
        }else{
            return NO;
        }
    }
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger caninputlen = 200 - comcatstr.length;
    if (caninputlen >= 0) {
        return YES;
    }else{
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        if (rg.length > 0) {
            NSString *s = @"";
            //判断是否只普通的字符或asc码(对于中文和表情返回NO)
            BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
            if (asc) {
                s = [text substringWithRange:rg];//因为是ascii码直接取就可以了不会错
            }else{
                __block NSInteger idx = 0;
                __block NSString  *trimString = @"";//截取出的字串
                //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
                                         options:NSStringEnumerationByComposedCharacterSequences
                                      usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                    NSInteger steplen = substring.length;
                    if (idx >= rg.length) {
                        *stop = YES; //取出所需要就break，提高效率
                        return ;
                    }
                    trimString = [trimString stringByAppendingString:substring];
                    
                    idx = idx + steplen;    //使用字串占的长度来作为步长
                }];
                s = trimString;
            }
            //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
        }
    }
    //判断最后输入的那一个字是否是回车
    if ([text isEqualToString:@"\n"]) {
        [self rightButtonClick:textView.text];
        [self textViewDidChange:textView];
        return NO;
    }
    return YES;
}
//根据textView字数动态增加textview高度
- (void)textViewDidChange:(UITextView *)textView{
    //限制字数
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange offset:0];
    //如果在变化中是高亮部分，就不计算字符
    if (selectedRange && pos) {
        return;
    }
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    if(existTextNum > 0){
        [self.inputView.moreBtn setHighlighted:YES];
        if (existTextNum > 200){
            //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
            NSString *s = [nsTextContent substringToIndex:200];
            [textView setText:s];
            [NewQAHud showHudWith:@"最多只能评论两百字哦～" AddView:self.view];
        }
    }else{
        [self.inputView.moreBtn setHighlighted:NO];
    }
    
    //根据textView计算高度呀
    CGFloat height = ceilf([self.inputView.textView sizeThatFits:CGSizeMake(self.inputView.textView.bounds.size.width, MAXFLOAT)].height);
    //如果高度变化了
    if (height != self.inputView.oldTextViewHeight) {
        //当高度小于最大高度才可以滑动
        self.inputView.textView.scrollEnabled = self.inputView.maxTextViewheight < height;
        
        if (self.inputView.textView.scrollEnabled == NO) {
            
            self.inputView.originTextViewSize = CGSizeMake(self.inputView.originTextViewSize.width, height + 10);
            //布局textView
            [self.inputView.textView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(self.inputView.originTextViewSize);
            }];
            //布局view
            [self.inputView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(IS_IPHONE8 ? (54 - 38 + height+10) : (70 - 38 + height+10));
            }];
            [self.view layoutIfNeeded];
        }
    }
    self.inputView.oldTextViewHeight = height;
}
//MARK:====================================表格的数据源方法============================================
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return self.commentTableDataAry.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    DynamicDetailCommentTableCellModel *model = self.commentTableDataAry[section];
    return model.reply_list.count + 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [UITableViewCell alloc] initWithStyle:<#(UITableViewCellStyle)#> reuseIdentifier:<#(nullable NSString *)#>
    NSString *identifier = @"commentCell";
        DynamicDetailComentTableCell *cell = [[DynamicDetailComentTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier commentType:(indexPath.row == 0 ? DynamicCommentType_stair : DynamicCommentType_secondLevel)];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        DynamicDetailCommentTableCellModel *model = self.commentTableDataAry[indexPath.section];
        if (indexPath.row == 0) {
            cell.dataModel = model;
            if (indexPath.section == 0) {
                cell.lineLB.hidden = YES;
            }
            //存储一级评论的高度
            NSString *height = [NSString stringWithFormat:@"%f",[model getCellHeight]];
            [self.oneLeveCommentHeight addObject:height];
           
        }else{
            cell.dataModel = model.reply_list[indexPath.row-1];
            
            //存储二级评论的高度
            NSString *height = [NSString stringWithFormat:@"%f",[cell.dataModel getCellHeight]];
            NSMutableArray *muteAry = self.twoLevelCommentHeight[indexPath.section];
            [muteAry addObject:height];
        }
    return cell;
}
    

//MARK:====================================表格的代理方法==============================================
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DynamicDetailCommentTableCellModel *model = self.commentTableDataAry[indexPath.section];
    
    if (indexPath.row == 0) {
        NSString *height = [NSString stringWithFormat:@"%f",[model getCellHeight]];
//        return [self.oneLeveCommentHeight[indexPath.section] doubleValue];
        return [height doubleValue];
    }else{
        DynamicDetailCommentTableCellModel *secondCommentModel = model.reply_list[indexPath.row-1];
        NSString *height = [NSString stringWithFormat:@"%f",[secondCommentModel getCellHeight]];
        //后面的20是回复的label的高度
        return [height doubleValue] + 22;
//        NSMutableArray *muteAry =  self.twoLevelCommentHeight[indexPath.section];
//        return [muteAry[indexPath.row - 1] doubleValue];
    }
   
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    DynamicDetailCommentTableCellModel *model = self.commentTableDataAry[indexPath.section];
    if (indexPath.row !=0 ) {
        model = model.reply_list[indexPath.row-1];
    }
    self.actionCommentModel = model;
    DynamicDetailComentTableCell *cell = (DynamicDetailComentTableCell *)[self.commentTable cellForRowAtIndexPath:indexPath];
    
    CGRect rectInTableView = [tableView rectForRowAtIndexPath:indexPath];
    //获取cell在tableView中的位置,后面点击之后弹出来的View是根据这个frame设定的
    CGRect rectInSuperview = [tableView convertRect:rectInTableView toView:[tableView superview]];
    
    //弹出视图在屏幕下方被隐藏时，设置它的最低的弹出位置
    CGFloat rectYMargin = rectInSuperview.origin.y+40;
    if (rectYMargin >= SCREEN_HEIGHT-NVGBARHEIGHT-STATUSBARHEIGHT-54) {
        rectYMargin = rectInSuperview.origin.y-SCREEN_WIDTH*0.0773;
    }
    
    //设置点击cell后弹出的cell
    SHPopMenu *_menu = [[SHPopMenu alloc]init];
    _menu.dimBackground = YES;
    _menu.menuW = SCREEN_WIDTH * 0.4747;
    _menu.contentH = SCREEN_WIDTH * 0.0773;
    _menu.mList = @[@"回复",@"复制",(model.is_self ? @"删除" : @"举报")];
    _menu.arrowX = 0;
    _menu.arrowImage = [UIImage imageNamed:@""];
    
    _menu.textColor = [UIColor colorWithLightColor:KUIColorFromRGB(0x0C3573) DarkColor:KUIColorFromRGB(0x0C3573)];
    _menu.font = [UIFont fontWithName:PingFangSCMedium size:12];
    _menu.layer.cornerRadius = 15;
    _menu.layer.masksToBounds = YES;
    
    __weak typeof(self)weakSelf = self;
    //显示菜单
    [_menu showInRectX:(cell.frame.size.width-_menu.menuW)/2.0 rectY:rectYMargin block:^(SHPopMenu *menu, NSInteger index) {
        
        if (index <= 1){
            if (index == 0) {
                //回复评论
                weakSelf.isCommentFirstLevel = NO;  //此处是二级评论
                [weakSelf.inputView startInputAction];
            }else{
                //复制
                UIPasteboard *pab = [UIPasteboard generalPasteboard];
                pab.string = model.content;
                [NewQAHud showHudWith:@"已复制内容" AddView:self.view];
            }
        }else{
            if (model.is_self) {
                //如果这条评论是自己的，就执行删除操作
                [weakSelf deleteAction:model.comment_id];
            }else{
                //举报功能
                weakSelf.isReportComment = YES;
                [weakSelf.view.window addSubview:weakSelf.backViewWithGesture]; //添加背景蒙板
                weakSelf.reportView.postID = [NSNumber numberWithInteger:model.comment_id];
                
                //每次添加到屏幕上时内容置空
                weakSelf.reportView.textView.text = @"";
                [weakSelf.view.window addSubview:weakSelf.reportView];
                [weakSelf.reportView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(self.view);
                    make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W - MAIN_SCREEN_W*2*0.1587, MAIN_SCREEN_W * 0.6827 * 329/256));
                }];
                weakSelf.isShowedReportView = YES;  //标记转为已经显示举报
            }
        }
    }];
}

#pragma mark- getter
- (DynamicDetailTopBarView *)topBarView{
    if (!_topBarView) {
        _topBarView = [[DynamicDetailTopBarView alloc] initWithFrame:CGRectMake(0, STATUSBARHEIGHT, MAIN_SCREEN_W, 45 * HScaleRate_SE)];
        _topBarView.delegate = self;
    }
    return _topBarView;
}

- (DynamicSpecificCell *)dynamicSpecifiCell{
    if (!_dynamicSpecifiCell) {
        _dynamicSpecifiCell = [[DynamicSpecificCell alloc] init];
    }
    return _dynamicSpecifiCell;
}

- (UITableView *)commentTable{
    if (!_commentTable) {
        _commentTable = [[UITableView alloc] initWithFrame:CGRectZero];
        _commentTable.backgroundColor = [UIColor colorNamed:@"255_255_255&0_0_0"];
        _commentTable.delegate = self;
        _commentTable.dataSource = self;
        //设置预加载高度
        _commentTable.estimatedRowHeight = SCREEN_HEIGHT * 0.461;
        //cell高度自适应
        _commentTable.rowHeight = UITableViewAutomaticDimension;
        _commentTable.automaticallyAdjustsScrollIndicatorInsets = NO;
        //cell间的颜色
        _commentTable.separatorColor = [UIColor colorNamed:@"ShareLineViewColor"];
        _commentTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        //分割线样式为无
        _commentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_commentTable registerClass:[DynamicDetailComentTableCell class] forCellReuseIdentifier:@"commentCell"];
    }
    return _commentTable;
}

- (UIView *)noCommentView{
    if (!_noCommentView) {
        _noCommentView = [[UIView alloc] initWithFrame:CGRectZero];
        //无评论的图片
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView.image = [UIImage imageNamed:@"图层 11"];
        [_noCommentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W * 0.4453, MAIN_SCREEN_H * 0.1904));
            make.top.equalTo(_noCommentView);
            make.centerX.equalTo(_noCommentView);
        }];
        
        //下面的文字
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = @"还没有评论哦～";
        label.textColor = [UIColor colorNamed:@"85_108_137&240_240_242"];
        label.font = [UIFont fontWithName:PingFangSCMedium size:13];
        [_noCommentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(imageView);
            make.top.equalTo(imageView.mas_bottom).offset(MAIN_SCREEN_H * 0.03);;
        }];
    }
    return _noCommentView;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50 * HScaleRate_SE, MAIN_SCREEN_W, IS_IPHONE8 ? (MAIN_SCREEN_H - 54) : (MAIN_SCREEN_H - 70))];
        
        _scrollView.contentSize = CGSizeMake(MAIN_SCREEN_W, MAIN_SCREEN_H * 1.5);
        
    }
    return _scrollView;
}

//点击多功能按钮会弹出的选择列表view
- (FuncView *)popView{
    if (!_popView) {
        _popView = [[FuncView alloc] init];
        _popView.delegate = self;
        if (self.dynamicDataModel.is_follow_topic.intValue == 1) {
            [_popView.starGroupBtn setTitle:@"取消关注" forState:UIControlStateNormal];
        }else{
            [_popView.starGroupBtn setTitle:@"关注圈子" forState:UIControlStateNormal];
        }
        _popView.layer.cornerRadius = 6;
    }
    return _popView;
}
- (SelfFuncView *)selfPopView{
    if (!_selfPopView) {
        _selfPopView = [[SelfFuncView alloc] init];
        _selfPopView.delegate = self;
    }
    return _selfPopView;
}

///点击多功能按钮后出现的蒙板
- (UIView *)backViewWithGesture{
    if (!_backViewWithGesture) {
        _backViewWithGesture = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _backViewWithGesture.backgroundColor = [UIColor blackColor];
        _backViewWithGesture.alpha = 0.36;
        UITapGestureRecognizer *dismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissBackViewWithGesture)];
        [_backViewWithGesture addGestureRecognizer:dismiss];
    }
    return _backViewWithGesture;
}

/// 举报的view
- (ReportView *)reportView{
    if (!_reportView) {
        _reportView = [[ReportView alloc] initWithPostID:[NSNumber numberWithInt:[self.post_id intValue]]];
        _reportView.delegate = self;
        _reportView.postID = [NSNumber numberWithString:self.post_id];
    }
    return _reportView;
}

///分享的View
- (ShareView *)shareView{
    if (!_shareView) {
        _shareView = [[ShareView alloc] init];
        _shareView.delegate = self;
    }
    return _shareView;
}

- (DKSKeyboardView *)inputView{
    if (!_inputView) {
        _inputView = [[DKSKeyboardView alloc] initWithFrame:CGRectZero];
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
        _inputView.textView.inputAccessoryView = toolbar;
        _inputView.textView.textColor = [UIColor colorNamed:@"CellDetailColor"];
        //设置代理方法
        _inputView.delegate = self;
        _inputView.textView.delegate = self;
    }
    return _inputView;
}

- (UIView *)hideKeyBoardView{
    if (!_hideKeyBoardView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *dismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissBottomKeyBoard)];
        [view addGestureRecognizer:dismiss];
        _hideKeyBoardView = view;
    }
    return _hideKeyBoardView;
}

@end
