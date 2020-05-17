//
//  FirstViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/10/21.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "DiscoverViewController.h"
#import "LoginViewController.h"
#import "FinderToolViewController.h"
#import "FinderView.h"
#import "EmptyClassViewController.h"
#import "ElectricFeeModel.h"
#import "OneNewsModel.h"
#import "ElectricFeeGlanceView.h"
#import "VolunteerGlanceView.h"
#import "NotSetElectriceFeeButton.h"
#import "NotSetVolunteerButton.h"
#import "InstallRoomViewController.h"
#import "ScheduleInquiryViewController.h"
#import "NewsViewController.h"
#import "ClassScheduleTabBarView.h"
#import "ClassTabBar.h"
#import "QueryLoginViewController.h"
#import "CalendarViewController.h"
#import "BannerModel.h"
#import "TestArrangeViewController.h"
#import "SchoolBusViewController.h"
#define Color242_243_248to000000 [UIColor colorNamed:@"color242_243_248&#000000" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]


typedef NS_ENUM(NSUInteger, LoginStates) {
    DidntLogin,
    LoginTimeOut,
    AlreadyLogin,
};

@interface DiscoverViewController ()<UIScrollViewDelegate, LQQFinderViewDelegate>

@property (nonatomic, assign, readonly) LoginStates loginStatus;
//View
@property(nonatomic, weak) FinderView *finderView;//上方发现页面
@property (nonatomic, weak) UIScrollView *contentView;
@property (nonatomic, weak) ElectricFeeGlanceView *eleGlanceView;//电费button页面
@property (nonatomic, weak) VolunteerGlanceView *volGlanceView;//志愿服务button页面
@property (nonatomic, weak) NotSetElectriceFeeButton *eleButton;//未绑定账号时电费button页面
@property (nonatomic, weak) NotSetVolunteerButton *volButton;//未绑定账号时电费button页面
//Model
@property ElectricFeeModel *elecModel;
@property (nonatomic, strong)OneNewsModel *oneNewsModel;
@property NSUserDefaults *defaults;
@property BannerModel *bannerModel;
@end

@implementation DiscoverViewController


#pragma mark - Getter
- (LoginStates)loginStatus {
    if (![UserItemTool defaultItem]) {
        return DidntLogin;
    } else {
        if ([[UserItemTool defaultItem].iat integerValue] + 45 * 24 * 3600 < [NSDate nowTimestamp]) {
            return LoginTimeOut;
        } else {
            return AlreadyLogin;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
    if (self.loginStatus != AlreadyLogin) {
        [self presentToLogin];
    } else {
        [self RequestCheckinInfo];
    }
     self.navigationController.navigationBar.translucent = NO;
    [self addGlanceView];//根据用户是否录入过宿舍信息和志愿服务账号显示电费查询和志愿服务
//    [self addClearView];//一个透明的View，用来保证边栏不会遮挡住部分志愿服务入口按钮
    
    ClassScheduleTabBarView *classTabBarView = [[ClassScheduleTabBarView alloc] initWithFrame:CGRectMake(0, -58, MAIN_SCREEN_W, 58)];
    classTabBarView.layer.cornerRadius = 16;
    [(ClassTabBar *)(self.tabBarController.tabBar) addSubview:classTabBarView];
    ((ClassTabBar *)(self.tabBarController.tabBar)).classScheduleTabBarView = classTabBarView;
    ((ClassTabBar *)(self.tabBarController.tabBar)).classScheduleTabBarView.userInteractionEnabled = YES;
}

- (void)viewDidLoad {
    [self requestData];
    [super viewDidLoad];
    [self addContentView];
    self.contentView.delegate = self;
    [self configDefaults];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addFinderView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateElectricFeeUI) name:@"electricFeeDataSucceed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNewsUI) name:@"oneNewsSucceed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFinderViewUI) name:@"customizeMainPageViewSuccess" object:nil];
}

- (void)presentToLogin {
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [self presentViewController:loginVC animated:NO completion:nil];
    if (self.loginStatus == LoginTimeOut) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"太久没有登录掌邮了..." message:@"\n重新登录试试吧" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好哒！" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        
        [loginVC presentViewController:alert animated:YES completion:nil];
    }
}

- (void)RequestCheckinInfo {
    NSDictionary *params = @{
        @"stunum": [UserDefaultTool getStuNum],
        @"idnum": [UserDefaultTool getIdNum]
    };
    
    HttpClient *client = [HttpClient defaultClient];
    [client requestWithPath:CHECKININFOAPI method:HttpRequestPost parameters:params prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [UserItemTool defaultItem].checkInDay = responseObject[@"data"][@"check_in_days"];
        [UserItemTool defaultItem].integral = responseObject[@"data"][@"integral"];
        [UserItemTool defaultItem].rank = responseObject[@"data"][@"rank"];
        [UserItemTool defaultItem].rank_Persent = responseObject[@"data"][@"percent"];
        [UserItemTool defaultItem].week_info = responseObject[@"data"][@"week_info"];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)configDefaults {
    self.defaults = [NSUserDefaults standardUserDefaults];
}

- (void)configNavagationBar {
    self.navigationController.navigationBar.translucent = NO;

    if (@available(iOS 11.0, *)) {
        self.navigationController.navigationBar.backgroundColor = [UIColor colorNamed:@"color242_243_248&#000000" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil];
    }
    //隐藏导航栏的分割线
    if (@available(iOS 11.0, *)) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorNamed:@"color242_243_248&#000000" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    }
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}



- (void)addContentView {
    UIScrollView *contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    self.contentView = contentView;
    if (@available(iOS 11.0, *)) {
        contentView.backgroundColor = Color242_243_248to000000;
    } else {
        contentView.backgroundColor = [UIColor colorWithRed:242/255.0 green:243/255.0 blue:248/255.0 alpha:1];
    }

    contentView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-70);
    }];
    
}

- (void)addFinderView {
    FinderView *finderView;
    if(IS_IPHONESE){//SE
        finderView = [[FinderView alloc]initWithFrame:CGRectMake(0, 0,self.view.width, self.view.height * 0.62)];
            self.contentView.contentSize = CGSizeMake(self.view.width,1.10*self.view.height);
    }else if(IS_IPHONEX) {
        finderView = [[FinderView alloc]initWithFrame:CGRectMake(0, 0,self.view.width, self.view.height * 0.36)];
        self.contentView.contentSize = CGSizeZero;
    }else {
        finderView = [[FinderView alloc]initWithFrame:CGRectMake(0, 0,self.view.width, 320)];
       self.contentView.contentSize = CGSizeMake(self.view.width,self.view.height);
    }
    self.finderView = finderView;
    self.finderView.delegate = self;
    [self.contentView addSubview:finderView];
    [self refreshBannerViewIfNeeded];
}
-(void) refreshBannerViewIfNeeded {
    //更新bannerView
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(UpdateBannerViewUI) name:@"BannerModel_Success" object:nil];
}
-(void)UpdateBannerViewUI {
    NSMutableArray *urlStrings = [NSMutableArray array];
    NSMutableArray *bannerGoToURL = [NSMutableArray array];
    for(BannerItem *item in self.bannerModel.bannerData.bannerItems) {
        [urlStrings addObject:item.pictureUrl];
        [bannerGoToURL addObject:item.pictureGoToUrl];
    }
    self.finderView.bannerGoToURL = bannerGoToURL;
    self.finderView.bannerURLStrings = urlStrings;
    [self.finderView updateBannerViewIfNeeded];
}
- (void)addGlanceView {
    int adjustToCorner = 18;
    UserItem *userItem = [UserItem defaultItem];
    NSLog(@"当前的building是%@,当前的room是%@",userItem.building,userItem.room);
    if(userItem.building != nil && userItem.room != nil && userItem.volunteerPassword != nil) {//用户已经绑定电费和志愿
        NSLog(@"用户已经绑定电费和志愿");
            ElectricFeeGlanceView *eleGlanceView = [[ElectricFeeGlanceView alloc]initWithFrame:CGRectMake(0, self.finderView.height, self.view.width,172)];
            self.eleGlanceView = eleGlanceView;
            [self.contentView addSubview:eleGlanceView];
            VolunteerGlanceView *volGlanceView = [[VolunteerGlanceView alloc]initWithFrame:CGRectMake(0, self.finderView.height + self.eleGlanceView.height - adjustToCorner, self.view.width, 152)];
            self.volGlanceView = volGlanceView;
            [self.contentView addSubview:volGlanceView];
    }else if(userItem.building != nil && userItem.room != nil && userItem.volunteerPassword == nil) {//用户仅绑定宿舍
        NSLog(@"用户仅绑定电费");
        ElectricFeeGlanceView *eleGlanceView = [[ElectricFeeGlanceView alloc]initWithFrame:CGRectMake(0, self.finderView.height, self.view.width,172)];
        self.eleGlanceView = eleGlanceView;
        [self.contentView addSubview:eleGlanceView];
        
        NotSetVolunteerButton *volButton = [[NotSetVolunteerButton alloc]initWithFrame:CGRectMake(0, self.finderView.height + self.eleGlanceView.height - adjustToCorner, self.view.width, 152 + 12)];
        self.volButton = volButton;
        [volButton addTarget:self action:@selector(bindingVolunteerButton) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:volButton];
    }else if(userItem.building == nil && userItem.room == nil && userItem.volunteerPassword != nil) {//用户仅绑定了志愿服务账号
        NSLog(@"用户仅绑定了志愿服务账号");
        NotSetElectriceFeeButton *eleButton = [[NotSetElectriceFeeButton alloc]initWithFrame:CGRectMake(0, self.finderView.height, self.view.width,172 + 12)];
        self.eleButton = eleButton;
        [self.contentView addSubview:eleButton];
        VolunteerGlanceView *volGlanceView = [[VolunteerGlanceView alloc]initWithFrame:CGRectMake(0, self.finderView.height + self.eleButton.height - adjustToCorner, self.view.width, 152)];
        self.volGlanceView = volGlanceView;
        [self.contentView addSubview:volGlanceView];
    }else {//用户什么都没绑定
        NSLog(@"用户什么都没绑定");
        NotSetElectriceFeeButton *eleButton = [[NotSetElectriceFeeButton alloc]initWithFrame:CGRectMake(0, self.finderView.height, self.view.width,172 + 12)];
        self.eleButton = eleButton;
        [self.contentView addSubview:eleButton];
        
        NotSetVolunteerButton *volButton = [[NotSetVolunteerButton alloc]initWithFrame:CGRectMake(0, self.finderView.height + self.eleButton.height - adjustToCorner, self.view.width, 152 + 12)];
        self.volButton = volButton;
        [volButton addTarget:self action:@selector(bindingVolunteerButton) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:volButton];
    }
     [self.eleButton addTarget:self action:@selector(bundlingBuildingAndRoom) forControlEvents:UIControlEventTouchUpInside];


    
}
- (void)bindingVolunteerButton {
    QueryLoginViewController * vc = [[QueryLoginViewController alloc]init];
    [self.navigationController hidesBottomBarWhenPushed];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)requestData {
    ElectricFeeModel *elecModel = [[ElectricFeeModel alloc]init];
    self.elecModel = elecModel;
    OneNewsModel *oneNewsModel = [[OneNewsModel alloc]initWithPage:@1];
    self.oneNewsModel = oneNewsModel;
    BannerModel * bannerModel = [[BannerModel alloc]init];
    [bannerModel fetchData];
    self.bannerModel = bannerModel;
}

- (void)updateElectricFeeUI {
    
    self.eleGlanceView.electricFeeMoney.text = self.elecModel.electricFeeItem.money;
    self.eleGlanceView.electricFeeDegree.text = self.elecModel.electricFeeItem.degree;
    self.eleGlanceView.electricFeeTime.text = self.elecModel.electricFeeItem.time;
    //同时写入缓存
    [self.defaults setObject:self.elecModel.electricFeeItem.money forKey:@"ElectricFee_money"];
    [self.defaults setObject:self.elecModel.electricFeeItem.degree forKey:@"ElectricFee_degree"];
    [self.defaults setObject:self.elecModel.electricFeeItem.time forKey:@"ElectricFee_time"];
}

- (void)updateNewsUI {
    if(self.oneNewsModel.oneNewsItem.dataArray != nil){
        [self.finderView.news setTitle:self.oneNewsModel.oneNewsItem.dataArray.firstObject.title forState:normal];
        //同时写入缓存
        [self.defaults setObject:self.oneNewsModel.oneNewsItem.dataArray.firstObject.title forKey:@"OneNews_oneNews"];
    }
}
- (void) bundlingBuildingAndRoom {
    NSLog(@"点击了绑定宿舍房间号");
    InstallRoomViewController *vc = [[InstallRoomViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)updateFinderViewUI {
    [self.finderView remoreAllEnters];
    [self.finderView addSomeEnters];
}
//MARK: FinderView代理
- (void)touchWriteButton {
    NSLog(@"点击了签到button");
}

- (void)touchNewsSender {
    NSLog(@"点击了“教务在线”");
    NewsViewController *vc = [[NewsViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)touchNews {
    NSLog(@"点击了新闻");
    NewsViewController *vc = [[NewsViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)touchFindClass {
    NSLog(@"点击了空教室");
    EmptyClassViewController *vc = [[EmptyClassViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)touchSchoolCar {
    NSLog(@"点击了校车查询");
    SchoolBusViewController *vc = [[SchoolBusViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)touchSchedule {
    NSLog(@"点击了空课表");
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
-(void)touchNoClassAppointment {
    NSLog(@"点击了没课约");
    
}
-(void)touchMyTest {
    NSLog(@"点击了我的考试");
    TestArrangeViewController *vc = [[TestArrangeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)touchSchoolCalender {
    NSLog(@"点击了校历");
    CalendarViewController *vc = [[CalendarViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)touchMap {
    NSLog(@"点击了重邮地图");
}
-(void)touchEmptyClass {
    NSLog(@"点击了空教室");
    EmptyClassViewController *vc = [[EmptyClassViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
