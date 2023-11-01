//
//  DiscoverViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/10/21.
//  Copyright © 2019 Redrock. All rights reserved.
//

// VC
#import "DiscoverViewController.h"
#import "LoginVC.h"
#import "CheckInViewController.h"
#import "CQUPTMapViewController.h"         // 地图
#import "FinderToolViewController.h"       // 工具
#import "TODOMainViewController.h"         // 邮子清单
#import "TODOMainViewController.h"         // 邮子清单
#import "ScheduleInquiryViewController.h"  // 查课表
#import "CalendarViewController.h"         // 校历
#import "DiscoverADModel.h"                // banner
#import "SchoolBusVC.h"                    // 校车
#import "ElectricViewController.h"         // 电费

// View
#import "FinderView.h"
#import "ClassScheduleTabBarView.h"
#import "ClassTabBar.h"

// Tool
#import "UserDefaultTool.h"
#import <SDCycleScrollView.h>  // banner的无限滚动

// swift (将Swift中的类暴露给OC)
#import "掌上重邮-Swift.h"

typedef NS_ENUM(NSUInteger, LoginStates) {
    DidntLogin,
    LoginTimeOut,
    AlreadyLogin,
};

@interface DiscoverViewController () <
    UIScrollViewDelegate,
    SDCycleScrollViewDelegate
>

@property (nonatomic, assign, readonly) LoginStates loginStatus;

@property (nonatomic, weak) UIScrollView *contentView;

/// 上方发现页面
@property (nonatomic, weak) FinderView *finderView;

/// 电费页面
@property (nonatomic, strong) ElectricViewController *electricViewVC;

///底部色块
@property (nonatomic, strong) UIView *colorView;

/// 用来遮挡tabbar的View
@property (nonatomic, weak) UIView *hideTabbarView;

@property (nonatomic, strong) DiscoverADModel *ADModel;

/// Data
@property (nonatomic, assign) int classTabbarHeight;

@property (nonatomic, assign) int classTabbarCornerRadius;

@end

@implementation DiscoverViewController


#pragma mark - Life cycle

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.barTintColor =
    [UIColor dm_colorWithLightColor:
        [UIColor colorWithHexString:@"#FFFFFF" alpha:1]
                          darkColor:
        [UIColor colorWithHexString:@"#2D2D2D" alpha:1]];
    
    self.navigationController.navigationBar.hidden = YES;

    if (self.loginStatus != AlreadyLogin) {
        [self presentToLogin];
        CCLog(@"needLogIn, %lud", self.loginStatus);
    } else {
        [self RequestCheckinInfo];
        CCLog(@"LogIned, %lud", self.loginStatus);
    }

    self.navigationController.navigationBar.translucent = NO;
    self.classTabbarHeight = 58;
    self.classTabbarCornerRadius = 16;
    if (((ClassTabBar *)(self.tabBarController.tabBar))
       .classScheduleTabBarView == nil) {
        ClassScheduleTabBarView *classTabBarView =
        [[ClassScheduleTabBarView alloc] initWithFrame:
         CGRectMake(0, - self.classTabbarHeight, MAIN_SCREEN_W, self.classTabbarHeight)];
        
        classTabBarView.layer.cornerRadius = self.classTabbarCornerRadius;
        [(ClassTabBar *)(self.tabBarController.tabBar) addSubview:classTabBarView];
        
        ((ClassTabBar *)(self.tabBarController.tabBar))
            .classScheduleTabBarView = classTabBarView;
        
        ((ClassTabBar *)(self.tabBarController.tabBar))
            .classScheduleTabBarView.userInteractionEnabled = YES;
            
        if (![NSUserDefaults.standardUserDefaults objectForKey:@"Mine_LaunchingWithClassScheduleView"] && classTabBarView.mySchedul!=nil){
            [classTabBarView.mySchedul setModalPresentationStyle:(UIModalPresentationCustom)];
            classTabBarView.mySchedul.fakeBar.alpha = 0;
            [classTabBarView.viewController presentViewController:classTabBarView.mySchedul animated:YES completion:nil];
        }

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentMySchedul) name:@"DiscoverVCShouldPresentMySchedul" object:nil];
    }
    
    [JudgeArrangeMessage judgetabBarRedDot];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addContentView];
    [self addFinderView];
    [self addButtonTargetInFinderview];
    [self addelectricViewVC];
    [self layoutSubviews];
    [self addNotifications];
    self.view.backgroundColor = self.finderView.backgroundColor;
}

#pragma mark - Method

/// 弹出课表
- (void)presentMySchedul{
    ClassScheduleTabBarView *classTabBarView = ((ClassTabBar *)(self.tabBarController.tabBar)).classScheduleTabBarView;
    [classTabBarView.mySchedul setModalPresentationStyle:(UIModalPresentationCustom)];
    classTabBarView.mySchedul.fakeBar.alpha = 0;
    [classTabBarView.viewController presentViewController:classTabBarView.mySchedul animated:YES completion:nil];
}

/// 添加通知中心
- (void)addNotifications {
    // 自定义发现主页三个控件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFinderViewUI) name:@"customizeMainPageViewSuccess" object:nil];
    // 退出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backToThisController) name:@"logout" object:nil];
}

/// 给FinderView按钮添加事件
- (void)addButtonTargetInFinderview {
    // 签到按钮
    [self.finderView.topView addSignBtnTarget:self action:@selector(touchWriteButton)];
    
    // 四个便捷按钮
    for (EnterButton *enterButton in self.finderView.enterButtonArray) {
        if ([enterButton.label.text isEqual: @"查课表"]) {
            [enterButton.imageButton addTarget:self action:@selector(touchSchedule) forControlEvents:UIControlEventTouchUpInside];
        } else if ([enterButton.label.text isEqual: @"校车轨迹"]) {
            [enterButton.imageButton addTarget:self action:@selector(touchSchoolCar) forControlEvents:UIControlEventTouchUpInside];
        } else if ([enterButton.label.text isEqual: @"更多功能"]) {
            [enterButton.imageButton addTarget:self action:@selector(touchMore) forControlEvents:UIControlEventTouchUpInside];
        } else if ([enterButton.label.text isEqual: @"没课约"]) {
            [enterButton.imageButton addTarget:self action:@selector(touchNoClassAppointment) forControlEvents:UIControlEventTouchUpInside];
        } else if ([enterButton.label.text isEqual: @"校历"]) {
            [enterButton.imageButton addTarget:self action:@selector(touchSchoolCalender) forControlEvents:UIControlEventTouchUpInside];
        } else if ([enterButton.label.text isEqual:@"重邮地图"]){
            [enterButton.imageButton addTarget:self action:@selector(touchMap) forControlEvents:UIControlEventTouchUpInside];
        } else if ([enterButton.label.text isEqualToString:@"邮子清单"]){
            [enterButton.imageButton addTarget:self action:@selector(touchToDOList) forControlEvents:UIControlEventTouchUpInside];
        }
        [self.finderView addSubview:enterButton];
    }
}

/// 设置位置
- (void)layoutSubviews {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        if(IS_IPHONEX) {
            make.top.equalTo(self.view).offset(44);
        } else {
            make.top.equalTo(self.view).offset(20);
        }
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];

    [self.finderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.finderView.enterButtonArray.firstObject.mas_bottom).offset(20);
    }];
    
    [self.electricViewVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.finderView.mas_bottom);
        make.width.equalTo(self.contentView);
        make.height.equalTo(@152);
        make.bottom.equalTo(self.contentView).offset(-20);
    }];
    
    [self.colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.electricViewVC.view.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@600);
    }];
}

/// 登录
- (void)presentToLogin {
    LoginVC *loginVC = [[LoginVC alloc] init];
    
    UITabBarController *tabBarVC = (UITabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    loginVC.modalPresentationStyle = UIModalPresentationFullScreen;
    if (tabBarVC.presentedViewController) {
        [tabBarVC dismissViewControllerAnimated:YES completion:^{
            [tabBarVC presentViewController:loginVC animated:YES completion:nil];
        }];
    } else {
        [tabBarVC presentViewController:loginVC animated:YES completion:nil];
    }
    if (self.loginStatus == LoginTimeOut) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"太久没有登录掌邮了..." message:@"\n重新登录试试吧" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好哒！" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [loginVC presentViewController:alert animated:YES completion:nil];
    }
}

/// 添加ScrollView 作为主View
- (void)addContentView {
    UIScrollView *contentView = [[UIScrollView alloc]init];
    self.contentView = contentView;
    self.contentView.delegate = self;
    if (@available(iOS 11.0, *)) {
        self.contentView.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#F2F3F8" alpha:1] darkColor:[UIColor colorWithHexString:@"#000000" alpha:1]];
    } else {
        self.contentView.backgroundColor = [UIColor colorWithRed:242/255.0 green:243/255.0 blue:248/255.0 alpha:1];
    }
    self.contentView.showsVerticalScrollIndicator = NO;
    self.contentView.contentInset = UIEdgeInsetsMake(0, 0, 70, 0);
    [self.view addSubview:self.contentView];
}

/// 添加FinderView
- (void)addFinderView {
    FinderView *finderView = [[FinderView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
    // Remake by SSR
    [self addChildViewController:finderView.msgViewController];
    
    self.finderView = finderView;
    self.finderView.bannerView.delegate = self;  // 无限滚动
    [self.contentView addSubview:finderView];
}

/// 更新Banner UI
- (void)UpdateBannerViewUI {
    NSMutableArray *urlStrings = [NSMutableArray array];
    NSMutableArray *bannerGoToURL = [NSMutableArray array];
    for(DiscoverAD *item in self.ADModel.ADCollectionInformation.ADCollection) {
        [urlStrings addObject:item.pictureUrl];
        [bannerGoToURL addObject:item.pictureGoToUrl];
    }
    self.finderView.bannerGoToURL = bannerGoToURL;
    self.finderView.bannerURLStrings = urlStrings;
    [self.finderView updateBannerViewIfNeeded];
}

/// 更新FinderView UI
- (void)updateFinderViewUI {
    [self.finderView remoreAllEnters];
    [self.finderView addSomeEnters];
    [self addButtonTargetInFinderview];
    [self layoutSubviews];
}

- (void)addelectricViewVC {
    ElectricViewController *vc = [[ElectricViewController alloc] init];
    vc.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.electricViewVC = vc;
    [self addChildViewController:vc];
    [self.contentView addSubview:self.electricViewVC.view];
    
    UIView *view = [[UIView alloc]init];//色块View
    self.colorView = view;
    self.colorView.backgroundColor = self.electricViewVC.view.backgroundColor;
    [self.contentView addSubview:self.colorView];

}

- (void)backToThisController{
    self.navigationController.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:NO];
}

// MARK: 网络请求

static int requestCheckinInfo = 0;
/// 登录状态时，网络请求签到信息
- (void)RequestCheckinInfo {
    if(![UserDefaultTool getStuNum]){
        requestCheckinInfo++;
        if (requestCheckinInfo==5) {
            requestCheckinInfo = 0;
            return;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self RequestCheckinInfo];
        });
        return;
    }
    
    requestCheckinInfo = 0;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[UserDefaultTool getStuNum], @"stunum",[UserDefaultTool getIdNum], @"idnum",nil];

    [HttpTool.shareTool
     request:Mine_POST_checkInInfo_API
     type:HttpToolRequestTypePost
     serializer:HttpToolRequestSerializerHTTP
     bodyParameters:params
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        [UserItemTool defaultItem].checkInDay = object[@"data"][@"check_in_days"];
        [UserItemTool defaultItem].integral = object[@"data"][@"integral"];
        [UserItemTool defaultItem].rank = object[@"data"][@"rank"];
        [UserItemTool defaultItem].rank_Persent = object[@"data"][@"percent"];
        [UserItemTool defaultItem].week_info = object[@"data"][@"week_info"];
        [UserItemTool defaultItem].canCheckIn = [object[@"data"][@"can_check_in"] boolValue];
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

/// 很奇怪的网络请求
- (void)request {
    [self.ADModel
     requestBannerSuccess:^{
        [self UpdateBannerViewUI];
    }
     failure:^(NSError * _Nonnull error) {
        NSLog(@"error");
    }];
}

// MARK: SEL

- (void)touchWriteButton {
    NSLog(@"点击了签到button");
    CheckInViewController * vc = [[CheckInViewController alloc]init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController presentViewController:vc animated:true completion:^{
        
    }];
}

- (void)touchSchoolCar {
    NSLog(@"点击了校车查询");
    SchoolBusVC *vc = [[SchoolBusVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)touchSchedule {
    NSLog(@"点击了查课表");
    ScheduleInquiryViewController *vc = [[ScheduleInquiryViewController alloc]init];
    vc.title = @"查课表";
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)touchNoClassAppointment {
    NSLog(@"点击了没课约");
    WeDateVC *vc = [[WeDateVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)touchSchoolCalender {
    NSLog(@"点击了校历");
    CalendarViewController *vc = [[CalendarViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)touchMap {
    NSLog(@"点击了重邮地图");
    CQUPTMapViewController * vc = [[CQUPTMapViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)touchToDOList{
    NSLog(@"点击了邮子清单");
    TODOMainViewController *vc = [[TODOMainViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)touchMore {
    NSLog(@"点击了更多功能");
    FinderToolViewController *vc = [[FinderToolViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Delegate

// MARK: <SDCycleScrollViewDelegate>

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    // 如果是http或者https协议的URL，用浏览器打开网页，如果是cyxbs协议的URL，打开对应页面
    if ([self.finderView.bannerGoToURL[index] hasPrefix:@"http"]) {
        URLController * controller = [[URLController alloc]init];
        controller.hidesBottomBarWhenPushed = YES;
        controller.toUrl = self.finderView.bannerGoToURL[index];
        [self.navigationController pushViewController:controller animated:YES];

    } else if ([self.finderView.bannerGoToURL[index] hasPrefix:@"cyxbs"]) {
        
        // TODO: 使用RisingRouter
    }
    
}

#pragma mark - Getter

- (LoginStates)loginStatus {
    if (![UserItemTool defaultItem].token) {
        return DidntLogin;
    } else {
        if (![[UserItemTool defaultItem].iat integerValue]
            && [[UserItemTool defaultItem].iat integerValue] + 45 * 24 * 3600 < [NSDate nowTimestamp]) {
            return LoginTimeOut;
        } else {
            return AlreadyLogin;
        }
    }
}

- (DiscoverADModel *)ADModel {
    if (_ADModel == nil) {
        _ADModel = [[DiscoverADModel alloc] init];
    }
    return _ADModel;
}

@end
