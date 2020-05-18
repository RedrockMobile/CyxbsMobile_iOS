//
//  MyGoodsViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/5/1.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "MyGoodsViewController.h"
#import "MyGoodsContentView.h"
#import "MyGoodsPresenter.h"
#import "MyGoodsProtocol.h"
#import "MyGoodsItem.h"
#import "MyGoodsTableViewCell.h"

@interface MyGoodsViewController () <MyGoodsProtocol, MyGoodsContentViewDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) MyGoodsPresenter *presenter;

@property (nonatomic, weak) MyGoodsContentView *contentView;

/// 已领取的商品列表
@property (nonatomic, strong) NSMutableArray<MyGoodsItem *> *recievedItemsArray;

/// 未领取的商品列表
@property (nonatomic, strong) NSMutableArray<MyGoodsItem *> *didNotRecievedItemsArray;

/// 加载的页数，用于上拉加载
@property (nonatomic, assign) int loadPage;

@end


@implementation MyGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化属性
    self.recievedItemsArray = [NSMutableArray array];
    self.didNotRecievedItemsArray = [NSMutableArray array];
    self.loadPage = 1;
    
    // 绑定presenter
    MyGoodsPresenter *presenter = [[MyGoodsPresenter alloc] init];
    [presenter attatchView:self];
    self.presenter = presenter;
    
    
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = [UIColor systemBackgroundColor];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
    MyGoodsContentView *contentview = [[MyGoodsContentView alloc] initWithFrame:self.view.bounds];
    contentview.delegate = self;
    [self.view addSubview:contentview];
    self.contentView = contentview;
    
    self.contentView.didNotRecievedTableView.dataSource = self;
    self.contentView.recievedTableView.dataSource = self;
    self.contentView.didNotRecievedTableView.delegate = self;
    self.contentView.recievedTableView.delegate = self;
    self.contentView.scrollView.delegate = self;
    [self.contentView.recievedTableView registerClass:[MyGoodsTableViewCell class] forCellReuseIdentifier:@"MyGoodsTableViewCell"];
    [self.contentView.didNotRecievedTableView registerClass:[MyGoodsTableViewCell class] forCellReuseIdentifier:@"MyGoodsTableViewCell"];

    
    // 请求数据
    [self.presenter requestMyGoodsDataWithPage:@"1" andSize:@"6"];
}

- (void)dealloc
{
    [self.presenter dettatchView];
}


#pragma mark - TableView数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.didNotRecievedItemsArray.count != 0 && !self.contentView.didNotRecievedTableView.mj_footer) {
        self.contentView.didNotRecievedTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    }
    if (self.recievedItemsArray.count != 0 && !self.contentView.recievedTableView.mj_footer) {
        self.contentView.recievedTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.contentView.recievedTableView) {
        return self.recievedItemsArray.count;
    } else {
        return self.didNotRecievedItemsArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyGoodsTableViewCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[MyGoodsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyGoodsCellID"];
    }
    
    if (tableView == self.contentView.recievedTableView) {
        NSURL *imgURL = [NSURL URLWithString:self.recievedItemsArray[indexPath.row].photo_src];
        [cell.photoImageView sd_setImageWithURL:imgURL placeholderImage:nil options:SDWebImageRefreshCached];
        cell.nameLabel.text = self.recievedItemsArray[indexPath.row].name;
        cell.timeLabel.text = [NSString stringWithFormat:@"兑换时间：%@", self.recievedItemsArray[indexPath.row].time];
        cell.integralLabel.text = self.recievedItemsArray[indexPath.row].value;
        cell.numLabel.text = [NSString stringWithFormat:@"数量：%@", self.recievedItemsArray[indexPath.row].num];
    } else {
        NSURL *imgURL = [NSURL URLWithString:self.didNotRecievedItemsArray[indexPath.row].photo_src];
        [cell.photoImageView sd_setImageWithURL:imgURL placeholderImage:nil options:SDWebImageRefreshCached];
        cell.nameLabel.text = self.didNotRecievedItemsArray[indexPath.row].name;
        cell.timeLabel.text = [NSString stringWithFormat:@"兑换时间：%@", self.didNotRecievedItemsArray[indexPath.row].time];
        cell.integralLabel.text = self.didNotRecievedItemsArray[indexPath.row].value;
        cell.numLabel.text = [NSString stringWithFormat:@"数量：%@", self.didNotRecievedItemsArray[indexPath.row].num];
    }
    
    return cell;
}


#pragma mark - TableVeiw代理
// 这四个代理方法用于解决tableview顶部和底部的空白问题
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}


#pragma mark - scrollView代理

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.contentView.scrollView && scrollView.contentOffset.x == 0) {
        CAKeyframeAnimation *scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        NSArray *shapes = @[@1.1, @1.1, @1.15, @1.15, @1.1, @1];
        [scale setDuration:0.5];
        [scale setValues:shapes];
        [scale setRemovedOnCompletion:NO];
        [scale setFillMode:kCAFillModeBoth];
        [self.contentView.didNotRecievedButton.layer addAnimation:scale forKey:@"transform.scale"];
        
        self.contentView.didNotRecievedButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:21];
        self.contentView.didNotRecievedButton.alpha = 1;
        
        self.contentView.recievedButton.titleLabel.font = [UIFont systemFontOfSize:15];
        self.contentView.recievedButton.alpha = 0.49;
    } else if (scrollView == self.contentView.scrollView && scrollView.contentOffset.x == MAIN_SCREEN_W) {
        CAKeyframeAnimation *scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        NSArray *shapes = @[@1.1, @1.1, @1.15, @1.15, @1.1, @1];
        [scale setDuration:0.5];
        [scale setValues:shapes];
        [scale setRemovedOnCompletion:NO];
        [scale setFillMode:kCAFillModeBoth];
        [self.contentView.recievedButton.layer addAnimation:scale forKey:@"transform.scale"];
        
        
        self.contentView.recievedButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:21];
        self.contentView.recievedButton.alpha = 1;
        
        self.contentView.didNotRecievedButton.titleLabel.font = [UIFont systemFontOfSize:15];
        self.contentView.didNotRecievedButton.alpha = 0.49;
    }
}


#pragma mark - contentView代理回调
- (void)backButtonClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didNotRecievedButtonClicked:(UIButton *)sender {
    
    [self.contentView.scrollView scrollToLeft];
}

- (void)recievedButtonClicked:(UIButton *)sender {
    
    [self.contentView.scrollView scrollToRight];
}


#pragma mark - Presenter回调
- (void)myGoodsDataRequestsSuccessWithRecievedArray:(NSArray<MyGoodsItem *> *)recievd andDidNotRecievedArray:(NSMutableArray<MyGoodsItem *> *)didNotRicieved {
    
    self.recievedItemsArray = [[self.recievedItemsArray arrayByAddingObjectsFromArray:recievd] mutableCopy];
    self.didNotRecievedItemsArray = [[self.didNotRecievedItemsArray arrayByAddingObjectsFromArray:didNotRicieved] mutableCopy];
    
    self.loadPage++;
    
    [self.contentView.recievedTableView reloadData];
    [self.contentView.didNotRecievedTableView reloadData];
    
    [self.contentView.recievedTableView.mj_footer endRefreshing];
    [self.contentView.recievedTableView.mj_footer endRefreshing];
}

- (void)myGoodsDataRequestsFailure:(NSError *)error {
    NSLog(@"%@", error);
}


#pragma mark - 上拉加载
- (void)loadData {
    [self.presenter requestMyGoodsDataWithPage:[NSString stringWithFormat:@"%i", self.loadPage] andSize:@"6"];
}

@end
