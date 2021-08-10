//
//  DetailsMainViewController.m
//  Details
//
//  Created by Edioth Jin on 2021/8/3.
//

#import "DetailsMainViewController.h"
// views
#import "DetailsCustomizeNavigationBar.h"
#import "SegmentView.h"
#import "DetailsCommoditiesTableView.h"
#import "DetailsCommodityTableViewCell.h"
#import "DetailsTasksTableView.h"
#import "DetailsTaskTableViewCell.h"
// models
#import "DetailsTaskModel.h"
#import "DetailsCommodityModel.h"
// controller
#import "PurchaseinfoViewController.h"

@interface DetailsMainViewController ()
<UITableViewDelegate, CustomizeNavigationItemsDelegate, SegmentViewDelegate>

/// 自定义导航栏
@property (nonatomic, strong) DetailsCustomizeNavigationBar * navBar;
/// 分隔栏
@property (nonatomic, strong) SegmentView * segmentView;
/// 水平滑动背景
@property (nonatomic, strong) UIScrollView * horizontalScrollView;
/// 兑换记录
@property (nonatomic, strong) DetailsCommoditiesTableView * DetailsCommoditiesTableView;
/// 获取记录
@property (nonatomic, strong) DetailsTasksTableView * DetailsTasksTableView;

/// 任务
@property (nonatomic, copy) NSArray * tasksAry;
/// 兑换记录
@property (nonatomic, copy) NSArray * commoditiesAry;

@end

@implementation DetailsMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureData];
    [self configureView];
}

#pragma mark - configure

- (void)configureData {
    self.tasksAry = [DetailsTaskModel getDatalist];
    self.commoditiesAry = [DetailsCommodityModel getDataList];
}

- (void)configureView {
    self.view.backgroundColor = [UIColor colorNamed:@"242_243_248_1"];

    CGSize size = self.view.frame.size;
    // navBar
    [self.view addSubview:self.navBar];

    // segmentView
    [self.view addSubview:self.segmentView];
    self.segmentView.frame = CGRectMake(0, self.navBar.height, size.width, 56);
    
    // horizontalScrollView
    [self.view addSubview:self.horizontalScrollView];
    self.horizontalScrollView.frame = CGRectMake(0, CGRectGetMaxY(self.segmentView.frame), size.width, size.height - CGRectGetMaxY(self.segmentView.frame));
    self.horizontalScrollView.contentSize = CGSizeMake(self.horizontalScrollView.frame.size.width * 2, 0);
    self.horizontalScrollView.contentOffset = CGPointMake(0, 0);
    
    CGRect bounds = self.horizontalScrollView.bounds;
    // DetailsCommoditiesTableView
    [self.horizontalScrollView addSubview:self.DetailsCommoditiesTableView];
    self.DetailsCommoditiesTableView.frame = bounds;
    self.DetailsCommoditiesTableView.dataAry = self.commoditiesAry;
    
    // DetailsTasksTableView
    [self.horizontalScrollView addSubview:self.DetailsTasksTableView];
    bounds.origin.x += bounds.size.width;
    self.DetailsTasksTableView.frame = bounds;
    self.DetailsTasksTableView.dataAry = self.tasksAry;

    [self.view bringSubviewToFront:self.navBar];
}

#pragma mark - observer

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    CGPoint offset = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue];
    self.segmentView.selectedIndex = (NSInteger)offset.x / self.horizontalScrollView.frame.size.width + 0.5;
}

#pragma mark - delegate & data source
//MARK:CustomizeNavigationItemsDelegate
- (void)DetailsCustomizeNavigationBarDidClickBack:(DetailsCustomizeNavigationBar *)DetailsCustomizeNavigationBar {
    // 删除 KVO 否则会导致错误
    [self.horizontalScrollView removeObserver:self forKeyPath:@"contentOffset"];
    [self.navigationController popViewControllerAnimated:YES];
}

//MARK:SegmentViewDelegate
- (void)segmentView:(SegmentView *)segmentView alertWithIndex:(NSInteger)index {
    NSLog(@"%zd", index);
    [UIView animateWithDuration:0.5 animations:^{
        self.horizontalScrollView.contentOffset = CGPointMake(self.view.frame.size.width * index, 0);
    }];
}

//MARK:table view delegate & data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([tableView isEqual:self.DetailsTasksTableView]) {
        return;
    }
    DetailsCommodityModel * model = self.commoditiesAry[indexPath.row];
    PurchaseinfoViewController * VC = [[PurchaseinfoViewController alloc] initWithcommodityName:model.commodity_name orderID:model.order_id date:model.date moment:model.moment price:model.price received:model.isCollected];
    [self.navigationController pushViewController:VC animated:YES];
}


#pragma mark - getter

- (DetailsCustomizeNavigationBar *)navBar {
    if (_navBar == nil) {
        _navBar = [[DetailsCustomizeNavigationBar alloc] initWithTitle:@"邮票明细"];
        _navBar.delegate = self;
    }
    return _navBar;
}

- (SegmentView *)segmentView {
    if (_segmentView == nil) {
        _segmentView = [[SegmentView alloc] initWithFrame:(CGRectZero)];
        _segmentView.titles = @[@"兑换详情", @"获取详情"];
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

- (DetailsCommoditiesTableView *)DetailsCommoditiesTableView {
    if (_DetailsCommoditiesTableView == nil) {
        _DetailsCommoditiesTableView = [[DetailsCommoditiesTableView alloc] initWithFrame:(CGRectZero) style:(UITableViewStylePlain)];
        _DetailsCommoditiesTableView.delegate = self;
        _DetailsCommoditiesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _DetailsCommoditiesTableView;
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
