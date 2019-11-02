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

@interface MineViewController () <MineContentViewProtocol>

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
    
    
    // 临时的退出按钮
    UIButton *quitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    quitButton.frame = CGRectMake(10, 400, 100, 40);
    [quitButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [quitButton addTarget:self action:@selector(quit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:quitButton];
    
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

- (void)viewWillAppear:(BOOL)animated {
    self.contentView.headerView.nicknameLabel.text = [UserItemTool defaultItem].nickname;
    
    if ([UserItemTool defaultItem].introduction.length == 0) {
        self.contentView.headerView.introductionLabel.text = @"写下你想对世界说的话，就现在";
    } else {
        self.contentView.headerView.introductionLabel.text = [UserItemTool defaultItem].introduction;
    }
    
    self.contentView.headerView.signinDaysLabel.text = [NSString stringWithFormat:@"已连续签到%@天", [UserItemTool defaultItem].checkInDay];
}

- (void)quit {
    [UserItemTool logout];
    NSLog(@"%@", [UserItemTool defaultItem].realName);
}

// Presenter回调
- (void)QAInfoRequestsSucceeded {
    NSLog(@"邮问数据请求成功");
}

@end
