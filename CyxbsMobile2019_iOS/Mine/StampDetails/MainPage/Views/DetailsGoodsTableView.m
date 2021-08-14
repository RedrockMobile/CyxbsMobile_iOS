//
//  DetailsgoodsTableView.m
//  Details
//
//  Created by Edioth Jin on 2021/8/6.
//

#import "DetailsGoodsTableView.h"
// views
#import "DetailsGoodsTableViewCell.h"
// models

@interface DetailsGoodsTableView ()
<UITableViewDataSource>

@end

@implementation DetailsGoodsTableView

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
    
    [self registerClass:[DetailsGoodsTableViewCell class] forCellReuseIdentifier:NSStringFromClass([DetailsGoodsTableViewCell class])];
    self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
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
    DetailsGoodsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DetailsGoodsTableViewCell class])];
    
    cell.cellModel = self.dataAry[indexPath.row];
    
    return cell;
}

#pragma mark - setter

- (void)setDataMAry:(NSArray *)dataAry {
   _dataAry = dataAry;
   [self reloadData];
}
@end
