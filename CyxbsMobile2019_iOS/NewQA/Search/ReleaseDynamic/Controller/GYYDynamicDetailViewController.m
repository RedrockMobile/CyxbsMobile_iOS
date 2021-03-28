//
//  GYYDynamicDetailViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 郭蕴尧 on 2021/1/28.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "GYYDynamicDetailViewController.h"
#import "RecommendedTableView.h"
#import "PostTableViewCell.h"//帖子详情
#import "GYYDynamicCommentTableViewCell.h"//评论cell
#import "MGDRefreshTool.h"
#import "GYYSendCommentImageChooseViewController.h"//评论
#import "DKSKeyboardView.h" //评论输入框
#import "UIView+FrameTool.h"
#import "GYYDynamicCommentModel.h"
#import "SHPopMenu.h"
#import "zhPopupController.h"
#import "ReportView.h"
#import "NewQAHud.h"
#import "UIScrollView+Empty.h"
#import "GYYShareView.h"
#import "shareView.h"
#import "StarPostModel.h"
#import "DeleteArticleTipView.h"

@interface GYYDynamicDetailViewController ()<UITableViewDelegate,UITableViewDataSource,DKSKeyboardDelegate,ReportViewDelegate,PostTableViewCellDelegate,GYYShareViewDelegate,ShareViewDelegate>

@property(nonatomic, strong) RecommendedTableView *mainTableView;
@property (nonatomic,assign) NSInteger pageIndex;
@property (nonatomic,assign) NSInteger totalCount;
@property(nonatomic, strong) NSMutableArray *allCommentM;

//@property(nonatomic, strong) PostItem *item;
@property(nonatomic, strong) PostTableViewCell *dynamicView;//动态详情页面

@property(nonatomic, strong) UIView *tableHeadView;
@property(nonatomic, strong) DKSKeyboardView *inputView;

//当前操作的评论
@property(nonatomic, strong) GYYDynamicCommentModel *actionCommentModel;
@property(nonatomic, strong) ReportView *reportView;

///分享页面
@property (nonatomic, strong) ShareView *shareView;

@end

@implementation GYYDynamicDetailViewController
- (UIView *)tableHeadView{
    if (!_tableHeadView) {
        _tableHeadView = [[UIView alloc]initWithFrame:CGRectZero];
        _tableHeadView.backgroundColor = [UIColor colorNamed:@"TableViewBackColor"];
        
        self.dynamicView = [[PostTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identifier"];
        self.dynamicView.item = self.item;
        self.dynamicView.frame = CGRectZero;
        self.dynamicView.delegate = self;
        [_tableHeadView addSubview:self.dynamicView];
        
        UILabel *remindLB = [[UILabel alloc]initWithFrame:CGRectZero];
        if (@available(iOS 11.0, *)) {
            remindLB.textColor = [UIColor colorWithLightColor:KUIColorFromRGB(0x15315B) DarkColor:KUIColorFromRGB(0xf0f0f2)];
        }
        remindLB.text = @"回复";
        remindLB.font = [UIFont fontWithName:PingFangSCSemibold size:18];
        [_tableHeadView addSubview:remindLB];
        
        UILabel *lineLB = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH, 1)];
        lineLB.backgroundColor = [UIColor colorWithLightColor:KUIColorFromRGB(0xF1F3F8) DarkColor:KUIColorFromRGB(0x252525)];
        
        [_tableHeadView addSubview:lineLB];
        
        [remindLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.equalTo(_tableHeadView);
            make.left.equalTo(_tableHeadView.mas_left).mas_offset(16);
        }];
        [lineLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_tableHeadView);
            make.left.equalTo(_tableHeadView.mas_left).mas_offset(15);
            make.bottom.equalTo(_tableHeadView.mas_bottom).mas_offset(-40);
            make.height.mas_offset(1);
        }];
    }
    return _tableHeadView;
}
- (DKSKeyboardView *)inputView{
    if (!_inputView) {
        _inputView = [[DKSKeyboardView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-54, SCREEN_WIDTH, 54)];
        //设置代理方法
        _inputView.delegate = self;
    }
    return _inputView;
}
- (ReportView *)reportView{
    if (!_reportView) {
        _reportView = [[ReportView alloc] initWithPostID:[NSNumber numberWithInt:[self.item.post_id intValue]]];
        _reportView.frame = CGRectMake(0, 0, SCREEN_WIDTH * (1-0.1587*2),SCREEN_WIDTH * 0.6827 * 329/256);
        _reportView.delegate = self;
    }
    return _reportView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置背景颜色
    if (@available(iOS 11.0, *)) {
        self.view.backgroundColor = [UIColor colorNamed:@"SZH发布动态主板颜色"];
    }
    self.title = @"详情";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:23],NSForegroundColorAttributeName:[UIColor colorWithLightColor:KUIColorFromRGB(0x15315B) DarkColor:KUIColorFromRGB(0xf0f0f2)]}];
    [self.navigationController.navigationBar setBarTintColor: [UIColor colorWithLightColor:KUIColorFromRGB(0xFFFFFF) DarkColor:KUIColorFromRGB(0x000000)]];
    
    [self addBackButton];
    self.allCommentM = [NSMutableArray array];
    
    self.mainTableView = [[RecommendedTableView alloc] initWithFrame:CGRectZero];
    self.mainTableView.backgroundColor = [UIColor colorWithLightColor:KUIColorFromRGB(0xffffff) DarkColor:KUIColorFromRGB(0x000000)];
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.tableHeaderView = self.tableHeadView;
    self.mainTableView.tableFooterView = [UIView new];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.mainTableView];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).mas_offset(STATUSBARHEIGHT+NVGBARHEIGHT);
        make.bottom.equalTo(self.view).mas_offset(-54-SAFE_AREA_BOTTOM);
    }];
    self.inputView.associateTableView = self.mainTableView;
    [self.view addSubview:self.inputView];
    
    self.pageIndex = 1;
    [self setUpRefresh];
    [self getPostItem];//获取帖子详情
    
    _shareView = [[ShareView alloc] init];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;  //显示导航栏
    [self.tabBarController.tabBar setHidden:YES];             //隐藏底部的tabbar
    
    self.pageIndex = 1;
    [self.mainTableView.mj_header beginRefreshing];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBar.hidden = YES;
}

//添加推出查课表页的按钮
- (void)addBackButton {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 40, 40);
    [backButton setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
    [backButton addTarget:self action: @selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backButton setContentHorizontalAlignment:1];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
}

//跳出查课表页的方法
- (void) back {
    [self.navigationController popViewControllerAnimated:YES];
}

///设置列表加载菊花
- (void)setUpRefresh {
    //上滑加载的设置
    //    MJRefreshBackNormalFooter *_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(dynamicTableLoadData)];
    //    self.mainTableView.mj_footer = _footer;
    
    //下拉刷新的设置
    MJRefreshNormalHeader *_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(dynamicTableReloadData)];
    self.mainTableView.mj_header = _header;
    
    //    [MGDRefreshTool setUPHeader:_header AndFooter:_footer];
    [MGDRefreshTool setUPHeader:_header];
    [self.mainTableView.mj_header beginRefreshing];
    
}
/// 上滑增加动态列表页数
- (void)dynamicTableLoadData{
    self.pageIndex +=1;
    
    [[HttpClient defaultClient] requestWithPath:[NSString stringWithFormat:@"https://cyxbsmobile.redrock.team/wxapi/magipoke-loop/comment/getallcomment?post_id=%d",self.post_id] method:HttpRequestGet parameters:@{} prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"加载动态列表数据成功");
        if ([responseObject[@"status"]intValue] ==200) {
            [self.allCommentM addObjectsFromArray:[GYYDynamicCommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]];
        }
        if (self.allCommentM.count <=0) {
            [self.mainTableView showNoDataStatusWithString:@"还没有评论哦~" imageName:@"图层 11" withOfffset:100];
        }
        
        [self.mainTableView.mj_footer endRefreshing];
        [self.mainTableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.mainTableView.mj_footer endRefreshing];
    }];
    
}
/// 下拉刷新动态列表
- (void)dynamicTableReloadData{
    self.pageIndex = 1;
    
    [[HttpClient defaultClient] requestWithPath:[NSString stringWithFormat:@"https://cyxbsmobile.redrock.team/wxapi/magipoke-loop/comment/getallcomment?post_id=%d",self.post_id] method:HttpRequestGet parameters:@{} prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[@"status"]intValue] ==200) {
            [self.allCommentM removeAllObjects];
            
            [self.allCommentM addObjectsFromArray:[GYYDynamicCommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]];
        }
        if (self.allCommentM.count <=0) {
            [self.mainTableView showNoDataStatusWithString:@"还没有评论哦~" imageName:@"图层 11" withOfffset:CGRectGetMidY(self.tableHeadView.frame)];
        }
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.mainTableView.mj_header endRefreshing];
    }];
    
}
- (void)getPostItem{
    
    if (!self.item && self.post_id >0) {
        
        [[HttpClient defaultClient] requestWithPath:@"https://cyxbsmobile.redrock.team/wxapi/magipoke-loop/post/getPostInfo" method:HttpRequestGet parameters:@{@"id":@(self.post_id)} prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"status"] intValue] ==200) {
                self.item = [PostItem mj_objectWithKeyValues:responseObject[@"data"]];
                [self updateDynamicViewHeight];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
        
    }else{
        [self updateDynamicViewHeight];
    }
    
}
- (void)updateDynamicViewHeight{
    
    self.post_id = [self.item.post_id intValue];
    self.dynamicView.item = self.item;
    //计算帖子的高度
    CGFloat height = MAIN_SCREEN_W*(0.0427+0.1066+0.021*2)+11+((SCREEN_WIDTH*0.0427)*62.5/16);
    if (self.item.pics.count >0) {
        height +=13.5;
        height += self.dynamicView.collectView.collectionViewLayout.collectionViewContentSize.height;
    }else{
        height +=5;
    }
    //计算内容高度
    CGSize titleSize =[self.item.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH*(1-0.0427*2-0.1066), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:15]} context:nil].size;
    
    height += titleSize.height;
    height += [UIImage imageNamed:@"标签背景"].size.height;
    
    self.dynamicView.frame = CGRectMake(0, 0, MAIN_SCREEN_W,height);
    self.tableHeadView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height+40);
    
    [self.mainTableView reloadData];
    
}
- (void)PostTableViewCellHeightUpDate:(CGFloat)cellHeight{
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.allCommentM.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    GYYDynamicCommentModel *commentModel = self.allCommentM[section];
    return commentModel.reply_list.count+1;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identifier = [NSString stringWithFormat:@"comment%ldcell",indexPath.row];
    GYYDynamicCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil) {
        cell = [[GYYDynamicCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier commentType:(indexPath.row ==0 ?DynamicCommentType_stair:DynamicCommentType_secondLevel)];
    }
    GYYDynamicCommentModel *commentModel = self.allCommentM[indexPath.section];
    if (indexPath.row ==0) {
        cell.commentModle = commentModel;
    }else{
        cell.commentModle = commentModel.reply_list[indexPath.row-1];
    }
//    NSInteger rowNum = [tableView numberOfRowsInSection:indexPath.section];
//    cell.lineLB.hidden = (rowNum == indexPath.row+1 ?NO:YES);

    return cell;
    
}
//自适应高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.actionCommentModel = self.allCommentM[indexPath.section];
    if (indexPath.row !=0) {
        self.actionCommentModel = self.actionCommentModel.reply_list[indexPath.row-1];
    }
    
    GYYDynamicCommentTableViewCell *cell = (GYYDynamicCommentTableViewCell*)[self.mainTableView cellForRowAtIndexPath:indexPath];
    
    CGRect rectInTableView = [tableView rectForRowAtIndexPath:indexPath];
    //获取cell在tableView中的位置
    CGRect rectInSuperview = [tableView convertRect:rectInTableView toView:[tableView superview]];
    
    CGFloat rectYMargin = rectInSuperview.origin.y+40;
    if (rectYMargin >=SCREEN_HEIGHT-NVGBARHEIGHT-STATUSBARHEIGHT-54) {
        rectYMargin = rectInSuperview.origin.y-SCREEN_WIDTH*0.0773;
    }
    
    SHPopMenu *_menu = [[SHPopMenu alloc]init];
    
    _menu.dimBackground = YES;
    _menu.menuW = SCREEN_WIDTH * 0.4747;
    _menu.contentH = SCREEN_WIDTH*0.0773;
    
    _menu.mList = @[@"回复",@"复制",(self.actionCommentModel.is_self?@"删除":@"举报")];
    _menu.arrowX = 0;
    _menu.arrowImage = [UIImage imageNamed:@""];
    
    _menu.textColor = [UIColor colorWithLightColor:KUIColorFromRGB(0x0C3573) DarkColor:KUIColorFromRGB(0x0C3573)];
    _menu.font = [UIFont fontWithName:PingFangSCMedium size:12];
    _menu.layer.cornerRadius = 15;
    _menu.layer.masksToBounds = YES;
    
    __weak typeof(self)weakSelf = self;
    //显示菜单
    [_menu showInRectX:(cell.frame.size.width-_menu.menuW)/2.0 rectY:rectYMargin block:^(SHPopMenu *menu, NSInteger index) {
        
        NSLog(@"点击了 --- %ld",(long)index);
        if (index <=1) {
            if (index == 0) {//回复
                [weakSelf.inputView startInputAction];
            }else{//复制
                UIPasteboard *pab = [UIPasteboard generalPasteboard];
                pab.string = weakSelf.actionCommentModel.content;
                // [NewQAHud showHudWith:@"已复制链接，可以去分享给小伙伴了～" AddView:self.view];
            }
        }else{
            if (self.actionCommentModel.is_self) {//删除
                [weakSelf deleteAction];
            }else{//举报
                
                weakSelf.reportView.postID = [NSNumber numberWithInteger:self.actionCommentModel.comment_id];
                weakSelf.zh_popupController = [zhPopupController popupControllerWithMaskType:zhPopupMaskTypeBlackTranslucent];
                weakSelf.zh_popupController.dismissOnMaskTouched = NO;
                [weakSelf.zh_popupController presentContentView:weakSelf.reportView];
            }
        }
        
    }];
    
}
#pragma mark --
//删除评论
- (void)deleteAction{
    
    
    DeleteArticleTipView *tipView = [[DeleteArticleTipView alloc] initWithDeleteBlock:^{
        
        [[HttpClient defaultClient]requestWithPath:@"https://cyxbsmobile.redrock.team/wxapi/magipoke-loop/comment/deleteId" method:HttpRequestPost parameters:@{@"id":@(self.actionCommentModel.comment_id),@"model":@"1"} prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            
            if ([responseObject[@"status"] intValue] ==200) {
                [NewQAHud showHudWith:@"删除成功" AddView:self.view];
                [self.mainTableView.mj_header beginRefreshing];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [NewQAHud showHudWith:@"删除失败，请重试" AddView:self.view];
            
        }];
        
    }];
    tipView.titleLabel.text = @"确定删除此条评论？";
    [self.view addSubview:tipView];
    
}
#pragma mark -举报页面的代理方法
///举报页面点击确定按钮
- (void)ClickedSureBtn {
    
    if (self.reportView.textView.text.length <=0 || [self.reportView.textView.text isEqualToString:@""]) return;
    
    [[HttpClient defaultClient]requestWithPath:@"https://cyxbsmobile.redrock.team/wxapi/magipoke-loop/comment/report" method:HttpRequestPost parameters:@{@"id":self.reportView.postID,@"model":@(self.reportView.model),@"content":self.reportView.textView.text} prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"status"] intValue] ==200) {
            [NewQAHud showHudWith:@"举报成功" AddView:self.view];
            [self.zh_popupController dismiss];
        }else{
            [NewQAHud showHudWith:@"网络错误，请重试" AddView:self.view];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [NewQAHud showHudWith:@"举报失败，请重试" AddView:self.view];
        
    }];
    
}
///举报页面点击取消按钮
- (void)ClickedCancelBtn {
    [self.zh_popupController dismiss];
}
#pragma mark -- PostTableViewCellDelegate
- (void)ClickedFuncBtn:(PostTableViewCell *)cell{
    
    SHPopMenu *_menu = [[SHPopMenu alloc]init];
    
    _menu.dimBackground = YES;
    _menu.menuW = 132;
    _menu.contentH = 35;
    
    _menu.mList = @[@"屏蔽此人",@"举报"];
    _menu.arrowX = 0;
    _menu.arrowImage = [UIImage imageNamed:@""];
    
    _menu.textColor = [UIColor colorWithLightColor:KUIColorFromRGB(0x0C3573) DarkColor:KUIColorFromRGB(0x0C3573)];
    _menu.font = [UIFont fontWithName:PingFangSCMedium size:12];
    //    _menu.layer.cornerRadius = 15;
    //    _menu.layer.masksToBounds = YES;
    
    __weak typeof(self)weakSelf = self;
    //显示菜单
    [_menu showInRectX:CGRectGetWidth(cell.frame)-132 rectY:CGRectGetMinY(cell.frame)+105 block:^(SHPopMenu *menu, NSInteger index) {
        
        if (index != 0) {//举报
            weakSelf.reportView.postID =  weakSelf.reportView.postID = [NSNumber numberWithInt:self.post_id];
            weakSelf.zh_popupController = [zhPopupController popupControllerWithMaskType:zhPopupMaskTypeBlackTranslucent];
            weakSelf.zh_popupController.dismissOnMaskTouched = NO;
            [weakSelf.zh_popupController presentContentView:weakSelf.reportView];
            
        }else{//屏蔽此人
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [NewQAHud showHudWith:@"将不再推荐该用户的动态给你" AddView:self.view];
            });
            
        }
        
    }];
    
}

///点赞的逻辑：根据点赞按钮的tag来获取post_id，并传入后端
- (void)ClickedStarBtn:(PostTableViewCell *)cell{
    if (cell.starBtn.selected == YES) {
        cell.starBtn.selected = NO;
        cell.starBtn.iconView.image = [UIImage imageNamed:@"未点赞"];
        NSString *count = cell.starBtn.countLabel.text;
        cell.starBtn.countLabel.text = [NSString stringWithFormat:@"%d",[count intValue] - 1];
        if (@available(iOS 11.0, *)) {
            cell.starBtn.countLabel.textColor = [UIColor colorNamed:@"FuncBtnColor"];
        } else {
            // Fallback on earlier versions
        }
    }else {
        cell.starBtn.selected = YES;
        cell.starBtn.iconView.image = [UIImage imageNamed:@"点赞"];
        NSString *count = cell.starBtn.countLabel.text;
        cell.starBtn.countLabel.text = [NSString stringWithFormat:@"%d",[count intValue] + 1];
        if (@available(iOS 11.0, *)) {
            cell.starBtn.countLabel.textColor = [UIColor colorNamed:@"countLabelColor"];
            
        } else {
            // Fallback on earlier versions
        }
        
    }
    StarPostModel *model = [[StarPostModel alloc] init];
    [model starPostWithPostID:[NSNumber numberWithString:self.item.post_id]];
}

- (void)ClickedCommentBtn:(PostTableViewCell *)cell{
    self.actionCommentModel = [GYYDynamicCommentModel new];
    [self.inputView startInputAction];
}
- (void)ClickedShareBtn:(PostTableViewCell *)cell{
    
    //    GYYShareView *shareView = [[GYYShareView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    //    shareView.delegate = self;
    //    self.zh_popupController = [zhPopupController popupControllerWithMaskType:zhPopupMaskTypeClear];
    //    self.zh_popupController.dismissOnMaskTouched = NO;
    //    [self.zh_popupController presentContentView:shareView];
    
    [self.view endEditing:YES];
    
    _shareView.delegate = self;
    _shareView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*(1-0.6897));
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ClickedShareBtn" object:nil userInfo:nil];
    //此处还需要修改
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString *shareURL = [NSString stringWithFormat:@"%@%@",@"cyxbs://redrock.team/answer_list/qa/entry?question_id=",self.item.post_id];
    pasteboard.string = shareURL;
    
    
    self.zh_popupController = [zhPopupController popupControllerWithMaskType:zhPopupMaskTypeBlackTranslucent];
    self.zh_popupController.dismissOnMaskTouched = NO;
    self.zh_popupController.layoutType = zhPopupLayoutTypeBottom;
    self.zh_popupController.slideStyle = zhPopupSlideStyleFromBottom;
    [self.zh_popupController presentContentView:_shareView];
    
}
- (void)ClickedGroupTopicBtn:(PostTableViewCell *)cell{
    
}

#pragma mark -分享View的代理方法
///点击取消
- (void)ClickedCancel {
    [self.zh_popupController dismiss];
}

///点击分享QQ空间
- (void)ClickedQQZone {
    [self.zh_popupController dismiss];
    [self shareSuccessful];
}

///点击分享朋友圈
- (void)ClickedVXGroup {
    [self.zh_popupController dismiss];
    [self shareSuccessful];
}

///点击分享QQ
- (void)ClickedQQ {
    [self.zh_popupController dismiss];
    [self shareSuccessful];
}

///点击分享微信好友
- (void)ClickedVXFriend {
    [self.zh_popupController dismiss];
    [self shareSuccessful];
}

///点击分享复制链接
- (void)ClickedUrl {
    [self.zh_popupController dismiss];
    [self shareSuccessful];
}
- (void)shareSuccessful {
    
    [NewQAHud showHudWith:@"已复制链接，可以去分享给小伙伴了～" AddView:self.view];
}


#pragma mark -- GYYShareViewDelegate
- (void)shareViewAction{
    [self.zh_popupController dismiss];
    
}
#pragma mark ====== DKSKeyboardDelegate ======
//发送的文案
- (void)textViewContentText:(NSString *)textStr {
    [self reportComment:textStr];
}
//选择图片
- (void)leftButtonClick:(NSString *)textStr{
    [self.view endEditing:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        GYYSendCommentImageChooseViewController *commentVC = [GYYSendCommentImageChooseViewController new];
        commentVC.post_id = self.post_id;
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
    
    [param setObject:@(self.post_id) forKey:@"post_id"];
    if (self.actionCommentModel.comment_id>0) {
        [param setObject:@(self.actionCommentModel.comment_id) forKey:@"reply_id"];
    }
    
    [[HttpClient defaultClient]requestWithPath:@"https://cyxbsmobile.redrock.team/wxapi/magipoke-loop/comment/releaseComment" method:HttpRequestPost parameters:param prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject[@"status"] intValue] ==200) {
            [NewQAHud showHudWith:@"发布评论成功" AddView:self.view];
            [self.inputView clearCurrentInput];
            [self.view endEditing:YES];
            [self.mainTableView.mj_header beginRefreshing];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [NewQAHud showHudWith:@"发布评论失败，请重试" AddView:self.view];
    }];
    
}
@end
