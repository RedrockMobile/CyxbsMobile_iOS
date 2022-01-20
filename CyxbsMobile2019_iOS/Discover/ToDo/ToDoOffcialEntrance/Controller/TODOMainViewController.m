//
//  TODOMainViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/8/22.
//  Copyright © 2021 Redrock. All rights reserved.
//

//工具类
#import "TodoSyncTool.h"
//controllers
#import "TODOMainViewController.h"
#import "ToDoDetaileViewController.h"

//Model
#import "TodoDataModel.h"

//Views
#import "ToDoMainBarView.h"
#import "ToDoTableView.h"
#import "DiscoverTodoSheetView.h"   //点击添加事项后，弹出来的View
#import "DiscoverTodoView.h"
#import "ToDoEmptyCell.h"
#import "TodoTableViewCell.h"
@interface TODOMainViewController ()<ToDoMainBarViewDelegate,UITableViewDelegate,UITableViewDataSource,DiscoverTodoSheetViewDelegate,TodoTableViewCellDelegate>

/// 顶层的View
@property (nonatomic, strong) ToDoMainBarView *barView;
/// 放置事项的table
@property (nonatomic, strong) ToDoTableView *tableView;

/// 数据源数组
@property (nonatomic, strong) NSMutableArray *dataSourceAry;

/// 是否折叠
@property (nonatomic, assign) BOOL isFold;
@end

@implementation TODOMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    //重置数据库
//    [[TodoSyncTool share] resetDB];
    //一些初始化-
    self.view.backgroundColor = [UIColor colorNamed:@"255_255_255&0_0_0"];
    self.isFold = NO;
    //先获取到数据库的数据，再进行frame设置
    [self  dataFromSqlite];
    
}

#pragma mark- private methonds
///设置frame
- (void)setFrame{
    //顶部的bar
    [self.view addSubview:self.barView];
    [self.barView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_top).offset(NVGBARHEIGHT + STATUSBARHEIGHT);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT * 0.0637));
    }];
    
    //下面的table
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.barView.mas_bottom);
    }];
}
///获取到数据库内的全部数据
- (void)dataFromSqlite{
    TodoSyncTool *synctool = [TodoSyncTool share];
    //得到数据库中所有的数据模型，将其分别赋予数据源数组
    NSArray *array = [synctool getTodoForMainPage];
    for (TodoDataModel *model in array) {
        if (model.isDone) {
            [self.dataSourceAry[1] addObject:model];
        }else{
            [self.dataSourceAry[0] addObject:model];
        }
    }
    //进行界面展示
    [self setFrame];
}
/// 刷新界面
- (void)refresh{
    [self.dataSourceAry removeAllObjects];
    self.dataSourceAry = nil;
    [self dataFromSqlite];
    [self.tableView reloadData];
//        [self.tableView reloadData];
//    [self setFrame];
}

#pragma mark- event methonds
- (void)foldAction{
    self.isFold = !self.isFold;
    [self.tableView reloadData];
}

#pragma mark- Delegate
//MARK:顶部bar的代理方法
/// 返回到上一界面
- (void)popVC{
    [self.navigationController popViewControllerAnimated:YES];
}
/// 添加待办事项
- (void)addMatter{
    DiscoverTodoSheetView* sheetView = [[DiscoverTodoSheetView alloc] init];
    [self.view addSubview:sheetView];
    sheetView.delegate = self;
    //调用show方法让它弹出来
    [sheetView show];
}

//MARK:cell的代理方法
///点击将未完成的cell转移到完成区域
- (void)toDoCellDidClickedThroughCell:(TodoTableViewCell *)toDoCell{
    //禁止table交互防止误触cell
    toDoCell.userInteractionEnabled = NO;
    
    //1.设置cell的属性转换
    [toDoCell.model setIsDoneForUserActivity:!toDoCell.model.isDone];
        //设置btn的icon变换
    [toDoCell.circlebtn setImage:[UIImage imageNamed:@"打勾"] forState:UIControlStateNormal];
        //设置lable的文本划线
    NSAttributedString *attrStr =
    [[NSAttributedString alloc]initWithString:toDoCell.model.titleStr
                                   attributes:
     @{NSFontAttributeName:toDoCell.titleLbl.font,
       NSForegroundColorAttributeName:[UIColor colorNamed:@"112_129_155&255_255_255"],
       NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
       NSStrikethroughColorAttributeName:[UIColor colorNamed:@"137_151_173&240_240_242"]}];
    toDoCell.titleLbl.attributedText = attrStr;
        //进行动画，使得变化不那么僵硬
    NSIndexPath *indexPath = [self.tableView indexPathForCell:toDoCell];
    [self.tableView reloadRow:indexPath.row inSection:indexPath.section withRowAnimation:UITableViewRowAnimationFade];

        //2延迟刷新table
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //2.1从未完成区域中删除
        [self.dataSourceAry[0] removeObjectAtIndex:indexPath.row];
        //2.2添加到已完成区域中的第一行
        [self.dataSourceAry[1] insertObject:toDoCell.model atIndex:0];
        [self.tableView reloadData];
        //恢复tablede交互
        toDoCell.userInteractionEnabled = YES;
    });
    
        //
    [toDoCell.model resetOverdueTime];
    toDoCell.model.lastModifyTime = [NSDate date].timeIntervalSince1970;
    //3.同步本地数据库的数据更改
    [[TodoSyncTool share] alterTodoWithModel:toDoCell.model needRecord:YES];
    
}
///点击将已经完成的cell转移到代办区域
- (void)doneCellDidClickedThroughCell:(TodoTableViewCell *)doneCell{
    //禁止cell交互防止误触导致崩溃
    doneCell.userInteractionEnabled = NO;
    
    //1.设置cell的属性转换
    [doneCell.model setIsDoneForUserActivity:!doneCell.model.isDone];
    [doneCell.circlebtn setImage:[UIImage imageNamed:@"未打勾"] forState:UIControlStateNormal];
    doneCell.titleLbl.text = doneCell.model.titleStr;
    
        //刷新这个cell
    NSIndexPath *indexPath = [self.tableView indexPathForCell:doneCell];
    [self.tableView reloadRow:indexPath.row inSection:indexPath.section withRowAnimation:UITableViewRowAnimationFade];
    
        //2.延迟进行刷新table
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //2.1从已完成区域中删除
        [self.dataSourceAry[1] removeObjectAtIndex:indexPath.row];
            //2.2添加到未完成区域中的第一行
        [self.dataSourceAry[0] insertObject:doneCell.model atIndex:0];
        [self.tableView reloadData];
        //恢复tablede交互
        doneCell.userInteractionEnabled = YES;
    });
    
        //保存修改时间
    [doneCell.model resetOverdueTime];
    doneCell.model.lastModifyTime = [NSDate date].timeIntervalSince1970;
    //3.同步本地数据库中模型数据的更改
    [[TodoSyncTool share] alterTodoWithModel:doneCell.model needRecord:YES];
    
  
}

//MARK: DiscoverTodoSheetView的代理方法：
///保存添加
- (void)sheetViewSaveBtnClicked:(TodoDataModel *)dataModel {
    NSLog(@"保存设置");
    //重新设置过期时间
    [dataModel resetOverdueTime];
    //保存上一次修改的时间
    dataModel.lastModifyTime = [NSDate date].timeIntervalSince1970;
    [self.dataSourceAry[0] insertObject:dataModel atIndex:0];
    [self.tableView reloadData];
    
    //保存到数据库里面，并进行同步
    [[TodoSyncTool share] saveTodoWithModel:dataModel needRecord:YES];
}
- (void)todoSyncToolDidSync:(NSNotification*)noti {
    TodoSyncMsg* msg = noti.object;
    NSString *str;
    switch (msg.syncState) {
        case TodoSyncStateSuccess:
            str = @"和服务器数据同步成功";
            break;
        case TodoSyncStateFailure:
            str = @" 网络错误，待接入网络时，再和服务器同步数据 ";
            break;
        case TodoSyncStateConflict:
            str = @" 产生了冲突 ";
            break;
        case TodoSyncStateUnexpectedError:
            str = @" 网络错误，待接入网络时，再和服务器同步数据 ";
            break;
    }
    
    [NewQAHud showHudAtWindowWithStr:str enableInteract:YES];
    
    if (msg.syncState==TodoSyncStateConflict) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
}
- (NSArray<TodoDataModel *> *)dataModelToShowForDiscoverTodoView:(DiscoverTodoView *)view {
    NSLog(@"datamodel");
//    return [self.todoSyncTool getTodoForDiscoverMainPage];
    return nil;
}
- (void)sheetViewCancelBtnClicked {
    NSLog(@"已经点击取消那妞");
}

//MARK: UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *sectionAry = self.dataSourceAry[section];
    if (sectionAry.count == 0) {
        //让空白的cell也可以被收起
        if (section == 1 && self.isFold) {
            return 0;
        }else{
            return 1;
        }
    }
    
    //让普通的cell被收起
    if (section == 1 && self.isFold) {
        return 0;
    }
    return sectionAry.count;
}
///cell的点击事件
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *sectionAry = self.dataSourceAry[indexPath.section];
    //如果无内容则设置为空cell的样式
    if (sectionAry.count == 0) {
        ToDoEmptyCell *cell = [[ToDoEmptyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ToDoEmptyCell"];
        cell.type = indexPath.section;
        return cell;
    }
    TodoTableViewCell *cell = [[TodoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ToDoCell"];
    TodoDataModel *model = sectionAry[indexPath.row];
    cell.delegate = self;
    [cell setDataWithModel:model];
    return cell;
}

//MARK: UITableViewDelegate
///组头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView* firstview = [[UIView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH, 60.0)];
        firstview.backgroundColor = [UIColor whiteColor];
        UILabel *toDoLbl = [[UILabel alloc] initWithFrame:CGRectMake(15,30,50,34)];
        toDoLbl.font = [UIFont fontWithName:PingFangSCBold size:24];
        toDoLbl.textColor = [UIColor colorNamed:@"21_49_91&240_240_242"];
        toDoLbl.text = @"待办";
        [firstview addSubview:toDoLbl];
        return firstview;
    }else{
        UIView * secondview = [[UIView alloc] initWithFrame:CGRectMake(0,30, SCREEN_WIDTH,60.0)];
        secondview.backgroundColor = [UIColor whiteColor];
        //完成的label
        UILabel *doneLbl = [[UILabel alloc ]initWithFrame:CGRectMake(15,30,100,34) ];
        doneLbl.font = [UIFont fontWithName:PingFangSCBold size:24];
        doneLbl.textColor = [UIColor colorNamed:@"21_49_91&240_240_242"];
        doneLbl.text = @"已完成";
        [secondview addSubview:doneLbl];
        
        //折叠的按钮
        UIButton *foldBtn = [[UIButton alloc] initWithFrame:CGRectZero];;
        [foldBtn setImage:[UIImage imageNamed:@"foldImage"] forState:(UIControlStateNormal)];
        [foldBtn addTarget:self action:@selector(foldAction) forControlEvents:(UIControlEventTouchUpInside)];
        foldBtn.imageView.transform = !self.isFold ? CGAffineTransformIdentity :  CGAffineTransformMakeRotation(M_PI);
        [secondview addSubview:foldBtn];
        [foldBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(doneLbl);
            make.right.equalTo(secondview).offset(-SCREEN_WIDTH * 0.04);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.0533, SCREEN_WIDTH * 0.0266));
        }];
        
        return secondview;
    }
    return nil;
}
///cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *sectionAry = self.dataSourceAry[indexPath.section];
    if (sectionAry.count == 0) {
        return 220;
    }
//    TodoDataModel *model = sectionAry[indexPath.row];
//    return model.cellHeight;
    return 65;
}
///组头视图高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return SCREEN_HEIGHT * 0.0899;
    }else{
        return SCREEN_HEIGHT * 0.0899;
    }
    
}
///删除cell
- ( UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray <TodoDataModel *>*dataList = self.dataSourceAry[indexPath.section];
    if (dataList.count == 0) {
        return nil;
    }
    //删除
    UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"删除" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        //1.获取这个模型
        TodoDataModel *model = dataList[indexPath.row];
        
        //2.从数据源数组中移除这个模型
        [dataList removeObjectAtIndex:indexPath.row];
        //3.从数据库中删除这个模型数据
        [[TodoSyncTool share] deleteTodoWithTodoID:model.todoIDStr  needRecord:YES];
        
        //4.进行动画，使得删除不这么违和
//        if (dataList.count != 0) {
//            [tableView beginUpdates];
//            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            [tableView endUpdates];
//        }
       
        //5.刷新table
        [tableView reloadData];
    }];
    deleteRowAction.image = [UIImage imageNamed:@"垃圾桶图"];
    deleteRowAction.backgroundColor = [UIColor colorWithRed:255/225.0 green:98/225.0 blue:95/225.0 alpha:1];;
    deleteRowAction.title = @"";
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteRowAction]];
    return config;
}
///点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *sectionArray = self.dataSourceAry[indexPath.section];
    
    TodoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if (sectionArray.count != 0) {
        //数据传递
        ToDoDetaileViewController *vc = [ToDoDetaileViewController new];
//         vc.model = sectionArray[indexPath.row];
        vc.model = cell.model;
        
        //跳转页面
        self.navigationController.navigationBar.hidden = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
        //回调刷新当前页面
        vc.block = ^{
            [self refresh];
        };
    }
  
}

#pragma mark- Getter
- (ToDoMainBarView *)barView{
    if (!_barView) {
        _barView = [[ToDoMainBarView alloc] initWithFrame:CGRectZero];
        _barView.delegate = self;
    }
    return _barView;
}

- (ToDoTableView *)tableView{
    if (!_tableView) {
        _tableView = [[ToDoTableView alloc] initWithFrame:CGRectZero];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)dataSourceAry{
    if (!_dataSourceAry) {
        _dataSourceAry = [NSMutableArray array];
        NSMutableArray <TodoDataModel *>*firstAry = [NSMutableArray array];
        NSMutableArray <TodoDataModel *>*lastAry = [NSMutableArray array];
        [_dataSourceAry addObject:firstAry];
        [_dataSourceAry addObject:lastAry];
    }
    return _dataSourceAry;
}

@end
