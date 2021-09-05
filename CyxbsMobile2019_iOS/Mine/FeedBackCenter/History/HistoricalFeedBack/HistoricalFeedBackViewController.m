//
//  HistoricalFeedBackViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/8/23.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "HistoricalFeedBackViewController.h"
// view
#import "HistoricalFeedBackTableView.h"
#import "FeedBackDefaultView.h"
// controller
#import "FeedBackDetailsViewController.h"

@interface HistoricalFeedBackViewController ()
<UITableViewDelegate>

/// 展示历史记录的 table
@property (nonatomic, strong) HistoricalFeedBackTableView * historicalFeedBackTableView;
/// table 的头视图刷新
@property (nonatomic, strong) MJRefreshStateHeader * feedBackStateHeader;
/// 缺省
@property (nonatomic, strong) FeedBackDefaultView * defaultView;

/// 储存数据的数组
@property (nonatomic, copy) NSArray * feedBackAry;

@end

@implementation HistoricalFeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureView];
}

- (void)configureView {
    // config self
    self.view.backgroundColor = [UIColor colorNamed:@"242_243_248_1&29_29_29_1"];
    self.VCTitleStr = @"历史反馈";
    self.titlePosition = TopBarViewTitlePositionLeft;
    self.splitLineColor = [UIColor colorNamed:@"221_230_244_1&43_44_45_1"];
    self.titleFont = [UIFont fontWithName:PingFangSCBold size:22];
    self.titleColor = [UIColor colorNamed:@"21_49_91_1&240_240_242_1"];
    
    // config historicalFeedBackTableView
    [self.view addSubview:self.historicalFeedBackTableView];
    [self.historicalFeedBackTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.topBarView.mas_bottom);
    }];
    [self.historicalFeedBackTableView.mj_header beginRefreshing];
    
    // config defaultView
    [self.historicalFeedBackTableView addSubview:self.defaultView];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.historicalFeedBackTableView);
    }];
    self.defaultView.hidden = YES;
}

#pragma mark - mj_refresh

- (void)refreshHistoricalFeedBack {
    [FeedBackModel getDataArySuccess:^(NSArray * _Nonnull array) {
        self.feedBackAry = array;
        self.historicalFeedBackTableView.row = self.feedBackAry.count;
        if (self.feedBackAry.count == 0) {
            self.defaultView.hidden = NO;
        } else {
            self.defaultView.hidden = YES;
        }
        [self.historicalFeedBackTableView.mj_header endRefreshing];
    } failure:^{
        [self.historicalFeedBackTableView.mj_header endRefreshing];
    }];
}

#pragma mark - table delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    FeedBackTableViewCell * feedBackCell = (FeedBackTableViewCell *)cell;
    feedBackCell.cellModel = self.feedBackAry[indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FeedBackModel * model = self.feedBackAry[indexPath.row];
    if (model.replied == true) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"feedback_history_%zd", model.ID]];
    }
    
    FeedBackDetailsViewController * vc = [[FeedBackDetailsViewController alloc] initWithFeedBackID:model.ID whenPopCompletion:^{
        [self.historicalFeedBackTableView reloadData];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - getter

- (HistoricalFeedBackTableView *)historicalFeedBackTableView {
    if (_historicalFeedBackTableView == nil) {
        _historicalFeedBackTableView = [[HistoricalFeedBackTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _historicalFeedBackTableView.delegate = self;
        _historicalFeedBackTableView.mj_header = self.feedBackStateHeader;
    }
    return _historicalFeedBackTableView;
}

- (MJRefreshStateHeader *)feedBackStateHeader {
    if (_feedBackStateHeader == nil) {
        _feedBackStateHeader = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHistoricalFeedBack)];
        _feedBackStateHeader.lastUpdatedTimeLabel.hidden = YES;
    }
    return _feedBackStateHeader;
}

- (FeedBackDefaultView *)defaultView {
    if (_defaultView == nil) {
        _defaultView = [[FeedBackDefaultView alloc] initWithFrame:CGRectZero];
        [_defaultView setText:@"你还没有提交过反馈意见哦~"
                  ImgWithName:@"缺省_无记录"];
    }
    return _defaultView;
}

@end
