//
//  DiscoverViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/10/21.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "DiscoverViewController.h"

#import "FinderToolViewController.h"
#import "FinderView.h"
#import "CheckInViewController.h"
#import "WeDateViewController.h"  //没课约
#import "CQUPTMapViewController.h"
#import "LoginVC.h"
#import "TODOMainViewController.h"  //邮子清单
#import "ScheduleInquiryViewController.h"
#import "ClassScheduleTabBarView.h"
#import "ClassTabBar.h"
#import "CalendarViewController.h"
#import "DiscoverADModel.h"
#import "SchoolBusVC.h"
#import "掌上重邮-Swift.h"        // 将Swift中的类暴露给OC
#import "UserDefaultTool.h"

typedef NS_ENUM(NSUInteger, LoginStates) {
    DidntLogin,
    LoginTimeOut,
    AlreadyLogin,
};

@interface DiscoverViewController () <
    UIScrollViewDelegate,
    LQQFinderViewDelegate
>

@property (nonatomic, assign, readonly) LoginStates loginStatus;

@property (nonatomic, weak) UIScrollView *contentView;

/// 上方发现页面
@property(nonatomic, weak) FinderView *finderView;

/// 用来遮挡tabbar的View
@property (nonatomic, weak) UIView *hideTabbarView;

@property (nonatomic, strong) DiscoverADModel *ADModel;

/// Data
@property (nonatomic, assign) int classTabbarHeight;

@property (nonatomic, assign) int classTabbarCornerRadius;

@end

@implementation DiscoverViewController

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

#pragma mark - Life cycle

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.barTintColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1] darkColor:[UIColor colorWithHexString:@"#2D2D2D" alpha:1]];
    
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
    if(((ClassTabBar *)(self.tabBarController.tabBar))
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
            
        if(![NSUserDefaults.standardUserDefaults objectForKey:@"Mine_LaunchingWithClassScheduleView"] && classTabBarView.mySchedul!=nil){
            [classTabBarView.mySchedul setModalPresentationStyle:(UIModalPresentationCustom)];
            classTabBarView.mySchedul.fakeBar.alpha = 0;
            [classTabBarView.viewController presentViewController:classTabBarView.mySchedul animated:YES completion:nil];
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentMySchedul) name:@"DiscoverVCShouldPresentMySchedul" object:nil];
    }
}

// MARK: TODO: Method
- (void)presentMySchedul{
    ClassScheduleTabBarView *classTabBarView = ((ClassTabBar *)(self.tabBarController.tabBar)).classScheduleTabBarView;
    [classTabBarView.mySchedul setModalPresentationStyle:(UIModalPresentationCustom)];
    classTabBarView.mySchedul.fakeBar.alpha = 0;
    [classTabBarView.viewController presentViewController:classTabBarView.mySchedul animated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addContentView];
    [self addFinderView];
    [self layoutSubviews];
    [self addNotifications];
    self.view.backgroundColor = self.finderView.backgroundColor;
}

// MARK: TODO: Method
- (void)addNotifications {
    // 自定义发现主页三个控件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFinderViewUI) name:@"customizeMainPageViewSuccess" object:nil];
    // 退出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backToThisController) name:@"logout" object:nil];
}


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
}

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

///这里有问题
static int requestCheckinInfo = 0;
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
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[UserDefaultTool getStuNum],@"stunum",[UserDefaultTool getIdNum],@"idnum",nil];

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

- (void)configNavagationBar {
    self.navigationController.navigationBar.translucent = NO;

    if (@available(iOS 11.0, *)) {
        self.navigationController.navigationBar.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#F2F3F8" alpha:1] darkColor:[UIColor colorWithHexString:@"#000000" alpha:1]];
    }
    //隐藏导航栏的分割线
    if (@available(iOS 11.0, *)) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#F2F3F8" alpha:1] darkColor:[UIColor colorWithHexString:@"#000000" alpha:1]]] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    }
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

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

- (void)addFinderView {
    FinderView *finderView = [[FinderView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
    // Remake by SSR
    [self addChildViewController:finderView.msgViewController];
    
    self.finderView = finderView;
    self.finderView.delegate = self;
    [self.contentView addSubview:finderView];
}

#pragma mark - 即将更改的东西

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

#pragma mark - 看不懂的网络请求骚操作

- (void)request {
    [self.ADModel
     requestBannerSuccess:^{
        [self UpdateBannerViewUI];
    }
     failure:^(NSError * _Nonnull error) {
        NSLog(@"error");
    }];
}

#pragma mark - Lazy

- (DiscoverADModel *)ADModel {
    if (_ADModel == nil) {
        _ADModel = [[DiscoverADModel alloc] init];
    }
    return _ADModel;
}

#pragma mark - end

- (void)updateFinderViewUI {
    [self.finderView remoreAllEnters];
    [self.finderView addSomeEnters];
    [self layoutSubviews];
}

- (void)reloadElectricViewIfNeeded {
    [self reloadViewController:self];
}

- (void)reloadVolViewIdNeeded {
    [self reloadViewController:self];
}

- (void)reloadViewController:(UIViewController *)viewController {
    NSArray *subviews = [viewController.view subviews];
    if (subviews.count > 0) {
        for (UIView *sub in subviews) {
            [sub removeFromSuperview];
        }
    }
    [viewController viewWillDisappear:YES];
    [viewController viewDidDisappear:YES];
    [viewController viewDidLoad];
    [viewController viewWillAppear:YES];
    [viewController viewDidAppear:YES];
    [viewController viewWillLayoutSubviews];
}

- (void)sheetViewCancelBtnClicked {
    //显示底部课表的tabBar
    [UIView animateWithDuration:0.5 animations:^{
        self.tabBarController.tabBar.alpha = 1;
    }];
}

// MARK: - FinderView代理

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

- (void)touchMore {
    NSLog(@"点击了更多功能");
    FinderToolViewController *vc = [[FinderToolViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)touchNoClassAppointment {
    NSLog(@"点击了没课约");
    UserItem *item = [[UserItem alloc] init];
    WeDateViewController *vc = [[WeDateViewController alloc] initWithInfoDictArray:[@[@{@"name":item.realName,@"stuNum":item.stuNum}] mutableCopy]];
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

- (void)backToThisController{
    self.navigationController.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:NO];
}

@end
