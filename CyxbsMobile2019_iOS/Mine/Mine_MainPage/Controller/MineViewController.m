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
#import "MineAboutController.h"
//#import "SelfSafeViewController.h"

#import "MainMsgCntModel.h"
#import "ArticleViewController.h"
#import "RemarkViewController.h"
#import "PraiseViewController.h"
#import "EditMyInfoModel.h"

#import "MineSettingViewController.h"
#import <UserNotifications/UserNotifications.h>
#import "CheckInModel.h"
//邮票中心
#import "StampCenterVC.h"

//意见与反馈
#import "FeedBackMainPageViewController.h"
#import "HistoricalFeedBackViewController.h"

@interface MineViewController () <UIViewControllerTransitioningDelegate,UITableViewDelegate, UITableViewDataSource, MineHeaderViewDelegate,MainMsgCntModelDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

/// tableView
@property (nonatomic, weak) UITableView *appSettingTableView;

/// 个人主页面的tableView顶部的一大块View都是，它会被设置成tableView的headview
@property (nonatomic, weak) MineHeaderView *headerView;

/// tabelViewCell的标题数据来源
@property (nonatomic, copy) NSArray <NSString*> *cellTitleStrArr;

@property (nonatomic, strong)MainMsgCntModel *msgCntModel;

/// 是否正在加载未读消息数、动态点赞评论的个数
@property (nonatomic, assign)BOOL isLoadingMsgCntData;

@property (nonatomic, assign)float cellHeight;

@property (nonatomic, assign)int cellHeigh;
@end


@implementation MineViewController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    
    
    if (@available(iOS 11.0, *)) {
        self.view.backgroundColor = [UIColor colorNamed:@"Mine_Store_ContainerColor"];
    } else {
        self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:242/255.0 blue:250/255.0 alpha:1];
    }
//    248_249_252&0_1_1
    self.msgCntModel = [[MainMsgCntModel alloc] init];
    self.msgCntModel.delegate = self;
    
    [self addContentView];
    [self addAppSettingTableView];
    self.isLoadingMsgCntData = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSucceded) name:@"Login_LoginSuceeded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadUserDataWithNoti:) name:@"UserItemGetUserInfo" object:nil];
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
    self.cellTitleStrArr = @[@"积分商城",@"设置",@"关于我们",@"意见与反馈"];
    
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
    if (self.isLoadingMsgCntData==YES) {
        return;
    }
    
    [[UserItem defaultItem] getUserInfo];
    [self.msgCntModel mainMsgCntModelLoadMoreData];
    
    self.isLoadingMsgCntData = YES;
    // 隐藏导航栏
    self.navigationController.navigationBar.hidden = YES;
}
- (void)loadUserDataWithNoti:(NSNotification*)noti {
    BOOL state = [noti.object boolValue];
    if (!state) {
        [NewQAHud showHudWith:@" 加载个人信息失败 " AddView:UIApplication.sharedApplication.windows.firstObject];
        return;
    }
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
    
    [self.headerView.headerImageBtn sd_setImageWithURL:headerImageURL forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"默认头像"] options:SDWebImageRefreshCached];
}


//MARK: - 消息数、动态、评论、获赞数model代理方法
- (void)mainMsgCntModelLoadDataFinishWithState:(MainMsgCntModelLoadDataState)state {
    BOOL isSuccess = NO;
    switch (state) {
        case MainMsgCntModelLoadDataStateSuccess_praise:
            isSuccess = YES;
            self.headerView.praiseNumBtn.msgCount = self.msgCntModel.uncheckedPraiseCnt;
            break;
        case MainMsgCntModelLoadDataStateFailure_praise:
            [NewQAHud showHudWith:@"加载未读获赞数失败～" AddView:self.view];
            break;
        case MainMsgCntModelLoadDataStateSuccess_comment:
            isSuccess = YES;
            self.headerView.remarkNumBtn.msgCount = self.msgCntModel.uncheckedCommentCnt;
            break;
        case MainMsgCntModelLoadDataStateFailure_comment:
            [NewQAHud showHudWith:@"加载未读评论数失败～" AddView:self.view];
            break;
        case MainMsgCntModelLoadDataStateSuccess_userCnt:
            isSuccess = YES;
            [self loadUserCountDataSuccess];
            break;
        case MainMsgCntModelLoadDataStateFailure_userCnt:
            [NewQAHud showHudWith:@"加载个人数据失败～" AddView:self.view];
            break;
    }
    
    
    if (self.isLoadingMsgCntData==NO) {
        return;
    }
    //如果没有没有加载成功，那么多半是后端出问题了，这种情况下，降低刷新未读消息会比较好
    if (isSuccess==NO) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.isLoadingMsgCntData = NO;
        });
    }else {
        self.isLoadingMsgCntData = NO;
    }
}

- (void)loadUserCountDataSuccess {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [self.headerView.articleNumBtn setTitle:[defaults stringForKey:MineDynamicCntStrKey]  forState:UIControlStateNormal];
    [self.headerView.remarkNumBtn setTitle:[defaults stringForKey:MineCommentCntStrKey]  forState:UIControlStateNormal];
    [self.headerView.praiseNumBtn setTitle:[defaults stringForKey:MinePraiseCntStrKey]  forState:UIControlStateNormal];
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
    ArticleViewController *vc = [[ArticleViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    //    MineQAController *vc = [[MineQAController alloc] init];
    //    vc.title = @"我的提问";
    //    vc.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:vc animated:YES];
}

/// 点击签到框框内的 “评论” 后调用
- (void)remarkNumBtnClicked{
    //存放用户最后一次点击评论按钮的时间，用这个时间在MainMsgCntModel获取用户的未读消息数时要使用
    [[NSUserDefaults standardUserDefaults] setValue:[self getTime] forKey:remarkLastClickTimeKey];
    RemarkViewController *vc = [[RemarkViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
//    MineQAController *vc = [[MineQAController alloc] init];
//    vc.title = @"我的回答";
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
}

/// 点击签到框框内的 “获赞” 后调用
- (void)praiseNumBtnClicked{
    //存放用户最后一次点击获赞按钮的时间，用这个时间在MainMsgCntModel获取用户的未读消息数时要使用
    [[NSUserDefaults standardUserDefaults] setValue:[self getTime] forKey:praiseLastClickTimeKey];
    
    PraiseViewController *vc = [[PraiseViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
//    MineQAController *vc = [[MineQAController alloc] init];
//    vc.title = @"评论回复";
//    vc.hidesBottomBarWhenPushed = YES;
//    vc.hidesBottomBarWhenPushed = YES;
}

- (void)headImgClicked {
    UIImagePickerController *ctrler = [[UIImagePickerController alloc] init];
    ctrler.allowsEditing = YES;
    ctrler.delegate = self;
    [self presentViewController:ctrler animated:YES completion:nil];
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

//    StampCenterVC * vc = [[StampCenterVC alloc] init];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
    
}

// 点击意见与反馈
- (void)selectedFeedBack {

//    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//    pasteboard.string = @"570919844";
//
//    UIAlertController *feedBackGroupAllert = [UIAlertController alertControllerWithTitle:@"欢迎加入反馈群" message:@"群号已复制到剪切板，快去QQ搜索吧～" preferredStyle:UIAlertControllerStyleAlert];
//
//    UIAlertAction *certainAction = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:nil];
//
//    [feedBackGroupAllert addAction:certainAction];
//
//    [self presentViewController:feedBackGroupAllert animated:YES completion:nil];
    
//    HistoricalFeedBackViewController * vc = [[HistoricalFeedBackViewController alloc] init];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];

    
    FeedBackMainPageViewController *fvc = [[FeedBackMainPageViewController alloc]init];
    fvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:fvc animated:YES];
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
    cell.textLabel.font = [UIFont fontWithName:PingFangSCRegular size:15*fontSizeScaleRate_SE];
    [cell setAccessoryType:(UITableViewCellAccessoryDisclosureIndicator)];
    if (@available(iOS 11.0, *)) {
        cell.textLabel.textColor = [UIColor colorNamed:@"25_56_102&240_240_242"];
    } else {
        cell.textLabel.textColor = [UIColor colorWithRed:25/255.0 green:56/255.0 blue:102/255.0 alpha:1];
    }
    
    cell.textLabel.text = self.cellTitleStrArr[indexPath.row];
//    CCLog(@"height=%f, width=%f",SCREEN_HEIGHT,SCREEN_WIDTH);
    
    return  cell;
}
//1.483
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 43.355*fontSizeScaleRate_SE;
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
        case 3:
            //意见反馈
            [self selectedFeedBack];
            break;
        default:
            break;
    }
}

/// 获取时间戳
- (NSString*)getTime {
    return [NSString stringWithFormat:@"%.0f", [NSDate.now timeIntervalSince1970]];
}

//imgPicker的代理方法：
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *img = info[UIImagePickerControllerEditedImage];
    [self.headerView.headerImageBtn setImage:img forState:normal];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [EditMyInfoModel uploadProfile:img success:^(NSDictionary * _Nonnull responseObject) {
        if ([responseObject[@"status"] intValue] == 200) {
            [UserItemTool defaultItem].headImgUrl = responseObject[@"data"][@"photosrc"];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"上传成功～";
            [hud hide:YES afterDelay:1];
        }
    } failure:^(NSError * _Nonnull error) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"上传成功～";
        [hud hide:YES afterDelay:1];
    }];
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

