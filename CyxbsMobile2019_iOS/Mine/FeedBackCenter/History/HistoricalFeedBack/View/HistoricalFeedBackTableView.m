//
//  HistoricalFeedBackTableView.m
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/8/23.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "HistoricalFeedBackTableView.h"

@interface HistoricalFeedBackTableView ()
<UITableViewDataSource>

@end

@implementation HistoricalFeedBackTableView

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self configureView];
    }
    return self;
}

- (void)configureView {
    self.dataSource = self;
    self.backgroundColor = [UIColor clearColor];
    self.rowHeight = 74;
    
    [self registerClass:[FeedBackTableViewCell class] forCellReuseIdentifier:reuseIdentifier(FeedBackTableViewCell)];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - setter

- (void)setRow:(NSInteger)row {
    _row = row;
    [self reloadData];
}

#pragma mark - data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeedBackTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier(FeedBackTableViewCell)];
    return cell;
}

@end
