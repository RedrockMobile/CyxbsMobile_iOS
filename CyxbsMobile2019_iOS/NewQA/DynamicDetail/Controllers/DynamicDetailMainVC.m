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

//Models
#import "DynamicDetailRequestDataModel.h"
#import "DynamicDetailViewModel.h"
#import "DynamicDetailCommentTableCellModel.h"  //评论cell的model
#import "StarPostModel.h"   //动态点赞的网络请求的model
#import "ReportModel.h"     //举报的网络请求的model
#import "FollowGroupModel.h"//关注圈子的网络请求的model
#import "ShieldModel.h"     //屏蔽的网络请求的model

@interface DynamicDetailMainVC ()<DynamicDetailTopBarViewDelegate,UITableViewDelegate,UITableViewDataSource,DynamicSpecificCellDelegate,FuncViewProtocol,ReportViewDelegate,ShareViewDelegate,UITextFieldDelegate,DKSKeyboardDelegate

>
///替代navigationBar的视图
@property (nonatomic, strong) DynamicDetailTopBarView *topBarView;

@property (nonatomic, strong) DynamicSpecificCell *dynamicSpecifiCell;
/// table的头视图
@property (nonatomic, strong) UIView *tableHeaderView;

/// 评论的Table
@property (nonatomic, strong) UITableView *commentTable;

///多功能View
@property (nonatomic, strong) FuncView *popView;
/// 点击多功能view后会出现的背景蒙版
@property (nonatomic, strong) UIView *backViewWithGesture;
/// 举报页面
@property (nonatomic, strong) ReportView *reportView;
@property (nonatomic, strong) ShareView *shareView;

/// 输入框
@property(nonatomic, strong) DKSKeyboardView *inputView;

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

/// 是否举报评论
@property (nonatomic, assign) BOOL isReportComment;
/// 发布评论时是否是一级评论
@property (nonatomic, assign) BOOL isCommentFirstLevel;
/// 是否是第一次网络请求后进入这个界面
@property (nonatomic, assign) BOOL isFirstEnter;
@end

@implementation DynamicDetailMainVC
#pragma mark- life cicrle
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化设置
    self.isReportComment = YES;
    self.isCommentFirstLevel = YES;
    self.isFirstEnter = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.commentTableDataAry = [NSMutableArray array];
    self.oneLeveCommentHeight = [NSMutableArray array];
    self.twoLevelCommentHeight = [NSMutableArray array];
    
    self.waiLoadHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.waiLoadHud.labelText = @"正在加载中...";
    [self getDataFirst];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (self.isFirstEnter == YES) {
        [self.commentTable.mj_header beginRefreshing];
    }
}
#pragma mark- private methonds
/// 设置各个控件的frame
- (void)buildFrame{
    if (self.isGetDynamicDataFailure == YES || self.isGetCommentDtaFailure == YES) {
        return;
    }
    [self.waiLoadHud hide:YES];
    
    //最顶部的视图
    [self.view addSubview:self.topBarView];
    
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
    self.commentTable.tableHeaderView = self.dynamicSpecifiCell;
    
    //添加无评论时的图层
    if (self.commentTableDataAry.count <=0) {
        [self.commentTable showNoDataStatusWithString:@"还没有评论哦~" imageName:@"图层 11" withOfffset:CGRectGetMidY(self.dynamicSpecifiCell.frame)];
    }
    
    //输入框
    self.inputView.associateTableView = self.commentTable;
    [self.view addSubview:self.inputView];
    
    //一些标识
    self.isFirstEnter = YES;
}


#pragma mark- 网络请求
///第一次请求动态和评论信息
- (void)getDataFirst{
    self.isGetCommentDtaFailure = YES;
    self.isGetDynamicDataFailure = YES;
    DynamicDetailRequestDataModel *requestModel = [[DynamicDetailRequestDataModel alloc] init];
    
    //动态信息
    DynamicSpecificCell *cell = [[DynamicSpecificCell alloc] init];     //动态信息的cell
    DynamicDetailViewModel *model = [[DynamicDetailViewModel alloc] init];  //动态信息的数据model
        //网络请求
    [requestModel requestDynamicDetailDataWithDynamic_id:[self.post_id intValue] Sucess:^(NSDictionary * _Nonnull dic) {
        //数据请求成功先进行赋值
        [model setValuesForKeysWithDictionary:dic];
        //获取该cell的缓存高度
        [model getModelHeight];
        cell.dynamicDataModel = model;
        self.dynamicSpecifiCell = cell;
        self.dynamicDataModel = model;
        self.isGetDynamicDataFailure = NO;
        [self buildFrame];
        } Failure:^{
            self.isGetDynamicDataFailure = YES;
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
    }];
}

///下拉刷新界面  重新网络请求并重新布置界面
- (void)dynamicTableReloadData{
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
        
        [self.commentTable reloadData];
//        self.noCommentView.hidden = self.commentTableDataAry.count == 0 ? NO : YES;
        //添加无评论时的图层
        if (self.commentTableDataAry.count <=0) {
            [self.commentTable showNoDataStatusWithString:@"还没有评论哦~" imageName:@"图层 11" withOfffset:CGRectGetMidY(self.dynamicSpecifiCell.frame)];
        }
        
        [self.commentTable.mj_header endRefreshing];
    } Failure:^{
        [self.commentTable.mj_header endRefreshing];
        }];
}

#pragma mark- event respomse
///点击多功能按钮之后出现的所有的视图消失
- (void)dismissBackViewWithGesture {
    [self.popView removeFromSuperview];
    [self.shareView removeFromSuperview];
    [self.reportView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
}
/// 分享成功后调用
- (void)shareSuccessful {
    [self.popView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    [NewQAHud showHudWith:@"  已复制链接，可以去分享给小伙伴了～  " AddView:self.view];
}

//删除评论
- (void)deleteAction:(int)comment_id{
    DeleteArticleTipView *tipView = [[DeleteArticleTipView alloc] initWithDeleteBlock:^{
        DynamicDetailRequestDataModel *model = [[DynamicDetailRequestDataModel alloc] init];
        [model deleteCommentWithId:comment_id Sucess:^{
            [self.commentTable.mj_header beginRefreshing];
            [NewQAHud showHudWith:@"删除成功" AddView:self.view];

        } Failure:^{
            [NewQAHud showHudWith:@"删除失败，请重试" AddView:self.view];
        }];
    }];
    tipView.titleLabel.text = @"确定删除此条评论？";
    [self.view addSubview:tipView];
    
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
    //添加背景蒙版
    [desWindow addSubview:self.backViewWithGesture];
    self.popView.frame =  CGRectMake(frame.origin.x - SCREEN_WIDTH * 0.27, frame.origin.y + 10, SCREEN_WIDTH * 0.3057, SCREEN_WIDTH * 0.3057 * 105/131.5);
    //添加弹出的view
    [self.view.window addSubview:self.popView];
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
        btn.selected = YES;
        btn.iconView.image = [UIImage imageNamed:@"点赞"];
        btn.countLabel.text = [NSString stringWithFormat:@"%d",[btn.countLabel.text intValue] + 1];
        btn.countLabel.textColor = [UIColor colorNamed:@"countLabelColor"];
    }
    //数据传入后端
    StarPostModel *model = [[StarPostModel alloc] init];
    [model starPostWithPostID:[NSNumber numberWithString:self.post_id]];
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
    NSString *shareURL = [NSString stringWithFormat:@"redrock.zscy.youwen.share://token=%@&id=%@",[UserDefaultTool getToken],self.post_id];
    pasteboard.string = shareURL;
}
///点击标签，跳转到对应的圈子界面
- (void)clickedGroupTopicBtn:(UIButton *)btn{
    YYZTopicDetailVC *vc = [[YYZTopicDetailVC alloc] init];
    vc.topicIdString = self.dynamicDataModel.topic;
//    vc.topicID = self.dynamicDataModel.is_follow_topic;
    [self.navigationController pushViewController:vc animated:YES];
}

//MARK:======================================多功能View的代理方法======================================
///点击关注按钮
- (void)ClickedStarGroupBtn:(UIButton *)sender {
    FollowGroupModel *model = [[FollowGroupModel alloc] init];
    [model FollowGroupWithName:self.dynamicDataModel.topic];
    if ([sender.titleLabel.text isEqualToString:@"关注圈子"]) {
        [model setBlock:^(id  _Nonnull info) {
            if ([info[@"status"] isEqualToNumber:[NSNumber numberWithInt:200]]) {
                //关注圈子成功后的操作
                [self.popView removeFromSuperview];
                [self.backViewWithGesture removeFromSuperview];
                [NewQAHud showHudWith:@"  关注圈子成功  " AddView:self.view AndToDo:^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reSetTopFollowUI" object:nil];
                }];
                //重新设置圈子列表
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadGroupList" object:nil];
            }else  {
                [self.popView removeFromSuperview];
                [self.backViewWithGesture removeFromSuperview];
                [NewQAHud showHudWith:@"  操作失败  " AddView:self.view];
            }
        }];
    } else if ([sender.titleLabel.text isEqualToString:@"取消关注"]) {
        [model setBlock:^(id  _Nonnull info) {
            if ([info[@"status"] isEqualToNumber:[NSNumber numberWithInt:200]]) {
                //取消关注成功的操作
                [self.popView removeFromSuperview];
                [self.backViewWithGesture removeFromSuperview];
                [NewQAHud showHudWith:@"  取消关注圈子成功  " AddView:self.view AndToDo:^{
                    //重新设置邮问首页的圈子关注列表
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reSetTopFollowUI" object:nil];
                }];
                //重新设置圈子列表
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadGroupList" object:nil];
            }else  {
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
    [self.popView removeFromSuperview];
    //此方式进入创建举报view为从动态的多功能按钮进入，只能是举报动态
    self.isReportComment = NO;
//    self.reportView.postID = [NSNumber numberWithString:self.post_id];
//    self.reportView.frame = CGRectMake(MAIN_SCREEN_W * 0.1587, SCREEN_HEIGHT * 0.1, MAIN_SCREEN_W - MAIN_SCREEN_W*2*0.1587,MAIN_SCREEN_W * 0.6827 * 329/256);
    [self.view.window addSubview:self.reportView];
}

//MARK:======================================举报页面的代理方法======================================
/// 举报页面点击确定按钮
- (void)ClickedSureBtn {
    [self.reportView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
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
//    [self.commentTable.mj_header beginRefreshing];
    
}
///举报页面点击取消按钮
- (void)ClickedCancelBtn {
    if (!self.isReportComment == NO) {
        //还原初始化设置
        self.isReportComment = NO;
        self.reportView.postID = [NSNumber numberWithInt:[self.post_id intValue]];
    }
    self.reportView.textView.text = @"";
    [self.reportView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
}

//MARK:======================================分享View的代理方法======================================
///点击取消
- (void)ClickedCancel {
    [self.shareView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
}
///点击分享QQ空间
- (void)ClickedQQZone {
    [self.shareView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    [self shareSuccessful];
}
///点击分享朋友圈
- (void)ClickedVXGroup {
    [self.shareView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    [self shareSuccessful];
}
///点击分享QQ
- (void)ClickedQQ {
    [self.shareView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    [self shareSuccessful];
}
///点击分享微信好友
- (void)ClickedVXFriend {
    [self.shareView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    [self shareSuccessful];
}
///点击分享复制链接
- (void)ClickedUrl {
    [self.shareView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    [self shareSuccessful];
}

//MARK:======================================DKSKeyboardDelegate===============================
//发送的文案
- (void)textViewContentText:(NSString *)textStr {
    [self reportComment:textStr];
}
//选择图片
- (void)leftButtonClick:(NSString *)textStr{
    [self.view endEditing:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        DynamicDetailAddPhotoController *commentVC = [[DynamicDetailAddPhotoController alloc] init];
        if (self.isCommentFirstLevel != YES) {
//            commentVC.reply_id = 0;
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
    });
}
//发送按钮
- (void)rightButtonClick:(NSString *)textStr{
    [self.view endEditing:YES];
    [self reportComment:textStr];
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

    [[HttpClient defaultClient]requestWithPath:@"https://be-prod.redrock.team/magipoke-loop/comment/releaseComment" method:HttpRequestPost parameters:param prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"status"] intValue] ==200) {
            [NewQAHud showHudWith:@"  发布评论成功  " AddView:self.view];
            [self.inputView clearCurrentInput];
            [self.view endEditing:YES];
            [self.commentTable.mj_header beginRefreshing];
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [NewQAHud showHudWith:@"  发布评论失败，请重试  " AddView:self.view];
    }];
    
    //初始化设置
    self.isCommentFirstLevel = YES;
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
    
    if (indexPath.row == 0) {
        return [self.oneLeveCommentHeight[indexPath.section] doubleValue];
    }else{
        NSMutableArray *muteAry = self.twoLevelCommentHeight[indexPath.section];
        return [muteAry[indexPath.row - 1] doubleValue];
    }
   
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
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
            }
        }
    }];
}

#pragma mark- getter
- (DynamicDetailTopBarView *)topBarView{
    if (!_topBarView) {
        _topBarView.delegate = self;
        _topBarView = [[DynamicDetailTopBarView alloc] initWithFrame:CGRectMake(0, STATUSBARHEIGHT, MAIN_SCREEN_W, 45 * HScaleRate_SE)];
    }
    return _topBarView;
}

- (UITableView *)commentTable{
    if (!_commentTable) {
        _commentTable = [[UITableView alloc] initWithFrame:CGRectZero];
        _commentTable.backgroundColor = self.topBarView.backgroundColor;
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
        //给评论table添加刷新控件
        MJRefreshNormalHeader *_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(dynamicTableReloadData)];
        _commentTable.mj_header = _header;
        [MGDRefreshTool setUPHeader:_header];
    }
    return _commentTable;
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
        _reportView.frame = CGRectMake(MAIN_SCREEN_W * 0.1587, SCREEN_HEIGHT * 0.1, MAIN_SCREEN_W - MAIN_SCREEN_W*2*0.1587,MAIN_SCREEN_W * 0.6827 * 329/256);
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
        _inputView = [[DKSKeyboardView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-54, SCREEN_WIDTH, 54)];
        //设置代理方法
        _inputView.delegate = self;
    }
    return _inputView;
}


@end
