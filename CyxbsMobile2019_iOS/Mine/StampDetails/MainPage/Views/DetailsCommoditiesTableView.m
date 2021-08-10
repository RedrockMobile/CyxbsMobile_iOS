//
//  DetailsCommoditiesTableView.m
//  Details
//
//  Created by Edioth Jin on 2021/8/6.
//

#import "DetailsCommoditiesTableView.h"
// views
#import "DetailsCommodityTableViewCell.h"
// models

@interface DetailsCommoditiesTableView ()
<UITableViewDataSource>

@end

@implementation DetailsCommoditiesTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self configureView];
    }
    return self;
}

- (void)configureView {
    self.dataSource = self;
    self.backgroundColor = [UIColor whiteColor];
    self.rowHeight = 74;
    
    [self registerClass:[DetailsCommodityTableViewCell class] forCellReuseIdentifier:NSStringFromClass([DetailsCommodityTableViewCell class])];
    self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

#pragma mark - setter

- (void)setDataMAry:(NSArray *)dataAry {
   _dataAry = dataAry;
   [self reloadData];
}

#pragma mark - delegate
//MARK:table view delegate & data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.dataAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailsCommodityTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DetailsCommodityTableViewCell class])];
    
    cell.cellModel = self.dataAry[indexPath.row];
    
    return cell;
}

@end
