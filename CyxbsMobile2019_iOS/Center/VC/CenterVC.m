//
//  CenterVC.m
//  CyxbsMobile2019_iOS
//
//  Created by 宋开开 on 2023/3/14.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "CenterVC.h"
#import "CenterView.h"
#import "ClassTabBar.h"
#import "CenterHeader.h"
#import <Accelerate/Accelerate.h>

@interface CenterVC ()

/// 封面View
@property (nonatomic, strong) CenterView *centerView;

@end

@implementation CenterVC

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    // 不做上拉课表
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HideBottomClassScheduleTabBarView" object:nil userInfo:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.centerView];
    // 获取姓名
    [self getName];
    // 网络请求天数和封面
    [self requestDays];
    // 设置按钮点击事件
    [self setDetailBtns];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    ((ClassTabBar *)self.tabBarController.tabBar).hidden = NO;
    // 恢复背景颜色
    if (@available(iOS 15.0, *)) {
        UITabBarAppearance *appearance = [[UITabBarAppearance alloc]init];
        appearance.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1] darkColor:[UIColor colorWithHexString:@"#2C2C2C" alpha:1]];
        self.tabBarController.tabBar.scrollEdgeAppearance = appearance;
        self.tabBarController.tabBar.standardAppearance = appearance;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowBottomClassScheduleTabBarView" object:nil userInfo:nil];
}

#pragma mark - Method

/// 获取人名
- (void)getName {
    UserItem *item = [[UserItem alloc] init];
    self.centerView.centerPromptBoxView.nameLab.text = [NSString stringWithFormat:@"Hi，%@", item.realName];
}

/// 网络请求天数
- (void)requestDays {
    NSDictionary *params = @{
        @"token": [UserItemTool defaultItem].token
    };
    [HttpTool.shareTool
     request:Discover_GET_playground_center_API
     type:HttpToolRequestTypeGet
     serializer:HttpToolRequestSerializerHTTP
     bodyParameters:params
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        NSLog(@"👁️%@", object);
        NSLog(@"🦞%@", object[@"data"][@"days"]);
        int dayNums = object[@"data"][@"days"];
        NSLog(@"🌮%d", dayNums);
        if (dayNums >= 10 && dayNums < 100) {
            self.centerView.centerPromptBoxView.daysLab.text = @"这是你来到游乐场的第     天";
        } else if (dayNums >= 100 && dayNums < 1000) {
            self.centerView.centerPromptBoxView.daysLab.text = @"这是你来到游乐场的第       天";
        } else if (dayNums >= 1000) {
            self.centerView.centerPromptBoxView.daysLab.text = @"这是你来到游乐场的第         天";
        }
        if (object[@"data"][@"days"] == nil) {
            self.centerView.centerPromptBoxView.daysNumLab.text = [NSString stringWithFormat:@"%ld", (long)[NSUserDefaults.standardUserDefaults integerForKey:@"lastTimeIntoYouCity"]];
        } else {
            self.centerView.centerPromptBoxView.daysNumLab.text = [NSString stringWithFormat:@"%@", object[@"data"][@"days"]];
        }
        
        [NSUserDefaults.standardUserDefaults setInteger:object[@"data"][@"days"] forKey:@"lastTimeIntoYouCity"];
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.centerView.centerPromptBoxView.daysLab.text = [NSString stringWithFormat:@"这是你来到属于你的邮乐园的第%ld天",  (long)[NSUserDefaults.standardUserDefaults integerForKey:@"lastTimeIntoYouCity"]];
    }];
}

/// 按钮设置方法
- (void)setDetailBtns {
    // 目前是三个界面：美食，表态和活动布告
    // 设置tag
    self.centerView.foodBtn.tag = 0;
    self.centerView.biaoTaiBtn.tag = 1;
    self.centerView.activityNotifyBtn.tag = 2;
    // 三个按钮均设置一样的跳转方法，再根据不同btn 的tag 来跳转到不同的VC
    [self.centerView.foodBtn addTarget:self action:@selector(pushDetailVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.centerView.biaoTaiBtn addTarget:self action:@selector(pushDetailVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.centerView.activityNotifyBtn addTarget:self action:@selector(pushDetailVC:) forControlEvents:UIControlEventTouchUpInside];
}

// MARK: SEL

/// 按钮触碰事件
- (void)pushDetailVC:(UIButton *)sender {
    switch (sender.tag) {
        case 0:  // 美食
//            [self.navigationController pushViewController:<#(nonnull UIViewController *)#> animated:YES];
            break;
        case 1:  // 表态
//            [self.navigationController pushViewController:<#(nonnull UIViewController *)#> animated:YES];
            break;
        case 2:  // 活动布告
//            [self.navigationController pushViewController:<#(nonnull UIViewController *)#> animated:YES];
            break;
        default:
            break;
    }
}

#pragma mark - Getter

- (CenterView *)centerView {
    if (_centerView == nil) {
        _centerView = [[CenterView alloc] initWithFrame:self.view.bounds];
    }
    return _centerView;
}

@end
