//
//  NewQAMainPageMainController.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/7/14.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "NewQAMainPageMainController.h"
#import "NewQAMainPageMainView.h"
#import "NewQAMainPageTableViewController.h"
#import "MGDStatusBarHeight.h"
#import "ClassTabBar.h"
#import "SearchBtn.h"
#import "TopFollowView.h"
#import "PostArchiveTool.h"
#import "RecommentLabel.h"
#import "SearchBeginVC.h"
#import "YYZTopicGroupVC.h"
#import "SZHReleaseDynamic.h"
#import "MGDTimer.h"

@interface NewQAMainPageMainController ()<NewQAMainPageViewScrollViewDelegate,TopFollowViewDelegate>

@property (nonatomic, strong) TopFollowView *headerFlowView;   // 顶部我的关注View
@property (nonatomic, strong) NewQAMainPageTableViewController *tableVC;    // 帖子列表
@property (nonatomic, strong) NewQAMainPageMainView *mainView;  // 推荐View
@property (nonatomic, assign) CGFloat headerViewH;  // 顶部我的关注View的高度
@property (nonatomic, assign) CGFloat topHeight;    // 安全区域高度
@property (nonatomic, assign) CGFloat recommendHeight; // 推荐Label的高度
@property (nonatomic, strong) UIView *topBackView;  // 搜索的背景View
@property (nonatomic, strong) SearchBtn *searchBtn;     // 搜索按钮
@property (nonatomic, assign) CGFloat topBackViewH; // 搜索背景View的高度
@property (nonatomic, strong) MBProgressHUD *loadHUD;   // 加载视图菊花
@property (nonatomic, strong) RecommentLabel *recommendedLabel; // 推荐label
@property (nonatomic, strong) UIButton *publishBtn;     // 发布按钮
@property (nonatomic, strong) MGDTimer *timer;         // 定时器

@property (nonatomic, strong) NSMutableArray *testArr;
@property (nonatomic, assign) NSInteger i;
@end

@implementation NewQAMainPageMainController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HideBottomClassScheduleTabBarView" object:nil userInfo:nil];
    if (self.isNeedFresh == YES || [UserItemTool defaultItem].firstLogin == YES) {
        [self removeTopFollowView];
        [self.tableVC.heightArray removeAllObjects];
        [self loadMyStarGroupList];
        [self.tableVC.tableView.mj_header beginRefreshing];
        [self.tableVC.tableArray removeAllObjects];
        [self.tableVC refreshData];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    ((ClassTabBar *)self.tabBarController.tabBar).hidden = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowBottomClassScheduleTabBarView" object:nil userInfo:nil];
    self.isNeedFresh = NO;
    [[UserItemTool defaultItem] setFirstLogin:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.view.backgroundColor = [UIColor colorNamed:@"QAMainPageBackGroudColor"];
    } else {
        self.view.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:243.0/255.0 blue:248.0/255.0 alpha:1];
    }
    // 设置通知中心
    [self setNSNotification];
    // 控件初始化的高度
    _topBackViewH = SCREEN_WIDTH * 0.04 * 11/15 + TOTAL_TOP_HEIGHT;
    _topHeight = [MGDStatusBarHeight getStatusBarHight];
    _headerViewH = SCREEN_WIDTH * 84/375;
    _recommendHeight = SCREEN_WIDTH * 43/375;
    // 设置UI界面
    [self setUI];
    // 模型的初始化
    self.groupModel = [[GroupModel alloc] init];
    self.hotWordModel = [[HotSearchModel alloc] init];
    // 数据源数组的初始化
    self.dataArray = [NSMutableArray array];
    self.hotWordsArray = [NSMutableArray array];
    self.hotWordIndex = 0;
    // 判断是否是登录状态，如果是第一次登录，则重新请求新的数据，如果不是则加载缓存数据
    if ([UserItemTool defaultItem].firstLogin == NO) {
        self.hotWordsArray = [PostArchiveTool getHotWords].hotWordsArray;
        self.dataArray = [PostArchiveTool getMyFollowGroup];
        [self settingFollowViewUI];
        // 每次加载缓存时，热搜词汇再次请求一下并缓存下来
        [self loadHotWords];
    } else {
        [self loadHotWords];
        [self loadMyStarGroupList];
        [[UserItemTool defaultItem] setFirstLogin:NO];
    }
    // 每隔三秒钟调用一次变换热搜词汇的方法
    self.timer = [[MGDTimer alloc] initInMainQueue];
    [self.timer event:^{
        [self refreshHotWords];
    } timeInterval:NSEC_PER_SEC * 3 delay:NSEC_PER_SEC * 1.2];
    
    // 启动计时器
    [self.timer start];

}

#pragma mark 设置控件的UI
- (void)setUI {
    [self mainView];
    self.headerFlowView = [[TopFollowView alloc]initWithFrame:CGRectMake(0, _topBackViewH, SCREEN_WIDTH, _headerViewH)];
    self.headerFlowView.delegate = self;
    self.loadHUD = [MBProgressHUD showHUDAddedTo:self.headerFlowView animated:YES];
    
    [self.view addSubview:self.headerFlowView];
    [self.view addSubview:self.mainView];
    
    [self recommendedLabel];
    [self.mainView addSubview:_recommendedLabel];
    [_recommendedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_mainView.mas_top);
        make.left.right.mas_equalTo(_mainView);
        make.height.mas_equalTo(_recommendHeight);
    }];

    [self topBackView];
    [self searchBtn];
    [self.view addSubview:_topBackView];
    [_topBackView addSubview:_searchBtn];
    
    [_topBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(_topBackViewH);
    }];
    
    [_searchBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_top).mas_offset(TOTAL_TOP_HEIGHT);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(SCREEN_WIDTH * 0.0427);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-SCREEN_WIDTH * 0.0427);
        make.height.mas_equalTo(SCREEN_WIDTH * 0.9147 * 37.5/343);
    }];
    _searchBtn.layer.cornerRadius = SCREEN_WIDTH * 0.9147 * 37.5/343 * 1/2;
    [self.view bringSubviewToFront:_topBackView];
    
    [self publishBtn];
    [self.view addSubview:_publishBtn];
    [_publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.top).mas_offset(SCREEN_HEIGHT * 0.7256);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-SCREEN_WIDTH * 0.0427);
        make.width.height.mas_equalTo(SCREEN_WIDTH * 0.17);
    }];
    _publishBtn.layer.cornerRadius = SCREEN_WIDTH * 0.17 * 1/2;
    _publishBtn.layer.masksToBounds = YES;
}

#pragma mark -我的关注请求成功后加载topFollowView
- (void)settingFollowViewUI {
    if ([self.dataArray count] != 0) {
        self.headerViewH = SCREEN_WIDTH * 147/375;
        _recommendHeight = SCREEN_WIDTH * 54/375;
        _recommendedLabel.lineView.hidden = NO;
    }
    [self.headerFlowView loadViewWithArray:self.dataArray];
    [self.loadHUD removeFromSuperview];
    [self reloadTopFollowViewWithArray:self.dataArray];
}

#pragma mark -根据我的关注数组个数刷新各个控件的高度
- (void)refreshHeight {
    self.headerFlowView.frame = CGRectMake(0, _topBackViewH, SCREEN_WIDTH, _headerViewH);
    self.mainView.frame = CGRectMake(0, CGRectGetMaxY(self.headerFlowView.frame), SCREEN_WIDTH, SCREEN_HEIGHT);
    [_recommendedLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_mainView.mas_top);
        make.left.right.mas_equalTo(_mainView);
        make.height.mas_equalTo(_recommendHeight);
    }];
    self.tableVC.view.frame = CGRectMake(0, _recommendHeight, SCREEN_WIDTH, SCREEN_HEIGHT - _recommendHeight);
}

#pragma mark -设置通知中心相关
- (void)setNSNotification {
    ///我的关注数据请求成功
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(topFollowViewLoadSuccess)
                                                 name:@"MyFollowGroupDataLoadSuccess" object:nil];
    
    ///热搜词汇请求成功
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(howWordsLoadSuccess)
                                                 name:@"HotWordsDataLoadSuccess" object:nil];
    ///热搜词汇请求失败
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(howWordsLoadError)
                                                 name:@"HotWordsDataLoadError" object:nil];
    ///刷新页面控件的高度
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(RefreshNewQAMainViewController)
                                                 name:@"RefreshNewQAMainViewController" object:nil];
}

#pragma mark - 监控滑动悬停的block
- (void)NewQAMainPageViewDidScroll:(CGFloat)scrollY{
    CGFloat headerViewY;
    if (scrollY > 0) {
       headerViewY = -scrollY + _topBackViewH;
        if (scrollY > _headerViewH) {
            headerViewY = -_headerViewH + _topBackViewH;
        }
    }else{
        headerViewY = _topBackViewH;
    }
    self.headerFlowView.frame = CGRectMake(0, headerViewY, SCREEN_WIDTH, _headerViewH);
    self.mainView.frame = CGRectMake(0, CGRectGetMaxY(self.headerFlowView.frame), SCREEN_WIDTH, SCREEN_HEIGHT);
}

#pragma mark 推荐Label的懒加载以及和帖子列表的联动
- (NewQAMainPageMainView *)mainView {
    if (!_mainView) {
        _mainView = [[NewQAMainPageMainView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(self.headerFlowView.frame), SCREEN_WIDTH, SCREEN_HEIGHT)];
        if (@available(iOS 11.0, *)) {
            _mainView.backgroundColor = [UIColor colorNamed:@"QAMainPageBackGroudColor"];
        } else {
            _mainView.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:243.0/255.0 blue:248.0/255.0 alpha:1];
        }
        _mainView.titleHeight = _recommendHeight;
        [_mainView setupViewControllerWithFatherVC:self AndChildVC:self.tableVC];
    }
    return _mainView;
}

#pragma mark 帖子列表Controller的懒加载
- (NewQAMainPageTableViewController *)tableVC{
    if (!_tableVC) {
        _tableVC = [[NewQAMainPageTableViewController alloc]init];
        __weak typeof(self) weakSelf = self;
        _tableVC.NewQAMainPageScrollBlock = ^(CGFloat scrollY) {
            [weakSelf NewQAMainPageViewDidScroll:scrollY];
        };
    }
    return _tableVC;
}

#pragma mark 顶部搜索背景View
///顶部搜索背景View懒加载
- (UIView *)topBackView {
    if (!_topBackView) {
        _topBackView = [[UIView alloc] init];
        if (@available(iOS 11.0, *)) {
            _topBackView.backgroundColor = [UIColor colorNamed:@"QAMainPageBackGroudColor"];
        } else {
            _topBackView.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:243.0/255.0 blue:248.0/255.0 alpha:1];
        }
    }
    return _topBackView;
}

///搜索按钮加载
- (SearchBtn *)searchBtn {
    if (!_searchBtn) {
        _searchBtn = [[SearchBtn alloc] init];
        [_searchBtn addTarget:self action:@selector(searchPost) forControlEvents:UIControlEventTouchUpInside];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHotWords) name:@"refreshHotWords" object:nil];
    }
    return _searchBtn;
}

///发布按钮加载
- (UIButton *)publishBtn {
    if (!_publishBtn) {
        _publishBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _publishBtn.backgroundColor = [UIColor clearColor];
        [_publishBtn setBackgroundImage:[UIImage imageNamed:@"发布动态"] forState:UIControlStateNormal];
        [_publishBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [_publishBtn addTarget:self action:@selector(clickedPublishBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _publishBtn;
}

// 推荐Label
- (RecommentLabel *)recommendedLabel {
    if (!_recommendedLabel) {
        _recommendedLabel = [[RecommentLabel alloc] init];
        _recommendedLabel.lineView.hidden = YES;
    }
    return _recommendedLabel;
}

#pragma mark -我的关注相关请求
///我的关注的网络请求
- (void)loadMyStarGroupList {
    [self.groupModel loadMyFollowGroup];
}

///我的关注网络请求成功后数据源数组赋值
- (void)topFollowViewLoadSuccess {
    self.dataArray = self.groupModel.dataArray;
    [self settingFollowViewUI];
    [PostArchiveTool saveMyFollowGroupWith:self.dataArray];
}

# pragma mark -我的关注页面重新加载控件和数据
- (void)reloadTopFollowViewWithArray:(NSMutableArray *)array {
    if ([array count] == 0) {
        _headerViewH = SCREEN_WIDTH * 84/375;
        _recommendHeight = SCREEN_WIDTH * 43/375;
        _recommendedLabel.lineView.hidden = YES;
        [self.headerFlowView loadTopFollowViewWithoutGroup:array];
    } else {
        _recommendedLabel.lineView.hidden = NO;
        _headerViewH = SCREEN_WIDTH * 147/375;
        _recommendHeight = SCREEN_WIDTH * 54/375;
        [self.headerFlowView loadTopFollowViewWithGroup:array];
    }
    [self refreshHeight];
}

# pragma mark -我的关注页面移除所有控件
- (void)removeTopFollowView {
    [self.headerFlowView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // 移除所有控件后，将初始化的UI高度恢复
    _topBackViewH = SCREEN_WIDTH * 0.04 * 11/15 + TOTAL_TOP_HEIGHT;
    _topHeight = [MGDStatusBarHeight getStatusBarHight];
    _headerViewH = SCREEN_WIDTH * 84/375;
    _recommendHeight = SCREEN_WIDTH * 43/375;
    _recommendedLabel.lineView.hidden = YES;
}

#pragma mark -热搜词汇相关请求
///热搜词汇的网络请求
- (void)loadHotWords {
    [self.hotWordModel getHotSearchArray];
}

///热搜词汇请求完成后数组赋值
- (void)howWordsLoadSuccess {
    self.hotWordsArray = self.hotWordModel.hotWordsArray;
    [PostArchiveTool saveHotWordsWith:self.hotWordModel];
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
        self->_searchBtn.searchBtnLabel.text = [NSString stringWithFormat:@"%@:%@",@"大家都在搜", self.hotWordsArray[self->_hotWordIndex]];

      } completion:nil];
}

- (void)howWordsLoadError {
    [NewQAHud showHudWith:@"  热搜词汇请求失败～  " AddView:self.view];
}

///点击了发布按钮，跳转到发布页面
- (void)clickedPublishBtn {
    SZHReleaseDynamic *vc = [[SZHReleaseDynamic alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    ((ClassTabBar *)self.tabBarController.tabBar).hidden = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

///点击了搜索按钮，跳转到搜索页面
- (void)searchPost {
    SearchBeginVC *vc = [[SearchBeginVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    ((ClassTabBar *)self.tabBarController.tabBar).hidden = NO;
    [self.navigationController pushViewController:vc animated:YES];
    NSLog(@"跳转到搜索页面");
}
#pragma mark- 我的关注页面的代理方法
///关注更多--跳转到圈子广场
- (void)FollowGroups {
    YYZTopicGroupVC *topVc = [[YYZTopicGroupVC alloc]init];
    topVc.hidesBottomBarWhenPushed = YES;
    ((ClassTabBar *)self.tabBarController.tabBar).hidden = NO;
    [self.navigationController pushViewController:topVc animated:YES];
}
///点击我的关注中的已关注的圈子跳转到具体的圈子里去
- (void)ClickedGroupBtn:(GroupBtn *)sender {
    NSString *groupName = sender.groupBtnLabel.text;
    if (sender.tag == 0) {
        YYZTopicGroupVC *topVc = [[YYZTopicGroupVC alloc]init];
        topVc.hidesBottomBarWhenPushed = YES;
        ((ClassTabBar *)self.tabBarController.tabBar).hidden = NO;
        [self.navigationController pushViewController:topVc animated:YES];
    }else {
        YYZTopicDetailVC *detailVC = [[YYZTopicDetailVC alloc]init];
        detailVC.topicID = [sender.item.topic_id intValue];
        detailVC.topicIdString = groupName;
        detailVC.hidesBottomBarWhenPushed = YES;
        ((ClassTabBar *)self.tabBarController.tabBar).hidden = NO;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

#pragma mark -通知刷新邮问主页
- (void) RefreshNewQAMainViewController {
    [self removeTopFollowView];
    [self loadMyStarGroupList];
    [self.tableVC.tableView removeFromSuperview];
    [self.tableVC.tableArray removeAllObjects];
    [self.tableVC.tableView.mj_header beginRefreshing];
    [self.tableVC refreshData];
}

- (void)dealloc {
    [self.timer destroy];
}


@end
