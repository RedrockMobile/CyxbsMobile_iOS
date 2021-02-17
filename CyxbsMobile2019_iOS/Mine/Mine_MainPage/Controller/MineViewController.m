//
//  MineViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/10/21.
//  Copyright © 2019 Redrock. All rights reserved.
//个人页面主控制器

#import "MineViewController.h"
#import "MineHeaderView.h"
#import "EditMyInfoViewController.h"
#import "EditMyInfoTransitionAnimator.h"
#import "EditMyInfoPercentDrivenController.h"
#import "CheckInViewController.h"
#import "MineQAController.h"
#import "MineQADataItem.h"
#import "MineAboutController.h"
//#import "SelfSafeViewController.h"
#import "PraiseViewController.h"
#import "MineModel.h"
#import "MineSettingViewController.h"
#import <UserNotifications/UserNotifications.h>
#import "CheckInModel.h"

@interface MineViewController () <UIViewControllerTransitioningDelegate,UITableViewDelegate, UITableViewDataSource, MineHeaderViewDelegate>

/// tableView
@property (nonatomic, weak) UITableView *appSettingTableView;

/// 个人主页面的tableView顶部的一大块View都是，它会被设置成tableView的headview
@property (nonatomic, weak) MineHeaderView *headerView;

/// tabelViewCell的标题数据来源
@property (nonatomic, copy) NSArray <NSString*> *cellTitleStrArr;
@end


@implementation MineViewController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSucceded) name:@"Login_LoginSuceeded" object:nil];
    
    if (@available(iOS 11.0, *)) {
        self.view.backgroundColor = [UIColor colorNamed:@"Mine_Store_ContainerColor"];
    } else {
        self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:242/255.0 blue:250/255.0 alpha:1];
    }
//    248_249_252&0_1_1
    
    [self addContentView];
    [self addAppSettingTableView];
}

/// 添加contentView
- (void)addContentView{
    // 添加contentView
    UIView *contentView = [[UIView alloc] init];
    [self.view addSubview:contentView];
    self.contentView = contentView;
    
    if (@available(iOS 11.0, *)) {
        contentView.backgroundColor = [UIColor colorNamed:@"248_249_252&0_1_1"];
    } else {
        contentView.backgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:252/255.0 alpha:1];
    }
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

}

/// 添加tableView
- (void)addAppSettingTableView{
    self.cellTitleStrArr = @[@"积分商城",@"设置",@"关于我们"];
    
    
    UITableView *appSettingTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_W, MAIN_SCREEN_H) style:UITableViewStyleGrouped];
    [self.contentView addSubview: appSettingTabelView];
    appSettingTabelView.delegate = self;
    appSettingTabelView.dataSource = self;
    appSettingTabelView.backgroundColor = self.view.backgroundColor;
    appSettingTabelView.rowHeight = 55;
    appSettingTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    appSettingTabelView.showsVerticalScrollIndicator = NO;
    appSettingTabelView.scrollEnabled = NO;
    self.appSettingTableView = appSettingTabelView;

    

    // 添加headerView（个人信息相关）
    MineHeaderView *headerView = [[MineHeaderView alloc] init];
    headerView.delegate = self;
    appSettingTabelView.tableHeaderView = headerView;
    self.headerView = headerView;
}

- (void)viewWillAppear:(BOOL)animated {
    // 加载邮问数据
    [MineModel requestQADataSucceeded:^(MineQADataItem * _Nonnull responseItem) {
        [self QAInfoRequestsSucceededWithItem:responseItem];
    } failed:^(NSError * _Nonnull err) {
        
    }];
    // 隐藏导航栏
    self.navigationController.navigationBar.hidden = YES;
    [self loadUserData];
}

- (void)loadUserData {
    UserItem *user = [UserItemTool defaultItem];
    self.headerView.nicknameLabel.text = user.nickname;
    
    if (user.introduction.length == 0) {
        self.headerView.introductionLabel.text = @"写下你想对世界说的话，就现在";
    } else {
        self.headerView.introductionLabel.text = user.introduction;
    }
    
    self.headerView.signinDaysLabel.text = [NSString stringWithFormat:@"已连续签到%@天", user.checkInDay ? user.checkInDay : @"0"];
    
    NSURL *headerImageURL = [NSURL URLWithString:[UserItemTool defaultItem].headImgUrl];
    [self.headerView.headerImageView sd_setImageWithURL:headerImageURL placeholderImage:[UIImage imageNamed:@"默认头像"] options:SDWebImageRefreshCached];
}

- (void)dealloc{
    
}




#pragma mark - headView代理方法
/// 点击编辑个人资料按钮后调用
- (void)editButtonClicked {
    EditMyInfoViewController *vc = [[EditMyInfoViewController alloc] init];
    vc.transitioningDelegate = self;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:nil];
}

/// 点击我的页面的签到按钮后调用
- (void)checkInButtonClicked {
    
    CheckInViewController *vc = [[CheckInViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

/// 点击签到框框内的 “动态” 后调用
- (void)articleNumBtnClicked{
//    MineQAController *vc = [[MineQAController alloc] init];
//    vc.title = @"我的提问";
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
    
    PraiseViewController *vc = [[PraiseViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}

/// 点击签到框框内的 “评论” 后调用
- (void)remarkNumBtnClicked{
    MineQAController *vc = [[MineQAController alloc] init];
    vc.title = @"我的回答";
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

/// 点击签到框框内的 “获赞” 后调用
- (void)praiseNumBtnClicked{
    MineQAController *vc = [[MineQAController alloc] init];
    vc.title = @"评论回复";
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


//MARK: - tabelView代理方法方法:
/// 点击“关于我们”后调用
- (void)selectedAboutCell {
    MineAboutController *vc = [[MineAboutController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

/// 点击“设置”后调用
- (void)selectedSettingCell {
    MineSettingViewController *vc = [[MineSettingViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

/// 点击“积分商城”后调用
- (void)selectedShopCell {
    CheckInViewController *vc = [[CheckInViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}


#pragma mark - Presenter回调
//MineModel请求QA数据成功后调用
- (void)QAInfoRequestsSucceededWithItem:(MineQADataItem *)item {
    //item.askNum
    [self.headerView.articleNumBtn setTitle:item.answerNum forState:UIControlStateNormal];
    [self.headerView.remarkNumBtn setTitle:item.commentNum forState:UIControlStateNormal];
    [self.headerView.praiseNumBtn setTitle:item.praiseNum forState:UIControlStateNormal];
}


#pragma mark - 通知中心回调
// 退出登录后刷新开关，是否折叠等界面信息
- (void)loginSucceded {
    [self.appSettingTableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark - TableVIew数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellTitleStrArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
    
    cell.backgroundColor = tableView.backgroundColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    if (@available(iOS 11.0, *)) {
        cell.textLabel.textColor = [UIColor colorNamed:@"25_56_102&240_240_242"];
    } else {
        cell.textLabel.textColor = [UIColor colorWithRed:25/255.0 green:56/255.0 blue:102/255.0 alpha:1];
    }
    
    cell.textLabel.text = self.cellTitleStrArr[indexPath.row];
    
    return  cell;
}


# pragma mark - TableView代理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //代理是MineViewController
    switch (indexPath.row) {
        case 0:
            //点击积分商城
            [self selectedShopCell];
            break;
        case 1:
            //点击设置
            [self selectedSettingCell];
            break;
        case 2:
            //点击关于我们
            [self selectedAboutCell];
            break;
        default:
            break;
    }
}


#pragma mark - 转场动画
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [[EditMyInfoTransitionAnimator alloc] init];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    if (self.panGesture) {
        return [[EditMyInfoTransitionAnimator alloc] initWithPanGesture:self.panGesture];
    } else {
        return [[EditMyInfoTransitionAnimator alloc] init];
    }
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    if (self.panGesture) {
        return [[EditMyInfoPercentDrivenController alloc] initWithPanGesture:self.panGesture];
    } else {
        return nil;
    }
}

@end

