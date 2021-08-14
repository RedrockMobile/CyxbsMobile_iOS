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
// controller
#import "PurchaseinfoViewController.h"

@interface DetailsMainViewController ()
<UITableViewDelegate, SegmentViewDelegate>

/// 分隔栏
@property (nonatomic, strong) SegmentView * segmentView;
/// 水平滑动背景
@property (nonatomic, strong) UIScrollView * horizontalScrollView;
/// 兑换记录
@property (nonatomic, strong) DetailsGoodsTableView * DetailsGoodsTableView;
/// 获取记录
@property (nonatomic, strong) DetailsTasksTableView * DetailsTasksTableView;

/// 任务
@property (nonatomic, copy) NSArray * tasksAry;
/// 兑换记录
@property (nonatomic, copy) NSArray * goodsAry;

@end

@implementation DetailsMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureData];
    [self configureView];
}

- (void)dealloc {
    // 移除KVO，否则会导致错误
    [self.horizontalScrollView removeObserver:self forKeyPath:@"contentOffset"];
}

#pragma mark - configure

- (void)configureData {
    self.tasksAry = [DetailsTaskModel getDatalist];
    self.goodsAry = [DetailsGoodsModel getDataList];
}

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
    [self.horizontalScrollView addSubview:self.DetailsGoodsTableView];
    self.DetailsGoodsTableView.frame = bounds;
    self.DetailsGoodsTableView.dataAry = self.goodsAry;
    
    // DetailsTasksTableView
    [self.horizontalScrollView addSubview:self.DetailsTasksTableView];
    bounds.origin.x += bounds.size.width;
    self.DetailsTasksTableView.frame = bounds;
    self.DetailsTasksTableView.dataAry = self.tasksAry;

}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    CGPoint offset = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue];
    self.segmentView.selectedIndex = (NSInteger)offset.x / self.horizontalScrollView.frame.size.width + 0.5;
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
    if ([tableView isEqual:self.DetailsTasksTableView]) {
        return;
    }
    DetailsGoodsModel * model = self.goodsAry[indexPath.row];
    PurchaseinfoViewController * VC = [[PurchaseinfoViewController alloc] initWithgoodsName:model.goods_name orderID:model.order_id date:model.date  price:model.goods_price received:model.is_received];
    [self.navigationController pushViewController:VC animated:YES];
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

- (DetailsGoodsTableView *)DetailsGoodsTableView {
    if (_DetailsGoodsTableView == nil) {
        _DetailsGoodsTableView = [[DetailsGoodsTableView alloc] initWithFrame:(CGRectZero) style:(UITableViewStylePlain)];
        _DetailsGoodsTableView.delegate = self;
        _DetailsGoodsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _DetailsGoodsTableView;
}

- (DetailsTasksTableView *)DetailsTasksTableView {
    if (_DetailsTasksTableView == nil) {
        _DetailsTasksTableView = [[DetailsTasksTableView alloc] initWithFrame:(CGRectZero) style:(UITableViewStylePlain)];
        _DetailsTasksTableView.delegate = self;
        _DetailsTasksTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _DetailsTasksTableView;
}

@end
