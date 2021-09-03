//
//  DetailsMainViewController.m
//  Details
//
//  Created by Edioth Jin on 2021/8/3.
//

#import "DetailsMainViewController.h"
// views
//#import "DetailsCustomizeNavigationBar.h"
#import "SegmentView.h"
#import "DetailsGoodsTableView.h"
#import "DetailsGoodsTableViewCell.h"
#import "DetailsTasksTableView.h"
#import "DetailsTaskTableViewCell.h"
// models
#import "DetailsTaskModel.h"
#import "DetailsgoodsModel.h"
// pod
#import <MJRefresh.h> // 用作下拉刷新和上拉加载更多
// controller
#import "PurchaseinfoViewController.h"

@interface DetailsMainViewController ()
<UITableViewDelegate, SegmentViewDelegate>

/// 分隔栏
@property (nonatomic, strong) SegmentView * segmentView;
/// 水平滑动背景
@property (nonatomic, strong) UIScrollView * horizontalScrollView;
/// 兑换记录
@property (nonatomic, strong) DetailsGoodsTableView * detailsGoodsTableView;
/// 兑换记录界面的下拉刷新
@property (nonatomic, strong) MJRefreshStateHeader * goodsRefreshHeader;
/// 获取记录
@property (nonatomic, strong) DetailsTasksTableView * detailsTasksTableView;
/// 获取记录界面的下拉刷新
@property (nonatomic, strong) MJRefreshStateHeader * tasksRefreshHeader;
/// 获取记录界面的上拉加载更多
@property (nonatomic, strong) MJRefreshAutoStateFooter * tasksLoadMoreFooter;

/// 缺省文字1
@property (nonatomic, strong) UILabel * goodsDefaultLabel;
/// 缺省图片1
@property (nonatomic, strong) UIImageView * goodsDefaultImgView;
/// 缺省文字2
@property (nonatomic, strong) UILabel * taskDefaultLabel;
/// 缺省图片2
@property (nonatomic, strong) UIImageView * taskDefaultImgView;
/// 缺省文字3
@property (nonatomic, strong) UILabel * networkFailureLabel1;
/// 缺省图片3
@property (nonatomic, strong) UIImageView * networkFailureImgView1;
/// 缺省文字4
@property (nonatomic, strong) UILabel * networkFailureLabel2;
/// 缺省图片4
@property (nonatomic, strong) UIImageView * networkFailureImgView2;


/// 任务
@property (nonatomic, copy) NSArray * tasksAry;
/// 兑换记录
@property (nonatomic, copy) NSArray * goodsAry;

@end

@implementation DetailsMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureView];
}

- (void)dealloc {
    // 移除KVO，否则会导致错误
    [self.horizontalScrollView removeObserver:self forKeyPath:@"contentOffset"];
}

#pragma mark - configure

- (void)configureView {
    self.view.backgroundColor = [UIColor colorNamed:@"242_243_248_1&0_0_0_1"];
    self.VCTitleStr = @"邮票明细";
    self.titlePosition = TopBarViewTitlePositionLeft;
    self.splitLineColor = [UIColor colorNamed:@"42_78_132_0.1&0_0_0_1"];
    self.titleFont = [UIFont fontWithName:PingFangSCBold size:22];
    
    CGSize size = self.view.frame.size;

    // segmentView
    [self.view addSubview:self.segmentView];
    self.segmentView.frame = CGRectMake(0, [self getTopBarViewHeight], size.width, 56);
    
    // horizontalScrollView
    [self.view addSubview:self.horizontalScrollView];
    self.horizontalScrollView.frame = CGRectMake(0, CGRectGetMaxY(self.segmentView.frame), size.width, size.height - CGRectGetMaxY(self.segmentView.frame));
    self.horizontalScrollView.contentSize = CGSizeMake(self.horizontalScrollView.frame.size.width * 2, 0);
    self.horizontalScrollView.contentOffset = CGPointMake(0, 0);
    
    CGRect bounds = self.horizontalScrollView.bounds;
    // DetailsGoodsTableView
    [self.horizontalScrollView addSubview:self.detailsGoodsTableView];
    self.detailsGoodsTableView.frame = bounds;
    
    // DetailsTasksTableView
    [self.horizontalScrollView addSubview:self.detailsTasksTableView];
    bounds.origin.x += bounds.size.width;
    self.detailsTasksTableView.frame = bounds;
    
    // goods default label
    [self.detailsGoodsTableView addSubview:self.goodsDefaultLabel];
    [self.goodsDefaultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.view);
    }];
    
    [self.detailsGoodsTableView addSubview:self.goodsDefaultImgView];
    [self.goodsDefaultImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.goodsDefaultLabel.mas_top);
    }];
    
    self.goodsDefaultImgView.hidden = YES;
    self.goodsDefaultLabel.hidden = YES;
    
    // task default label
    [self.detailsTasksTableView addSubview:self.taskDefaultLabel];
    [self.taskDefaultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.view);
    }];
    [self.detailsTasksTableView addSubview:self.taskDefaultImgView];
    [self.taskDefaultImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.taskDefaultLabel.mas_top);
    }];
    
    self.taskDefaultLabel.hidden = YES;
    self.taskDefaultImgView.hidden = YES;
    
    // network 缺省1
    [self.detailsGoodsTableView addSubview:self.networkFailureLabel1];
    [self.networkFailureLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.view);
    }];
    [self.detailsGoodsTableView addSubview:self.networkFailureImgView1];
    [self.networkFailureImgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.networkFailureLabel1.mas_top);
    }];
    
    self.networkFailureLabel1.hidden = YES;
    self.networkFailureImgView1.hidden = YES;
    
    // network 缺省2
    [self.detailsTasksTableView addSubview:self.networkFailureLabel2];
    [self.networkFailureLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.view);
    }];
    [self.detailsTasksTableView addSubview:self.networkFailureImgView2];
    [self.networkFailureImgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.networkFailureLabel2.mas_top);
    }];
    
    self.networkFailureLabel2.hidden = YES;
    self.networkFailureImgView2.hidden = YES;
    
    // 一个向上滑的动画
    CGFloat animationTime = 0.4f;
    self.horizontalScrollView.layer.affineTransform = CGAffineTransformMakeTranslation(0, size.height - [self getTopBarViewHeight]);
    [UIView animateWithDuration:animationTime animations:^{
        self.horizontalScrollView.layer.affineTransform = CGAffineTransformMakeTranslation(0, 0);
    } completion:nil];
    // 动画执行完毕再刷新数据
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animationTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 得到数据
        [self.detailsGoodsTableView.mj_header beginRefreshing];
        [self.detailsTasksTableView.mj_header beginRefreshing];
    });
    
    [self.view bringSubviewToFront:self.topBarView];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    CGPoint offset = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue];
    NSInteger currentIndex = (NSInteger)offset.x / self.horizontalScrollView.frame.size.width + 0.5;
    if (self.segmentView.selectedIndex == currentIndex) {
        return;
    }
    self.segmentView.selectedIndex = currentIndex;
}

#pragma mark - delegate
//MARK:SegmentViewDelegate
- (void)segmentView:(SegmentView *)segmentView alertWithIndex:(NSInteger)index {
    [UIView animateWithDuration:0.5 animations:^{
        self.horizontalScrollView.contentOffset = CGPointMake(self.view.frame.size.width * index, 0);
    }];
}

//MARK:table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([tableView isEqual:self.detailsTasksTableView]) {
        return;
    }
    DetailsGoodsModel * model = self.goodsAry[indexPath.row];
    PurchaseinfoViewController * VC = [[PurchaseinfoViewController alloc] initWithgoodsName:model.goods_name orderID:model.order_id date:model.date  price:model.goods_price received:model.is_received];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.detailsGoodsTableView]) {
        DetailsGoodsTableViewCell * goodsCell = (DetailsGoodsTableViewCell *)cell;
        goodsCell.cellModel = self.goodsAry[indexPath.row];
    }
    else if ([tableView isEqual:self.detailsTasksTableView]) {
        DetailsTaskTableViewCell * taskCell = (DetailsTaskTableViewCell *)cell;
        taskCell.cellModel = self.tasksAry[indexPath.row];
    }
}

#pragma mark - MJRefresh

- (void)refreshGoods {
    // 兑换记录的数据
    [DetailsGoodsModel getDataArySuccess:^(NSArray * _Nonnull array) {
        self.goodsAry = array;
        self.detailsGoodsTableView.dataAry = self.goodsAry;
        if (array.count == 0) {
            self.goodsDefaultLabel.hidden = NO;
            self.goodsDefaultImgView.hidden = NO;
        } else {
            self.goodsDefaultLabel.hidden = YES;
            self.goodsDefaultImgView.hidden = YES;
        }
        self.networkFailureLabel1.hidden = YES;
        self.networkFailureImgView1.hidden = YES;
        [self.goodsRefreshHeader endRefreshing];
    } failure:^(void) {
        self.goodsDefaultLabel.hidden = YES;
        self.goodsDefaultImgView.hidden = YES;
        self.networkFailureLabel1.hidden = NO;
        self.networkFailureImgView1.hidden = NO;
        [self.goodsRefreshHeader endRefreshing];
    }];
}

- (void)refreshTasks {
    // 获取记录的数据
    [DetailsTaskModel getDataAryWithPage:1 Size:10 Success:^(NSArray * _Nonnull array) {
        self.tasksAry = array;
        self.detailsTasksTableView.dataAry = self.tasksAry;
        if (array.count == 0) {
            self.taskDefaultLabel.hidden = NO;
            self.taskDefaultImgView.hidden = NO;
        } else {
            self.taskDefaultLabel.hidden = YES;
            self.taskDefaultImgView.hidden = YES;
        }
        self.networkFailureLabel2.hidden = YES;
        self.networkFailureImgView2.hidden = YES;
        [self.tasksRefreshHeader endRefreshing];
    } failure:^(void) {
        self.taskDefaultLabel.hidden = YES;
        self.taskDefaultImgView.hidden = YES;
        self.networkFailureLabel2.hidden = NO;
        self.networkFailureImgView2.hidden = NO;
        [self.tasksRefreshHeader endRefreshing];
    }];
}

- (void)loadMoreTasks {
    [DetailsTaskModel getDataAryWithPage:self.tasksAry.count / 10 + 1 Size:10 Success:^(NSArray * _Nonnull array) {
        NSMutableArray * mAry = [self.tasksAry mutableCopy];
        [mAry addObjectsFromArray:array];
        self.tasksAry = [mAry copy];
        self.detailsTasksTableView.dataAry = self.tasksAry;
        [self.tasksLoadMoreFooter endRefreshing];
    } failure:^{
            
        [self.tasksLoadMoreFooter endRefreshing];
    }];
}

#pragma mark - getter

- (SegmentView *)segmentView {
    if (_segmentView == nil) {
        _segmentView = [[SegmentView alloc] initWithFrame:(CGRectZero)];
        _segmentView.titles = @[@"兑换记录", @"获取记录"];
        _segmentView.delegate = self;
    }
    return _segmentView;
}

- (UIScrollView *)horizontalScrollView {
    if (_horizontalScrollView == nil) {
        _horizontalScrollView = [[UIScrollView alloc] initWithFrame:(CGRectZero)];
        _horizontalScrollView.backgroundColor = [UIColor colorNamed:@"255_255_255_1&29_29_29_1"];
        _horizontalScrollView.showsHorizontalScrollIndicator = NO;
        _horizontalScrollView.pagingEnabled = YES;
        _horizontalScrollView.layer.cornerRadius = 20;
        [_horizontalScrollView addObserver:self forKeyPath:@"contentOffset" options:(NSKeyValueObservingOptionNew) context:nil];
    }
    return _horizontalScrollView;
}

- (DetailsGoodsTableView *)detailsGoodsTableView {
    if (_detailsGoodsTableView == nil) {
        _detailsGoodsTableView = [[DetailsGoodsTableView alloc] initWithFrame:(CGRectZero) style:(UITableViewStylePlain)];
        _detailsGoodsTableView.delegate = self;
        _detailsGoodsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _detailsGoodsTableView.mj_header = self.goodsRefreshHeader;
    }
    return _detailsGoodsTableView;
}

- (MJRefreshStateHeader *)goodsRefreshHeader {
    if (_goodsRefreshHeader == nil) {
        _goodsRefreshHeader = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshGoods)];
        [_goodsRefreshHeader setTitle:@"松开手刷新兑换记录" forState:MJRefreshStatePulling];
        _goodsRefreshHeader.lastUpdatedTimeLabel.hidden = YES;
        _goodsRefreshHeader.automaticallyChangeAlpha = YES;
    }
    return _goodsRefreshHeader;
}

- (DetailsTasksTableView *)detailsTasksTableView {
    if (_detailsTasksTableView == nil) {
        _detailsTasksTableView = [[DetailsTasksTableView alloc] initWithFrame:(CGRectZero) style:(UITableViewStylePlain)];
        _detailsTasksTableView.delegate = self;
        _detailsTasksTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _detailsTasksTableView.mj_footer = self.tasksLoadMoreFooter;
        _detailsTasksTableView.mj_header = self.tasksRefreshHeader;
    }
    return _detailsTasksTableView;
}

- (MJRefreshStateHeader *)tasksRefreshHeader {
    if (_tasksRefreshHeader == nil) {
        _tasksRefreshHeader = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshTasks)];
        [_tasksRefreshHeader setTitle:@"松开手刷新获取记录" forState:MJRefreshStatePulling];
        _tasksRefreshHeader.lastUpdatedTimeLabel.hidden = YES;
        _tasksRefreshHeader.automaticallyChangeAlpha = YES;
    }
    return _tasksRefreshHeader;
}

- (MJRefreshAutoStateFooter *)tasksLoadMoreFooter {
    if (_tasksLoadMoreFooter == nil) {
        _tasksLoadMoreFooter = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTasks)];
        _tasksLoadMoreFooter.automaticallyChangeAlpha = YES;
    }
    return _tasksLoadMoreFooter;
}

- (UILabel *)goodsDefaultLabel {
    if (_goodsDefaultLabel == nil) {
        _goodsDefaultLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _goodsDefaultLabel.textColor = [UIColor colorNamed:@"17_44_84_1&223_223_227_1"];
        _goodsDefaultLabel.text = @"还没有兑换记录哦";
        _goodsDefaultLabel.font = [UIFont fontWithName:PingFangSCMedium size:12];
        [_goodsDefaultLabel sizeToFit];
    }
    return _goodsDefaultLabel;
}

- (UIImageView *)goodsDefaultImgView {
    if (_goodsDefaultImgView == nil) {
        _goodsDefaultImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"details_goods_defaults"]];
        [_goodsDefaultImgView sizeToFit];
    }
    return _goodsDefaultImgView;
}

- (UILabel *)taskDefaultLabel {
    if (_taskDefaultLabel == nil) {
        _taskDefaultLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _taskDefaultLabel.textColor = [UIColor colorNamed:@"17_44_84_1&223_223_227_1"];
        _taskDefaultLabel.text = @"还没有获取记录，快去做任务吧";
        _taskDefaultLabel.font = [UIFont fontWithName:PingFangSCMedium size:12];
        [_taskDefaultLabel sizeToFit];
    }
    return _taskDefaultLabel;
}

- (UIImageView *)taskDefaultImgView {
    if (_taskDefaultImgView == nil) {
        _taskDefaultImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"details_task_defaults"]];
        [_taskDefaultImgView sizeToFit];
    }
    return _taskDefaultImgView;
}

- (UILabel *)networkFailureLabel1 {
    if (_networkFailureLabel1 == nil) {
        _networkFailureLabel1 = [[UILabel alloc] initWithFrame:CGRectZero];
        _networkFailureLabel1.textColor = [UIColor colorNamed:@"17_44_84_1&223_223_227_1"];
        _networkFailureLabel1.text = @"最遥远的距离不是天各一方，而是断网了 TAT";
        _networkFailureLabel1.font = [UIFont fontWithName:PingFangSCMedium size:12];
        [_networkFailureLabel1 sizeToFit];
    }
    return _networkFailureLabel1;
}

- (UIImageView *)networkFailureImgView1 {
    if (_networkFailureImgView1 == nil) {
        _networkFailureImgView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"details_network_failure"]];
        [_networkFailureImgView1 sizeToFit];
    }
    return _networkFailureImgView1;
}

- (UILabel *)networkFailureLabel2 {
    if (_networkFailureLabel2 == nil) {
        _networkFailureLabel2 = [[UILabel alloc] initWithFrame:CGRectZero];
        _networkFailureLabel2.textColor = [UIColor colorNamed:@"17_44_84_1&223_223_227_1"];
        _networkFailureLabel2.text = @"最遥远的距离不是天各一方，而是断网了 TAT";
        _networkFailureLabel2.font = [UIFont fontWithName:PingFangSCMedium size:12];
        [_networkFailureLabel2 sizeToFit];
    }
    return _networkFailureLabel2;
}

- (UIImageView *)networkFailureImgView2 {
    if (_networkFailureImgView2 == nil) {
        _networkFailureImgView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"details_network_failure"]];
        [_networkFailureImgView2 sizeToFit];
    }
    return _networkFailureImgView2;
}

@end
