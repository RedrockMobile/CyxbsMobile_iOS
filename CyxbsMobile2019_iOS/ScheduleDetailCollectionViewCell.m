//
//  ScheduleDetailCollectionViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/10/18.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleDetailCollectionViewCell.h"

#import "ScheduleDetailMessageTableViewCell.h"

NSString *ScheduleDetailCollectionViewCellReuseIdentifier = @"ScheduleDetailCollectionViewCellReuseIdentifier";

#pragma mark - ScheduleDetailCollectionViewCell ()

@interface ScheduleDetailCollectionViewCell () <
    UITableViewDataSource
>

/// table veiw
@property (nonatomic, strong) UITableView *tableView;

@end

#pragma mark - ScheduleDetailCollectionViewCell

@implementation ScheduleDetailCollectionViewCell

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.tableView];
    }
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    self.tableView.size = layoutAttributes.size;
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.contentView.SuperFrame style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ScheduleDetailMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ScheduleDetailMessageTableViewCellReuseIdentifier forIndexPath:indexPath];
    
    
    
    return cell;
}

@end
