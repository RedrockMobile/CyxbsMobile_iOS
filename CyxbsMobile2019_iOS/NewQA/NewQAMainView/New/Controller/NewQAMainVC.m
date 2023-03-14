//
//  NewQAMainVC.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/8/17.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "NewQAMainVC.h"
#import "ClassTabBar.h"
#import "SearchBtn.h"
#import "MGDRefreshTool.h"
#import "NewQAContentScrollView.h"
#import "NewQAHeadrView.h"
#import "NewQASelectorView.h"
#import "MGDGCD.h"
#import "PostTableViewCell.h"
#import "PostTableViewCellFrame.h"
#import "DynamicDetailMainVC.h"
#import "TopFollowView.h"
#import "GroupModel.h"
#import "YYZTopicGroupVC.h"
#import "PostFocusModel.h"
#import "SearchBeginVC.h"
#import "MGDTimer.h"
#import "PostArchiveTool.h"
#import "NewQANoDataView.h"
#import "SZHReleaseDynamic.h"
#import "QASearchResultVC.h"
@interface NewQAMainVC () <UIScrollViewDelegate, UITableViewDelegate,UITableViewDataSource,TopFollowViewDelegate,ReportViewDelegate,FuncViewProtocol,ShareViewDelegate,PostTableViewCellDelegate,SelfFuncViewProtocol,TopFollowViewDelegate>

@property (nonatomic, strong) UIView *topBackView;  // 搜索的背景View
@property (nonatomic, strong) SearchBtn *searchBtn;     // 搜索按钮
@property (nonatomic, assign) CGFloat topBackViewH; // 搜索背景View的高度
@property (nonatomic, strong) NewQAContentScrollView *scrollView; // 左右滑动的scrollView
@property (nonatomic, strong) UIView *tableViewHeadView;
@property (nonatomic, strong) NewQAHeadrView *headBackView;
@property (nonatomic, assign) CGFloat headViewHeight;
@property (nonatomic, strong) NewQASelectorView *titleBarView;  // 选择器View
@property (nonatomic, strong) TopFollowView *topView;
@property (nonatomic, strong) GroupModel *groupmodel;
@property (nonatomic, strong) PostFocusModel *postfocusmodel;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NewQANoDataView *recommenNoDataView;
@property (nonatomic, strong) NewQANoDataView *focusNoDataView;
@property (nonatomic, strong) UIButton *publishBtn;
@property (nonatomic, assign) NSInteger hotWordIndex;
@property (nonatomic, strong) MGDTimer *timer;         // 定时器

 
@end

@implementation NewQAMainVC
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#F1F3F8" alpha:1] darkColor:[UIColor colorWithHexString:@"#000000" alpha:1]];
//    self.view.clipsToBounds = YES;
//
//    // 顶部搜索区域初始化高度
//    self.topBackViewH = SCREEN_WIDTH * 0.04 * 11/15 + TOTAL_TOP_HEIGHT;
//    // 相关操作的初始化
//    self.recommenPage = 0;
//    self.focusPage = 0;
//    [self setNotification];
//    [self setUpModel];
//    [self funcPopViewinit];
//    // 各种数据源数组和高度数组的初始化
//    _focusArray = [NSMutableArray array];
//    _focusheightArray = [NSMutableArray array];
//    _dataArray = [NSMutableArray array];
//    self.hotWordsArray = [PostArchiveTool getHotWords].hotWordsArray;
//    self.dataArray = [PostArchiveTool getMyFollowGroup];
//    // 我的关注区域初始化
//    self.headViewHeight = [self.dataArray count] != 0 ? 190 * HScaleRate_SE : SLIDERHEIGHT;
//
//    // 加载页面操作
//    [self setUpTopSearchView];
//    [self setTableScrollView];
//    [self setupContentView];
//    [self setBackViewWithGesture];
//    [self setupPublishBtn];
//
//    [self.view bringSubviewToFront:_searchBtn];
//    [self settingFollowViewUI];
//    self.recommenArray = [NSMutableArray arrayWithArray:[PostArchiveTool getPostList]];
//    self.recommenheightArray = [NSMutableArray arrayWithArray:[PostArchiveTool getPostCellHeight]];
//
////     判断是否是登录状态，如果是第一次登录，则重新请求新的数据，如果不是则加载缓存数据
//    if ([UserItemTool defaultItem].firstLogin == NO && [self.recommenArray count] != 0 && [self.recommenheightArray count] != 0 && [self.recommenheightArray[0] isKindOfClass:[PostTableViewCellFrame class]]) {
//        NSLog(@"这是缓存的\n\n\n\n\n");
//        [self.recommenTableView reloadData];
//        // 每次加载缓存时，热搜词汇再次请求一下并缓存下来
//        [self loadHotWords];
//    } else {
//        NSLog(@"这是加载的\n\n\n\n");
//        [self loadHotWords];
//        [self loadMyStarGroupList];
//        [self recommendTableLoadData];
//        [[UserItemTool defaultItem] setFirstLogin:NO];
//    }
//    [self focusTableLoadData];
//
//    self.timer = [[MGDTimer alloc] initInMainQueue];
//    [self.timer event:^{
//        [self refreshHotWords];
//    } timeInterval:NSEC_PER_SEC * 3 delay:NSEC_PER_SEC * 1.2];
//
//    // 启动计时器
//    [self.timer start];
//}
//
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.hidden = YES;
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"HideBottomClassScheduleTabBarView" object:nil userInfo:nil];
//    if (self.isNeedFresh == YES || [UserItemTool defaultItem].firstLogin == YES) {
//        [self.topView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//        [self loadMyStarGroupList];
//    }
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    ((ClassTabBar *)self.tabBarController.tabBar).hidden = NO;
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowBottomClassScheduleTabBarView" object:nil userInfo:nil];
//    self.isNeedFresh = NO;
//}
//
//- (void)setNotification {
//    ///我的关注数据请求成功
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(topFollowViewLoadSuccess)
//                                                 name:@"MyFollowGroupDataLoadSuccess" object:nil];
//    ///热搜词汇请求成功
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(howWordsLoadSuccess)
//                                                 name:@"HotWordsDataLoadSuccess" object:nil];
//    //监听键盘将要消失、出现，以此来动态的设置举报View的上下移动
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reportViewKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reportViewKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
//    ///刷新页面控件的高度
////    [[NSNotificationCenter defaultCenter] addObserver:self
////                                             selector:@selector(RefreshRecommenTableView)
////                                                 name:@"RefreshRecommenTableView" object:nil];
////
////    [[NSNotificationCenter defaultCenter] addObserver:self
////                                             selector:@selector(RefreshFocusTableView)
////                                                 name:@"RefreshFocusTableView" object:nil];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(RefreshNewQAMainViewController)
//                                                 name:@"RefreshNewQAMainViewController" object:nil];
//}
//
/////键盘将要出现时，若举报页面已经显示则上移
//- (void)reportViewKeyboardWillShow:(NSNotification *)notification{
//    //如果举报页面已经出现，就将举报View上移动
//    if (self.isShowedReportView == YES) {
//        //获取键盘高度
//        NSDictionary *userInfo = notification.userInfo;
//        CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//        CGFloat keyBoardHeight = endFrame.size.height;
//
//        [self.reportView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.view);
//            make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W - MAIN_SCREEN_W*2*0.1587, MAIN_SCREEN_W * 0.6827 * 329/256));
//            //这里如果是设置成距离self.view的底部，会高出一截
//            make.bottom.equalTo(self.view.window).offset( IS_IPHONEX ? -(keyBoardHeight+20) : -keyBoardHeight);
//        }];
//    }
//}
/////键盘将要消失，若举报页面已经显示则使其下移
//- (void)reportViewKeyboardWillHide:(NSNotification *)notification{
//    if (self.isShowedReportView == YES) {
//        [self.reportView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.center.equalTo(self.view);
//            make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W - MAIN_SCREEN_W*2*0.1587, MAIN_SCREEN_W * 0.6827 * 329/256));
//        }];
//    }
//}
//
/////我的关注的网络请求
//- (void)loadMyStarGroupList {
//    [self.groupmodel loadMyFollowGroup];
//}
//
/////我的关注网络请求成功后数据源数组赋值
//- (void)topFollowViewLoadSuccess {
//    self.dataArray = self.groupmodel.dataArray;
//    [self settingFollowViewUI];
//    [PostArchiveTool saveMyFollowGroupWith:self.dataArray];
//}
//
/////设置顶部我的关注View
//- (void)settingFollowViewUI {
//    [self setupHeadView];
//    [self.view bringSubviewToFront:_searchBtn];
//    [self reloadTopFollowViewWithArray:self.dataArray];
////    [self.topView loadViewWithArray:self.dataArray];
//}
//
//- (void)setUpModel {
//    _reportmodel = [[ReportModel alloc] init];
//    _postmodel = [[PostModel alloc] init];
//    _shieldmodel = [[ShieldModel alloc] init];
//    _starpostmodel = [[StarPostModel alloc] init];
//    _deletepostmodel = [[DeletePostModel alloc] init];
//    _followgroupmodel = [[FollowGroupModel alloc] init];
//    _postfocusmodel = [[PostFocusModel alloc] init];
//    _hotWordModel = [[HotSearchModel alloc] init];
//    _groupmodel = [[GroupModel alloc] init];
//}
//
//- (void)funcPopViewinit {
//    // 创建分享页面
//    _shareView = [[ShareView alloc] init];
//    _shareView.delegate = self;
//
//    // 创建多功能--别人页面
//    _popView = [[FuncView alloc] init];
//    _popView.delegate = self;
//
//    // 创建多功能--自己页面
//    _selfPopView = [[SelfFuncView alloc] init];
//    _selfPopView.delegate = self;
//
//    // 创建举报页面
//    _reportView = [[ReportView alloc]initWithPostID:[NSNumber numberWithInt:0]];
//    _reportView.delegate = self;
//
//    _recommenNoDataView.hidden = YES;
//    _focusNoDataView.hidden = YES;
//
//}
//
//- (NewQANoDataView *)recommenNoDataView {
//    if (!_recommenNoDataView) {
//        _recommenNoDataView = [[NewQANoDataView alloc] initWithNodataImage:[UIImage imageNamed:@"NewQARecommenNoDataImage"] AndText:@"暂时没有数据哦~"];
//        _recommenNoDataView.frame = CGRectMake(0, self.headViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT);
//        [self.recommenTableView addSubview:_recommenNoDataView];
//    }
//    return _recommenNoDataView;
//}
//
//- (NewQANoDataView *)focusNoDataView {
//    if (!_focusNoDataView) {
//        _focusNoDataView = [[NewQANoDataView alloc] initWithNodataImage:[UIImage imageNamed:@"QATABLENODATA"] AndText:@"去发现第一个有趣的人吧~"];
//        _focusNoDataView.frame = CGRectMake(0, self.headViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT);
//        [self.focusTableView addSubview:_focusNoDataView];
//    }
//    return _focusNoDataView;
//}
//
//- (void)setUpTopSearchView {
//    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    [self.view addSubview:backView];
//    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:backView.frame];
//    backImageView.image = [UIImage imageNamed:@"NewQATopImage"];
//    [backView addSubview:backImageView];
//    UIImageView *leftCircleImage = [[UIImageView alloc] init];
//    leftCircleImage.image = [UIImage imageNamed:@"NewQATopLeftCircleImage"];
//    [backImageView addSubview:leftCircleImage];
//    [leftCircleImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.view).mas_offset(-WScaleRate_SE * 11);
//        make.top.mas_equalTo(self.view).mas_offset(HScaleRate_SE * 40);
//        make.width.mas_equalTo(WScaleRate_SE * 163);
//        make.height.mas_equalTo(HScaleRate_SE * 160);
//    }];
//
//    UIImageView *rightCircleImage = [[UIImageView alloc] init];
//    rightCircleImage.image = [UIImage imageNamed:@"NewQATopRightCircleImage"];
//    [backImageView addSubview:rightCircleImage];
//    [rightCircleImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self.view).mas_offset(WScaleRate_SE * 46);
//        make.top.mas_equalTo(self.view).mas_offset(HScaleRate_SE * 93);
//        make.width.mas_equalTo(WScaleRate_SE * 219);
//        make.height.mas_equalTo(HScaleRate_SE * 217);
//    }];
//    [self.view addSubview:self.searchBtn];
//    [_searchBtn mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(self.view.mas_top).mas_offset(TOTAL_TOP_HEIGHT);
//        make.left.mas_equalTo(self.view.mas_left).mas_offset(SCREEN_WIDTH * 0.0427);
//        make.right.mas_equalTo(self.view.mas_right).mas_offset(-SCREEN_WIDTH * 0.0427);
//        make.height.mas_equalTo(SCREEN_WIDTH * 0.9147 * 37.5/343);
//    }];
//    _searchBtn.layer.cornerRadius = SCREEN_WIDTH * 0.9147 * 37.5/343 * 1/2;
//}
//
//- (void)setTableScrollView {
//    // scrollView
//    NewQAContentScrollView *scrollView = [[NewQAContentScrollView alloc] init];
//    scrollView.delaysContentTouches = NO;
//    [self.view addSubview:scrollView];
//    scrollView.backgroundColor = [UIColor clearColor];
//    self.scrollView = scrollView;
//    scrollView.pagingEnabled = YES;
//    scrollView.showsVerticalScrollIndicator = NO;
//    scrollView.showsHorizontalScrollIndicator = NO;
//    scrollView.delegate = self;
//    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, 0);
//    self.scrollView = scrollView;
//}
//
//- (void)setupContentView
//{
//    // 设置两个tableView的headerView
//    UIView* headView = [[UIView alloc] init];
//    headView.backgroundColor = [UIColor clearColor];
//    headView.frame = CGRectMake(0, _topBackViewH, 0, self.headViewHeight);
//    self.tableViewHeadView = headView;
//
//
//    _recommenTableView = [[NewQARecommenTableView alloc] init];
//    _recommenTableView.layer.cornerRadius = 28;
//    _recommenTableView.backgroundColor = [UIColor clearColor];
//    _recommenTableView.tag = 1;
//    _recommenTableView.delegate = self;
//    _recommenTableView.showsVerticalScrollIndicator = FALSE;
//    _recommenTableView.dataSource = self;
//    _recommenTableView.tableHeaderView = headView;
//    [_scrollView addSubview:_recommenTableView];
//    [_recommenTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.scrollView);
//        make.width.mas_equalTo(SCREEN_WIDTH);
//        make.top.mas_equalTo(self.view).mas_offset(_topBackViewH);
//        make.bottom.mas_equalTo(self.view);
//    }];
//    __weak typeof (self) weakSelf = self;
//    _recommenTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [weakSelf recommendTableRefreshData];
//    }];
//    _recommenTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        [weakSelf recommendTableLoadData];
//    }];
//
//
//    _focusTableView = [[NewQAFollowTableView alloc] init];
//    _focusTableView.backgroundColor = [UIColor clearColor];
//    _focusTableView.tag = 2;
//    _focusTableView.delegate = self;
//    _focusTableView.dataSource = self;
//    _focusTableView.showsVerticalScrollIndicator = FALSE;
//    _focusTableView.tableHeaderView = headView;
//    [_scrollView addSubview:_focusTableView];
//    [_focusTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.scrollView).offset(SCREEN_WIDTH);
//        make.width.mas_equalTo(_recommenTableView);
//        make.top.bottom.mas_equalTo(_recommenTableView);
//    }];
//    _focusTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [weakSelf focusTableRefreshData];
//    }];
//    _focusTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        [weakSelf focusTableLoadData];
//    }];
//
//}
//
//// 设置HeadView
//- (void)setupHeadView
//{
//    if (!_topView) {
//        _topView = [[TopFollowView alloc]initWithFrame:CGRectMake(0, _topBackViewH, SCREEN_WIDTH, self.headViewHeight)];
//    }
//    _topView.delegate = self;
//    _topView.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:_topView];
//
//    _titleBarView = [[NewQASelectorView alloc] init];
//    [self.topView addSubview:_titleBarView];
//    [self.titleBarView.leftBtn addTarget:self action:@selector(clickTitleLeft) forControlEvents:UIControlEventTouchUpInside];
//    [self.titleBarView.rightBtn addTarget:self action:@selector(clickTitleRight) forControlEvents:UIControlEventTouchUpInside];
//    [_titleBarView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(self.view);
//        make.bottom.mas_equalTo(_topView.mas_bottom);
//        make.height.mas_equalTo(SLIDERHEIGHT);
//    }];
//    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.mas_equalTo(self.view);
//        make.top.mas_equalTo(self.view);
//    }];
//
//    [self.view bringSubviewToFront:_searchBtn];
//    self.titleBarView.selectedItemIndex = 0;
//}
//
//- (void)setupPublishBtn {
//    [self.view addSubview:_publishBtn];
//    [_publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.view.top).mas_offset(SCREEN_HEIGHT * 0.7256);
//        make.right.mas_equalTo(self.view.mas_right).mas_offset(-SCREEN_WIDTH * 0.0427);
//        make.width.height.mas_equalTo(WScaleRate_SE * 70);
//    }];
//    _publishBtn.layer.cornerRadius = WScaleRate_SE * 70 * 1/2;
//    _publishBtn.layer.masksToBounds = YES;
//}
//
//- (void)reloadTopFollowViewWithArray:(NSMutableArray *)array {
//    if ([array count] == 0) {
//        self.headViewHeight = SLIDERHEIGHT;
//    } else {
//        self.headViewHeight = 190 * HScaleRate_SE;
//    }
//    CGRect frame = self.topView.frame;
//    frame.size.height = self.headViewHeight;
//    // 使用动画修改headerView高度
//    [self.recommenTableView beginUpdates];
//    [UIView animateWithDuration:0.3 animations:^{
//        self.tableViewHeadView.frame = frame;
//    }];
//    [self.recommenTableView endUpdates];
//    for(id tmpView in [self.topView subviews])
//    {
//        //找到要删除的子视图的对象
//        if(![tmpView isKindOfClass:[NewQASelectorView class]])
//        {
//            [tmpView removeFromSuperview];
//        }
//    }
//    [self.recommenTableView.mj_header beginRefreshing];
//    [self recommendTableRefreshData];
//    [self.topView loadViewWithArray:self.dataArray];
//}
//
/////搜索按钮加载
//- (SearchBtn *)searchBtn {
//    if (!_searchBtn) {
//        _searchBtn = [[SearchBtn alloc] init];
//        [_searchBtn addTarget:self action:@selector(searchPost) forControlEvents:UIControlEventTouchUpInside];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHotWords) name:@"refreshHotWords" object:nil];
//    }
//    return _searchBtn;
//}
//
/////发布按钮加载
//- (UIButton *)publishBtn {
//    if (!_publishBtn) {
//        _publishBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//        _publishBtn.backgroundColor = [UIColor clearColor];
//        [_publishBtn setBackgroundImage:[UIImage imageNamed:@"发布动态"] forState:UIControlStateNormal];
//        [_publishBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//        [_publishBtn addTarget:self action:@selector(clickedPublishBtn) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _publishBtn;
//}
//
/////热搜词汇的网络请求
//- (void)loadHotWords {
//    [self.hotWordModel getHotSearchArray];
//}
//
/////热搜词汇请求完成后数组赋值
//- (void)howWordsLoadSuccess {
//    self.hotWordsArray = self.hotWordModel.hotWordsArray;
//    [PostArchiveTool saveHotWordsWith:self.hotWordModel];
//}
//
/////3s刷新热搜词汇
//-(void)refreshHotWords {
//    if ([self.hotWordsArray count] == 0) {
//        return;
//    }
//    if (_hotWordIndex < [self.hotWordsArray count] - 1) {
//        _hotWordIndex++;
//    }else {
//        _hotWordIndex = 0;
//    }
//    [UIView transitionWithView:_searchBtn.searchBtnLabel
//                      duration:0.25f
//                       options:UIViewAnimationOptionTransitionCrossDissolve
//                    animations:^{
//        self->_searchBtn.searchBtnLabel.text = [NSString stringWithFormat:@"%@:%@",@"大家都在搜", self.hotWordsArray[self->_hotWordIndex]];
//
//      } completion:nil];
//}
//
/////跳转到搜索界面
//- (void)searchPost {
//    SearchBeginVC *vc = [[SearchBeginVC alloc] init];
//    vc.hidesBottomBarWhenPushed = YES;
//    ((ClassTabBar *)self.tabBarController.tabBar).hidden = NO;
//    [self.navigationController pushViewController:vc animated:YES];
//}
//
/////点击了发布按钮，跳转到发布页面
//- (void)clickedPublishBtn {
//    SZHReleaseDynamic *vc = [[SZHReleaseDynamic alloc] init];
//    vc.hidesBottomBarWhenPushed = YES;
//    ((ClassTabBar *)self.tabBarController.tabBar).hidden = NO;
//    [self.navigationController pushViewController:vc animated:YES];
//}
//
//
//
//#pragma mark - 底部的scrollViuew的代理方法scrollViewDidScroll
//
//
//#pragma mark - UIScrollViewDelegate
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (scrollView == self.scrollView || !scrollView.window) {
//        // 左右滑动时
//        CGFloat offSetX = scrollView.contentOffset.x; //主页面相对起始位置的位移
//        NSInteger currentIndex = floor(scrollView.contentOffset.x / SCREEN_WIDTH);
//        self.titleBarView.selectedItemIndex = currentIndex;
//        //滑块第一部分的位移变化
//        self.titleBarView.sliderLinePart.frame = CGRectMake(17 * WScaleRate_SE + (offSetX / SCREEN_WIDTH * WScaleRate_SE * 59) ,HScaleRate_SE * 44, self.titleBarView.sliderWidth, self.titleBarView.sliderHeight);
//        return;
//    }
//    // 上下滑动时
//    CGFloat offsetY = scrollView.contentOffset.y;
//    CGFloat originY = 0;
//    CGFloat otherOffsetY = 0;
//    if (offsetY <= self.headViewHeight-self.titleBarView.height) {
//        originY = -offsetY;
//        if (offsetY <= 0) {
//            otherOffsetY = 0;
//        } else {
//            otherOffsetY = offsetY;
//        }
//    } else {
//        originY = -(self.headViewHeight-self.titleBarView.height);
//        otherOffsetY = self.headViewHeight;
//    }
//    CGFloat ratio = MIN(1,MAX(0,(-originY/(self.headViewHeight-self.titleBarView.height - _topBackViewH))));
//    self.topView.frame = CGRectMake(0, originY + _topBackViewH, SCREEN_WIDTH, self.headViewHeight);
//    self.topView.groupsScrollView.alpha = 1-ratio;
//    for ( int i = 0; i < 2; i++) {
//        if (i != self.titleBarView.selectedItemIndex) {
//            UITableView* contentView = self.scrollView.subviews[i];
//            CGPoint offset = CGPointMake(0, otherOffsetY);
//            if ([contentView isKindOfClass:[UITableView class]]) {
//                if (contentView.contentOffset.y < self.headViewHeight || offset.y < self.headViewHeight) {
//                    [contentView setContentOffset:offset animated:NO];
//                    self.scrollView.offset = offset;
//                }
//            }
//        }
//    }
//}
//
//
//#pragma mark - 底部的scrollViuew的代理方法scrollViewDidEndDecelerating
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    CGFloat xMargin = 0;
//    if (self.titleBarView.selectedItemIndex == 0) {
//        xMargin = WScaleRate_SE * 17;
//    } else if (self.titleBarView.selectedItemIndex == 1) {
//        xMargin = WScaleRate_SE * 76;
//    }
//    self.titleBarView.sliderLinePart.frame = CGRectMake(xMargin,HScaleRate_SE * 44, self.titleBarView.sliderWidth, self.titleBarView.sliderHeight);
//}
//
//- (void)clickTitleRight {
//    NSLog(@"right");
//    self.titleBarView.sliderLinePart.frame = CGRectMake(WScaleRate_SE * 76 , HScaleRate_SE * 44, self.titleBarView.sliderWidth, self.titleBarView.sliderHeight);
//    self.titleBarView.leftBtn.titleLabel.alpha = 0.8;
//    [self.titleBarView.leftBtn.titleLabel setFont:[UIFont fontWithName:PingFangSCMedium size:14*fontSizeScaleRate_SE]];
//    self.titleBarView.rightBtn.titleLabel.alpha = 1;
//    [self.titleBarView.rightBtn.titleLabel setFont:[UIFont fontWithName:PingFangSCMedium size:18*fontSizeScaleRate_SE]];
//    self.titleBarView.selectedItemIndex = 1;
//    UITableView* contentView = self.scrollView.subviews[0];
//    [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, contentView.contentOffset.y) animated:NO];
//}
//
//- (void)clickTitleLeft {
//    NSLog(@"left");
//    self.titleBarView.sliderLinePart.frame = CGRectMake(WScaleRate_SE * 17 , HScaleRate_SE * 44, self.titleBarView.sliderWidth, self.titleBarView.sliderHeight);
//    self.titleBarView.leftBtn.titleLabel.alpha = 1;
//    [self.titleBarView.leftBtn.titleLabel setFont:[UIFont fontWithName:PingFangSCMedium size:18*fontSizeScaleRate_SE]];
//    self.titleBarView.rightBtn.titleLabel.alpha = 0.8;
//    [self.titleBarView.rightBtn.titleLabel setFont:[UIFont fontWithName:PingFangSCMedium size:14*fontSizeScaleRate_SE]];
//    self.titleBarView.selectedItemIndex = 0;
//    UITableView* contentView = self.scrollView.subviews[0];
//    [self.scrollView setContentOffset:CGPointMake(0, contentView.contentOffset.y) animated:NO];
//}
//
//// 下滑加载
//- (void)recommendTableLoadData{
//    self.recommenPage += 1;
//    __weak typeof (self) weakSelf = self;
//    [self.postmodel handleDataWithPage:self.recommenPage
//                               Success:^(NSArray *arr) {
//        if (weakSelf.recommenPage == 1) {
//            [weakSelf.recommenArray removeAllObjects];
//            [weakSelf.recommenheightArray removeAllObjects];
//            [weakSelf.recommenArray addObjectsFromArray:arr];
//            for (NSDictionary *dic in arr) {
//                weakSelf.item = [[PostItem alloc] initWithDic:dic];
//                PostTableViewCellFrame *cellFrame = [[PostTableViewCellFrame alloc] init];
//                cellFrame.item = weakSelf.item;
//                [weakSelf.recommenheightArray addObject:cellFrame];
//            }
//            [PostArchiveTool savePostListWith:weakSelf.recommenArray];
//            [PostArchiveTool savePostCellHeightWith:weakSelf.recommenheightArray];
//        } else {
//            [weakSelf.recommenArray addObjectsFromArray:arr];
//            for (NSDictionary *dic in arr) {
//                weakSelf.item = [[PostItem alloc] initWithDic:dic];
//                PostTableViewCellFrame *cellFrame = [[PostTableViewCellFrame alloc] init];
//                [cellFrame setItem:weakSelf.item];
//                [weakSelf.recommenheightArray addObject:cellFrame];
//            }
//        }
//        [MainQueue AsyncTask:^{
//            [weakSelf.recommenTableView reloadData];
//            if ([weakSelf.recommenArray count] == 0) {
//                weakSelf.recommenNoDataView.hidden = NO;
//            }
////            [weakSelf.recommendTableView layoutIfNeeded]; //这句是关键
//            [weakSelf.recommenTableView.mj_header endRefreshing];
//            [weakSelf.recommenTableView.mj_footer endRefreshing];
//        }];
//    } failure:^(NSError *error) {
//        NSLog(@"请求失败 error:%@",error.description);
//        if ([weakSelf.recommenArray count] == 0) {
//            weakSelf.recommenNoDataView.hidden = NO;
//        }
//        [weakSelf.recommenTableView.mj_header endRefreshing];
//        [weakSelf.recommenTableView.mj_footer endRefreshing];
//    }];
//}
//
/////上滑刷新
//- (void)recommendTableRefreshData{
//    [self.recommenTableView.heightArray removeAllObjects];
//    self.recommenPage = 0;
//    [self recommendTableLoadData];
//}
//
/////关注列表刷新数据
//- (void)focusTableLoadData {
//    self.focusPage += 1;
//    __weak typeof (self) weakSelf = self;
//    [self.postfocusmodel handleFocusDataWithPage:self.focusPage
//                               Success:^(NSArray *arr) {
//        if (weakSelf.focusPage == 1) {
//            [weakSelf.focusArray removeAllObjects];
//            [weakSelf.focusheightArray removeAllObjects];
//            [weakSelf.focusArray addObjectsFromArray:arr];
//            for (NSDictionary *dic in arr) {
//                weakSelf.item = [[PostItem alloc] initWithDic:dic];
//                PostTableViewCellFrame *cellFrame = [[PostTableViewCellFrame alloc] init];
//                cellFrame.item = weakSelf.item;
//                [weakSelf.focusheightArray addObject:cellFrame];
//            }
//        } else {
//            [weakSelf.focusArray addObjectsFromArray:arr];
//            for (NSDictionary *dic in arr) {
//                weakSelf.item = [[PostItem alloc] initWithDic:dic];
//                PostTableViewCellFrame *cellFrame = [[PostTableViewCellFrame alloc] init];
//                [cellFrame setItem:weakSelf.item];
//                [weakSelf.focusheightArray addObject:cellFrame];
//            }
//        }
//        [MainQueue AsyncTask:^{
//            [weakSelf.focusTableView reloadData];
//            if ([weakSelf.focusArray count] == 0) {
//                weakSelf.focusNoDataView.hidden = NO;
//            }
////            [weakSelf.recommendTableView layoutIfNeeded]; //这句是关键
//            [weakSelf.focusTableView.mj_header endRefreshing];
//            [weakSelf.focusTableView.mj_footer endRefreshing];
//        }];
//    } failure:^(NSError *error) {
//        NSLog(@"请求失败 error:%@",error.description);
//        if ([weakSelf.focusArray count] == 0) {
//            weakSelf.focusNoDataView.hidden = NO;
//        }
//        [weakSelf.focusTableView.mj_header endRefreshing];
//        [weakSelf.focusTableView.mj_footer endRefreshing];
//    }];
//}
//
//- (void)focusTableRefreshData {
//    [self.focusTableView.heightArray removeAllObjects];
//    self.focusPage = 0;
//    [self focusTableLoadData];
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    if (tableView.tag == 1) {
//        return _recommenArray.count;
//    } else {
//        return _focusArray.count;
//    }
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (tableView.tag == 1) {
//        NSString *identifier = [NSString stringWithFormat:@"postcell"];
//        _item = [[PostItem alloc] initWithDic:self.recommenArray[indexPath.row]];
//        PostTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        if(cell == nil) {
//            //这里
//            cell = [[PostTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//            cell.delegate = self;
//            cell.item = _item;
//            cell.funcBtn.tag = indexPath.row;
//            cell.commendBtn.tag = indexPath.row;
//            cell.shareBtn.tag = indexPath.row;
//            cell.starBtn.tag = indexPath.row;
//            cell.tableTag = [NSNumber numberWithInt:1];
//            cell.tag = indexPath.row;
//        }else if (_item.post_id != cell.item.post_id){
//            [self.recommenTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row inSection:0],nil] withRowAnimation:UITableViewRowAnimationNone];
//        }
//        cell.cellFrame = self.recommenheightArray[indexPath.row];
////        [cell layoutSubviews];
////        [cell layoutIfNeeded];
//        return cell;
//    } else {
//        NSString *identifier = [NSString stringWithFormat:@"postfocuscell"];
//        _item = [[PostItem alloc] initWithDic:self.focusArray[indexPath.row]];
//        PostTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        if(cell == nil) {
//            //这里
//            cell = [[PostTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//            cell.delegate = self;
//            cell.item = _item;
//            cell.funcBtn.tag = indexPath.row;
//            cell.commendBtn.tag = indexPath.row;
//            cell.shareBtn.tag = indexPath.row;
//            cell.starBtn.tag = indexPath.row;
//            // 此处准备把这个功能按钮隐藏了
////            cell.funcBtn.hidden = YES;
//            cell.tableTag = [NSNumber numberWithInt:2];
//            cell.tag = indexPath.row;
//        }else if (_item.post_id != cell.item.post_id){
//            [self.focusTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row inSection:0],nil] withRowAnimation:UITableViewRowAnimationNone];
//        }
//        cell.cellFrame = self.focusheightArray[indexPath.row];
//        [cell layoutSubviews];
//        [cell layoutIfNeeded];
//        return cell;
//    }
//
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    PostTableViewCellFrame *cellFrame;
//    if (tableView.tag == 1) {
//        cellFrame = self.recommenheightArray[indexPath.row];
//        return cellFrame.cellHeight;
//    } else {
//        cellFrame = self.focusheightArray[indexPath.row];
//        return cellFrame.cellHeight;
//    }
//
//}
//
/////点击我的关注中的已关注的圈子跳转到具体的圈子里去
//- (void)ClickedGroupBtn:(GroupBtn *)sender {
//    NSString *groupName = sender.groupBtnLabel.text;
//    if (sender.tag == 0) {
//        YYZTopicGroupVC *topVc = [[YYZTopicGroupVC alloc]init];
//        topVc.hidesBottomBarWhenPushed = YES;
//        ((ClassTabBar *)self.tabBarController.tabBar).hidden = NO;
//        [self.navigationController pushViewController:topVc animated:YES];
//    }else {
//        YYZTopicDetailVC *detailVC = [[YYZTopicDetailVC alloc]init];
//        detailVC.topicID = [sender.item.topic_id intValue];
//        detailVC.topicIdString = groupName;
//        detailVC.hidesBottomBarWhenPushed = YES;
//        ((ClassTabBar *)self.tabBarController.tabBar).hidden = NO;
//        [self.navigationController pushViewController:detailVC animated:YES];
//    }
//}
//
/////点击跳转到具体的帖子（与下方commentBtn的事件相同）
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (tableView.tag == 1) {
//        DynamicDetailMainVC *dynamicDetailVC = [[DynamicDetailMainVC alloc]init];
//        _item = [[PostItem alloc] initWithDic:self.recommenArray[indexPath.row]];
//        dynamicDetailVC.post_id = _item.post_id;
//        dynamicDetailVC.hidesBottomBarWhenPushed = YES;
//        ((ClassTabBar *)self.tabBarController.tabBar).hidden = NO;
//        [self.navigationController pushViewController:dynamicDetailVC animated:YES];
//    } else {
//
//    }
//
//}
//
///// 废弃方法
//- (CGFloat)getHeightText:(NSString *)text font:(UIFont *)font labelWidth:(CGFloat)width{
//    NSDictionary *attrDic = @{NSFontAttributeName:font};
//    CGRect strRect = [text boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:attrDic context:nil];
//    return strRect.size.height;
//}
//
///// 废弃方法
//- (CGFloat)getCellHeightContent:(NSString *)content AndPicsArray:(NSArray *)pics{
//    CGFloat height;
//    CGFloat imageHeight;
//    imageHeight = [pics count] != 0 ? SCREEN_WIDTH * 0.944 / 3 : 0;
//    // 计算cell中detailLabel的高度
//    CGFloat detailLabelHeight = [self getHeightText:content font:[UIFont fontWithName:PingFangSCRegular size:16] labelWidth:WScaleRate_SE * 342];
//    height = (detailLabelHeight + CELLINITHEIGHT + imageHeight);
//    return height;
//}
//
//#pragma mark -配置相关弹出View和其蒙版的操作
//- (void)setBackViewWithGesture {
//    self.backViewWithGesture = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    self.backViewWithGesture.backgroundColor = [UIColor blackColor];
//    self.backViewWithGesture.alpha = 0.36;
//    UITapGestureRecognizer *dismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissBackViewWithGesture)];
//    [self.backViewWithGesture addGestureRecognizer:dismiss];
//}
//
//- (void)showBackViewWithGesture {
//    [self.view.window addSubview:self.backViewWithGesture];
//}
//
//- (void)dismissBackViewWithGestureAnd:(UIView *)view {
//    [view removeFromSuperview];
//    [self.backViewWithGesture removeFromSuperview];
//}
//
//- (void)dismissBackViewWithGesture {
//    [self.popView removeFromSuperview];
//    [self.shareView removeFromSuperview];
//    [self.reportView removeFromSuperview];
//    [self.selfPopView removeFromSuperview];
//    [self.backViewWithGesture removeFromSuperview];
//}
//
//- (NSMutableArray *)topicArray {
//    if (!_topicArray) {
////
//        [HttpTool.shareTool
//         request:NewQA_POST_QATopicGroup_API
//         type:HttpToolRequestTypePost
//         serializer:HttpToolRequestSerializerHTTP
//         bodyParameters:nil
//         progress:nil
//         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
//            NSArray *array = object[@"data"];
//            self.topicArray = [NSMutableArray arrayWithArray:array];
//        }
//         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//        }];
////
////        [[HttpClient defaultClient] requestWithPath:NewQA_POST_QATopicGroup_API method:HttpRequestPost parameters:nil prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
////            NSArray *array = responseObject[@"data"];
////            self.topicArray = [NSMutableArray arrayWithArray:array];
////        } failure:^(NSURLSessionDataTask *task, NSError *error) {
////
////        }];
//    }
//    return self.topicArray;
//}
//
//#pragma mark -通知刷新邮问主页
//- (void) RefreshRecommenTableView {
//    NSLog(@"调用了RefreshRecommenTableView方法\n\n\n\n\n\n\n");
////    [self.topView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    [self loadMyStarGroupList];
//}
//
//- (void) RefreshFocusTableView {
//    [self.topView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    [self loadMyStarGroupList];
//}
//
//- (void) RefreshNewQAMainViewController {
//    [self RefreshRecommenTableView];
////    [self.recommenTableView removeFromSuperview];
////    [self.recommenArray removeAllObjects];
////    [self.recommenTableView.mj_header beginRefreshing];
////    [self recommendTableRefreshData];
//}
//
//- (void)dealloc {
//    [self.timer destroy];
//}

- (void)viewDidLoad{
    self.view.backgroundColor = [UIColor dm_colorWithLightColor:UIColor.whiteColor darkColor:UIColor.blackColor];
    [self addStopView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HideBottomClassScheduleTabBarView" object:nil userInfo:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    ((ClassTabBar *)self.tabBarController.tabBar).hidden = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowBottomClassScheduleTabBarView" object:nil userInfo:nil];
    self.isNeedFresh = NO;
}

//服务功能暂停页
- (void)addStopView{
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"人在手机里"]];
    [self.view addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-20);
    }];
    
    UILabel *Lab = [[UILabel alloc] init];
    Lab.text = @"服务升级ing...敬请期待";
    Lab.font = [UIFont fontWithName:PingFangSCLight size: 12];
    Lab.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#112C54" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
    [self.view addSubview:Lab];
    [Lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(imgView.mas_bottom).offset(16);
    }];
}

@end
