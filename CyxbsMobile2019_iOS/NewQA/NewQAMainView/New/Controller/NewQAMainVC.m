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

#define kItemheight 50
#define kTopView_Height 200

@interface NewQAMainVC () <UIScrollViewDelegate, UITableViewDelegate,UITableViewDataSource,ReportViewDelegate,FuncViewProtocol,ShareViewDelegate,PostTableViewCellDelegate,SelfFuncViewProtocol>

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
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIVisualEffectView *HUDView;
@property (nonatomic, strong) UIView *nodataView;
@property (nonatomic, strong) UIImageView *nodataImageView;

 
@end

@implementation NewQAMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorNamed:@"QAMainPageBackGroudColor"];
    self.view.clipsToBounds = YES;
    self.topBackViewH = SCREEN_WIDTH * 0.04 * 11/15 + TOTAL_TOP_HEIGHT;
    self.headViewHeight = 205 * HScaleRate_SE - SCREEN_WIDTH * 0.04 * 11/15;
    
    ///我的关注数据请求成功
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(topFollowViewLoadSuccess)
                                                 name:@"MyFollowGroupDataLoadSuccess" object:nil];
    
    self.recommenPage = 0;
    [self setUpModel];
    [self funcPopViewinit];
    self.groupmodel = [[GroupModel alloc] init];
    [self loadMyStarGroupList];
    _recommenArray = [NSMutableArray array];
    _recommenheightArray = [NSMutableArray array];
    [self setUpTopSearchView];
    [self setupContentView];
    [self setupHeadView];
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    _HUDView = [[UIVisualEffectView alloc] initWithEffect:blur];
    _HUDView.alpha = 0.0f;
    _HUDView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.headViewHeight + self.topBackViewH - SLIDERHEIGHT);
    [self.view addSubview:_HUDView];
    [self.view bringSubviewToFront:_searchBtn];
    [self recommendTableLoadData];
    
}

///我的关注的网络请求
- (void)loadMyStarGroupList {
    [self.groupmodel loadMyFollowGroup];
}

///我的关注网络请求成功后数据源数组赋值
- (void)topFollowViewLoadSuccess {
    self.dataArray = self.groupmodel.dataArray;
    [self settingFollowViewUI];
//    [PostArchiveTool saveMyFollowGroupWith:self.dataArray];
}

- (void)settingFollowViewUI {

    [self.view bringSubviewToFront:_searchBtn];
    [self.topView loadViewWithArray:self.dataArray];
//    [self.loadHUD removeFromSuperview];
//    [self reloadTopFollowViewWithArray:self.dataArray];
}

- (void)setUpModel {
    _reportmodel = [[ReportModel alloc] init];
    _postmodel = [[PostModel alloc] init];
    _shieldmodel = [[ShieldModel alloc] init];
    _starpostmodel = [[StarPostModel alloc] init];
    _deletepostmodel = [[DeletePostModel alloc] init];
    _followgroupmodel = [[FollowGroupModel alloc] init];
}

- (void)funcPopViewinit {
    // 创建分享页面
    _shareView = [[ShareView alloc] init];
    _shareView.delegate = self;
    
    // 创建多功能--别人页面
    _popView = [[FuncView alloc] init];
    _popView.delegate = self;
    
    // 创建多功能--自己页面
    _selfPopView = [[SelfFuncView alloc] init];
    _selfPopView.delegate = self;
    
    // 创建举报页面
    _reportView = [[ReportView alloc]initWithPostID:[NSNumber numberWithInt:0]];
    _reportView.delegate = self;
    
    _nodataView.hidden = YES;
    
}

- (UIView *)nodataView {
    if (!_nodataView) {
        _nodataView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT - self.headViewHeight)];
        _nodataView.backgroundColor = [UIColor colorNamed:@"QATABLENODATACOLOR"];
        
        _nodataImageView = [[UIImageView alloc] init];
        _nodataImageView.image = [UIImage imageNamed:@"QATABLENODATA"];
        [_nodataView addSubview:_nodataImageView];
        [self.recommenTableView addSubview:_nodataView];
        CGFloat imageW = _nodataImageView.image.size.width;
        CGFloat imageH = _nodataImageView.image.size.height;
        [_nodataImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_nodataView.mas_top).mas_offset(HScaleRate_SE * 72);
            make.centerX.mas_equalTo(self.view);
            make.height.mas_equalTo(imageH);
            make.width.mas_equalTo(imageW);
        }];
        
        UILabel *nodataLabel = [[UILabel alloc] init];
        nodataLabel.text = @"去发现第一个有趣的人吧~";
        nodataLabel.textAlignment = NSTextAlignmentCenter;
        nodataLabel.font = [UIFont fontWithName:PingFangSCRegular size:12];
        nodataLabel.textColor = [UIColor colorNamed:@"CellDetailColor"];
        [_nodataView addSubview:nodataLabel];
        [nodataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_nodataImageView.mas_bottom).mas_offset(HScaleRate_SE * 10);
            make.centerX.mas_equalTo(self.view);
            make.height.mas_equalTo(HScaleRate_SE * 17);
            make.width.mas_equalTo(self.view);
        }];
    }
    return _nodataView;
}

- (void)setUpTopSearchView {
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.headViewHeight + self.topBackViewH)];
    [self.view addSubview:backView];
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:backView.frame];
    backImageView.image = [UIImage imageNamed:@"NewQATopImage"];
    [backView addSubview:backImageView];
//    backView.backgroundColor = [UIColor redColor];
//    [backView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"NewQATopImage"]]];
    UIImageView *leftCircleImage = [[UIImageView alloc] init];
    leftCircleImage.image = [UIImage imageNamed:@"NewQATopLeftCircleImage"];
    [backImageView addSubview:leftCircleImage];
    [leftCircleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).mas_offset(-WScaleRate_SE * 11);
        make.top.mas_equalTo(self.view).mas_offset(HScaleRate_SE * 40);
        make.width.mas_equalTo(WScaleRate_SE * 163);
        make.height.mas_equalTo(HScaleRate_SE * 160);
    }];
    
    UIImageView *rightCircleImage = [[UIImageView alloc] init];
    rightCircleImage.image = [UIImage imageNamed:@"NewQATopRightCircleImage"];
    [backImageView addSubview:rightCircleImage];
    [rightCircleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).mas_offset(WScaleRate_SE * 46);
        make.top.mas_equalTo(self.view).mas_offset(HScaleRate_SE * 93);
        make.width.mas_equalTo(WScaleRate_SE * 219);
        make.height.mas_equalTo(HScaleRate_SE * 217);
    }];
//    [self.view addSubview:self.topBackView];
    [self.view addSubview:self.searchBtn];
//    [_topBackView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.mas_equalTo(self.view);
//        make.height.mas_equalTo(_topBackViewH);
//    }];
    [_searchBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_top).mas_offset(TOTAL_TOP_HEIGHT);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(SCREEN_WIDTH * 0.0427);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-SCREEN_WIDTH * 0.0427);
        make.height.mas_equalTo(SCREEN_WIDTH * 0.9147 * 37.5/343);
    }];
    _searchBtn.layer.cornerRadius = SCREEN_WIDTH * 0.9147 * 37.5/343 * 1/2;
//    [self.view bringSubviewToFront:_topBackView];
}

- (void)setupContentView
{
    // scrollView
    NewQAContentScrollView *scrollView = [[NewQAContentScrollView alloc] init];
    scrollView.delaysContentTouches = NO;
    [self.view addSubview:scrollView];
    scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView = scrollView;
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, 0);

    // 设置两个tableView的headerView
    UIView* headView = [[UIView alloc] init];
    headView.backgroundColor = [UIColor clearColor];
    headView.frame = CGRectMake(0, _topBackViewH, 0, self.headViewHeight);
    self.tableViewHeadView = headView;
    
    
    _recommenTableView = [[NewQARecommenTableView alloc] init];
    _recommenTableView.backgroundColor = [UIColor clearColor];
    _recommenTableView.tag = 1;
    _recommenTableView.delegate = self;
    _recommenTableView.showsVerticalScrollIndicator = FALSE;
    _recommenTableView.dataSource = self;
    _recommenTableView.tableHeaderView = headView;
    [scrollView addSubview:_recommenTableView];
    [_recommenTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(scrollView);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.top.mas_equalTo(self.view).mas_offset(_topBackViewH);
        make.bottom.mas_equalTo(self.view);
    }];
    __weak typeof (self) weakSelf = self;
    _recommenTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf recommendTableRefreshData];
    }];
    _recommenTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf recommendTableLoadData];
    }];

    
    _focusTableView = [[NewQAMainTableView alloc] init];
    _focusTableView.tag = 2;
    _focusTableView.delegate = self;
    _focusTableView.dataSource = self;
    _focusTableView.showsVerticalScrollIndicator = FALSE;
    _focusTableView.tableHeaderView = headView;
    [scrollView addSubview:_focusTableView];
    [_focusTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(scrollView).offset(SCREEN_WIDTH);
        make.width.mas_equalTo(_recommenTableView);
        make.top.bottom.mas_equalTo(_recommenTableView);
    }];
    
}

// 设置HeadView
- (void)setupHeadView
{
    _topView = [[TopFollowView alloc]initWithFrame:CGRectMake(0, _topBackViewH, SCREEN_WIDTH, self.headViewHeight)];
    _topView.backgroundColor = [UIColor clearColor];
    UIView *v = [[UIView alloc] init];
    v.frame = CGRectMake(0, 20, 200, 40);
    v.backgroundColor = [UIColor redColor];
    [_topView addSubview:v];
    [self.view addSubview:_topView];
    
    NewQASelectorView *titleBarView = [[NewQASelectorView alloc] init];
    [self.topView addSubview:titleBarView];
    self.titleBarView = titleBarView;
    [self.titleBarView.leftBtn addTarget:self action:@selector(clickTitleLeft) forControlEvents:UIControlEventTouchUpInside];
    [self.titleBarView.rightBtn addTarget:self action:@selector(clickTitleRight) forControlEvents:UIControlEventTouchUpInside];
    [titleBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(_topView.mas_bottom);
        make.height.mas_equalTo(SLIDERHEIGHT);
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
    }];
//    [self.view bringSubviewToFront:_scrollView];
    [self.view bringSubviewToFront:_searchBtn];
    self.titleBarView.selectedItemIndex = 0;
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
}

///顶部搜索背景View懒加载
- (UIView *)topBackView {
    if (!_topBackView) {
        _topBackView = [[UIView alloc] init];
//        [_topBackView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"NewQATopImage"]]];
        _topBackView.backgroundColor = [UIColor redColor];
    }
    return _topBackView;
}

///搜索按钮加载
- (SearchBtn *)searchBtn {
    if (!_searchBtn) {
        _searchBtn = [[SearchBtn alloc] init];
//        [_searchBtn addTarget:self action:@selector(searchPost) forControlEvents:UIControlEventTouchUpInside];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHotWords) name:@"refreshHotWords" object:nil];
    }
    return _searchBtn;
}



#pragma mark - 底部的scrollViuew的代理方法scrollViewDidScroll


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView || !scrollView.window) {
        // 左右滑动时
        CGFloat offSetX = scrollView.contentOffset.x; //主页面相对起始位置的位移
        NSInteger currentIndex = floor(scrollView.contentOffset.x / SCREEN_WIDTH);
        self.titleBarView.selectedItemIndex = currentIndex;
        //滑块第一部分的位移变化
        self.titleBarView.sliderLinePart.frame = CGRectMake(17 * WScaleRate_SE + (offSetX / SCREEN_WIDTH * WScaleRate_SE * 59) ,HScaleRate_SE * 44, self.titleBarView.sliderWidth, self.titleBarView.sliderHeight);
        return;
    }
    // 上下滑动时
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat originY = 0;
    CGFloat otherOffsetY = 0;
    if (offsetY <= self.headViewHeight-self.titleBarView.height) {
        originY = -offsetY;
        if (offsetY <= 0) {
            otherOffsetY = 0;
        } else {
            otherOffsetY = offsetY;
        }
    } else {
        originY = -(self.headViewHeight-self.titleBarView.height);
        otherOffsetY = self.headViewHeight;
    }
    CGFloat ratio = MIN(1,MAX(0,(-originY/(self.headViewHeight-self.titleBarView.height - _topBackViewH))));
    NSLog(@"%f\n",ratio);
    self.topView.frame = CGRectMake(SCREEN_WIDTH * ratio/2, originY + _topBackViewH, SCREEN_WIDTH * (1 - ratio), self.headViewHeight);
    self.HUDView.frame = CGRectMake(0, originY, SCREEN_WIDTH, self.headViewHeight + self.topBackViewH - SLIDERHEIGHT);
    self.HUDView.alpha = ratio;
//    self.titleBarView.frame = CGRectMake(0, originY + _topBackViewH, SCREEN_WIDTH, self.titleBarView.frame.size.height);
    for ( int i = 0; i < 2; i++) {
        if (i != self.titleBarView.selectedItemIndex) {
            UITableView* contentView = self.scrollView.subviews[i];
            CGPoint offset = CGPointMake(0, otherOffsetY);
            if ([contentView isKindOfClass:[UITableView class]]) {
                if (contentView.contentOffset.y < self.headViewHeight || offset.y < self.headViewHeight) {
                    [contentView setContentOffset:offset animated:NO];
                    self.scrollView.offset = offset;
                }
            }
        }
    }
}


#pragma mark - 底部的scrollViuew的代理方法scrollViewDidEndDecelerating

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat xMargin = 0;
    if (self.titleBarView.selectedItemIndex == 0) {
        xMargin = WScaleRate_SE * 17;
    } else if (self.titleBarView.selectedItemIndex == 1) {
        xMargin = WScaleRate_SE * 76;
    }
    self.titleBarView.sliderLinePart.frame = CGRectMake(xMargin,HScaleRate_SE * 44, self.titleBarView.sliderWidth, self.titleBarView.sliderHeight);
}

- (void)clickTitleRight {
    NSLog(@"right");
    self.titleBarView.sliderLinePart.frame = CGRectMake(WScaleRate_SE * 76 , HScaleRate_SE * 44, self.titleBarView.sliderWidth, self.titleBarView.sliderHeight);
    self.titleBarView.leftBtn.titleLabel.alpha = 0.8;
    [self.titleBarView.leftBtn.titleLabel setFont:[UIFont fontWithName:PingFangSCMedium size:14*fontSizeScaleRate_SE]];
    self.titleBarView.rightBtn.titleLabel.alpha = 1;
    [self.titleBarView.rightBtn.titleLabel setFont:[UIFont fontWithName:PingFangSCMedium size:18*fontSizeScaleRate_SE]];
    self.titleBarView.selectedItemIndex = 1;
    UITableView* contentView = self.scrollView.subviews[0];
    [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, contentView.contentOffset.y) animated:NO];
}

- (void)clickTitleLeft {
    NSLog(@"left");
    self.titleBarView.sliderLinePart.frame = CGRectMake(WScaleRate_SE * 17 , HScaleRate_SE * 44, self.titleBarView.sliderWidth, self.titleBarView.sliderHeight);
    self.titleBarView.leftBtn.titleLabel.alpha = 1;
    [self.titleBarView.leftBtn.titleLabel setFont:[UIFont fontWithName:PingFangSCMedium size:18*fontSizeScaleRate_SE]];
    self.titleBarView.rightBtn.titleLabel.alpha = 0.8;
    [self.titleBarView.rightBtn.titleLabel setFont:[UIFont fontWithName:PingFangSCMedium size:14*fontSizeScaleRate_SE]];
    self.titleBarView.selectedItemIndex = 0;
    UITableView* contentView = self.scrollView.subviews[0];
    [self.scrollView setContentOffset:CGPointMake(0, contentView.contentOffset.y) animated:NO];
}

// 下滑加载
- (void)recommendTableLoadData{
    self.recommenPage += 1;
    __weak typeof (self) weakSelf = self;
    [self.postmodel handleDataWithPage:self.recommenPage
                               Success:^(NSArray *arr) {
        if (weakSelf.recommenPage == 1) {
            [weakSelf.recommenArray removeAllObjects];
            [weakSelf.recommenheightArray removeAllObjects];
            [weakSelf.recommenArray addObjectsFromArray:arr];
            for (NSDictionary *dic in arr) {
                weakSelf.item = [[PostItem alloc] initWithDic:dic];
                PostTableViewCellFrame *cellFrame = [[PostTableViewCellFrame alloc] init];
                cellFrame.item = weakSelf.item;
                [weakSelf.recommenheightArray addObject:cellFrame];
            }
//            [PostArchiveTool savePostListWith:self.tableArray];
        } else {
            [weakSelf.recommenArray addObjectsFromArray:arr];
            for (NSDictionary *dic in arr) {
                weakSelf.item = [[PostItem alloc] initWithDic:dic];
                PostTableViewCellFrame *cellFrame = [[PostTableViewCellFrame alloc] init];
                [cellFrame setItem:weakSelf.item];
                [weakSelf.recommenheightArray addObject:cellFrame];
            }
        }
        [MainQueue AsyncTask:^{
            [weakSelf.recommenTableView reloadData];
            if ([weakSelf.recommenArray count] == 0) {
                weakSelf.nodataView.hidden = NO;
            }
//            [weakSelf.recommendTableView layoutIfNeeded]; //这句是关键
            [weakSelf.recommenTableView.mj_header endRefreshing];
            [weakSelf.recommenTableView.mj_footer endRefreshing];
        }];
    } failure:^(NSError *error) {
        NSLog(@"请求失败 error:%@",error.description);
        if ([weakSelf.recommenArray count] == 0) {
            weakSelf.nodataView.hidden = NO;
        }
        [weakSelf.recommenTableView.mj_header endRefreshing];
        [weakSelf.recommenTableView.mj_footer endRefreshing];
    }];
}

///上滑刷新
- (void)recommendTableRefreshData{
    [self.recommenTableView.heightArray removeAllObjects];
    self.recommenPage = 0;
    [self recommendTableLoadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1) {
        return _recommenArray.count;
    }
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        NSString *identifier = [NSString stringWithFormat:@"postcell"];
        _item = [[PostItem alloc] initWithDic:self.recommenArray[indexPath.row]];
        PostTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if(cell == nil) {
            //这里
            cell = [[PostTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.delegate = self;
            cell.item = _item;
            cell.funcBtn.tag = indexPath.row;
            cell.commendBtn.tag = indexPath.row;
            cell.shareBtn.tag = indexPath.row;
            cell.starBtn.tag = indexPath.row;
            cell.tableTag = [NSNumber numberWithInt:1];
            cell.tag = indexPath.row;
        }else if (_item.post_id != cell.item.post_id){
            [self.recommenTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row inSection:0],nil] withRowAnimation:UITableViewRowAnimationNone];
        }
        cell.cellFrame = self.recommenheightArray[indexPath.row];
//        [cell layoutSubviews];
//        [cell layoutIfNeeded];
        return cell;
    }
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"contentCell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"contentCell"];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"content - %zd", indexPath.row];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 1) {
        PostTableViewCellFrame *cellFrame = self.recommenheightArray[indexPath.row];
        return cellFrame.cellHeight;
    }
    return 160;

}

///点击跳转到具体的帖子（与下方commentBtn的事件相同）
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 1) {
        DynamicDetailMainVC *dynamicDetailVC = [[DynamicDetailMainVC alloc]init];
        _item = [[PostItem alloc] initWithDic:self.recommenArray[indexPath.row]];
        dynamicDetailVC.post_id = _item.post_id;
        dynamicDetailVC.hidesBottomBarWhenPushed = YES;
        ((ClassTabBar *)self.tabBarController.tabBar).hidden = NO;
        [self.navigationController pushViewController:dynamicDetailVC animated:YES];
    } else {
        
    }
    
}


- (CGFloat)getHeightText:(NSString *)text font:(UIFont *)font labelWidth:(CGFloat)width{
    NSDictionary *attrDic = @{NSFontAttributeName:font};
    CGRect strRect = [text boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:attrDic context:nil];
    return strRect.size.height;
}

- (CGFloat)getCellHeightContent:(NSString *)content AndPicsArray:(NSArray *)pics{
    CGFloat height;
    CGFloat imageHeight;
    imageHeight = [pics count] != 0 ? SCREEN_WIDTH * 0.944 / 3 : 0;
    // 计算cell中detailLabel的高度
    CGFloat detailLabelHeight = [self getHeightText:content font:[UIFont fontWithName:PingFangSCRegular size:16] labelWidth:WScaleRate_SE * 342];
    height = (detailLabelHeight + CELLINITHEIGHT + imageHeight);
    return height;
}

#pragma mark -配置相关弹出View和其蒙版的操作
- (void)setBackViewWithGesture {
    self.backViewWithGesture = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.backViewWithGesture.backgroundColor = [UIColor blackColor];
    self.backViewWithGesture.alpha = 0.36;
    UITapGestureRecognizer *dismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissBackViewWithGesture)];
    [self.backViewWithGesture addGestureRecognizer:dismiss];
}

- (void)showBackViewWithGesture {
    [self.view.window addSubview:self.backViewWithGesture];
}

- (void)dismissBackViewWithGestureAnd:(UIView *)view {
    [view removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
}

- (void)dismissBackViewWithGesture {
    [self.popView removeFromSuperview];
    [self.shareView removeFromSuperview];
    [self.reportView removeFromSuperview];
    [self.selfPopView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
}




@end
