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
#import "DeletePostModel.h"                 //删除动态的model

//视图类
#import "SearchBeiginView.h"    //本界面上半部分
#import "RecommendedTableView.h"//下半部分相关动态表格
#import "PostTableViewCell.h"   //相关动态表格cell
#import "ReportView.h"          //举报界面
#import "ShareView.h"           //分享界面
#import "FuncView.h"            //cell上的三个点点击后界面
#import "CYSearchEndKnowledgeDetailView.h"  //知识库详情页
#import "SearchTopView.h"
#import "SelfFuncView.h"    //动态是自己的时候的多功能View
#import "LYEmptyView.h"
#import "PostTableViewCellFrame.h"  //动态cell的高度抽象类

@interface SZHSearchEndCv ()<UITextFieldDelegate,SearchTopViewDelegate,SZHHotSearchViewDelegate,UITableViewDelegate,UITableViewDataSource,PostTableViewCellDelegate,ShareViewDelegate,FuncViewProtocol,ReportViewDelegate,SelfFuncViewProtocol>
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
@property (nonatomic, strong) NSMutableArray <PostTableViewCellFrame *>*tableHeightAry; //cell的高度数组
    //cell相关
///多功能View（点击cell上的三个小点后出来的view）
@property (nonatomic, strong) FuncView *popView;
///自己动态的多功能View
@property (nonatomic, strong) SelfFuncView *selfPopView;
///举报页面
@property (nonatomic, strong) ReportView *reportView;
/// 是否已经显示reportView
@property (nonatomic, assign) BOOL isShowedReportView;
@property (nonatomic, strong) ShareView *shareView; //分享页面

/// 顶view距离table内容的距离
@property (nonatomic, assign) CGFloat staticReleventLaeblHeight;
///距离top顶端和table实际内容之间的View
@property (nonatomic, strong) UIView *topView;
/// 有知识库详情页的时候的View
@property (nonatomic, strong) UIView *detailKnowledgeTopView;

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
    
    self.staticReleventLaeblHeight = MAIN_SCREEN_H*0.0802 + 17;
    
    [self setBackViewWithGesture];
    
    self.view.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#F1F3F8" alpha:1] darkColor:[UIColor colorWithHexString:@"#000001" alpha:1]];
    //如果数据源数组为空，无数据，则不展示下半部分页面
    if (self.tableDataAry.count == 0) {
        [self buildFrameWhenNoDynamic];
    }else{
        //初始化高度数组
        self.tableHeightAry = [NSMutableArray array];
        for (NSDictionary *dic in self.tableDataAry) {
            PostItem *item = [[PostItem alloc] initWithDic:dic];
            PostTableViewCellFrame *cellFrame = [[PostTableViewCellFrame alloc] init];
            cellFrame.item = item;
            [self.tableHeightAry addObject:cellFrame];
            
        }
        [self buildFrameWhenHaveDynamic];
    }
    
    [self setUpRefresh];
    [self.relevantDynamicTable.mj_header endRefreshing];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.tabBarController.tabBar setHidden:YES];
    
    //注册通知中心
    //监听键盘将要消失、出现，以此来动态的设置举报View的上下移动
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reportViewKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reportViewKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

//移除通知中心，防止在其他页面调用本页面方法
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)dealloc
{
    [self.relevantDynamicTable removeObserver:self forKeyPath:@"contentOffset"];
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
    [NewQAHud showHudWith:@"  加载中  " AddView:self.view];
    /*
     进行网络请求获取数据
     先将搜索帖子和搜索知识库的网络请求全部获取后再进行后续逻辑判断
    */
    self.getDynamicFailure = NO;
    self.getKnowledgeFailure = NO;
    __weak typeof(self)weakSelf = self;
    //请求相关动态
    [self.searchDataModel getSearchDynamicWithStr:searchString Success:^(NSDictionary * _Nonnull dynamicDic) {
        weakSelf.searchDynamicDic = dynamicDic;
        [weakSelf processDataWithStr:searchString];
        } Failure:^{
            weakSelf.getDynamicFailure = YES;
            weakSelf.searchDynamicDic = [NSDictionary dictionary];
            [weakSelf processDataWithStr:searchString];
        }];
    //请求帖子
    [self.searchDataModel getSearchKnowledgeWithStr:searchString Success:^(NSDictionary * _Nonnull knowledgeDic) {
        weakSelf.searchKnowledgeDic = knowledgeDic;
        [weakSelf processDataWithStr:searchString];
        } Failure:^{
            weakSelf.getKnowledgeFailure = YES;
            weakSelf.searchKnowledgeDic = [NSDictionary dictionary];
            [weakSelf processDataWithStr:searchString];
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
    [self.searchEndDataModel loadRelevantDynamicDataWithStr:self.searchStr Page:self.page Success:^(NSArray * _Nonnull array) {
        [strongSelf loadDynamicTableSuccessWithAry:array];
        [self loadDynamicTableSuccessWithAry:array];
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
    [self.searchEndDataModel loadRelevantDynamicDataWithStr:self.searchStr Page:self.page Success:^(NSArray * _Nonnull array) {
        [strongSelf loadDynamicTableSuccessWithAry:array];
        [self loadDynamicTableSuccessWithAry:array];
        } Failure:^{
            [strongSelf loadDynamicTableFailure];
        }];
}

///动态列表成功请求数据后的操作
- (void)loadDynamicTableSuccessWithAry:(NSArray *)array{
    //根据当前页数判断是下拉刷新还是上滑增加内容
    if (self.page == 1) {
        NSLog(@"%@",array);
        self.tableDataAry = array;
        
        //重装高度数组
        [self.tableHeightAry removeAllObjects];
        for (NSDictionary *dic in self.tableDataAry) {
            PostItem *item = [[PostItem alloc] initWithDic:dic];
            PostTableViewCellFrame *cellFrame = [[PostTableViewCellFrame alloc] init];
            cellFrame.item = item;
            [self.tableHeightAry addObject:cellFrame];
        }
        
        [self.relevantDynamicTable reloadData];
        [self.relevantDynamicTable.mj_header endRefreshing];
    }else{
        NSMutableArray *ary = [NSMutableArray arrayWithArray:self.tableDataAry];
        [ary addObjectsFromArray:array];
        self.tableDataAry = ary;
        for (NSDictionary *dic in array) {
            PostItem *item = [[PostItem alloc] initWithDic:dic];
            PostTableViewCellFrame *cellFrame = [[PostTableViewCellFrame alloc] init];
            cellFrame.item = item;
            [self.tableHeightAry addObject:cellFrame];
        }
        
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
///当有动态时的布局
- (void)buildFrameWhenHaveDynamic{
    [self.view addSubview:self.relevantDynamicTable];
    //当无知识库的情况
    if (self.knowlegeAry.count == 0){
        SearchTopView *topView = [[SearchTopView alloc] init];
        topView.searchTextfield.delegate = self;
        topView.delegate = self;
        [self.view addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_top).offset(STATUSBARHEIGHT + NVGBARHEIGHT);
            make.left.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W, MAIN_SCREEN_H * 0.0462));
        }];
        [self.view addSubview:self.relevantDynamicLbl];
        [self.relevantDynamicLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topView.mas_bottom).offset(MAIN_SCREEN_H * 0.0375);
            make.left.equalTo(self.view).offset(MAIN_SCREEN_W * 0.0427);
        }];
        [self.relevantDynamicTable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.relevantDynamicLbl.mas_bottom).offset(MAIN_SCREEN_H*0.0462);
            make.left.right.bottom.equalTo(self.view);
        }];
//        self.relevantDynamicTable.contentInset = UIEdgeInsetsMake(MAIN_SCREEN_H * 0.0462 + MAIN_SCREEN_H*0.1633 + 17, 0, 0, 0);
    }else{
    //有知识库的情况
        [self.view addSubview:self.topView];
        self.relevantDynamicTable.tableHeaderView = self.topView;
    }
}
///当无动态时的布局
- (void)buildFrameWhenNoDynamic{
    //添加上半部分视图
    [self.view addSubview:self.searchEndTopView];
    [self.searchEndTopView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo([self.searchEndTopView searchBeginViewHeight]);
    }];
}

/// 将搜索的内容添加到历史记录
/// @param string 搜索的内容
- (void)wirteHistoryRecord:(NSString *)string{
    //1.取出userDefault的历史数组，从缓存中取出数组的时候要mutablyCopy一下，不然会崩溃
    NSMutableArray *array = [[NSUserDefaults.standardUserDefaults objectForKey:@"historyRecords"] mutableCopy];
    
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
    [NSUserDefaults.standardUserDefaults setObject:array forKey:@"historyRecords"];
    
    //5.发出通知，在搜索开始页去刷新历史记录（在willAppear里面调用）
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadHistory" object:nil];
}
/// 处理网络请求的数据，进行逻辑判断跳转界面
- (void)processDataWithStr:(NSString *)str{
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
        [NewQAHud showHudWith:@"  加载中  " AddView:self.view];
    
            //2.1无搜索内容，跳转到搜索无结果页
        if (dynamicAry.count == 0 && knowledgeAry.count == 0) {
            SearchEndNoResultCV *vc = [[SearchEndNoResultCV alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else{//2.2 有搜索内容进行赋值，跳转到搜索结果页
            SZHSearchEndCv *vc = [[SZHSearchEndCv alloc] init];
            vc.tableDataAry = dynamicAry;
            vc.knowlegeAry = knowledgeAry;
            vc.searchStr = str;
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
    [self.popView removeFromSuperview];
    [self.selfPopView removeFromSuperview];
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
    
    CYSearchEndKnowledgeDetailView *vc = [[CYSearchEndKnowledgeDetailView alloc] init];
    //设置知识库的数据
    for (CYSearchEndKnowledgeDetailModel *model in self.knowledgeDetaileModelsAry) {
        if ([model.titleStr isEqualToString:btn.titleLabel.text] ) {
            vc.model = model;
            break;
        }
    }
    vc.view.backgroundColor = self.view.backgroundColor;
    [self.navigationController pushViewController:vc animated:YES];
    
}

//点击搜索后执行
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    [self searchWithString:textField.text];
    return YES;
}


//MARK:==============================相关动态table的数据源和代理方法=====================================
///数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableDataAry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //创建单元格（用复用池）
    NSString *identifier = [NSString stringWithFormat:@"dynamicCell"];
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
    cell.cellFrame = self.tableHeightAry[indexPath.row];
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
//    return UITableViewAutomaticDimension;
    PostTableViewCellFrame *cellFrame;
    cellFrame = self.tableHeightAry[indexPath.row];
    return cellFrame.cellHeight;
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
            cell.starBtn.countLabel.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#ABBCD9" alpha:1] darkColor:[UIColor colorWithHexString:@"#838384" alpha:1]];
        } else {
            // Fallback on earlier versions
        }
    }else {
        cell.starBtn.selected = YES;
        cell.starBtn.iconView.image = [UIImage imageNamed:@"点赞"];
        NSString *count = cell.starBtn.countLabel.text;
        cell.starBtn.countLabel.text = [NSString stringWithFormat:@"%d",[count intValue] + 1];
        if (@available(iOS 11.0, *)) {
            cell.starBtn.countLabel.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#3D35E1" alpha:1] darkColor:[UIColor colorWithHexString:@"#2CDEFF" alpha:1]];
            
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
    
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:self.tableDataAry[cell.tag]];
    if ([dic[@"is_self"] intValue] == 1) {
        self.selfPopView.frame = CGRectMake(frame.origin.x - SCREEN_WIDTH * 0.27, frame.origin.y + 10, SCREEN_WIDTH * 0.3057, SCREEN_WIDTH * 0.3057 * 105/131.5* 1/3);
        [self.view.window addSubview:self.selfPopView];
    }else{
        if ([dic[@"is_follow_topic"] intValue] == 1) {
            [self.popView.starGroupBtn setTitle:@"取消关注" forState:UIControlStateNormal];
        }else {
            [self.popView.starGroupBtn setTitle:@"关注圈子" forState:UIControlStateNormal];
        }
        self.popView.frame = CGRectMake(frame.origin.x - SCREEN_WIDTH * 0.27, frame.origin.y + 10, SCREEN_WIDTH * 0.3057, SCREEN_WIDTH * 0.3057 * 105/131.5);
        [self.view.window addSubview:self.popView];
    }
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
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshNewQAMainViewController" object:nil userInfo:nil];
            }else  {
                [self funcViewFailure];
            }
        }];
    } else if ([sender.titleLabel.text isEqualToString:@"取消关注"]) {
        [model setBlock:^(id  _Nonnull info) {
            if ([info[@"status"] isEqualToNumber:[NSNumber numberWithInt:200]]) {
                [self showUnStarSuccessful];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshNewQAMainViewController" object:nil userInfo:nil];
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

//MARK:===========================自己动态的多功能View代理方法=========================
- (void)ClickedDeletePostBtn:(UIButton *)sender{
    [self.selfPopView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    NSDictionary *dic = self.tableDataAry[sender.tag];
    DeletePostModel *model = [[DeletePostModel alloc] init];
    [model deletePostWithID:dic[@"post_id"] AndModel:[NSNumber numberWithInt:0]];
    [model setBlock:^(id  _Nonnull info) {
        NSMutableArray *muteAry = [NSMutableArray arrayWithArray:self.tableDataAry];
        for (int i = 0;i < self.tableDataAry.count; i++) {
            if ([muteAry[i][@"post_id"] isEqualToString:dic[@"post_id"]]) {
                [muteAry removeObjectAtIndex:i];
                self.tableDataAry = muteAry;
                [self.relevantDynamicTable reloadData];
                if (self.tableDataAry.count == 0) {
                    LYEmptyView *emptyView = [LYEmptyView emptyViewWithImageStr:@"图层 11" titleStr:@"还没有评论哦~" detailStr:@""];
                    self.relevantDynamicTable.tableFooterView = emptyView;
                    [self.relevantDynamicTable addSubview:emptyView];
                }
                break;
            }
        }
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
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"reSetTopFollowUI" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshNewQAMainViewController" object:nil userInfo:nil];
    }];
}

//取消关注圈子成功后提示
- (void)showUnStarSuccessful {
    [self.popView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    [NewQAHud showHudWith:@"  取消关注圈子成功  " AddView:self.view AndToDo:^{
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"reSetTopFollowUI" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshNewQAMainViewController" object:nil userInfo:nil];
    }];
}

//操作失败的提示
- (void)funcViewFailure {
    [self.popView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    [NewQAHud showHudWith:@"  操作失败  " AddView:self.view];
}

///设置列表加载菊花
- (void)setUpRefresh {
    //上滑加载的设置
    _footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(dynamicTableLoadData)];
    self.relevantDynamicTable.mj_footer = _footer;
    
    //下拉刷新的设置
    [_footer setTitle:@"上滑加载更多" forState:MJRefreshStateIdle];
    [_footer setTitle:@"上滑加载更多" forState:MJRefreshStatePulling];
    [_footer setTitle:@"正在加载中" forState:MJRefreshStateRefreshing];
    [_footer setTitle:@"暂无更多数据" forState:MJRefreshStateNoMoreData];
}

#pragma mark- getter
- (UIView *)topView{
    if (!_topView) {
      _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_W, MAIN_SCREEN_H*0.0802 + 17 + [self.searchEndTopView searchBeginViewHeight])];
        _topView.backgroundColor = self.view.backgroundColor;
        
       
        [_topView addSubview:self.searchEndTopView];
        [self.searchEndTopView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(_topView);
            make.height.mas_equalTo([self.searchEndTopView searchBeginViewHeight]);
        }];
        [_topView addSubview:self.relevantDynamicLbl];
        [self.relevantDynamicLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.searchEndTopView.mas_bottom).offset(MAIN_SCREEN_H * 0.0375);
            make.left.equalTo(_topView).offset(MAIN_SCREEN_W * 0.0427);
        }];
    }
    return _topView;
}
//上半部分视图
- (SearchBeiginView *)searchEndTopView{
    if (!_searchEndTopView) {
        _searchEndTopView = [[SearchBeiginView alloc] initWithString:@"邮问知识库"];
        _searchEndTopView.searchTopView.delegate = self;
        _searchEndTopView.hotSearchView.delegate = self;
        _searchEndTopView.searchTopView.searchTextfield.delegate = self;
        [_searchEndTopView.searchTopView.searchTextfield setReturnKeyType:UIReturnKeySearch];
        
        //设置邮问知识库
        if (self.knowlegeAry.count != 0) {
            NSMutableArray *muteAry = [NSMutableArray array];
            NSMutableArray *muteDicAry = [NSMutableArray array];
            for (NSDictionary *dic in self.knowlegeAry) {
                CYSearchEndKnowledgeDetailModel *knowledgeDetaileModel  = [CYSearchEndKnowledgeDetailModel initWithDict:dic];
                [muteAry addObject:knowledgeDetaileModel.titleStr];
                [muteDicAry addObject:knowledgeDetaileModel];
            }
            self.knowledgeDetaileModelsAry = muteDicAry;
            _searchEndTopView.hotSearchView.buttonTextAry = muteAry;
            [_searchEndTopView.hotSearchView updateBtns];
            [_searchEndTopView updateHotSearchViewFrame];
             
        }
        _searchEndTopView.frame = CGRectMake(0, 0, MAIN_SCREEN_W, [_searchEndTopView searchBeginViewHeight]);
    }
    return _searchEndTopView;
}
///相关动态的label
- (UILabel *)relevantDynamicLbl{
    if (!_relevantDynamicLbl) {
        _relevantDynamicLbl = [[UILabel alloc] init];
        _relevantDynamicLbl.text = @"相关动态";
        _relevantDynamicLbl.font = [UIFont fontWithName:PingFangSCMedium size:18];
            //设置字体和背景颜色
        if (@available(iOS 11.0, *)) {
            _relevantDynamicLbl.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
            _relevantDynamicLbl.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#F1F3F8" alpha:1] darkColor:[UIColor colorWithHexString:@"#000000" alpha:1]];
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
        _relevantDynamicTable.frame = self.view.frame;
        _relevantDynamicTable.delegate = self;
        _relevantDynamicTable.dataSource = self;
        
        self.page = 1;
        //设置列表加载菊花
//        [self setUpRefresh];
    }
    return _relevantDynamicTable;
}

- (FuncView *)popView{
    if (!_popView) {
        _popView = [[FuncView alloc] init];
        _popView.delegate = self;
        _popView.layer.cornerRadius = 3;
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

- (ReportView *)reportView{
    if (!_reportView) {
        //最开始默认输入为0，后面再进行赋值
        _reportView = [[ReportView alloc] initWithPostID:@0];
        _reportView.delegate = self;
    }
    return _reportView;
}
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


@end
