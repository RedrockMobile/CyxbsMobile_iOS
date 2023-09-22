//
//  NewQAMainVC.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/8/17.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "NewQAMainVC.h"
@interface NewQAMainVC ()

@end

@implementation NewQAMainVC

- (void)viewDidLoad{
    self.view.backgroundColor = [UIColor dm_colorWithLightColor:UIColor.whiteColor darkColor:UIColor.blackColor];
    [self addStopView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HideBottomClassScheduleTabBarView" object:nil userInfo:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    ((ClassTabBar *)self.tabBarController.tabBar).hidden = NO;
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowBottomClassScheduleTabBarView" object:nil userInfo:nil];
//    self.isNeedFresh = NO;
}

//服务功能暂停页
- (void)addStopView{
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"人在手机里"]];
    [self.view addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-20);
    }];
    
    UILabel *Lab = [[UILabel alloc] init];
    Lab.text = @"服务升级ing...敬请期待";
    Lab.font = [UIFont fontWithName:PingFangSCLight size: 12];
    Lab.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#112C54" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
    [self.view addSubview:Lab];
    [Lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(imgView.mas_bottom).offset(16);
    }];
}

@end
