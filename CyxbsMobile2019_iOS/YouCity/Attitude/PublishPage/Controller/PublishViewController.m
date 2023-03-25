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

// Model
#import "PublishPageModel.h"

#define TABLEVIEWHEIGHT self.tableView.frame.size.height
@interface PublishViewController () <
    UITextViewDelegate,
    UITableViewDataSource,
    UITableViewDelegate,
    PublishPageCellDelegate
>

@property (nonatomic, strong) PublishTopView *topView;

@property (nonatomic, strong) UITableView *tableView;

// 获取tableview的高度
//@property (nonatomic, assign) CGFloat tableViewHeight;

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
    [self addTitleTap];// 使title可点击
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F2F3F8"];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.addTagView];

    [self addTargetToBtn];
}

#pragma mark - Method
// 给title添加点击方法
- (void)addTitleTap {
    NSLog(@"addTitleTap使title可以点");
    [self.headerView.headerLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTitle)]];
    [self.headerView.backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTitle)]];
}

/// TODO: 点击title跳转提示框方法
- (void)clickTitle {
    // 加入背景蒙版
    [self.view addSubview:self.backView];
    // 加入输入框
    [self.backView addSubview:self.publishTitleTextView];
    [self.publishTitleTextView.publishTextView clearAllDecoratedFoundText];
    self.publishTitleTextView.publishTextView.delegate = self;
}

/// TODO: 点击cell跳转提示框方法
- (void)clickCell {
    // 加入背景蒙版
    [self.view addSubview:self.backView];
    // 加入输入框
    [self.backView addSubview:self.publishOptionTextView];
    [self.publishOptionTextView.publishTextView clearAllDecoratedFoundText];
    self.publishOptionTextView.publishTextView.delegate = self;
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
    self.headerView.headerLabel.text = titleStr;
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
    
    if ([textView isEqual:self.publishTitleTextView.publishTextView]) {
        // 输入为0
        if (stringsCount == 0) {
            self.publishTitleTextView.sureBtn.enabled = NO;
            self.publishTitleTextView.sureBtn.backgroundColor = [UIColor colorWithHexString:@"#C3D4EE" alpha:1.0];
        } else {
            self.publishTitleTextView.sureBtn.enabled = YES;
            self.publishTitleTextView.sureBtn.backgroundColor = [UIColor colorWithHexString:@"#4841E2" alpha:1.0];
        }
        // 不断改变现在的字数
        self.publishTitleTextView.stringsLab.text = [NSString stringWithFormat:@"%ld/30", stringsCount];
        
    } else if ([textView isEqual:self.publishOptionTextView.publishTextView]) {
        if (stringsCount == 0) {
            self.publishOptionTextView.sureBtn.enabled = NO;
            self.publishOptionTextView.sureBtn.backgroundColor = [UIColor colorWithHexString:@"#C3D4EE" alpha:1.0];
        } else {
            self.publishOptionTextView.sureBtn.enabled = YES;
            self.publishOptionTextView.sureBtn.backgroundColor = [UIColor colorWithHexString:@"#4841E2" alpha:1.0];
        }
        self.publishOptionTextView.stringsLab.text = [NSString stringWithFormat:@"%ld/15", stringsCount];
    }
}

/// 超过字数不再输入
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (([textView isEqual:self.publishTitleTextView.publishTextView] && range.location >= 30) || ([textView isEqual:self.publishOptionTextView.publishTextView] && range.location >= 15)) {
        // TODO: 弹出提示框 您已达到最大输入限制
        
        return NO;
    } else {
        return YES;
    }
}


// 添加cell方法
- (void)addCell:(UIButton *)button{
    if (_count < 10) {
        [self.tableView beginUpdates];
        _count += 1;
        // 动态变化tableview高度：增加
        if (TABLEVIEWHEIGHT < kScreenHeight - 220) {
            [self tableViewChangeHeight];
        }
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        [self.tableView reloadData];
    }
    else {
        // 设置提示弹窗🥺
        [NewQAHud showHudAtWindowWithStr:@"最多仅可以添加10个选项" enableInteract:YES];
    }
}

// 点击完成编辑按钮后：发布投票
- (void)uploadTagDataToPost {
    NSMutableArray *choicesArray = [NSMutableArray array];
    for (PublishPageCell *cell in [self.tableView visibleCells]) {
        [choicesArray addObject:cell.tagLabel.text];
    }
    NSString *title = [NSString string];
    title = self.headerView.headerLabel.text;
    PublishPageModel *model = [[PublishPageModel alloc] init];
    [model postTagWithTitle:title andChoices:choicesArray withSuccess:^{
        NSLog(@"发布投票success");
    } Failure:^{
        NSLog(@"发布投票failure");
    }];
}

// 发布投票
- (void)clickedOkEdit {
    NSLog(@"发布投票--------");
    [self uploadTagDataToPost];
}



// MARK: <PublishPageCellDelegate>
// 点击按钮删除cell
- (void)tableViewCellPressDeleteCell:(PublishPageCell *)cell {
    [self.tableView beginUpdates];
    _count -= 1;
    [self.tableView deleteRowsAtIndexPaths:@[[self.tableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    // 动态变化tableview高度
    CGFloat newHeight = [self getTableViewNewHeight];
    if (newHeight <= kScreenHeight - 220) {
        [self tableViewChangeHeight];
    }
}

// 获取最新高度
- (CGFloat)getTableViewNewHeight {
    NSInteger numberOfCells = [self tableView:self.tableView numberOfRowsInSection:0];
    // 获取每个cell的高度
    CGFloat cellHeight = [self tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    // 计算tableview应该展示的高度
    CGFloat newHeight = numberOfCells * cellHeight + [self tableView:self.tableView heightForFooterInSection:0];
    return newHeight;
}

// 高度变化
- (void)tableViewChangeHeight {
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat newHeight = [self getTableViewNewHeight];
        // 设置tableview的高度不能小于最小高度
        newHeight = MAX(newHeight, 50 * 4 + 100);
        self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, newHeight);
    }];
}

// MARK: <UITableViewDataSource>
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 100;
}
// MARK: <UITableViewDelegate>

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.addTagView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"identify";
    PublishPageCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[PublishPageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.tagLabel.text = [NSString stringWithFormat:@"选项%ld", indexPath.row + 1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    cell.tagLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self clickCell];
//    PublishPageCell * cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.tagLabel.text =
    
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

- (UITableView *)tableView {
    if (!_tableView) {
//        CGFloat tableViewH = 50 * 4 + [self tableView:_tableView heightForFooterInSection:0];
        _tableView = [[UITableView alloc] init];
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(15, 180, self.view.frame.size.width - 30, 50 * 4 + 100) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        // tableView的圆角，暂定15
        _tableView.layer.cornerRadius = 15;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (PublishTableAddTagView *)addTagView {
    if (!_addTagView) {
        _addTagView = [[PublishTableAddTagView alloc] initWithView];
        _addTagView.backgroundColor = [UIColor whiteColor];
        [_addTagView.btn addTarget:self action:@selector(addCell:) forControlEvents:UIControlEventTouchUpInside];
        [_addTagView.okEditBtn addTarget:self action:@selector(clickedOkEdit) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addTagView;
}

- (PublishTableHeadView *)headerView {
    if (!_headerView) {
        _headerView = [[PublishTableHeadView alloc] initWithHeaderView];
        _headerView.frame = CGRectMake(self.tableView.origin.x, self.tableView.origin.y - 80, self.tableView.frame.size.width, 100);
        _headerView.backgroundColor = [UIColor whiteColor];
        _headerView.layer.cornerRadius = 15;
    }
    return _headerView;
}


- (PublishTextView *)publishTitleTextView {
    if (_publishTitleTextView == nil) {
        _publishTitleTextView = [[PublishTextView alloc] initWithFrame:CGRectMake(15, STATUSBARHEIGHT + 190, SCREEN_WIDTH - 30, 250)];
        _publishTitleTextView.publishTextView.frame = CGRectMake(22, 22, SCREEN_WIDTH - 30 - 44, 142);
        _publishTitleTextView.stringsLab.text = @"0/30";
    }
    return _publishTitleTextView;
}
 

- (PublishTextView *)publishOptionTextView {
    if (_publishOptionTextView == nil) {
        _publishOptionTextView = [[PublishTextView alloc] initWithFrame:CGRectMake(15, STATUSBARHEIGHT + 190,SCREEN_WIDTH - 30, 210)];
        _publishOptionTextView.publishTextView.frame = CGRectMake(22, 22, SCREEN_WIDTH - 30 - 44, 102);
        _publishOptionTextView.stringsLab.text = @"0/15";
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
 
