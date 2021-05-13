//
//  SZHSearchEndCv.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/1/27.
//  Copyright © 2021 Redrock. All rights reserved.
//
//工具类
#import "MGDRefreshTool.h"      //列表刷新工具类

//controller类
#import "SZHSearchEndCv.h"
#import "SearchEndNoResultCV.h" //搜索无结果vc
#import "DynamicDetailMainVC.h" //动态详情页的vc
#import "YYZTopicDetailVC.h"    //圈子详情页

//模型类
#import "SZHSearchDataModel.h"  //搜索模型
#import "StarPostModel.h"       //点赞网络请求模型
#import "SearchEndModel.h"      //搜索结束页网络请求模型
#import "CYSearchEndKnowledgeDetailModel.h" //知识库详情页的model
#import "ShieldModel.h"                     //屏蔽数据的model
#import "ReportModel.h"                     //举报的数据model
#import "FollowGroupModel.h"                //关注圈子的数据model

//视图类
#import "SearchBeiginView.h"    //本界面上半部分
#import "RecommendedTableView.h"//下半部分相关动态表格
#import "PostTableViewCell.h"   //相关动态表格cell
#import "ReportView.h"          //举报界面
#import "ShareView.h"           //分享界面
#import "FuncView.h"            //cell上的三个点点击后界面
#import "CYSearchEndKnowledgeDetailView.h"  //知识库详情页

@interface SZHSearchEndCv ()<UITextFieldDelegate,SearchTopViewDelegate,SZHHotSearchViewDelegate,UITableViewDelegate,UITableViewDataSource,PostTableViewCellDelegate,ShareViewDelegate,FuncViewProtocol,ReportViewDelegate,CYSearchEndKnowledgeDetailViewDelegate>
@property (nonatomic, strong) SearchBeiginView *searchEndTopView;   //上半部分视图
/// 知识库详情页View
@property (nonatomic, strong) CYSearchEndKnowledgeDetailView *knowledgeDetailView;
/// 知识库详情页的model数组
@property (nonatomic, copy) NSArray *knowledgeDetaileModelsAry;
    ///顶部搜索逻辑相关
@property (nonatomic, strong) SZHSearchDataModel *searchDataModel;
@property (nonatomic, strong) NSDictionary *searchDynamicDic;    //相关动态数组
@property (nonatomic, strong) NSDictionary *searchKnowledgeDic;    //知识库数组
@property (nonatomic, assign) BOOL getDynamicFailure;   //获取动态失败
@property (nonatomic, assign) BOOL getKnowledgeFailure; //获取知识库失败


///下半部分视图相关
@property(nonatomic, strong) UILabel *relevantDynamicLbl;   //相关动态标题
    ///表格相关
@property (nonatomic, strong) RecommendedTableView *relevantDynamicTable;   //展示相关动态的表格
@property (nonatomic, strong) SearchEndModel *searchEndDataModel;   //结束页网络请求model
@property (nonatomic, strong) MJRefreshBackNormalFooter *footer;    //列表底部刷新控件
@property (nonatomic, strong) MJRefreshNormalHeader *header;        //列表顶部刷新控件
@property (nonatomic, assign) NSInteger page;   //列表分页展示
    //cell相关
@property (nonatomic, strong) FuncView *popView;    //多功能View（点击cell上的三个小点后出来的view）
@property (nonatomic, strong) ReportView *reportView;   //举报页面
/// 是否已经显示reportView
@property (nonatomic, assign) BOOL isShowedReportView;
@property (nonatomic, strong) ShareView *shareView; //分享页面


///背景蒙版
@property (nonatomic, strong) UIView *backViewWithGesture;

@end

@implementation SZHSearchEndCv

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化设置
    self.searchDynamicDic = nil;
    self.searchKnowledgeDic = nil;
    self.isShowedReportView = NO;
    
    [self setBackViewWithGesture];
    [self addSearchEndTopView];
    self.view.backgroundColor = self.searchEndTopView.backgroundColor;
    if (self.knowlegeAry.count == 0) {
        [self.searchEndTopView.hotSearchView setHidden:YES];
        [self.searchEndTopView.topSeparation setHidden:YES];
    }else{
//        [self.searchEndTopView.hotSearchView setHidden:NO];
//        [self.searchEndTopView.topSeparation setHidden:NO];
    }
    //如果数据源数组为空，无数据，则不展示下半部分页面
    if (self.tableDataAry != nil) {
        [self addSearchEndBottomView];
        [self dynamicTableReloadData];  //手动调用刷洗一次
    }
    
    //监听键盘将要消失、出现，以此来动态的设置举报View的上下移动
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reportViewKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reportViewKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
}

#pragma mark- event response
/// 点击搜索按钮之后去进行的逻辑操作
/// @param searchString 搜索的文本
- (void)searchWithString:(NSString *)searchString{
    //1.如果内容为空仅提示
    if ([searchString isEqualToString:@""]) {
        [NewQAHud showHudWith:@"输入为空" AddView:self.view];
        return;                 //直接返回
    }
    
    //2.内容不为空
    [NewQAHud showHudWith:@"加载中" AddView:self.view];
    /*
     进行网络请求获取数据
     先将搜索帖子和搜索知识库的网络请求全部获取后再进行后续逻辑判断
    */
    self.getDynamicFailure = NO;
    self.getKnowledgeFailure = NO;
    __weak typeof(self)weakSelf = self;
    //请求相关动态
    [self.searchDataModel getSearchDynamicWithStr:searchString Sucess:^(NSDictionary * _Nonnull dynamicDic) {
        weakSelf.searchDynamicDic = dynamicDic;
        [weakSelf processData];
        } Failure:^{
            weakSelf.getDynamicFailure = YES;
            weakSelf.searchDynamicDic = [NSDictionary dictionary];
            [weakSelf processData];
        }];
    //请求帖子
    [self.searchDataModel getSearchKnowledgeWithStr:searchString Sucess:^(NSDictionary * _Nonnull knowledgeDic) {
        weakSelf.searchKnowledgeDic = knowledgeDic;
        [weakSelf processData];
        } Failure:^{
            weakSelf.getKnowledgeFailure = YES;
            weakSelf.searchKnowledgeDic = [NSDictionary dictionary];
            [weakSelf processData];
        }];

    //清除缓存
    self.searchDynamicDic = nil;
    self.searchKnowledgeDic = nil;
    
    //3.添加历史记录
    [self wirteHistoryRecord:searchString];
}

/// 上滑增加动态列表页数
- (void)dynamicTableLoadData{
    self.page +=1;
    __weak typeof(self)weakSelf = self;
    __strong typeof(weakSelf)strongSelf = weakSelf;
    [self.searchEndDataModel loadRelevantDynamicDataWithStr:@"test" Page:self.page Sucess:^(NSArray * _Nonnull array) {
        [strongSelf loadDynamicTableSucessWithAry:array];
        [self loadDynamicTableSucessWithAry:array];
        } Failure:^{
            [strongSelf loadDynamicTableFailure];
        }];
}
/// 下拉刷新动态列表
- (void)dynamicTableReloadData{
    self.page = 1;
//    self.tableDataAry = [NSArray array];
    __weak typeof(self)weakSelf = self;
    __strong typeof(weakSelf)strongSelf = weakSelf;
    [self.searchEndDataModel loadRelevantDynamicDataWithStr:@"test" Page:self.page Sucess:^(NSArray * _Nonnull array) {
        [strongSelf loadDynamicTableSucessWithAry:array];
        [self loadDynamicTableSucessWithAry:array];
        } Failure:^{
            [strongSelf loadDynamicTableFailure];
        }];
}

///动态列表成功请求数据后的操作
- (void)loadDynamicTableSucessWithAry:(NSArray *)array{
    //根据当前页数判断是下拉刷新还是上滑增加内容
    if (self.page == 1) {
        self.tableDataAry = array;
        [self.relevantDynamicTable reloadData];
        [self.relevantDynamicTable.mj_header endRefreshing];
    }else{
        NSMutableArray *ary = [NSMutableArray arrayWithArray:self.tableDataAry];
        [ary addObjectsFromArray:array];
        self.tableDataAry = ary;
        [self.relevantDynamicTable reloadData];
        [self.relevantDynamicTable.mj_footer endRefreshing];
    }
    
}
///动态列表请求数据失败后的操作
- (void)loadDynamicTableFailure{
    [self.relevantDynamicTable.mj_footer endRefreshing];
    [self.relevantDynamicTable.mj_header endRefreshing];
    [NewQAHud showHudWith:@"网络异常" AddView:self.view];
}

///键盘将要出现时，若举报页面已经显示则上移
- (void)reportViewKeyboardWillShow:(NSNotification *)notification{
    //如果举报页面已经出现，就将举报View上移动
    if (self.isShowedReportView == YES) {
        //获取键盘高度
        NSDictionary *userInfo = notification.userInfo;
        CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat keyBoardHeight = endFrame.size.height;
        
        [self.reportView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W - MAIN_SCREEN_W*2*0.1587, MAIN_SCREEN_W * 0.6827 * 329/256));
            make.bottom.equalTo(self.view).offset( IS_IPHONEX ? -(keyBoardHeight+20) : -keyBoardHeight);
        }];
    }
}
///键盘将要消失，若举报页面已经显示则使其下移
- (void)reportViewKeyboardWillHide:(NSNotification *)notification{
    if (self.isShowedReportView == YES) {
        [self.reportView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W - MAIN_SCREEN_W*2*0.1587, MAIN_SCREEN_W * 0.6827 * 329/256));
        }];
    }
    
}

#pragma mark- private methonds
/// 将搜索的内容添加到历史记录
/// @param string 搜索的内容
- (void)wirteHistoryRecord:(NSString *)string{
    //1.取出userDefault的历史数组
    NSUserDefaults *userdefaulte = [NSUserDefaults standardUserDefaults];
        //从缓存中取出数组的时候要mutablyCopy一下，不然会崩溃
    NSMutableArray *array = [[userdefaulte objectForKey:@"historyRecords"] mutableCopy];
    
    //2.判断当前搜素内容是否与历史记录重合，如果重合就删除历史记录中原存在的数组
    for (NSString *historyStr in array) {
        if ([historyStr isEqualToString:string]) {
            [array removeObject:historyStr];        //从数组中移除
            break;                                  //直接退出
        }
    }
    //3.将内容加入到历史记录数组里面
    [array insertObject:string atIndex:0];
    
    //4.将历史数组重新存入UserDefault
    [userdefaulte setObject:array forKey:@"historyRecords"];
    
    //5.发出通知，在搜索开始页去刷新历史记录（在willAppear里面调用）
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadHistory" object:nil];
}
/// 处理网络请求的数据，进行逻辑判断跳转界面
- (void)processData{
    //如果两个返回的response均有值，则可进行逻辑判断，否则直接返回
    if (self.searchDynamicDic == nil || self.searchKnowledgeDic == nil) {
        return;
    }else{
        //1.无网络连接
        if (self.getKnowledgeFailure == YES && self.getDynamicFailure == YES) {
            [NewQAHud showHudWith:@"无网络连接" AddView:self.view];
            return;
        }
        //2.有网络连接
        NSDictionary *dynamicDic = self.searchDynamicDic;
        NSDictionary *knowledgeDic = self.searchKnowledgeDic;
        NSArray *dynamicAry = dynamicDic[@"data"];
        NSArray *knowledgeAry = knowledgeDic[@"data"];
//        NSArray *knowledgeAry = self.knowledgeDic[@"data"];
            //2.1加载提示
        [NewQAHud showHudWith:@"加载中" AddView:self.view];
    
            //2.1无搜索内容，跳转到搜索无结果页
        if (dynamicAry.count == 0 && knowledgeAry.count == 0) {
            SearchEndNoResultCV *vc = [[SearchEndNoResultCV alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else{//2.2 有搜索内容进行赋值，跳转到搜索结果页
            SZHSearchEndCv *vc = [[SZHSearchEndCv alloc] init];
            vc.tableDataAry = dynamicAry;
            vc.knowlegeAry = knowledgeAry;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
}

///设置相关蒙版
- (void)setBackViewWithGesture {
    _backViewWithGesture = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _backViewWithGesture.backgroundColor = [UIColor blackColor];
    _backViewWithGesture.alpha = 0.36;
    UITapGestureRecognizer *dismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissBackViewWithGesture)];
    [self.backViewWithGesture addGestureRecognizer:dismiss];
//    [self.view addSubview:self.backViewWithGesture];
}
- (void)showBackViewWithGesture {
    [self.view.window addSubview:_backViewWithGesture];
}
- (void)dismissBackViewWithGestureAnd:(UIView *)view {
    [view removeFromSuperview];
    [_backViewWithGesture removeFromSuperview];
}
- (void)dismissBackViewWithGesture {
    [_popView removeFromSuperview];
    [_shareView removeFromSuperview];
    [self.reportView removeFromSuperview];
    self.isShowedReportView = NO;
    [_backViewWithGesture removeFromSuperview];
}

//配置相关操作成功后的弹窗
- (void)showShieldSuccessful {
    [self.popView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    [NewQAHud showHudWith:@"将不再推荐该用户的动态给你" AddView:self.view];
}

- (void)showReportSuccessful {
    [self.popView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    [NewQAHud showHudWith:@"举报成功" AddView:self.view];
}

- (void)showReportFailure {
    [self.popView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    [NewQAHud showHudWith:@"网络繁忙，请稍后再试" AddView:self.view];
}

- (void)shareSuccessful {
    [self.popView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    [NewQAHud showHudWith:@"已复制链接，可以去分享给小伙伴了～" AddView:self.view];
}

#pragma mark- 代理方法
//MARK:上半部分视图以及UITextField的代理方法
//返回上一界面
- (void)jumpBack{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

//点击重邮知识库按钮 弹出详细界面
- (void)touchCQUPTKonwledgeThroughBtn:(UIButton *)btn{
    //更改上半部分的view
    [self.searchEndTopView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(MAIN_SCREEN_H * 0.4505);
    }];
    
    [self.searchEndTopView.hotSearchView hideKnowledgeBtns];    //隐藏热搜view的button们
    //添加知识库详情页并进行布局
    [self.searchEndTopView.hotSearchView addSubview:self.knowledgeDetailView];
    [self.knowledgeDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchEndTopView.hotSearchView.hotSearch_KnowledgeLabel);
        make.right.equalTo(self.searchEndTopView).offset(-MAIN_SCREEN_W * 0.0426);
        make.top.equalTo(self.searchEndTopView.hotSearchView.hotSearch_KnowledgeLabel.mas_bottom).offset(MAIN_SCREEN_H * 0.02548);
        make.bottom.equalTo(self.searchEndTopView.topSeparation).offset(- MAIN_SCREEN_H * 0.0375);
        
    }];
    //设置知识库的数据
    for (CYSearchEndKnowledgeDetailModel *model in self.knowledgeDetaileModelsAry) {
        if ([model.titleStr isEqualToString:btn.titleLabel.text] ) {
            self.knowledgeDetailView.model = model;
            break;
        }
    }
    
    
}

//点击搜索后执行
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    [self searchWithString:textField.text];
    return YES;
}

//MARK:知识库详情页的代理方法
- (void)deleteKnowledgeDetaileview:(UIView *)view{
    [view removeFromSuperview];
    //更改上半部分视图
    [self.searchEndTopView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(MAIN_SCREEN_H * 0.3375);
    }];
    //将重邮知识库的button显示出来
    [self.searchEndTopView.hotSearchView updateBtns];
}

//MARK:==============================相关动态table的数据源和代理方法=====================================
///数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableDataAry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //创建单元格（用复用池）
    ///给每一个cell的identifier设置为唯一的
    NSString *identifier = [NSString stringWithFormat:@"dynamicCell%ld",indexPath.row];
    PostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil) {
        PostItem *item = [[PostItem alloc] initWithDic:self.tableDataAry[indexPath.row]];
        //这里
        cell = [[PostTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.delegate = self;
        cell.item = item;
        cell.commendBtn.tag = indexPath.row;
        cell.shareBtn.tag = indexPath.row;
        cell.starBtn.tag = indexPath.row;
        cell.tag = indexPath.row;
        if (cell.tag == 0) {
            cell.layer.cornerRadius = 10;
        }
    }
    return cell;
}
///点击跳转到具体的帖子（与下方commentBtn的事件相同）
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DynamicDetailMainVC *dynamicDetailVC = [[DynamicDetailMainVC alloc]init];
    PostItem *item = [[PostItem alloc] initWithDic:self.tableDataAry[indexPath.row]];
    dynamicDetailVC.post_id = item.post_id;
    dynamicDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:dynamicDetailVC animated:YES];
}
//自适应高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

//MARK:==============================相关动态cell的代理方法==============================
///点赞的逻辑：根据点赞按钮的tag来获取post_id，并传入后端
- (void)ClickedStarBtn:(PostTableViewCell *)cell {
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
    [model starPostWithPostID:cell.item.post_id.numberValue];
}
///跳转到具体的帖子详情:(可以通过帖子id跳转到具体的帖子页面，获取帖子id的方式如下方注释的代码)
- (void)ClickedCommentBtn:(PostTableViewCell *)cell {
    DynamicDetailMainVC *dynamicDetailVC = [[DynamicDetailMainVC alloc]init];
    dynamicDetailVC.post_id = cell.item.post_id;
    dynamicDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:dynamicDetailVC animated:YES];
}
///分享帖子
- (void)ClickedShareBtn:(PostTableViewCell *)cell {
    [self showBackViewWithGesture];
    _shareView = [[ShareView alloc] init];
    _shareView.delegate = self;
    [self.view.window addSubview:_shareView];
    [_shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.window.mas_top).mas_offset(SCREEN_HEIGHT * 0.6897);
        make.left.right.bottom.mas_equalTo(self.view.window);
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ClickedShareBtn" object:nil userInfo:nil];
    //此处还需要修改
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString *shareURL = [NSString stringWithFormat:@"https://fe-prod.redrock.team/zscy-youwen-share/#/dynamic?id=%@",cell.item.post_id];
    pasteboard.string = shareURL;
}
/**
 举报和屏蔽的多能按钮
 此处的逻辑：接收到cell里传来的多功能按钮的frame，在此frame上放置多功能View，同时加上蒙版
 */
- (void)ClickedFuncBtn:(PostTableViewCell *)cell{
//    [self setBackViewWithGesture];
    UIWindow* desWindow = self.view.window;
    CGRect frame = [cell.funcBtn convertRect:cell.funcBtn.bounds toView:desWindow];
    [self showBackViewWithGesture];
    _popView = [[FuncView alloc] init];
    _popView.delegate = self;
    _popView.layer.cornerRadius = 3;
    _popView.frame = CGRectMake(frame.origin.x - SCREEN_WIDTH * 0.27, frame.origin.y + 10, SCREEN_WIDTH * 0.3057, SCREEN_WIDTH * 0.3057 * 105/131.5);
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:self.tableDataAry[cell.tag]];
    if ([dic[@"is_follow_topic"] intValue] == 1) {
        NSLog(@"取消关注");
        [_popView.starGroupBtn setTitle:@"取消关注" forState:UIControlStateNormal];
    }else {
        NSLog(@"关注圈子");
        [_popView.starGroupBtn setTitle:@"关注圈子" forState:UIControlStateNormal];
    }
    
    [self.view.window addSubview:_popView];
    
}
/// 点击标签，进入到圈子详情页
- (void)ClickedGroupTopicBtn:(PostTableViewCell *)cell{
//    YYZTopicDetailVC *vc = [[YYZTopicDetailVC alloc] init];
//    vc.topicIdString = cell.item.topic;
//    [self.navigationController pushViewController:vc animated:YES];
}

//MARK:==============================多功能View代理方法==============================
///点击关注按钮
- (void)ClickedStarGroupBtn:(UIButton *)sender {
    NSDictionary * _itemDic = self.tableDataAry[sender.tag];
    FollowGroupModel *model = [[FollowGroupModel alloc] init];
    [model FollowGroupWithName:_itemDic[@"topic"]];
    if ([sender.titleLabel.text isEqualToString:@"关注圈子"]) {
        [model setBlock:^(id  _Nonnull info) {
            if ([info[@"status"] isEqualToNumber:[NSNumber numberWithInt:200]]) {
                [self showStarSuccessful];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadGroupList" object:nil];
            }else  {
                [self funcViewFailure];
            }
        }];
    } else if ([sender.titleLabel.text isEqualToString:@"取消关注"]) {
        [model setBlock:^(id  _Nonnull info) {
            if ([info[@"status"] isEqualToNumber:[NSNumber numberWithInt:200]]) {
                [self showUnStarSuccessful];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadGroupList" object:nil];
            }else  {
                [self funcViewFailure];
            }
        }];
    }
}
///点击屏蔽按钮
- (void)ClickedShieldBtn:(UIButton *)sender {
    ShieldModel *model = [[ShieldModel alloc] init];
    PostItem *item = [[PostItem alloc] initWithDic:self.tableDataAry[sender.tag]];
//    [self showShieldSuccessful];
    [model ShieldPersonWithUid:item.uid];
    [model setBlock:^(id  _Nonnull info) {
        if ([info[@"info"] isEqualToString:@"success"]) {
            [self showShieldSuccessful];
        }
    }];
}
///点击举报按钮
- (void)ClickedReportBtn:(UIButton *)sender  {
    [_popView removeFromSuperview];
    //已经显示举报
    self.isShowedReportView = YES;
    
    PostItem *item = [[PostItem alloc] initWithDic:self.tableDataAry[sender.tag]];
    self.reportView.postID = [NSNumber numberWithString:item.post_id];
    [self.view.window addSubview:self.reportView];
    [self.reportView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W - MAIN_SCREEN_W*2*0.1587, MAIN_SCREEN_W * 0.6827 * 329/256));
    }];
}

//MARK:==============================举报页面代理方法==============================
///举报页面点击确定按钮
- (void)ClickedSureBtn {
    self.isShowedReportView = NO;   //未显示举报页面
    [self.reportView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    ReportModel *model = [[ReportModel alloc] init];
    [model ReportWithPostID:self.reportView.postID WithModel:[NSNumber numberWithInt:0] AndContent:self.reportView.textView.text];
    [model setBlock:^(id  _Nonnull info) {
        [self showReportSuccessful];
    }];
}
///举报页面点击取消按钮
- (void)ClickedCancelBtn {
    self.isShowedReportView = NO;
    [self.reportView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
}

//MARK:==============================分享view的代理方法==============================
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

//关注圈子成功后提示
- (void)showStarSuccessful {
    [self.popView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    [NewQAHud showHudWith:@"  关注圈子成功  " AddView:self.view AndToDo:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reSetTopFollowUI" object:nil];
    }];
}

//取消关注圈子成功后提示
- (void)showUnStarSuccessful {
    [self.popView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    [NewQAHud showHudWith:@"  取消关注圈子成功  " AddView:self.view AndToDo:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reSetTopFollowUI" object:nil];
    }];
}

//操作失败的提示
- (void)funcViewFailure {
    [self.popView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    [NewQAHud showHudWith:@"  操作失败  " AddView:self.view];
}

#pragma mark- ==============================添加界面控件==============================
/// 添加上半部分视图
- (void)addSearchEndTopView{
    self.searchEndTopView = [[SearchBeiginView alloc] initWithString:@"邮问知识库"];
    
    //设置重邮知识库的view
//    self.knowlegeAry = @[@"红岩网校",@"校庆",@"啦啦操比赛",@"话剧表演",@"奖学金",@"建模"];
    if (self.knowlegeAry != nil) {
        NSMutableArray *muteAry = [NSMutableArray array];
        NSMutableArray *muteDicAry = [NSMutableArray array];
        for (NSDictionary *dic in self.knowlegeAry) {
            CYSearchEndKnowledgeDetailModel *knowledgeDetaileModel  = [CYSearchEndKnowledgeDetailModel initWithDict:dic];
            [muteAry addObject:knowledgeDetaileModel.titleStr];
            [muteDicAry addObject:knowledgeDetaileModel];
        }
        self.knowledgeDetaileModelsAry = muteDicAry;
        self.searchEndTopView.hotSearchView.buttonTextAry = muteAry;
        [self.searchEndTopView.hotSearchView updateBtns];
    }
    
    
    //设置代理
    self.searchEndTopView.searchTopView.delegate = self;
    self.searchEndTopView.hotSearchView.delegate = self;
    self.searchEndTopView.searchTopView.searchTextfield.delegate = self;
    [self.searchEndTopView.searchTopView.searchTextfield setReturnKeyType:UIReturnKeySearch];
    //设置frame
    [self.view addSubview:self.searchEndTopView];
//    self.searchEndTopView.frame = self.view.frame;
    [self.searchEndTopView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(MAIN_SCREEN_H * 0.3375);
    }];
}

/// 添加底部视图，主要为一个label和一个table
- (void)addSearchEndBottomView{
    //底部的包含label和table的view
    UIView *bottomBackGroundView = [[UIView alloc] init];
    bottomBackGroundView.backgroundColor = self.searchEndTopView.backgroundColor;
    [self.view addSubview:bottomBackGroundView];
    //如果上半部分无视图，则上移动，有则保持原位
    if (self.knowlegeAry.count == 0) {
        [bottomBackGroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.view).offset(MAIN_SCREEN_H * 0.1364);
        }];
    }else{
        [bottomBackGroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
//            make.top.equalTo(self.view.mas_top).offset(MAIN_SCREEN_H * 0.3613);
            make.top.equalTo(self.searchEndTopView.mas_bottom).offset(MAIN_SCREEN_H * 0.0375);
        }];
    }
    
    //相关动态的label
    [bottomBackGroundView addSubview:self.relevantDynamicLbl];
    [self.relevantDynamicLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomBackGroundView).offset(MAIN_SCREEN_W * 0.0427);
        make.top.equalTo(bottomBackGroundView);
        make.height.mas_equalTo(17);
    }];
    
    //相关动态的table
    [bottomBackGroundView addSubview:self.relevantDynamicTable];
    [self.relevantDynamicTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(bottomBackGroundView);
        make.top.equalTo(self.relevantDynamicLbl.mas_bottom).offset(MAIN_SCREEN_H * 0.0299);
    }];
    self.page = 1;
    //设置列表加载菊花
    [self setUpRefresh];
}

///设置列表加载菊花
- (void)setUpRefresh {
    //上滑加载的设置
    _footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(dynamicTableLoadData)];
    self.relevantDynamicTable.mj_footer = _footer;
    
    //下拉刷新的设置
    _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(dynamicTableReloadData)];
    self.relevantDynamicTable.mj_header = _header;
    
    [MGDRefreshTool setUPHeader:_header AndFooter:_footer];
}

#pragma mark- getter
/// 获取热搜、知识库、相关动态的网络数据的model
- (SZHSearchDataModel *)searchDataModel{
    if (_searchDataModel == nil) {
        _searchDataModel = [[SZHSearchDataModel alloc] init];
    }
    return _searchDataModel;
}

/// 获取相关动态列表网络数据的model
- (SearchEndModel *)searchEndDataModel{
    if (_searchEndDataModel == nil) {
        _searchEndDataModel = [[SearchEndModel alloc] init];
    }
    return _searchEndDataModel;
}

/// 知识库详情的View
- (CYSearchEndKnowledgeDetailView *)knowledgeDetailView{
    if (!_knowledgeDetailView) {
        CYSearchEndKnowledgeDetailView *knowlegeDetailView = [[CYSearchEndKnowledgeDetailView alloc] initWithFrame:CGRectZero];
        _knowledgeDetailView = knowlegeDetailView;
        _knowledgeDetailView.delegate = self;
    }
    return _knowledgeDetailView;
}

///相关动态的label
- (UILabel *)relevantDynamicLbl{
    if (!_relevantDynamicLbl) {
        _relevantDynamicLbl = [[UILabel alloc] init];
        _relevantDynamicLbl.text = @"相关动态";
        _relevantDynamicLbl.font = [UIFont fontWithName:PingFangSCMedium size:18];
            //设置字体和背景颜色
        if (@available(iOS 11.0, *)) {
            _relevantDynamicLbl.textColor = [UIColor colorNamed:@"SZHHotHistoryKnowledgeLblColor"];
            _relevantDynamicLbl.backgroundColor = [UIColor colorNamed:@"QAMainPageBackGroudColor"];
        } else {
            // Fallback on earlier versions
        }
    }
    return _relevantDynamicLbl;
}

/// 相关动态的table
- (RecommendedTableView *)relevantDynamicTable{
    if (!_relevantDynamicTable) {
        _relevantDynamicTable = [[RecommendedTableView alloc] init];
        _relevantDynamicTable.delegate = self;
        _relevantDynamicTable.dataSource = self;
    }
    return _relevantDynamicTable;
}

- (ReportView *)reportView{
    if (!_reportView) {
        //最开始默认输入为0，后面再进行赋值
        _reportView = [[ReportView alloc] initWithPostID:@0];
        _reportView.delegate = self;
    }
    return _reportView;
}
@end
