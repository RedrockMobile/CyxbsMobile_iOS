//
//  NewQAMainPageViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/12/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "NewQAMainPageViewController.h"
#import "FuncView.h"
#import "PostModel.h"
#import "ReportModel.h"
#import "NewQAHud.h"
#import "GroupModel.h"
#import "FuncView.h"
#import "PostItem.h"
#import "PostModel.h"
#import "PostTableViewCell.h"
#import "MGDRefreshTool.h"
#import "StarPostModel.h"
#import "HotSearchModel.h"
#import "PostArchiveTool.h"
#import "FollowGroupModel.h"
#import "ShieldModel.h"
#import "SearchBeginVC.h"   //搜索初始界面
@interface NewQAMainPageViewController ()<ReportViewDelegate,FuncViewProtocol,ShareViewDelegate,UITableViewDelegate,UITableViewDataSource,PostTableViewCellDelegate,TopFollowViewDelegate>
//帖子列表数据源数组
@property (nonatomic, strong) NSMutableArray *tableArray;
//headerView的控件高度
@property (nonatomic, assign) CGFloat TopViewHeight;
@property (nonatomic, assign) CGFloat NavHeight;
@property (nonatomic, assign) CGFloat recommendHeight;
@property (nonatomic, assign) CGFloat lineHeight;
//headerView控件
@property (nonatomic, strong) UIView *topBackView;
@property (nonatomic, strong) UIView *lineView;
//列表顶部底部刷新控件
@property (nonatomic, strong) MJRefreshBackNormalFooter *footer;
@property (nonatomic, strong) MJRefreshNormalHeader *header;
//热搜词汇模型
@property (nonatomic, strong) HotSearchModel *hotWordModel;
@property (nonatomic, strong) NSMutableArray *hotWordsArray;
@property (nonatomic, assign) int hotWordIndex;

@property (nonatomic, strong) NSNumber *pageNumber;
//帖子模型
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) PostModel *postmodel;
@property (nonatomic, strong) NSMutableArray<PostItem *> *postArray;
//我的关注模型
@property (nonatomic, strong) GroupModel *groupModel;
@property (nonatomic, strong) NSMutableArray<GroupItem *> *dataArray;
//加载视图菊花
@property (nonatomic, strong) MBProgressHUD *loadHUD;

@end

@implementation NewQAMainPageViewController
//加载邮问时隐藏底部课表
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HideBottomClassScheduleTabBarView" object:nil userInfo:nil];
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}
//邮问视图消失时显示底部课表
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowBottomClassScheduleTabBarView" object:nil userInfo:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.view.backgroundColor = [UIColor colorNamed:@"QAMainPageBackGroudColor"];
    } else {
        
    }
    //设置通知中心
    [self setNotification];
    //设置背景蒙版
    [self setBackViewWithGesture];
    //热搜词汇的索引
    self.hotWordIndex = 0;
    /**
        逻辑：首先取得缓存数据，如果有数据，则加载缓存的数据，同时根据帖子的条数来判断当前的page，下拉加载，上拉刷新
        如果缓存没有数据，则进行网络请求
     */
    /*
     tableArray:帖子列表数据源数组
     dataArray:我的关注数据源数组
     hotWordsArray:热搜词汇数据源数组
     */
    self.tableArray = [NSMutableArray arrayWithArray:[PostArchiveTool getPostList]];
    self.dataArray = [NSMutableArray arrayWithArray:[PostArchiveTool getMyFollowGroup].dataArray];
    self.hotWordsArray = [NSMutableArray arrayWithArray:[PostArchiveTool getHotWords].hotWordsArray];
    
    self.hotWordModel = [[HotSearchModel alloc] init];
    self.groupModel = [[GroupModel alloc] init];
    self.postmodel = [[PostModel alloc] init];
    if (self.tableArray != nil && [self.tableArray count] != 0 && self.dataArray != nil && self.hotWordsArray != nil) {
        NSLog(@"帖子列表的数据通过缓存");
        self.page = floor(self.tableArray.count / 6.0);
        [self setMainViewUI];
        [self loadHotWords];
        [self loadMyStarGroupList];
        self->_searchBtn.searchBtnLabel.text = self.hotWordsArray[self->_hotWordIndex];
        NSLog(@"初始的page:%lu",self.page);
    }else {
        NSLog(@"帖子列表的数据通过网络请求");
        self.page = 0;
        self.loadHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.loadHUD.labelText = @"正在加载中...";
        dispatch_group_t group = dispatch_group_create();
            dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
            dispatch_group_enter(group);
            dispatch_group_async(group, queue, ^{
                NSLog(@"热搜词汇网络请求");
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self loadHotWords];
                    dispatch_group_leave(group);
                });
            });

            dispatch_group_enter(group);
            dispatch_group_async(group, queue, ^{

                NSLog(@"我的关注网络请求");
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self loadMyStarGroupList];
                    dispatch_group_leave(group);
                });
            });

            dispatch_group_enter(group);
            dispatch_group_async(group, queue, ^{

                NSLog(@"帖子列表网络请求");
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self loadData];
                    dispatch_group_leave(group);
                });
            });

            dispatch_group_notify(group, queue, ^{
                self->_searchBtn.searchBtnLabel.text = self.hotWordsArray[self->_hotWordIndex];
                NSLog(@"所有网络请求完成执行");
            });
    }
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.modalPresentationStyle = 0;
    
    ///每隔三秒钟调用一次变换热搜词汇的方法
    [NSTimer scheduledTimerWithTimeInterval:3.0
        target:self
        selector:@selector(refreshHotWords)
        userInfo:nil
        repeats:YES];
    
}
//设置通知中心的监听
- (void)setNotification{
    ///帖子列表请求成功
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NewQAListLoadSuccess)
                                                 name:@"NewQAListPageDataLoadSuccess" object:nil];
    ///帖子列表请求失败
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NewQAListLoadError)
                                                 name:@"NewQAListDataLoadFailure" object:nil];
    ///热搜词汇请求成功
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(howWordsLoadSuccess)
                                                 name:@"HotWordsDataLoadSuccess" object:nil];
    ///热搜词汇请求失败
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(howWordsLoadError)
                                                 name:@"HotWordsDataLoadError" object:nil];
    ///我的关注请求成功
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(topFollowViewLoadSuccess)
                                                 name:@"MyFollowGroupDataLoadSuccess" object:nil];
    ///我的关注请求失败
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(topFollowViewLoadError)
                                                 name:@"MyFollowGroupDataLoadError" object:nil];
}

#pragma mark -热搜词汇相关
///热搜词汇的网络请求
- (void)loadHotWords {
    [self.hotWordModel getHotSearchArray];
}

///热搜词汇请求完成后数组赋值
- (void)howWordsLoadSuccess {
    self.hotWordsArray = self.hotWordModel.hotWordsArray;
    [PostArchiveTool saveHotWordsWith:self.hotWordModel];
    NSLog(@"热词请求成功");
}

///3s刷新热搜词汇
-(void)refreshHotWords {
    if ([self.hotWordsArray count] == 0) {
        return;
    }
    if (_hotWordIndex < [self.hotWordsArray count] - 1) {
        _hotWordIndex++;
    }else {
        _hotWordIndex = 0;
    }
    [UIView transitionWithView:_searchBtn.searchBtnLabel
                      duration:0.25f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
        self->_searchBtn.searchBtnLabel.text = self.hotWordsArray[self->_hotWordIndex];

      } completion:nil];
}

- (void)howWordsLoadError {
    [NewQAHud showHudWith:@"热搜词汇请求失败～" AddView:self.view];
}

#pragma mark -我的关注相关
///我的关注的网络请求
- (void)loadMyStarGroupList {
    [self.groupModel loadMyFollowGroup];
    
}

///我的关注网络请求成功后数据源数组赋值
- (void)topFollowViewLoadSuccess {
    self.dataArray = self.groupModel.dataArray;
    [PostArchiveTool saveMyFollowGroupWith:self.groupModel];
    NSLog(@"我的关注请求成功");
}

///我的关注请求失败
- (void)topFollowViewLoadError {
    [NewQAHud showHudWith:@"我的关注请求失败～" AddView:self.view];
}

#pragma mark- 帖子列表的网络请求

///下拉加载
- (void)loadData{
    NSLog(@"此时的page:%ld",(long)self.page);
    self.page += 1;
    [self.postmodel loadMainPostWithPage:self.page AndSize:6];
}

///上拉刷新
- (void)reloadData{
    [self.tableArray removeAllObjects];
    self.page = 1;
    NSLog(@"此时的page:%ld",(long)self.page);
    [self.postmodel loadMainPostWithPage:self.page AndSize:6];
}

///成功请求数据
- (void)NewQAListLoadSuccess {
    if (self.page == 1) {
        self.tableArray = self.postmodel.postArray;
        NSLog(@"%@",self.tableArray);
    }else {
        [self.tableArray addObjectsFromArray:self.postmodel.postArray];
    }
    
    [PostArchiveTool savePostListWith:self.tableArray];
    if(!self.tableView){
        [self setMainViewUI];
    }
    //根据当前加载的问题页数判断是上拉刷新还是下拉刷新
    if (self.page == 1) {
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }else{
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    }
}

///请求失败
- (void)NewQAListLoadError {
    [_loadHUD removeFromSuperview];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [NewQAHud showHudWith:@"网络异常" AddView:self.view];
}

///设置UI界面
- (void)setMainViewUI {
    //我的关注View高度
    _TopViewHeight = self.dataArray.count != 0 ? SCREEN_WIDTH * 202/375 : (SCREEN_WIDTH * 127/375);
    //推荐Label高度
    _recommendHeight = self.dataArray.count != 0 ? SCREEN_WIDTH * 54/375 : SCREEN_WIDTH * 43/375;
    _lineHeight = self.dataArray.count != 0 ? 2 : 0;
    _NavHeight = _topBackView.frame.size.height;

    _tableView = [[RecommendedTableView alloc] initWithFrame:CGRectMake(0, NVGBARHEIGHT + STATUSBARHEIGHT + SCREEN_WIDTH * 14/375, SCREEN_WIDTH, SCREEN_HEIGHT - (SCREEN_HEIGHT * 0.0165 + NVGBARHEIGHT + STATUSBARHEIGHT + TABBARHEIGHT))];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.contentInset = UIEdgeInsetsMake(_TopViewHeight, 0, 0, 0);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //增加Observer，监听列表滑动
    [_tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [self.view addSubview:self.tableView];
    [self setUpRefresh];

    self.topFollowView = [[TopFollowView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , _TopViewHeight) And:self.dataArray];
    if (@available(iOS 11.0, *)) {
        self.topFollowView.backgroundColor = [UIColor colorNamed:@"QAMainPageBackGroudColor"];
    } else {
        // Fallback on earlier versions
    }
    [self.view addSubview:self.topFollowView];
    if ([self.dataArray count] == 0) {
        [self.view bringSubviewToFront:self.topFollowView.followBtn];
    }

    UIView *lineView = [[UIView alloc] init];
    if (@available(iOS 11.0, *)) {
        lineView.backgroundColor = [UIColor colorNamed:@"ShareLineViewColor"];
    } else {
        // Fallback on earlier versions
    }
    [self.view addSubview:lineView];
    _lineView = lineView;

    _recommendedLabel = [[UILabel alloc] init];
    if (@available(iOS 11.0, *)) {
        _recommendedLabel.backgroundColor = [UIColor colorNamed:@"QAMainPageBackGroudColor"];
    } else {
        // Fallback on earlier versions
    }
    _recommendedLabel.text = @"  推荐";
    _recommendedLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 18];
    if (@available(iOS 11.0, *)) {
        _recommendedLabel.textColor = [UIColor colorNamed:@"MainPageLabelColor"];
    } else {
        // Fallback on earlier versions
    }
    _recommendedLabel.textAlignment = NSTextAlignmentLeft;
    [self.topFollowView addSubview:_recommendedLabel];
    
    _topBackView = [[UIView alloc] init];
    if (@available(iOS 11.0, *)) {
        _topBackView.backgroundColor = [UIColor colorNamed:@"QAMainPageBackGroudColor"];
    } else {
        // Fallback on earlier versions
    }
    [self.view addSubview:_topBackView];

    SearchBtn *searchBtn = [[SearchBtn alloc] init];
    [searchBtn addTarget:self action:@selector(searchPost) forControlEvents:UIControlEventTouchUpInside];
    [_topBackView addSubview:searchBtn];
    _searchBtn = searchBtn;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHotWords) name:@"refreshHotWords" object:nil];
    
    UIButton *publishBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    publishBtn.backgroundColor = [UIColor clearColor];
    [publishBtn setBackgroundImage:[UIImage imageNamed:@"发布动态"] forState:UIControlStateNormal];
    [publishBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [publishBtn addTarget:self action:@selector(clickedPublishBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:publishBtn];
    _publishBtn = publishBtn;
    
    [self layoutSubviews];
}


- (void)layoutSubviews {
    [_topBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(_searchBtn.mas_bottom).mas_offset(SCREEN_WIDTH * 11/375);
    }];
    
    [_searchBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_top).mas_offset(NVGBARHEIGHT + STATUSBARHEIGHT);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(SCREEN_WIDTH * 0.0427);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-SCREEN_WIDTH * 0.0427);
        make.height.mas_equalTo(SCREEN_HEIGHT * 0.0563);
    }];
    _searchBtn.layer.cornerRadius = SCREEN_HEIGHT * 0.0563 * 1/2;
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_recommendedLabel.mas_top).mas_offset(-1);
        make.right.mas_equalTo(self.view.mas_right);
        make.left.mas_equalTo(self.view.mas_left);
        make.height.mas_equalTo(_lineHeight);
    }];
    
    [_recommendedLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_topFollowView.mas_bottom);
        make.right.mas_equalTo(self.view.mas_right);
        make.left.mas_equalTo(self.view.mas_left);
        make.height.mas_equalTo(_recommendHeight);
    }];
    
    
    [_publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.top).mas_offset(SCREEN_HEIGHT * 0.7256);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-SCREEN_WIDTH * 0.0427);
        make.width.height.mas_equalTo(SCREEN_WIDTH * 0.14);
    }];
    _publishBtn.layer.cornerRadius = SCREEN_WIDTH * 0.14 * 1/2;
    _publishBtn.layer.masksToBounds = YES;
}

///设置列表加载菊花
- (void)setUpRefresh {
    //上滑加载的设置
    _footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.tableView.mj_footer = _footer;
    
    //下拉刷新的设置
    _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadData)];
    self.tableView.mj_header = _header;
    
    [MGDRefreshTool setUPHeader:_header AndFooter:_footer];
}

///监控滑动
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint offset = [change[NSKeyValueChangeNewKey] CGPointValue];
        if (-offset.y >= _TopViewHeight) {
            self.topFollowView.frame = CGRectMake(0, STATUSBARHEIGHT + NVGBARHEIGHT  +  SCREEN_HEIGHT * 0.0165, SCREEN_WIDTH, _TopViewHeight);
        }
        else if (-offset.y > _NavHeight +  _recommendedLabel.frame.size.height && -offset.y < _TopViewHeight) {
            self.topFollowView.frame = CGRectMake(0, -offset.y-_TopViewHeight + STATUSBARHEIGHT + NVGBARHEIGHT + SCREEN_HEIGHT * 0.0165, SCREEN_WIDTH, _TopViewHeight);
        }
        else if (-offset.y <= _NavHeight +  _recommendedLabel.frame.size.height) {
            self.topFollowView.frame = CGRectMake(0, _NavHeight -_TopViewHeight + STATUSBARHEIGHT + NVGBARHEIGHT + _recommendedLabel.frame.size.height + SCREEN_HEIGHT * 0.0165, SCREEN_WIDTH, _TopViewHeight);
        }
    }
}

- (void)dealloc {
    [_tableView removeObserver:self forKeyPath:@"contentOffset"];
}

#pragma mark -RecommendedTableView的数据源和代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

///点击跳转到具体的帖子（与下方commentBtn的事件相同）
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //创建单元格（用复用池）
    ///给每一个cell的identifier设置为唯一的
    NSString *identifier = [NSString stringWithFormat:@"post%ldcell",indexPath.row];
    PostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil) {
        PostItem *item = [[PostItem alloc] initWithDic:self.tableArray[indexPath.row]];
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

#pragma mark - Cell中的相关事件
///点赞的逻辑：根据点赞按钮的tag来获取post_id，并传入后端
- (void)ClickedStarBtn:(FunctionBtn *)sender {
    if (sender.selected == YES) {
        sender.selected = NO;
        sender.iconView.image = [UIImage imageNamed:@"未点赞"];
        NSString *count = sender.countLabel.text;
        sender.countLabel.text = [NSString stringWithFormat:@"%d",[count intValue] - 1];
        if (@available(iOS 11.0, *)) {
            sender.countLabel.textColor = [UIColor colorNamed:@"FuncBtnColor"];
        } else {
            // Fallback on earlier versions
        }
    }else {
        sender.selected = YES;
        sender.iconView.image = [UIImage imageNamed:@"点赞"];
        NSString *count = sender.countLabel.text;
        sender.countLabel.text = [NSString stringWithFormat:@"%d",[count intValue] + 1];
        if (@available(iOS 11.0, *)) {
            sender.countLabel.textColor = [UIColor colorNamed:@"countLabelColor"];
            
        } else {
            // Fallback on earlier versions
        }
        
    }
    StarPostModel *model = [[StarPostModel alloc] init];
    PostItem *item = [[PostItem alloc] initWithDic:self.tableArray[sender.tag]];
    [model starPostWithPostID:[NSNumber numberWithString:item.post_id]];
}

///跳转到具体的帖子详情:(可以通过帖子id跳转到具体的帖子页面，获取帖子id的方式如下方注释的代码)
- (void)ClickedCommentBtn:(FunctionBtn *)sender {
//    PostItem *item = self.postArray[sender.tag];
//    int post_id = [item.post_id intValue];
}

///分享帖子
- (void)ClickedShareBtn:(UIButton *)sender{
    [self showBackViewWithGesture];
    _shareView = [[ShareView alloc] init];
    _shareView.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:_shareView];
    [_shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([UIApplication sharedApplication].keyWindow.mas_top).mas_offset(SCREEN_HEIGHT * 0.6897);
        make.left.right.bottom.mas_equalTo([UIApplication sharedApplication].keyWindow);
    }];
    PostItem *item = [[PostItem alloc] initWithDic:self.tableArray[sender.tag]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ClickedShareBtn" object:nil userInfo:nil];
    //此处还需要修改
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString *shareURL = [NSString stringWithFormat:@"%@%@",@"cyxbs://redrock.team/answer_list/qa/entry?question_id=",item.post_id];
    pasteboard.string = shareURL;
}

/**
 举报和屏蔽的多能按钮
 此处的逻辑：接收到cell里传来的多功能按钮的frame，在此frame上放置多功能View，同时加上蒙版
 */
- (void)ClickedFuncBtn:(UIButton *)sender {
    UIWindow* desWindow=[UIApplication sharedApplication].keyWindow;
    CGRect frame = [sender convertRect:sender.bounds toView:desWindow];
    [self showBackViewWithGesture];
    _popView = [[FuncView alloc] init];
    _popView.delegate = self;
    _popView.layer.cornerRadius = 3;
    _popView.frame = CGRectMake(frame.origin.x - SCREEN_WIDTH * 0.27, frame.origin.y + 10, SCREEN_WIDTH * 0.3057, SCREEN_WIDTH * 0.3057 * 105/131.5 * 2/3);
    [[UIApplication sharedApplication].keyWindow addSubview:_popView];
}

#pragma mark- 配置相关弹出View和其蒙版的操作
///设置相关蒙版

- (void)setBackViewWithGesture {
    _backViewWithGesture = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _backViewWithGesture.backgroundColor = [UIColor blackColor];
    _backViewWithGesture.alpha = 0.36;
    UITapGestureRecognizer *dismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissBackViewWithGesture)];
    [self.backViewWithGesture addGestureRecognizer:dismiss];
}

- (void)showBackViewWithGesture {
    [[UIApplication sharedApplication].keyWindow addSubview:_backViewWithGesture];
}

- (void)dismissBackViewWithGestureAnd:(UIView *)view {
    [view removeFromSuperview];
    [_backViewWithGesture removeFromSuperview];
}

- (void)dismissBackViewWithGesture {
    [_popView removeFromSuperview];
    [_shareView removeFromSuperview];
    [_reportView removeFromSuperview];
    [_backViewWithGesture removeFromSuperview];
}

#pragma mark -多功能View的代理方法
///点击屏蔽按钮
- (void)ClickedShieldBtn:(UIButton *)sender {
//    ShieldModel *model = [[ShieldModel alloc] init];
//    PostItem *item = [[PostItem alloc] initWithDic:self.tableArray[sender.tag]];
    [self showShieldSuccessful];
//    [model ShieldPersonWithUid:item.uid];
//    [model setBlock:^(id  _Nonnull info) {
//        if ([info[@"info"] isEqualToString:@"success"]) {
//            [self showShieldSuccessful];
//        }
//    }];
}
///点击举报按钮
- (void)ClickedReportBtn:(UIButton *)sender  {
    [_popView removeFromSuperview];
    PostItem *item = [[PostItem alloc] initWithDic:self.tableArray[sender.tag]];
    _reportView = [[ReportView alloc] initWithPostID:[NSNumber numberWithString:item.post_id]];
    _reportView.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:_reportView];
    [_reportView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([UIApplication sharedApplication].keyWindow.mas_top).mas_offset(SCREEN_HEIGHT * 0.2309);
        make.left.mas_equalTo([UIApplication sharedApplication].keyWindow.mas_left).mas_offset(SCREEN_WIDTH * 0.1587);
        make.right.mas_equalTo([UIApplication sharedApplication].keyWindow.mas_right).mas_offset(-SCREEN_WIDTH * 0.1587);
        make.height.mas_equalTo([UIApplication sharedApplication].keyWindow.width * 0.6827 * 329/256);
    }];
}

#pragma mark -举报页面的代理方法
///举报页面点击确定按钮
- (void)ClickedSureBtn {
//    [self dismissReportBackView];
    [_reportView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    [self showReportSuccessful];
//    ReportModel *model = [[ReportModel alloc] init];
//    [model ReportWithPostID:_reportView.postID WithModel:[NSNumber numberWithInt:0] AndContent:_reportView.textView.text];
//    [model setBlock:^(id  _Nonnull info) {
//        [self showReportSuccessful];
//    }];
}

///举报页面点击取消按钮
- (void)ClickedCancelBtn {
    [_reportView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
}

#pragma mark- 配置相关操作成功后的弹窗
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

#pragma mark -分享View的代理方法
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

#pragma mark 跳转到别的页面的方法

#pragma mark- 我的关注页面的代理方法
///关注更多--跳转到圈子广场
- (void)FollowGroups {
    
}

///点击跳转到具体的圈子里去
- (void)ClickedGroupBtn:(UIButton *)sender {
    
}

#pragma mark -发布动态和搜索的跳转
///点击了发布按钮，跳转到发布动态的页面
- (void)clickedPublishBtn {
    NSLog(@"跳转到发布界面");
}

///点击了搜索按钮，跳转到搜索页面
- (void)searchPost {
    SearchBeginVC *vc = [[SearchBeginVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    NSLog(@"跳转到搜索页面");
}

@end


