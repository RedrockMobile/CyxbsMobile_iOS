//
//  MineViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/10/21.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "MineViewController.h"
//#import "LoginViewController.h"
#import "MineContentViewProtocol.h"
#import "MinePresenter.h"
#import "EditMyInfoViewController.h"
#import "EditMyInfoTransitionAnimator.h"
#import "EditMyInfoPercentDrivenController.h"
#import "CheckInViewController.h"
#import "MineQAController.h"
#import "MineQADataItem.h"
#import "MineAboutController.h"
#import <UserNotifications/UserNotifications.h>
@interface MineViewController () <MineContentViewDelegate, MineContentViewProtocol, UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) MinePresenter *presenter;

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
    
    // 绑定Presenter
    self.presenter = [[MinePresenter alloc] init];
    [self.presenter attachView:self];
    
    // 添加contentView
    MineContentView *contentView = [[MineContentView alloc] init];
    [self.view addSubview:contentView];
    self.contentView = contentView;
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    contentView.delegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated {
    // 加载邮问数据
    [self.presenter requestQAInfo];
    // 隐藏导航栏
    self.navigationController.navigationBar.hidden = YES;
    [self loadUserData];
}

- (void)loadUserData {
    UserItem *user = [UserItemTool defaultItem];
    self.contentView.headerView.nicknameLabel.text = user.nickname;
    
    if (user.introduction.length == 0) {
        self.contentView.headerView.introductionLabel.text = @"写下你想对世界说的话，就现在";
    } else {
        self.contentView.headerView.introductionLabel.text = user.introduction;
    }
    
    self.contentView.headerView.signinDaysLabel.text = [NSString stringWithFormat:@"已连续签到%@天", user.checkInDay ? user.checkInDay : @"0"];
    
    NSURL *headerImageURL = [NSURL URLWithString:[UserItemTool defaultItem].headImgUrl];
    [self.contentView.headerView.headerImageView sd_setImageWithURL:headerImageURL placeholderImage:[UIImage imageNamed:@"默认头像"] options:SDWebImageRefreshCached];
}

- (void)dealloc
{
    [self.presenter detachView];
}


#pragma mark - ContentView代理
- (void)editButtonClicked {
    EditMyInfoViewController *vc = [[EditMyInfoViewController alloc] init];
    vc.transitioningDelegate = self;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)checkInButtonClicked:(UIButton *)sender {
    CheckInViewController *vc = [[CheckInViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)foldButtonClicked:(UIButton *)foldButton foldState:(BOOL)isFold {
    [UIView animateWithDuration:0.25 animations:^{
        if (isFold) {
            foldButton.transform = CGAffineTransformMakeRotation(-M_PI_2);
        } else {
            foldButton.transform = CGAffineTransformMakeRotation(M_PI_2);
        }
    }];
    [self.contentView.classScheduleTableView reloadSection:0 withRowAnimation:UITableViewRowAnimationFade];
}

- (void)quitButtonClicked:(UIButton *)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"退出登录" message:@"退出登录将清除所有账号信息哟，你确定要退出吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *determine = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [UserItemTool logout];
    }];
    [alertController addAction:determine];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
//上课前提醒我
- (void)switchedRemindBeforeClass:(UISwitch *)sender {
    if (sender.on) {            // 打开开关
        [UserDefaultTool saveValue:@"test" forKey:@"Mine_RemindBeforeClass"];
        //通知WYCClassBookViewController要课前提醒
        [[NSNotificationCenter defaultCenter] postNotificationName:@"remindBeforeClass" object:nil];
    } else {                    // 关闭开关
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Mine_RemindBeforeClass"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //通知WYCClassBookViewController不要课前提醒
        [[NSNotificationCenter defaultCenter] postNotificationName:@"notRemindBeforeClass" object:nil];
    }
}
//每天推送课表
- (void)switchedRemindEveryDay:(UISwitch *)sender {
    if (sender.on) {            // 打开开关
        [UserDefaultTool saveValue:@"test" forKey:@"Mine_RemindEveryDay"];
    } else {                    // 关闭开关
        
        NSArray *idStrArr = @[@"每天晚上推送课表0",@"每天晚上推送课表1",@"每天晚上推送课表2",
                              @"每天晚上推送课表3",@"每天晚上推送课表4",@"每天晚上推送课表5",
                              @"每天晚上推送课表6",];
        [[UNUserNotificationCenter currentNotificationCenter] removeDeliveredNotificationsWithIdentifiers:idStrArr];
        
        [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers:idStrArr];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Mine_RemindEveryDay"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
//- (void)setLocalNoti{
//    //配置content
//    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
//    content.title = @"明日课表已送达";
//    content.body = @"查看明日课表，提前做好规划";
//    [content setSound:[UNNotificationSound defaultSound]];
//
//
//    //配置component
//    NSDateComponents *component = [[NSDateComponents alloc] init];
//    //推送时间
//    component.hour = 22;
//
//    //通过component配置trigger
//    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:component repeats:YES];
//
//    //通过trigger和content配置request
//    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"deliverSchedulEverday" content:content trigger:trigger];
//
//    //通过request添加本地通知
//    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:nil];
//}
//打开app后是否自动弹出课表
- (void)switchedLaunchingWithClassScheduleView:(UISwitch *)sender {
    if (sender.on) {            // 打开开关
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Mine_LaunchingWithClassScheduleView"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {                    // 关闭开关
        [UserDefaultTool saveValue:@"test" forKey:@"Mine_LaunchingWithClassScheduleView"];
    }
}

- (void)questionLabelClicked {
    MineQAController *vc = [[MineQAController alloc] init];
    vc.title = @"我的提问";
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)answerLabelClicked {
    MineQAController *vc = [[MineQAController alloc] init];
    vc.title = @"我的回答";
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)responseLabelClicked {
    MineQAController *vc = [[MineQAController alloc] init];
    vc.title = @"评论回复";
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)selectedAboutCell {
    MineAboutController *vc = [[MineAboutController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Presenter回调
- (void)QAInfoRequestsSucceededWithItem:(MineQADataItem *)item {
    self.contentView.headerView.questionsNumberLabel.text = [NSString stringWithFormat:@"%@", item.askNum];
    self.contentView.headerView.answerNumberLabel.text = [NSString stringWithFormat:@"%@", item.answerNum];
    self.contentView.headerView.responseNumberLabel.text = [NSString stringWithFormat:@"%@", item.commentNum];
    self.contentView.headerView.praiseNumberLabel.text = [NSString stringWithFormat:@"%@", item.praiseNum];
}


#pragma mark - 通知中心回调
// 退出登录后刷新开关，是否折叠等界面信息
- (void)loginSucceded {
    [self.contentView.classScheduleTableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
    [self.contentView.appSettingTableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
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
