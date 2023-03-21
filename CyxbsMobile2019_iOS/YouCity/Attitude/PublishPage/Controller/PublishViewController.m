//
//  PublishViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 艾 on 2023/3/8.
//  Copyright © 2023 Redrock. All rights reserved.
//

// VC
#import "PublishViewController.h"
// View
#import "PublishTopView.h"
#import "PublishPageCell.h"
#import "PublishTableAddTagView.h"
#import "PublishTableHeadView.h"

@interface PublishViewController () <
    UITableViewDelegate,
    UITableViewDataSource,
    PublishPageCellDelegate
>
@property (nonatomic, strong) PublishTopView *topView;
@property (nonatomic, strong) UITableView *table;
// 初始4选项
//@property (nonatomic, copy) NSArray *dataArray;
// 可变数组添加选项
//@property (nonatomic, strong) NSMutableArray *muteDataArray;
// 获取tableview的高度
@property (nonatomic, assign) CGFloat tableViewHeight;

@property (nonatomic, strong) PublishTableAddTagView *addTagView;
@property (nonatomic, strong) PublishTableHeadView *headerView;
@end

@implementation PublishViewController {
    NSInteger _count;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _count = 4;
    [self setDefaultTagData];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F2F3F8"];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.addTagView];
    [self.view addSubview:self.table];
    self.table.editing = YES;
}

// 回退页面
- (void)didClickBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

// 初始选项
- (void)setDefaultTagData {
//    self.dataArray = @[@"选项1", @"选项2", @"选项3", @"选项4"];
//    self.muteDataArray = [self.dataArray mutableCopy];
}
// 添加cell方法
- (void)addCell:(UIButton *)button{
    if (_count < 10) {

        [self.table beginUpdates];
        _count += 1;
        [self.table insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        
        // 动态变化tableview高度：增加
        if (self.table.frame.size.height < self.view.frame.size.height - 100) {
            [self tableViewChangeHeight];
        }
        [self.table endUpdates];
    }
    else {
        // 设置提示弹窗🥺
        NSLog(@"最大只能添加10个");
    }
}

#pragma mark - PublishPageCellDelegate
// 点击按钮删除cell
- (void)tableViewCellPressDeleteCell:(PublishPageCell *)cell {
    [self.table beginUpdates];
    _count -= 1;
    [self.table deleteRowsAtIndexPaths:@[[self.table indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationFade];
    // 动态变化tableview高度
    [self tableViewChangeHeight];
    [self.table endUpdates];
}

- (void)tableViewChangeHeight {
    [UIView animateWithDuration:0.3 animations:^{
        NSInteger numberOfCells = [self numberOfSectionsInTableView:self.table];
        // 获取每个cell的高度
        CGFloat cellHeight = [self tableView:self.table heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        // 计算tableview应该展示的高度
        CGFloat newHeight = (numberOfCells + 2) * cellHeight;
        // 设置tableview的高度不能小于最小高度
        newHeight = MAX(newHeight, 50 * 7);
        // 设置tableview的高度
        self.table.frame = CGRectMake(self.table.frame.origin.x, self.table.frame.origin.y, self.table.frame.size.width, newHeight);
    }];
}
#pragma mark - DataSource
// 暂定高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 110;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 100;
}
#pragma mark - Delegate
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    return self.headerView;
//}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.addTagView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"identify";
    PublishPageCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[PublishPageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.tagLabel.text = [NSString stringWithFormat:@"aa%ld", indexPath.row + 1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.delegate = self;
    
    // 删除该行cell方法
//    cell.pressDeleteCell = ^(UITableViewCell * _Nonnull currentCell) {
//        // 1.删除cell
//        NSIndexPath *currentIndex = [self.table indexPathForCell:currentCell];
////        [self.muteDataArray removeObjectAtIndex:currentIndex.row];
//        [self.table beginUpdates];
//        [self.table deleteRowsAtIndexPaths:@[currentIndex] withRowAnimation:UITableViewRowAnimationFade];
//        _count -= 1;
//        [self.table endUpdates];
//        // 2.动态变化tableview高度：缩小
//        [UIView animateWithDuration:0.3 animations:^{
//            // 2.1获取tableview中cell的数量
//            NSInteger numberOfCells = [self numberOfSectionsInTableView:self.table];;
//            // 2.2获取每个cell的高度
//            CGFloat cellHeight = [self.table.delegate tableView:self.table heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//            // 2.3计算tableview应该展示的高度
//                // +2是footer和header也当做两个cell
//            CGFloat newHeight = (numberOfCells + 2) * cellHeight;
//            // 2.4设置tableview的高度不能小于最小高度
//            newHeight = MAX(newHeight, 50 * 7);
//            // 2.5设置tableview的高度
//            self.table.frame = CGRectMake(self.table.frame.origin.x, self.table.frame.origin.y, self.table.frame.size.width, newHeight);
//            // 强制布局
//            [self.view layoutIfNeeded];
//        }];
//    };
    
    return cell;
}

#pragma mark - LazyLoad
- (PublishTopView *)topView {
    if (!_topView) {
        CGFloat h = getStatusBarHeight_Double + 44;
        _topView = [[PublishTopView alloc] initWithTopView];
        _topView.frame = CGRectMake(0, 0, kScreenWidth, h);
        [_topView.backBtn addTarget:self action:@selector(didClickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topView;
}

- (UITableView *)table {
    if (!_table) {
        self.tableViewHeight = 50 * 7;
        _table = [[UITableView alloc] initWithFrame:CGRectMake(15, 200, self.view.frame.size.width - 30, self.tableViewHeight) style:UITableViewStylePlain];
        _table.delegate = self;
        _table.dataSource = self;
        // tableView的圆角，暂定15
        _table.layer.cornerRadius = 15;
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _table;
}

- (PublishTableAddTagView *)addTagView {
    if (!_addTagView) {
        _addTagView = [[PublishTableAddTagView alloc] initWithView];
        _addTagView.backgroundColor = [UIColor whiteColor];
        [_addTagView.btn addTarget:self action:@selector(addCell:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addTagView;
}

- (PublishTableHeadView *)headerView {
    if (!_headerView) {
        _headerView = [[PublishTableHeadView alloc] initWithHeaderView];
        _headerView.frame = CGRectMake(self.table.origin.x, self.table.origin.y - 80, self.view.frame.size.width - 30, 100);
        _headerView.backgroundColor = [UIColor whiteColor];
        _headerView.layer.cornerRadius = 15;
    }
    return _headerView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
