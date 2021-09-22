//
//  NewQAMainPageTableViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/7/14.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "NewQAMainPageTableViewController.h"
#import "PostModel.h"
#import "DynamicDetailMainVC.h"
#import "ClassTabBar.h"
#import "MGDRefreshTool.h"
#import "PostArchiveTool.h"
#import "MGDGCD.h"


@interface NewQAMainPageTableViewController () <UITableViewDelegate,UITableViewDataSource,ReportViewDelegate,FuncViewProtocol,ShareViewDelegate,PostTableViewCellDelegate,SelfFuncViewProtocol>

//帖子模型
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) PostModel *postmodel;


@property (nonatomic, assign) CGFloat initHeight;
@property (nonatomic, strong) MJRefreshBackNormalFooter *footer;
@property (nonatomic, strong) MJRefreshNormalHeader *header;

@end

@implementation NewQAMainPageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 90;
    [self.view addSubview:self.tableView];
    self.isShowedReportView = NO;
    [self setUpRefresh];
    [self setBackViewWithGesture];
    [self setModel];
    [self setNSNotificationCenter];
    [self funcPopViewinit];
    // 先加载缓存数据，加载6条数据，然后开始自动刷新
    self.page = 0;
    self.tableArray = [NSMutableArray arrayWithArray:[PostArchiveTool getPostList]];
    self.heightArray = [NSMutableArray arrayWithArray:[PostArchiveTool getPostCellHeight]];
    if (self.tableArray.count != 0) {
        [self.tableView reloadData];
        [_header beginRefreshing];
    }
    [self loadData];
    
    [[NSUserDefaults standardUserDefaults] setValue:@(NO) forKey:@"_UIConstraintBasedLayoutLogUnsatisfiable"];
    _initHeight = SCREEN_WIDTH * (0.1486 + 0.0427 * 101.5/16  + 0.2707 * 25.5/101.5);
}

#pragma mark -设置一些网络请求中的model
- (void)setModel {
    _reportmodel = [[ReportModel alloc] init];
    _postmodel = [[PostModel alloc] init];
    _shieldmodel = [[ShieldModel alloc] init];
    _starpostmodel = [[StarPostModel alloc] init];
    _deletepostmodel = [[DeletePostModel alloc] init];
    _followgroupmodel = [[FollowGroupModel alloc] init];
}

#pragma mark -设置通知中心
- (void)setNSNotificationCenter {
    ///帖子列表请求成功
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NewQAListLoadSuccess)
                                                 name:@"NewQAListPageDataLoadSuccess" object:nil];
    ///帖子列表请求失败
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NewQAListLoadError)
                                                 name:@"NewQAListPageDataLoadError" object:nil];
    
    //监听键盘将要消失、出现，以此来动态的设置举报View的上下移动
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reportViewKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reportViewKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
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
            //这里如果是设置成距离self.view的底部，会高出一截
            make.bottom.equalTo(self.view.window).offset( IS_IPHONEX ? -(keyBoardHeight+20) : -keyBoardHeight);
//            make.bottom.equalTo(self.view.window).offset(-keyBoardHeight);

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

# pragma mark -初始化功能弹出页面
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
    
}

#pragma mark- 帖子列表的网络请求
///下滑加载
- (void)loadData{
//    self.page += 1;
//    __weak typeof (self) weakSelf = self;
//    [self.postmodel handleDataWithPage:self.page
//                               Success:^(NSArray *arr, NSMutableArray *a) {
//        if (weakSelf.page == 1) {
//            [weakSelf.tableArray removeAllObjects];
//            [weakSelf.tableArray addObjectsFromArray:arr];
//            [PostArchiveTool savePostListWith:self.tableArray];
//        } else {
//            [weakSelf.tableArray addObjectsFromArray:arr];
//        }
//        [MainQueue SyncTask:^{
//            [weakSelf.tableView reloadData];
//        }];
//    } failure:^(NSError *error) {
//        NSLog(@"请求失败 error:%@",error.description);
//    }];
}

///上滑刷新
- (void)refreshData{
    [self.heightArray removeAllObjects];
    self.page = 1;
    NSLog(@"此时的page:%ld",(long)self.page);
//    [self.postmodel loadMainPostWithPage:self.page AndSize:6];
}

///成功请求数据
- (void)NewQAListLoadSuccess {
    NSLog(@"请求列表数据成功");
    BOOL flag = true;
    if (self.page == 1) {
        [self.tableArray removeAllObjects];
        self.tableArray = self.postmodel.postArray;
        // 每次只缓存第一页数据
        [PostArchiveTool savePostListWith:self.tableArray];
    }else {
        [self.tableArray addObjectsFromArray:self.postmodel.postArray];
    }
    //根据当前加载的问题页数判断是上拉刷新还是下拉刷新
    if (self.page == 1) {
        [self.tableView.mj_header endRefreshing];
    }else{
        [self.tableView.mj_footer endRefreshing];
    }
    [self.tableView reloadData];
    [self.tableView layoutIfNeeded]; //这句是关键
    for(UIView * view in [self.view subviews]) {
        if([view isKindOfClass:[UITableView class]]) {
            flag = false;
            break;
        }
    }
    if (flag) {
        [self.view addSubview:self.tableView];
        NSIndexPath* indexPat = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPat atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

///请求失败
- (void)NewQAListLoadError {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [NewQAHud showHudWith:@"网络异常" AddView:self.view.window];
}

- (NSMutableArray *)heightArray{
   if (_heightArray == nil) {
       _heightArray = [NSMutableArray array];
   }
   return _heightArray;
}

///设置列表加载菊花
- (void)setUpRefresh {
    //上滑加载的设置
    _footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.tableView.mj_footer = _footer;
    
    //下拉刷新的设置
    _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    self.tableView.mj_header = _header;
    
    [MGDRefreshTool setUPHeader:_header AndFooter:_footer];
}


#pragma mark 帖子列表的数据源和代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    CGFloat imageHeight;
    if (self.heightArray.count > indexPath.row) {
        // 如果有缓存的高度，取出缓存高度
        height = [self.heightArray[indexPath.row] floatValue];
    }else{
        _item = [[PostItem alloc] initWithDic:self.tableArray[indexPath.row]];
        imageHeight = [_item.pics count] != 0 ? SCREEN_WIDTH * 0.944 / 3 : 0;
        // 计算cell中detailLabel的高度
        NSString *string = [NSString stringWithString:_item.content];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:string];
        NSRange allRange = [string rangeOfString:string];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:PingFangSCRegular size:15] range:allRange];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor]range:allRange];
        NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
            // 获取label的最大宽度
        CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, CGFLOAT_MAX)options:options context:nil];
        height = ceilf(rect.size.height) + _initHeight + imageHeight;
        [self.heightArray addObject:[NSNumber numberWithDouble:height]];
    }
    [PostArchiveTool savePostCellHeightWith:self.heightArray];
    return height;
}

///点击跳转到具体的帖子（与下方commentBtn的事件相同）
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DynamicDetailMainVC *dynamicDetailVC = [[DynamicDetailMainVC alloc]init];
    _item = [[PostItem alloc] initWithDic:self.tableArray[indexPath.row]];
    dynamicDetailVC.post_id = _item.post_id;
    dynamicDetailVC.hidesBottomBarWhenPushed = YES;
    ((ClassTabBar *)self.tabBarController.tabBar).hidden = NO;
    [self.navigationController pushViewController:dynamicDetailVC animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //创建单元格（用复用池）
    ///给每一个cell的identifier设置为唯一的
    NSString *identifier = [NSString stringWithFormat:@"postcell"];
    _item = [[PostItem alloc] initWithDic:self.tableArray[indexPath.row]];
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
        cell.tag = indexPath.row;
        if (cell.tag == 0) {
            cell.layer.cornerRadius = 10;
        }
    }else if (_item.post_id != cell.item.post_id){
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row inSection:0],nil] withRowAnimation:UITableViewRowAnimationNone];
    }
    [cell layoutSubviews];
    [cell layoutIfNeeded];
    return cell;
}

#pragma mark 监听滑动悬停的block方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.NewQAMainPageScrollBlock) {
        self.NewQAMainPageScrollBlock(scrollView.contentOffset.y);
    }
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
