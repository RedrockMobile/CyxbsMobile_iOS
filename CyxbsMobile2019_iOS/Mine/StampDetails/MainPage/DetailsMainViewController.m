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
    [self.detailsGoodsTableView.mj_header beginRefreshing];
    
    // DetailsTasksTableView
    [self.horizontalScrollView addSubview:self.detailsTasksTableView];
    bounds.origin.x += bounds.size.width;
    self.detailsTasksTableView.frame = bounds;
    [self.detailsTasksTableView.mj_header beginRefreshing];
    
    // 一个向上滑的动画
    self.horizontalScrollView.layer.affineTransform = CGAffineTransformMakeTranslation(0, size.height);
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:1 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.horizontalScrollView.layer.affineTransform = CGAffineTransformMakeTranslation(0, 0);
    } completion:nil];
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

#pragma mark - delegate & data source
//MARK:SegmentViewDelegate
- (void)segmentView:(SegmentView *)segmentView alertWithIndex:(NSInteger)index {
    NSLog(@"%zd", index);
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

#pragma mark - MJRefresh

- (void)refreshGoods {
    // 兑换记录的数据
    [DetailsGoodsModel getDataArySuccess:^(NSArray * _Nonnull array) {
        self.goodsAry = array;
        self.detailsGoodsTableView.dataAry = self.goodsAry;
        [self.goodsRefreshHeader endRefreshing];
    } failure:^(NSString * _Nonnull failureStr) {
            
        [self.goodsRefreshHeader endRefreshing];
    }];
}

- (void)refreshTasks {
    // 获取记录的数据
    [DetailsTaskModel getDataAryWithPage:1 Size:10 Success:^(NSArray * _Nonnull array) {
        self.tasksAry = array;
        self.detailsTasksTableView.dataAry = self.tasksAry;
        [self.tasksRefreshHeader endRefreshing];
    } failure:^(void) {
        
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
            
    }];
    
    NSLog(@"上拉加载更多");
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
        _horizontalScrollView.backgroundColor = [UIColor clearColor];
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

@end
