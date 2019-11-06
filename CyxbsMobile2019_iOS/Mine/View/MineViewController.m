//
//  MineViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/10/21.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "MineViewController.h"
#import "LoginViewController.h"
#import "MineContentViewProtocol.h"
#import "MinePresenter.h"

@interface MineViewController () <MineContentViewDelegate, MineContentViewProtocol>

@property (nonatomic, strong) MinePresenter *presenter;

@end

@implementation MineViewController


#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 绑定Presenter
    self.presenter = [[MinePresenter alloc] init];
    [self.presenter attachView:self];
    
    // 加载邮问数据
    [self.presenter requestQAInfo];
    
    // 添加contentView
    MineContentView *contentView = [[MineContentView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:contentView];
    self.contentView = contentView;
    contentView.delegate = self;
    
    
    // 临时的退出按钮
    UIButton *quitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    quitButton.frame = CGRectMake(250, 100, 100, 40);
    [quitButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [quitButton addTarget:self action:@selector(quit) forControlEvents:UIControlEventTouchUpInside];
    [contentView.headerView addSubview:quitButton];
    
}

- (void)viewWillAppear:(BOOL)animated {
    UserItem *user = [UserItemTool defaultItem];
    self.contentView.headerView.nicknameLabel.text = user.nickname;
    
    if (user.introduction.length == 0) {
        self.contentView.headerView.introductionLabel.text = @"写下你想对世界说的话，就现在";
    } else {
        self.contentView.headerView.introductionLabel.text = user.introduction;
    }
    
    self.contentView.headerView.signinDaysLabel.text = [NSString stringWithFormat:@"已连续签到%@天", user.checkInDay];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.presenter detachView];
}


#pragma mark - 按钮回调
- (void)quit {
    [UserItemTool logout];
    NSLog(@"%@", [UserItemTool defaultItem].realName);
}


#pragma mark - ContentView代理
- (void)editButtonClicked {
    NSLog(@"跳转到修改信息");
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

- (void)switchedRemindBeforeClass:(UISwitch *)sender {
    if (sender.on) {            // 打开开关
        [UserDefaultTool saveValue:@"test" forKey:@"Mine_RemindBeforeClass"];
    } else {                    // 关闭开关
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Mine_RemindBeforeClass"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)switchedRemindEveryDay:(UISwitch *)sender {
    if (sender.on) {            // 打开开关
        [UserDefaultTool saveValue:@"test" forKey:@"Mine_RemindEveryDay"];
    } else {                    // 关闭开关
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Mine_RemindEveryDay"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)switchedDisplayMemoPad:(UISwitch *)sender {
    if (sender.on) {            // 打开开关
        [UserDefaultTool saveValue:@"test" forKey:@"Mine_DisplayMemoPad"];
    } else {                    // 关闭开关
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Mine_DisplayMemoPad"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)switchedLaunchingWithClassScheduleView:(UISwitch *)sender {
    if (sender.on) {            // 打开开关
        [UserDefaultTool saveValue:@"test" forKey:@"Mine_LaunchingWithClassScheduleView"];
    } else {                    // 关闭开关
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Mine_LaunchingWithClassScheduleView"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


#pragma mark - Presenter回调
- (void)QAInfoRequestsSucceeded {
    NSLog(@"邮问数据请求成功");
}

@end
