//
//  FeedBackDetailsTableView.m
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/8/23.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "FeedBackDetailsTableView.h"

@interface FeedBackDetailsTableView ()
<UITableViewDataSource>

@end

@implementation FeedBackDetailsTableView

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
    
    [self registerClass:[FeedBackDetailsTableViewCell class] forCellReuseIdentifier:[FeedBackDetailsTableViewCell reuseIdentifier]];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self registerClass:[FeedBackReplyTableViewCell class] forCellReuseIdentifier:[FeedBackReplyTableViewCell reuseIdentifier]];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - setter

- (void)setSection:(NSInteger)section{
    _section = section;
    [self reloadData];
}

#pragma mark - data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.section;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:indexPath.section == 0?
            [FeedBackDetailsTableViewCell reuseIdentifier]:
            [FeedBackReplyTableViewCell reuseIdentifier]];
}

@end
