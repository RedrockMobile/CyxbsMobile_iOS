//
//  FeedBackDetailsViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/8/23.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "FeedBackDetailsViewController.h"
//view
#import "FeedBackDetailsTableView.h"
//model
#import "FeedBackDetailsRequestDataModel.h"

@interface FeedBackDetailsViewController ()
<UITableViewDelegate>

/// 展示反馈和回复
@property (nonatomic, strong) FeedBackDetailsTableView * feedBackDetailsTableView;
/// 刷新
@property (nonatomic, strong) MJRefreshStateHeader * feedBackStateHeader;

/// 储存数据的数组
@property (nonatomic, copy) NSArray * detailsAry;

@end

@implementation FeedBackDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureView];
}

#pragma mark - config

- (void)configureView {
    // config self
    self.view.backgroundColor = [UIColor colorNamed:@"242_243_248_1&29_29_29_1"];
    self.VCTitleStr = @"历史反馈";
    self.titlePosition = TopBarViewTitlePositionLeft;
    self.splitLineColor = [UIColor colorNamed:@"221_230_244_1&43_44_45_1"];
    self.titleFont = [UIFont fontWithName:PingFangSCBold size:22];
    self.titleColor = [UIColor colorNamed:@"21_49_91_1&240_240_242_1"];
    
    // config feedBackDetailsTableView
    [self.view addSubview:self.feedBackDetailsTableView];
    [self.feedBackDetailsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.topBarView.mas_bottom);
    }];
    [self.feedBackDetailsTableView.mj_header beginRefreshing];
    
}

#pragma mark - tableview delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        FeedBackDetailsTableViewCell * detailsCell = (FeedBackDetailsTableViewCell *)cell;
        detailsCell.cellModel = self.detailsAry[indexPath.section];
    } else {
        FeedBackReplyTableViewCell * replyCell = (FeedBackReplyTableViewCell *)cell;
        
    }
}

#pragma mark - mj_refresh

- (void)refreshFeedBackDetails {
    [FeedBackDetailsRequestDataModel getDataArySuccess:^(NSArray * _Nonnull array) {
        self.detailsAry = array;
        self.feedBackDetailsTableView.section = self.detailsAry.count;
        [self.feedBackDetailsTableView.mj_header endRefreshing];
    } failure:^{
        [self.feedBackDetailsTableView.mj_header endRefreshing];
    }];
}


#pragma mark - getter

- (FeedBackDetailsTableView *)feedBackDetailsTableView {
    if (_feedBackDetailsTableView == nil) {
        _feedBackDetailsTableView = [[FeedBackDetailsTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _feedBackDetailsTableView.delegate = self;
        _feedBackDetailsTableView.mj_header = self.feedBackStateHeader;
    }
    return _feedBackDetailsTableView;
}

- (MJRefreshStateHeader *)feedBackStateHeader {
    if (_feedBackStateHeader == nil) {
        _feedBackStateHeader = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshFeedBackDetails)];
        _feedBackStateHeader.lastUpdatedTimeLabel.hidden = YES;
    }
    return _feedBackStateHeader;
}

@end
