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

// 定义按钮标签的枚举
typedef NS_ENUM(NSInteger, ButtonTag) {
    ButtonTagFood = 1,
    ButtonTagBiaoTai = 2,
    ButtonTagActivityNotify = 3
};

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
    // 设置按钮标签(tag)
    self.centerView.foodBtn.tag = ButtonTagFood;
    self.centerView.biaoTaiBtn.tag = ButtonTagBiaoTai;
    self.centerView.activityNotifyBtn.tag = ButtonTagActivityNotify;
    
    // 设置按钮触发事件
    [self.centerView.foodBtn addTarget:self action:@selector(pushDetailVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.centerView.biaoTaiBtn addTarget:self action:@selector(pushDetailVC:) forControlEvents:UIControlEventTouchUpInside];
    
    // 添加图片点击手势
    [self addTapGestureToView:self.centerView.foodImg withTag:ButtonTagFood];
    [self addTapGestureToView:self.centerView.biaoTaiImg withTag:ButtonTagBiaoTai];
}

// 添加点击手势
- (void)addTapGestureToView:(UIView *)view withTag:(NSInteger)tag {
    view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushDetailVC:)];
    view.tag = tag;
    [view addGestureRecognizer:tapGesture];
}

// 按钮触碰事件
- (void)pushDetailVC:(id)sender {
    NSInteger tag = 0;
    if ([sender isKindOfClass:[UIButton class]]) {
        tag = ((UIButton *)sender).tag;
    } else if ([sender isKindOfClass:[UITapGestureRecognizer class]]) {
        tag = ((UIGestureRecognizer *)sender).view.tag;
    }
    
    switch (tag) {
        case ButtonTagFood: {
            [self pushFoodVC];
            break;
        }
        case ButtonTagBiaoTai: {
            [self pushAttitudeVC];
            break;
        }
        case ButtonTagActivityNotify: {
            // 处理活动布告按钮的逻辑
            break;
        }
        default:
            break;
    }
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

#pragma mark - Getter

- (CenterView *)centerView {
    if (_centerView == nil) {
        _centerView = [[CenterView alloc] initWithFrame:self.view.bounds];
    }
    return _centerView;
}

@end
