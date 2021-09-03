//
//  FeedBackDetailsViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/8/23.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "FeedBackDetailsViewController.h"
//view
#import "FeedBackDetailsTableViewCell.h"
#import "FeedBackReplyTableViewCell.h"
#import "HistoricalFBDefaultView.h"
//model
#import "FeedBackDetailsRequestDataModel.h"

@interface FeedBackDetailsViewController ()
<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) long feedback_id;

/// 展示反馈和回复
@property (nonatomic, strong) UITableView * feedBackDetailsTableView;
/// 刷新
@property (nonatomic, strong) MJRefreshStateHeader * feedBackStateHeader;
/// 缺省
@property (nonatomic, strong) HistoricalFBDefaultView * defaultView;

/// 储存数据的数组
@property (nonatomic, copy) NSArray * detailsAry;
/*
 [
    detailsModel,
    [
        replyModel,
        replyModel...
    ]
 ]
 */

@end

@implementation FeedBackDetailsViewController

- (instancetype)initWithFeedBackID:(long)feedback_id {
    self = [super init];
    if (self) {
        _feedback_id = feedback_id;
    }
    return self;
}

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
    CGRect bounds = self.view.bounds;
    bounds.size.height -= [self getTopBarViewHeight];
    bounds.origin.y += [self getTopBarViewHeight];
    self.feedBackDetailsTableView.frame = bounds;
    [self.feedBackDetailsTableView.mj_header beginRefreshing];
    
    // config defaultView
    CGFloat height = (131.f / 812) * SCREEN_HEIGHT;
    self.feedBackDetailsTableView.tableFooterView = self.defaultView;
    CGRect f_defaultView = bounds;
    f_defaultView.size.height = height;
    self.defaultView.frame = f_defaultView;
    
}

#pragma mark - tableview delegate & data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.detailsAry.count;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return ((NSArray *)self.detailsAry[section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        FeedBackDetailsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier(FeedBackDetailsTableViewCell)];
        cell.cellModel = self.detailsAry[indexPath.section];
        return cell;
    } else {
        FeedBackReplyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier(FeedBackReplyTableViewCell)];
        cell.cellModel = self.detailsAry[indexPath.section][indexPath.row];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        FeedBackDetailsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier(FeedBackDetailsTableViewCell)];
        cell.bounds = tableView.bounds;
        cell.cellModel = self.detailsAry[indexPath.section];
        return cell.height;
    } else {
        FeedBackReplyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier(FeedBackReplyTableViewCell)];
        cell.bounds = tableView.bounds;
        cell.cellModel = self.detailsAry[indexPath.section];
        return cell.height;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - mj_refresh

- (void)refreshFeedBackDetails {
    [FeedBackDetailsRequestDataModel getDataAryWithFeedBackID:self.feedback_id Success:^(NSArray * _Nonnull array) {
        self.detailsAry = array;
        [self.feedBackDetailsTableView reloadData];
        if (self.detailsAry.count == 2) {
            self.defaultView.hidden = YES;
        } else if (self.detailsAry.count == 1) {
            self.defaultView.hidden = NO;
        }
        [self.feedBackDetailsTableView.mj_header endRefreshing];
    } failure:^{
        [self.feedBackDetailsTableView.mj_header endRefreshing];
    }];
}


#pragma mark - getter

- (UITableView *)feedBackDetailsTableView {
    if (_feedBackDetailsTableView == nil) {
        _feedBackDetailsTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _feedBackDetailsTableView.delegate = self;
        _feedBackDetailsTableView.dataSource = self;
        _feedBackDetailsTableView.backgroundColor = [UIColor clearColor];
        [_feedBackDetailsTableView registerClass:FeedBackDetailsTableViewCell.class
                          forCellReuseIdentifier:reuseIdentifier(FeedBackDetailsTableViewCell)];
        [_feedBackDetailsTableView registerClass:FeedBackReplyTableViewCell.class
                          forCellReuseIdentifier:reuseIdentifier(FeedBackReplyTableViewCell)];
        _feedBackDetailsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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

- (HistoricalFBDefaultView *)defaultView {
    if (_defaultView == nil) {
        _defaultView = [[HistoricalFBDefaultView alloc] initWithFrame:CGRectZero];
        [_defaultView setText:@"还没有收到回复哦~再等等吧！" ImgWithName:@"缺省_未回复"];
    }
    return _defaultView;
}

@end
