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
#import "FoodVC.h"
#import "AttitudeMainPageVC.h"

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

- (void)viewDidDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    ((ClassTabBar *)self.tabBarController.tabBar).hidden = NO;
//    // 恢复背景颜色
//    if (@available(iOS 15.0, *)) {
//        UITabBarAppearance *appearance = [[UITabBarAppearance alloc]init];
//        appearance.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1] darkColor:[UIColor colorWithHexString:@"#2C2C2C" alpha:1]];
//        self.tabBarController.tabBar.scrollEdgeAppearance = appearance;
//        self.tabBarController.tabBar.standardAppearance = appearance;
//    }
//    
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
    [HttpTool.shareTool
     request:Center_GET_playground_API
     type:HttpToolRequestTypeGet
     serializer:HttpToolRequestSerializerHTTP
     bodyParameters:nil
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
//        NSLog(@"👁️%@", object);
//        NSLog(@"🦞%@", object[@"data"][@"days"]);
        if (object[@"data"][@"days"] == nil) {
            NSInteger num = [NSUserDefaults.standardUserDefaults integerForKey:@"lastTimeIntoYouCity"];
            [self.centerView.centerPromptBoxView setNum:num];
        } else {
            NSInteger dayNums = [object[@"data"][@"days"] longValue];
            dayNums = MAX(0, dayNums);
            [self.centerView.centerPromptBoxView setNum:dayNums];
            [NSUserDefaults.standardUserDefaults setInteger:dayNums forKey:@"lastTimeIntoYouCity"];
        }
        
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSInteger num = [NSUserDefaults.standardUserDefaults integerForKey:@"lastTimeIntoYouCity"];
        [self.centerView.centerPromptBoxView setNum:num];
    }];
}

// 按钮设置方法
- (void)setDetailBtns {
    // 设置按钮触发事件
    [self.centerView.foodBtn addTarget:self action:@selector(pushFoodVC) forControlEvents:UIControlEventTouchUpInside];
    [self.centerView.biaoTaiBtn addTarget:self action:@selector(pushAttitudeVC) forControlEvents:UIControlEventTouchUpInside];
    [self.centerView.activityNotifyBtn addTarget:self action:@selector(pushActivityVC) forControlEvents:UIControlEventTouchUpInside];
    
    // 添加图片点击手势
    [self addTapGestureToView:self.centerView.foodImg withSelector:@selector(pushFoodVC)];
    [self addTapGestureToView:self.centerView.biaoTaiImg withSelector:@selector(pushAttitudeVC)];
    [self addTapGestureToView:self.centerView.activityNotifyImg withSelector:@selector(pushActivityVC)];
}

// 添加点击手势
- (void)addTapGestureToView:(UIView *)view withSelector:(SEL)selector {
    view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:selector];
    [view addGestureRecognizer:tapGesture];
}

// 跳转到美食
- (void)pushFoodVC {
    FoodVC* foodVC = [[FoodVC alloc] init];
    foodVC.hidesBottomBarWhenPushed = YES;
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:foodVC animated:YES];
}

// 跳转到表态
- (void)pushAttitudeVC {
    AttitudeMainPageVC* attitudeVC = [[AttitudeMainPageVC alloc] init];
    attitudeVC.hidesBottomBarWhenPushed = YES;
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:attitudeVC animated:YES];
}

// 跳转到活动
- (void)pushActivityVC {
}

#pragma mark - Getter

- (CenterView *)centerView {
    if (_centerView == nil) {
        _centerView = [[CenterView alloc] initWithFrame:self.view.bounds];
    }
    return _centerView;
}

@end
