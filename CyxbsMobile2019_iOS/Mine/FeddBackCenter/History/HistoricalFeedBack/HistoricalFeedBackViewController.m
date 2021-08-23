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

@interface HistoricalFeedBackViewController ()
<UITableViewDelegate>

/// 展示历史记录的 table
@property (nonatomic, strong) HistoricalFeedBackTableView * historicalFeedBackTableView;

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
    self.splitLineColor = [UIColor colorNamed:@"42_78_132_1&223_223_227_1"];
    self.titleFont = [UIFont fontWithName:PingFangSCBold size:22];
    self.titleColor = [UIColor colorNamed:@"21_49_91_1&240_240_242_1"];
    
}

#pragma mark - getter

- (HistoricalFeedBackTableView *)historicalFeedBackTableView {
    if (_historicalFeedBackTableView == nil) {
        _historicalFeedBackTableView = [[HistoricalFeedBackTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _historicalFeedBackTableView.delegate = self;
    }
    return _historicalFeedBackTableView;
}

@end
