//
//  PMPDynamicTableViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/9/27.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "PMPDynamicTableViewController.h"
// model
#import "PMPPostItem.h"
// controller
//#import "DynamicDetailMainVC.h"
#import "StarPostModel.h"
#import "YYZTopicDetailVC.h"

@interface PMPDynamicTableViewController ()
<PostTableViewCellDelegate,
ShareViewDelegate,
FuncViewProtocol,
SelfFuncViewProtocol,
ReportViewDelegate>

/// 装动态的数组
@property (nonatomic, strong) NSMutableArray <PMPPostItem *> * dynamicMAry;
@property (nonatomic, copy) NSMutableArray <PostTableViewCellFrame *> * dynamicCellHeightMAry;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSString * redid;

@property (nonatomic, strong) UIImageView * defaultImgView;
@property (nonatomic, strong) UILabel * defaultLabel;

@property (nonatomic, assign) BOOL canScroll;

/// 是否已经显示reportView
@property (nonatomic, assign) BOOL isShowedReportView;

@property (nonatomic, assign) BOOL haveMoreData;

@property (nonatomic, strong) MJRefreshAutoFooter * refreshFooter;

@end

@implementation PMPDynamicTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
                        redid:(NSString *)redid
{
    self = [super init];
    if (self) {
        _page = 1;
        _redid = redid;
        _dynamicMAry = [NSMutableArray arrayWithCapacity:6];
        _dynamicCellHeightMAry = [NSMutableArray arrayWithCapacity:6];
        _haveMoreData = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1] darkColor:[UIColor colorWithHexString:@"#1D1D1D" alpha:1]];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[PMPDynamicTableViewCell class] forCellReuseIdentifier:[PMPDynamicTableViewCell reuseIdentifier]];
    [self funcPopViewinit];
    [self setBackViewWithGesture];
    [self setUpModel];
    
    //    self.tableView.mj_footer = self.refreshFooter;
    [self.view addSubview:self.defaultLabel];
    [self.defaultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_centerY);
    }];
    self.defaultLabel.hidden = YES;
    
    [self.view addSubview:self.defaultImgView];
    [self.defaultImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.defaultLabel.mas_top).offset(-10);
        make.centerX.mas_equalTo(self.view);
    }];
    self.defaultImgView.hidden = YES;
    
    [self loadData];
    [self addNotification];
}

- (void)loadData {
    if (self.haveMoreData == NO) {
        return;
    }
    [PMPPostItem
     getDataWithPage:self.page
     Redid:self.redid
     success:^(NSArray * _Nonnull dataAry) {
        [self.dynamicMAry appendObjects:dataAry];
        if (dataAry.count < 6) {
            self.haveMoreData = NO;
            self.defaultLabel.hidden = !(self.page == 1 && dataAry.count == 0);
            self.defaultImgView.hidden = !(self.page == 1 && dataAry.count == 0);
        }
        for (PMPPostItem * item in dataAry) {
            PostTableViewCellFrame * cellFrame = [[PostTableViewCellFrame alloc] init];
            cellFrame.item = item;
            [self.dynamicCellHeightMAry addObject:cellFrame];
        }
        [self.tableView reloadData];
        self.page += 1;
    }
     failure:^{
        [NewQAHud showHudWith:@"刷新失败!" AddView:self.tableView];
    }];
}

- (void)setUpModel {
    _reportmodel = [[ReportModel alloc] init];
    _shieldmodel = [[ShieldModel alloc] init];
    _starpostmodel = [[StarPostModel alloc] init];
    _deletepostmodel = [[DeletePostModel alloc] init];
    _followgroupmodel = [[FollowGroupModel alloc] init];
}

#pragma mark - notification

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:kHomeGoTopNotification object:nil];
    //其中一个TAB离开顶部的时候，如果其他几个偏移量不为0的时候，要把他们都置为0
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:kHomeLeaveTopNotification object:nil];
}

- (void)acceptMsg:(NSNotification *)notification {
    NSString *notificationName = notification.name;
    if ([notificationName isEqualToString:kHomeGoTopNotification]) {
        NSDictionary *userInfo = notification.userInfo;
        NSString *canScroll = userInfo[@"canScroll"];
        if ([canScroll isEqualToString:@"1"]) {
            _canScroll = YES;
            self.tableView.showsVerticalScrollIndicator = YES;
        }
    }else if([notificationName isEqualToString:kHomeLeaveTopNotification]){
        self.tableView.contentOffset = CGPointZero;
        _canScroll = NO;
        self.tableView.showsVerticalScrollIndicator = NO;
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!self.canScroll) {
        [scrollView setContentOffset:CGPointZero];
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kHomeLeaveTopNotification object:nil userInfo:@{@"canScroll":@"1"}];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dynamicMAry.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    if (self.dynamicCellHeightMAry[indexPath.row]) {
    //        return [self.dynamicCellHeightMAry[indexPath.row] doubleValue];
    //    }
    PostTableViewCellFrame * cellFrame = [[PostTableViewCellFrame alloc] init];
    cellFrame.item = self.dynamicMAry[indexPath.row];
    return cellFrame.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PMPDynamicTableViewCell *
    cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:[PMPDynamicTableViewCell reuseIdentifier]];
        
        // Configure the cell...
        cell.item = self.dynamicMAry[indexPath.row];
        cell.delegate = self;
        cell.funcBtn.tag = indexPath.row;
        cell.commendBtn.tag = indexPath.row;
        cell.shareBtn.tag = indexPath.row;
        cell.starBtn.tag = indexPath.row;
        cell.tag = indexPath.row;
    }
    cell.cellFrame = self.dynamicCellHeightMAry[indexPath.row];
    return cell;
}

#pragma mark -配置相关弹出View和其蒙版的操作
- (void)setBackViewWithGesture {
    self.backViewWithGesture = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.backViewWithGesture.backgroundColor = [UIColor blackColor];
    self.backViewWithGesture.alpha = 0.36;
    UITapGestureRecognizer *dismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissBackViewWithGesture)];
    [self.backViewWithGesture addGestureRecognizer:dismiss];
}

- (void)showBackViewWithGesture {
    [self.view.window addSubview:self.backViewWithGesture];
}

- (void)dismissBackViewWithGestureAnd:(UIView *)view {
    [view removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
}

- (void)dismissBackViewWithGesture {
    [self.popView removeFromSuperview];
    [self.shareView removeFromSuperview];
    [self.reportView removeFromSuperview];
    [self.selfPopView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
}

- (void)funcPopViewinit {
    // 创建分享页面
    _shareView = [[ShareView alloc] init];
    _shareView.delegate = self;
    
    // 创建多功能--别人页面
    _popView = [[FuncView alloc] init];
    _popView.delegate = self;
    
    // 创建多功能--自己页面
    _selfPopView = [[SelfFuncView alloc] init];
    _selfPopView.delegate = self;
    
    // 创建举报页面
    _reportView = [[ReportView alloc]initWithPostID:[NSNumber numberWithInt:0]];
    _reportView.delegate = self;
}

#pragma mark - PostTableViewCellDelegate

///点赞的逻辑：根据点赞按钮的tag来获取post_id，并传入后端
- (void)ClickedStarBtn:(PostTableViewCell *)cell{
    cell.starBtn.isFirst = NO;
    if (cell.starBtn.selected == YES) {
        cell.starBtn.selected = NO;
        cell.starBtn.iconView.image = [UIImage imageNamed:@"未点赞"];
        NSString *count = cell.starBtn.countLabel.text;
        cell.starBtn.countLabel.text = [NSString stringWithFormat:@"%d",[count intValue] - 1];
        cell.starBtn.countLabel.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#ABBCD9" alpha:1] darkColor:[UIColor colorWithHexString:@"#838384" alpha:1]];
    }else {
        cell.starBtn.selected = YES;
        cell.starBtn.iconView.image = [UIImage imageNamed:@"点赞"];
        NSString *count = cell.starBtn.countLabel.text;
        cell.starBtn.countLabel.text = [NSString stringWithFormat:@"%d",[count intValue] + 1];
        cell.starBtn.countLabel.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#3D35E1" alpha:1] darkColor:[UIColor colorWithHexString:@"#2CDEFF" alpha:1]];
    }
    self.starpostmodel = [[StarPostModel alloc] init];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    PMPPostItem * item = self.dynamicMAry[indexPath.row];
    [self.starpostmodel starPostWithPostID:[NSNumber numberWithString:item.post_id]];
    item.is_praised = cell.starBtn.selected == YES ? @1 : @0;
    item.praise_count = [cell.starBtn.countLabel.text numberValue];
    [self.dynamicMAry replaceObjectAtIndex:indexPath.row withObject:item];
}

#pragma mark -点击评论按钮跳转到具体的帖子
- (void)ClickedCommentBtn:(PostTableViewCell *)cell{
//    DynamicDetailMainVC *dynamicDetailVC = [[DynamicDetailMainVC alloc]init];
//    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
//    dynamicDetailVC.post_id = self.dynamicMAry[indexPath.row].post_id;
//    dynamicDetailVC.hidesBottomBarWhenPushed = YES;
//    [self.parentViewController.navigationController pushViewController:dynamicDetailVC animated:YES];
}

#pragma mark -点击分享按钮
- (void)ClickedShareBtn:(PostTableViewCell *)cell {
    [self showBackViewWithGesture];
    [self.view.window addSubview:self.shareView];
    [self.shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.window.mas_top).mas_offset(SCREEN_HEIGHT * 460/667);
        make.left.right.bottom.mas_equalTo(self.view.window);
    }];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    //此处还需要修改
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString *shareURL = [NSString stringWithFormat:@"https://fe-prod.redrock.team/zscy-youwen-share/#/dynamic?id=%@",self.dynamicMAry[indexPath.row].post_id];
    pasteboard.string = shareURL;
}

# pragma mark - 关注，举报和屏蔽的多功能按钮
- (void)ClickedFuncBtn:(PostTableViewCell *)cell{
    [self showBackViewWithGesture];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    PMPPostItem * item = self.dynamicMAry[indexPath.row];
    if ([item.is_self intValue] == 1) {
        self.selfPopView.deleteBtn.tag = indexPath.row;
        self.selfPopView.postID = [item.post_id numberValue];
        self.selfPopView.layer.cornerRadius = 8;
        [self.view.window addSubview:self.selfPopView];
        [self.selfPopView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.view.window.mas_bottom);
            make.left.right.mas_equalTo(self.view.window);
            make.height.mas_equalTo(HScaleRate_SE * 198);
        }];
    } else {
        self.popView.starGroupBtn.tag = indexPath.row;
        self.popView.shieldBtn.tag = indexPath.row;
        self.popView.reportBtn.tag = indexPath.row;
        if ([item.is_follow_topic intValue] == 1) {
            [self.popView.starGroupBtn setTitle:@"取消关注" forState:UIControlStateNormal];
        }else {
            [self.popView.starGroupBtn setTitle:@"关注圈子" forState:UIControlStateNormal];
        }
        self.popView.layer.cornerRadius = 8;
        [self.view.window addSubview:self.popView];
        [self.popView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(HScaleRate_SE * 198);
            make.left.right.bottom.mas_equalTo(self.view.window);
        }];
    }
}

#pragma mark -多功能View的代理方法
//点击关注按钮
- (void)ClickedStarGroupBtn:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    PMPPostItem * item = self.dynamicMAry[sender.tag];
    [self.followgroupmodel FollowGroupWithName:item.topic];
    if ([sender.titleLabel.text isEqualToString:@"关注圈子"]) {
        [self.followgroupmodel setBlock:^(id  _Nonnull info) {
            if (![info isKindOfClass:[NSError class]]) {
                if ([info[@"status"] isEqualToNumber:[NSNumber numberWithInt:200]]) {
                    [weakSelf showOperationSuccessfulWithString:@"  关注圈子成功  "];
                }else  {
                    [weakSelf showOperationSuccessfulWithString:@"  关注圈子失败  "];
                }
            }else {
                [weakSelf showOperationSuccessfulWithString:@"  操作失败  "];
            }
        }];
    } else if ([sender.titleLabel.text isEqualToString:@"取消关注"]) {
        [self.followgroupmodel setBlock:^(id  _Nonnull info) {
            if (![info isKindOfClass:[NSError class]]) {
                if ([info[@"status"] isEqualToNumber:[NSNumber numberWithInt:200]]) {
                    [weakSelf showOperationSuccessfulWithString:@"  取消关注圈子成功  "];
                }else  {
                    [weakSelf showOperationSuccessfulWithString:@"  取消关注圈子失败  "];
                }
            }else {
                [weakSelf showOperationSuccessfulWithString:@"  操作失败  "];
            }
        }];
    }
}

///点击屏蔽按钮
- (void)ClickedShieldBtn:(UIButton *)sender {
    PMPPostItem * item = self.dynamicMAry[sender.tag];
    [self.shieldmodel ShieldPersonWithUid:item.uid];
    __weak typeof(self) weakSelf = self;
    [self.shieldmodel setBlock:^(id  _Nonnull info) {
        if ([info[@"info"] isEqualToString:@"success"]) {
            [weakSelf showOperationSuccessfulWithString:@"  将不再推荐该用户的动态给你  "];
        }else if ([info[@"info"] isEqualToString:@"该用户已屏蔽"]) {
            [weakSelf showOperationSuccessfulWithString:@"  该用户已经屏蔽了  "];
        } else {
            [weakSelf showOperationSuccessfulWithString:@"  屏蔽失败了  "];
        }
    }];
}
///点击举报按钮
- (void)ClickedReportBtn:(UIButton *)sender  {
    [self.popView removeFromSuperview];
    PMPPostItem * item = self.dynamicMAry[sender.tag];
    self.reportView.postID = [item.post_id numberValue];
    [self.view.window addSubview:self.reportView];
    [self.reportView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view.window);
        make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W - MAIN_SCREEN_W*2*0.1587, MAIN_SCREEN_W * 0.6827 * 329/256));
    }];
    self.isShowedReportView = YES;
}

#pragma mark -举报页面的代理方法
///举报页面点击确定按钮
- (void)ClickedSureBtn {
    [self.reportView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    self.reportmodel = [[ReportModel alloc] init];
    __weak typeof(self) weakSelf = self;
    [self.reportmodel ReportWithPostID:self.reportView.postID WithModel:[NSNumber numberWithInt:0] AndContent:self.reportView.textView.text];
    [self.reportmodel setBlock:^(id  _Nonnull info) { //3
        [weakSelf showOperationSuccessfulWithString:@"  举报成功  "];
    }];
    self.isShowedReportView = NO;
}

///举报页面点击取消按钮
- (void)ClickedCancelBtn {
    [self.reportView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    self.isShowedReportView = NO;
}

#pragma mark -多功能View--自己的代理方法
- (void)ClickedDeletePostBtn:(UIButton *)sender {
    [self.selfPopView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    PMPPostItem * item = self.dynamicMAry[sender.tag];
    self.deletepostmodel = [[DeletePostModel alloc] init];
    __weak typeof(self) weakSelf = self;
    [self.deletepostmodel deletePostWithID:[item.post_id numberValue] AndModel:[NSNumber numberWithInt:0]];
    [self.deletepostmodel setBlock:^(id  _Nonnull info) {
        for (int i = 0;i < [self.dynamicMAry count]; i++) {
            if ([weakSelf.dynamicMAry[i].post_id isEqualToString:item.post_id]) {
                [weakSelf.dynamicMAry removeObjectAtIndex:i];
                [weakSelf.dynamicCellHeightMAry removeObjectAtIndex:i];
                break;
            }
        }
        [NewQAHud showHudWith:@"  已经删除该帖子 " AddView:weakSelf.view AndToDo:^{
            [weakSelf.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:sender.tag inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
            [weakSelf.tableView reloadData];
        }];
    }];
}

#pragma mark- 配置相关操作成功后的弹窗
- (void)showOperationSuccessfulWithString:(NSString *)str {
    [self.popView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    [NewQAHud showHudWith:str AddView:self.view.window];
}

#pragma mark -分享View的代理方法
///点击取消
- (void)ClickedCancel {
    [self.shareView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
}

///点击分享QQ空间
- (void)ClickedQQZone {
    [self.shareView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
}

///点击分享朋友圈
- (void)ClickedVXGroup {
    [self.shareView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
}

///点击分享QQ
- (void)ClickedQQ {
    [self.shareView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
}

///点击分享微信好友
- (void)ClickedVXFriend {
    [self.shareView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
}

///点击分享复制链接
- (void)ClickedUrl {
    [self.shareView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
}

#pragma mark - lazy

- (MJRefreshAutoFooter *)refreshFooter {
    if (_refreshFooter == nil) {
        _refreshFooter = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
        _refreshFooter.automaticallyChangeAlpha = YES;
    }
    return _refreshFooter;
}

- (UILabel *)defaultLabel {
    if (_defaultLabel == nil) {
        _defaultLabel = [[UILabel alloc] init];
        _defaultLabel.text = @"嘿,说点什么吧...";
        _defaultLabel.font = [UIFont fontWithName:PingFangSCMedium size:12];
        //        _defaultLabel.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#112C53" alpha:1] darkColor:[UIColor colorWithHexString:@"#EFEFEF" alpha:1]];
        _defaultLabel.textColor = [UIColor blackColor];
        [_defaultLabel sizeToFit];
    }
    return _defaultLabel;
}

- (UIImageView *)defaultImgView {
    if (_defaultImgView == nil) {
        _defaultImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_dynamic_default"]];
        [_defaultImgView sizeToFit];
    }
    return _defaultImgView;
}

@end
