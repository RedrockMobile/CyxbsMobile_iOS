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


#import "PublishTextView.h"
#import "PublishMakeSureView.h"

@interface PublishViewController () <
    UITextViewDelegate,
    UITableViewDataSource,
    PublishPageCellDelegate
>

@property (nonatomic, strong) PublishTopView *topView;

@property (nonatomic, strong) UITableView *table;

// 获取tableview的高度
@property (nonatomic, assign) CGFloat tableViewHeight;

@property (nonatomic, strong) PublishTableAddTagView *addTagView;
@property (nonatomic, strong) PublishTableHeadView *headerView;

/// title输入框
@property (nonatomic, strong) PublishTextView *publishTitleTextView;

/// 选项Option输入框
@property (nonatomic, strong) PublishTextView *publishOptionTextView;

/// 确认输入提示框
@property (nonatomic, strong) PublishMakeSureView *publishMakeSureView;

/// 背景蒙版
@property (nonatomic, strong) UIView *backView;


@end

@implementation PublishViewController {
    NSInteger _count;
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    _count = 4;
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F2F3F8"];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.addTagView];
    [self.view addSubview:self.table];
    self.table.editing = YES;
}



#pragma mark - Method

/// TODO: 点击title跳转提示框方法
- (void)clickTitle {
//    UIWindow *window = self.view.window;
    // 加入背景蒙版
    [self.view.window addSubview:self.backView];
    // 加入输入框
    [self.view.window addSubview:self.publishTitleTextView];
}

/// TODO: 点击cell跳转提示框方法
- (void)clickCell {
//    UIWindow *window = self.view.window;
    // 加入背景蒙版
    [self.view.window addSubview:self.backView];
    // 加入输入框
    [self.view.window addSubview:self.publishOptionTextView];
}

// TODO: 点击完成编辑出现确认提示框
- (void)clickFinishBtn:(UIButton *)sender {
//    UIView *view = [sender superview];
    // 加入背景蒙版
    [self.view.window addSubview:self.backView];
    // 加入确认提示框
    [self.view.window addSubview:self.publishMakeSureView];
}

/// 给按钮加SEL
- (void)addTargetToBtn {
    // 1.取消按钮都是一样的
    [self.publishTitleTextView.cancelBtn addTarget:self action:@selector(cancelInput) forControlEvents:UIControlEventTouchUpInside];
    [self.publishOptionTextView.cancelBtn addTarget:self action:@selector(cancelInput) forControlEvents:UIControlEventTouchUpInside];
    [self.publishMakeSureView.cancelBtn addTarget:self action:@selector(cancelInput) forControlEvents:UIControlEventTouchUpInside];
    // 2.publishTitleTextView 的确认，textView 里面的内容被放到title 中
    [self.publishTitleTextView.sureBtn addTarget:self action:@selector(sureTitle) forControlEvents:UIControlEventTouchUpInside];
    // 3.publishOptionTextView 的确认，textView 里面的内容被放到option 中
    [self.publishOptionTextView.sureBtn addTarget:self action:@selector(sureOption) forControlEvents:UIControlEventTouchUpInside];
    // 4.确认框
    [self.publishMakeSureView.sureBtn addTarget:self action:@selector(surePublish) forControlEvents:UIControlEventTouchUpInside];
}

// MARK: SEL

// 回退页面

- (void)didClickBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

/// 取消输入
- (void)cancelInput {
    if (self.publishTitleTextView != nil) {
        [self.publishTitleTextView removeFromSuperview];
    } else if (self.publishOptionTextView != nil) {
        [self.publishOptionTextView removeFromSuperview];
    } else if (self.publishMakeSureView != nil) {
        [self.publishMakeSureView removeFromSuperview];
    }
    // 取消蒙版
    [self.backView removeFromSuperview];
}

/// 确认标题
- (void)sureTitle {
    NSString *titleStr = self.publishTitleTextView.publishTextView.text;
    NSLog(@"🥑%@", titleStr);
    // TODO: 传输文字
    
    // 框消失与取消蒙版
    [self.publishTitleTextView removeFromSuperview];
    [self.backView removeFromSuperview];
}

/// 确认选项
- (void)sureOption {
    NSString *optionStr = self.publishOptionTextView.publishTextView.text;
    NSLog(@"🌮%@", optionStr);
    // TODO: 传输文字
    
    // 框消失与取消蒙版
    [self.publishOptionTextView removeFromSuperview];
    [self.backView removeFromSuperview];
}

/// 确认发表
- (void)surePublish {
    // TODO: 需要回掉信息？还是要上传后端数据库
    
    // 框消失与取消蒙版
    [self.publishMakeSureView removeFromSuperview];
    [self.backView removeFromSuperview];
}

#pragma mark - Delegate

// MARK: <UITextViewDelegate>

// 监听文本框输入内容
- (void)textViewDidChange:(UITextView *)textView {
    // 获取字数
    NSInteger stringsCount = textView.text.length;
    
    if ([textView isEqual:self.publishTitleTextView]) {
        // 输入为0
        if (stringsCount == 0) {
            self.publishTitleTextView.sureBtn.enabled = NO;
            self.publishTitleTextView.sureBtn.backgroundColor = [UIColor colorWithHexString:@"#C3D4EE" alpha:1.0];
        } else {
            // 不断改变现在的字数
            self.publishTitleTextView.stringsLab.text = [NSString stringWithFormat:@"%ld/30", stringsCount];
        }
    } else if ([textView isEqual:self.publishOptionTextView]) {
        if (stringsCount == 0) {
            self.publishOptionTextView.sureBtn.enabled = NO;
            self.publishOptionTextView.sureBtn.backgroundColor = [UIColor colorWithHexString:@"#C3D4EE" alpha:1.0];
        } else {
            self.publishOptionTextView.stringsLab.text = [NSString stringWithFormat:@"%ld/15", stringsCount];
        }
    }
}

/// 超过字数不再输入
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (([textView isEqual:self.publishTitleTextView] && range.location >= 30) || ([textView isEqual:self.publishOptionTextView] && range.location >= 15)) {
        // TODO: 弹出提示框 您已达到最大输入限制
        
        return NO;
    } else {
        return YES;
    }
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
    
    return cell;
}

#pragma mark - Getter


- (PublishTopView *)topView {
    if (!_topView) {
        CGFloat h = getStatusBarHeight_Double + 44;
        _topView = [[PublishTopView alloc] initWithTopView];
        _topView.frame = CGRectMake(0, 0, kScreenWidth, h);
        [_topView.backBtn addTarget:self action:@selector(didClickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topView;
}


- (PublishTextView *)publishTitleTextView {
    if (_publishTitleTextView == nil) {
        _publishTitleTextView = [[PublishTextView alloc] initWithFrame:CGRectMake(15, STATUSBARHEIGHT + 190, SCREEN_WIDTH - 30, 250)];
        _publishTitleTextView.publishTextView.text = @"0/30";
    }
    return _publishTitleTextView;
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



- (PublishTextView *)publishOptionTextView {
    if (_publishOptionTextView == nil) {
        _publishOptionTextView = [[PublishTextView alloc] initWithFrame:CGRectMake(15, STATUSBARHEIGHT + 190, SCREEN_WIDTH - 30, 210)];
        _publishOptionTextView.publishTextView.text = @"0/15";
    }
    return _publishOptionTextView;
}

- (PublishMakeSureView *)publishMakeSureView {
    if (_publishMakeSureView == nil) {
        _publishMakeSureView = [[PublishMakeSureView alloc] initWithFrame:CGRectMake(60, STATUSBARHEIGHT + 190, SCREEN_WIDTH - 120, 206)];
    }
    return _publishMakeSureView;
}

- (UIView *)backView {
    if (_backView == nil) {
        _backView = [[UIView alloc] initWithFrame:self.view.bounds];
        _backView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.47];
    }
    return _backView;
}
@end
