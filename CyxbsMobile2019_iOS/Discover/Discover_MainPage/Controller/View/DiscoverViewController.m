//
//  FirstViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/10/21.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "DiscoverViewController.h"

//#import "LoginViewController.h"
#import "FinderToolViewController.h"
#import "FinderView.h"
#import "EmptyClassViewController.h"
#import "ElectricFeeModel.h"
#import "JWZXNewsModel.h"
#import "CheckInViewController.h"
#import "WeDateViewController.h"//没课约
#import "CQUPTMapViewController.h"

#import "TODOMainViewController.h"  //邮子清单
//#import "InstallRoomViewController.h"
#import "ScheduleInquiryViewController.h"
#import "JWZXNewsViewController.h"
#import "ClassScheduleTabBarView.h"
#import "ClassTabBar.h"
#import "QueryLoginViewController.h"
#import "CalendarViewController.h"
#import "DiscoverADModel.h"
#import "TestArrangeViewController.h"
#import "SchoolBusVC.h"
#import "PickerModel.h"
#import <MBProgressHUD.h>
#import "ElectricityView.h"
#import "VolunteerView.h"
#import "VolunteerItem.h"
#import "QueryViewController.h"
#import "ArchiveTool.h"
#import "DiscoverTodoView.h"
#import "DiscoverTodoSheetView.h"
#import "掌上重邮-Swift.h"        // 将Swift中的类暴露给OC

//Tool
#import "NewQAHud.h"
#import "TodoSyncTool.h"
#import "TodoSyncMsg.h"


typedef NS_ENUM(NSUInteger, LoginStates) {
    DidntLogin,
    LoginTimeOut,
    AlreadyLogin,
};

@interface DiscoverViewController ()<
    UIScrollViewDelegate,
    LQQFinderViewDelegate,
    UIPickerViewDelegate,
    UIPickerViewDataSource,
    ElectricityViewDelegate,
    VolunteerViewDelegate,
    DiscoverTodoViewDelegate,
    DiscoverTodoSheetViewDelegate,
    DiscoverTodoViewDataSource
>

@property (nonatomic, assign, readonly) LoginStates loginStatus;

@property (nonatomic, weak) UIScrollView *contentView;

/// 上方发现页面
@property(nonatomic, weak) FinderView *finderView;

/// 电费相关View
@property (nonatomic, weak) ElectricityView *eleView;

/// 志愿服务View
@property (nonatomic, weak)VolunteerView *volView;

/// 绑定宿舍页面的contentView，他是一个button，用来保证点击空白处可以取消设置宿舍
@property (nonatomic, weak) UIButton * bindingDormitoryContentView;

/// 用来绑定宿舍的View
@property (nonatomic, weak)UIView *bindingView;

/// 选择宿舍时候的宿舍号label
@property (nonatomic, weak)UILabel *buildingNumberLabel;

/// 填写房间号的框框
@property (nonatomic, weak)UITextField *roomTextField;

/// 用来遮挡tabbar的View
@property (nonatomic, weak)UIView *hideTabbarView;

/// 用来补充志愿服务页面下方颜色
@property (nonatomic, weak)UIView *colorView;

/// Model
@property ElectricFeeModel *elecModel;

@property (nonatomic, strong)JWZXNewsModel *jwzxNewsModel;

@property (nonatomic, strong) DiscoverADModel *ADModel;

@property PickerModel *pickerModel;

/// pickerView
@property (nonatomic)NSInteger selectedArrays;

/// Data
@property (nonatomic, assign)int classTabbarHeight;

@property(nonatomic, assign)int classTabbarCornerRadius;

@property(nonatomic,strong)UIWindow *window;

@property(nonatomic, strong)DiscoverTodoView* todoView;

@property(nonatomic, strong)TodoSyncTool* todoSyncTool;


@end

@implementation DiscoverViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tabBarItem =
        [[UITabBarItem alloc]
         initWithTitle:@"发现"
         image:[UIImage imageNamed:@"DiscoverVC.deselect"]
         selectedImage:[UIImage imageNamed:@"DiscoverVC.select"]];
        
        [self.tabBarItem
         setTitleTextAttributes:@{
            NSFontAttributeName : [UIFont fontWithName:PingFangSC size:10],
            NSForegroundColorAttributeName : [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#AABCD8" alpha:1] darkColor:[UIColor colorWithHexString:@"#5A5A5A" alpha:1]]
        }
         forState:UIControlStateNormal];
        
        [self.tabBarItem
         setTitleTextAttributes:@{
            NSFontAttributeName : [UIFont fontWithName:PingFangSC size:10],
            NSForegroundColorAttributeName : [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#2923D2" alpha:1] darkColor:[UIColor colorWithHexString:@"#465FFF" alpha:1]]
        }
         forState:UIControlStateSelected];
    }
    return self;
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

#pragma mark - Life cycle

- (void)viewWillAppear:(BOOL)animated {
    
//    self.tabBarController.tabBar.translucent = NO;

//    self.tabBarController.tabBar.tintColor = [UIColor colorWithHexString:@"2527C8"];
    
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
//    if(((ClassTabBar *)(self.tabBarController.tabBar))
//       .classScheduleTabBarView == nil) {
//        ClassScheduleTabBarView *classTabBarView =
//        [[ClassScheduleTabBarView alloc] initWithFrame:
//         CGRectMake(0, -self.classTabbarHeight, MAIN_SCREEN_W, self.classTabbarHeight)];
//
//        classTabBarView.layer.cornerRadius = self.classTabbarCornerRadius;
//        [(ClassTabBar *)(self.tabBarController.tabBar) addSubview:classTabBarView];
//
//        ((ClassTabBar *)(self.tabBarController.tabBar))
//            .classScheduleTabBarView = classTabBarView;
//
//        ((ClassTabBar *)(self.tabBarController.tabBar))
//            .classScheduleTabBarView.userInteractionEnabled = YES;
//
//        if(![NSUserDefaults.standardUserDefaults objectForKey:@"Mine_LaunchingWithClassScheduleView"] && classTabBarView.mySchedul!=nil){
//            [classTabBarView.mySchedul setModalPresentationStyle:(UIModalPresentationCustom)];
//            classTabBarView.mySchedul.fakeBar.alpha = 0;
//            [classTabBarView.viewController presentViewController:classTabBarView.mySchedul animated:YES completion:nil];
//        }
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentMySchedul) name:@"DiscoverVCShouldPresentMySchedul" object:nil];
//    }
    [self.todoView reloadData];
}
- (void)presentMySchedul{
    ClassScheduleTabBarView *classTabBarView = ((ClassTabBar *)(self.tabBarController.tabBar)).classScheduleTabBarView;
    [classTabBarView.mySchedul setModalPresentationStyle:(UIModalPresentationCustom)];
    classTabBarView.mySchedul.fakeBar.alpha = 0;
    [classTabBarView.viewController presentViewController:classTabBarView.mySchedul animated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.todoSyncTool = [TodoSyncTool share];
    [self requestData];
    [self addContentView];
    [self addFinderView];
    [self addTodoView];
    [self addEleView];
    [self addVolView];
    [self layoutSubviews];
    [self addNotifications];
    self.view.backgroundColor = self.finderView.backgroundColor;
}

//- (void)viewWillDisappear:(BOOL)animated {
//    self.hidesBottomBarWhenPushed = NO;
//}

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSucceed) name:@"Login_LoginSuceeded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindingRoomFailed) name:@"electricFeeRoomFailed" object:nil];//绑定的宿舍号码有问题
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestElectricFeeFailed) name:@"electricFeeRequestFailed" object:nil];//服务器可能有问题，电费信息请求失败
    //志愿服务绑定完成后重新加载发现主页
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadVolViewIdNeeded) name:@"LoginVolunteerAccountSucceed" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateElectricFeeUI) name:@"electricFeeDataSucceed" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFinderViewUI) name:@"customizeMainPageViewSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];//监听键盘出现
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];//监听键盘消失
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(todoSyncToolDidSync:) name:TodoSyncToolSyncNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backToThisController) name:@"logout" object:nil];
}
- (void)loginSucceed {
    [self requestData];
}
- (void)layoutSubviews {

    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        if(IS_IPHONEX) {
            make.top.equalTo(self.view).offset(44);
        }else {
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
    
    [self.todoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.finderView.mas_bottom).offset(20);
    }];
    
    [self.eleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.todoView.mas_bottom);
        make.width.equalTo(self.contentView);
        make.height.equalTo(@152);
    }];
    [self.volView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.eleView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@152);
        make.bottom.equalTo(self.contentView).offset(-20);
    }];
    
    [self.colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.volView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@600);
    }];
}
- (void)presentToLogin {
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginVC];
    navController.modalPresentationStyle = UIModalPresentationFullScreen;
    UITabBarController *tabBarVC = (UITabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    if (tabBarVC.presentedViewController) {
        [tabBarVC dismissViewControllerAnimated:YES completion:^{
            [tabBarVC presentViewController:navController animated:YES completion:nil];
        }];
    } else {
        [tabBarVC presentViewController:navController animated:YES completion:nil];
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
    [self addChildViewController:finderView.jwzxViewController];
    [self addChildViewController:finderView.msgViewController];
    
    
    self.finderView = finderView;
    self.finderView.delegate = self;
    [self.contentView addSubview:finderView];
    [self requestData];

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


- (void)addEleView {
    ElectricityView *eleView = [[ElectricityView alloc]init];
    self.eleView = eleView;
    eleView.delegate = self;
    [self.contentView addSubview:eleView];

}
- (void)addVolView {
    VolunteerView *volView = [[VolunteerView alloc]init];
    self.volView = volView;
    volView.delegate = self;
    [self.contentView addSubview:volView];
    
    UIView *view = [[UIView alloc]init];//色块View
    self.colorView = view;
    self.colorView.backgroundColor = self.volView.backgroundColor;
    [self.contentView addSubview:self.colorView];
}
/// 添加todo的view
- (void)addTodoView {
    DiscoverTodoView* todoView = [[DiscoverTodoView alloc] init];
    [self.contentView addSubview:todoView];
    self.todoView = todoView;
    
    todoView.delegate = self;
    todoView.dataSource = self;
    [todoView reloadData];
}
- (void)bindingVolunteerButton {
    ///需要在此处判断一下是否已经登陆了志愿者的界面，如果登陆了，则直接跳QueryViewController，如果未登陆的话则跳登陆的viewController
    if (![NSUserDefaults.standardUserDefaults objectForKey:@"volunteer_information"]) {
        QueryLoginViewController * vc = [[QueryLoginViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        VolunteerItem *volunteer = [ArchiveTool getPersonalInfo];
        QueryViewController *queryVC = [[QueryViewController alloc] initWithVolunteerItem:volunteer];
        queryVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:queryVC animated:YES];
    }
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

- (void)requestData {
    ElectricFeeModel *elecModel = [[ElectricFeeModel alloc]init];
    self.elecModel = elecModel;
    JWZXNewsModel *oneNewsModel = [[JWZXNewsModel alloc]init];
    self.jwzxNewsModel = oneNewsModel;
    
    [self request];
}

#pragma mark - Lazy

- (DiscoverADModel *)ADModel {
    if (_ADModel == nil) {
        _ADModel = [[DiscoverADModel alloc] init];
    }
    return _ADModel;
}

#pragma mark - END

- (void)bindingRoomFailed {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setMode:(MBProgressHUDModeText)];
    hud.labelText = @"绑定的宿舍号可能有问题哦，请重新绑定";
    [UserItem defaultItem].building = nil;
    [UserItem defaultItem].room = nil;
    [hud hide:YES afterDelay:1.2];
}
- (void)requestElectricFeeFailed {
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [hud setMode:(MBProgressHUDModeText)];
//    hud.labelText = @"电费查询服务器开小差了哦，请稍后重试";
//    [hud hide:YES afterDelay:1];
//    return;
//    [NewQAHud showHudWith:@"电费查询服务器开小差了哦，请稍后重试" AddView:self.view];
}
- (void)updateElectricFeeUI {
    //先写入缓存
    [NSUserDefaults.standardUserDefaults setObject:self.elecModel.electricFeeItem.money forKey:@"ElectricFee_money"];
    [NSUserDefaults.standardUserDefaults setObject:self.elecModel.electricFeeItem.degree forKey:@"ElectricFee_degree"];
    [NSUserDefaults.standardUserDefaults setObject:self.elecModel.electricFeeItem.time forKey:@"ElectricFee_time"];
    [self.eleView refreshViewIfNeeded];
    [self.eleView.electricFeeMoney setTitle: self.elecModel.electricFeeItem.money forState:UIControlStateNormal];
    //self.eleView.electricFeeDegree.text = self.elecModel.electricFeeItem.degree;
    //这里读缓存以后日期的样式就改回去了，所以先屏蔽
}

#pragma mark - 即将要被更改的地方
- (void)updateNewsUI {
//    if(self.jwzxNewsModel.jwzxNews.news != nil){
////        [self.finderView.news setTitle:self.jwzxNewsModel.jwzxNews.news.firstObject.title forState:normal];
//        //同时写入缓存
//        [self.defaults setObject:self.jwzxNewsModel.jwzxNews.news.firstObject.title forKey:@"OneNews_oneNews"];
//    }
}

#pragma mark - end

//点击了绑定宿舍房间号
- (void) bindingBuildingAndRoom {
    [self getPickerViewData];
    //添加灰色背景板
    UIButton * contentView = [[UIButton alloc]initWithFrame:self.view.frame];
    self.bindingDormitoryContentView = contentView;
    [self.view addSubview:contentView];
    contentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    contentView.alpha = 0;
    
    UIView *hideTabbarView = [[UIView alloc]initWithFrame:CGRectMake(0,-self.classTabbarHeight, MAIN_SCREEN_W, 800)];
    hideTabbarView.layer.cornerRadius = self.classTabbarCornerRadius;
    self.hideTabbarView = hideTabbarView;
    hideTabbarView.backgroundColor = contentView.backgroundColor;
    hideTabbarView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        contentView.alpha = 1;
        hideTabbarView.alpha = 1;
//        self.tabBarController.tabBar.hidden=YES;
        self.tabBarController.tabBar.userInteractionEnabled = NO;
        ((ClassTabBar *)(self.tabBarController.tabBar))
            .classScheduleTabBarView.userInteractionEnabled = NO;
        [self.tabBarController.tabBar addSubview:hideTabbarView];
        [[UIApplication.sharedApplication.windows firstObject] bringSubviewToFront:hideTabbarView];
        self.view.backgroundColor = self.finderView.backgroundColor;
    }];
    [contentView addTarget:self action:@selector(cancelSettingDormitory) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *bindingView = [[UIView alloc]init];
    bindingView.layer.cornerRadius = 8;
    if (@available(iOS 11.0, *)) {
        bindingView.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1] darkColor:[UIColor colorWithHexString:@"#000000" alpha:1]];
    } else {
        bindingView.backgroundColor = UIColor.whiteColor;
    }
    [contentView addSubview:bindingView];
    self.bindingView = bindingView;
    [bindingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.equalTo(@339);
    }];
    UIPickerView * pickerView = [[UIPickerView alloc]init];
    [bindingView addSubview:pickerView];
    [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bindingView).offset(97);
        make.left.right.equalTo(bindingView);
        make.height.equalTo(@152);
    }];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    
    UILabel * roomNumberLabel = [[UILabel alloc]init];
    roomNumberLabel.font = [UIFont fontWithName:PingFangSCBold size: 24];
    roomNumberLabel.text = @"宿舍号：";
    if (@available(iOS 11.0, *)) {
        roomNumberLabel.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#5E5F64" alpha:1]];
    } else {
    }
    [bindingView addSubview:roomNumberLabel];
    [roomNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bindingView).offset(14);
        make.top.equalTo(bindingView).offset(23);
    }];
    UITextField * textField = [[UITextField alloc]init];
    [bindingView addSubview:textField];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.returnKeyType =UIReturnKeyDone;
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(roomNumberLabel).offset(85);
        make.centerY.equalTo(roomNumberLabel);
        make.width.equalTo(@170);
    }];
    textField.placeholder = @"例如\"403\"";
    if([UserItem defaultItem].room) {
        textField.text = [UserItem defaultItem].room;
    }

    textField.inputAccessoryView = [self addToolbar];
    textField.font = roomNumberLabel.font;
    self.roomTextField = textField;
    if (@available(iOS 11.0, *)) {
        textField.textColor = roomNumberLabel.textColor;
    } else {
        // Fallback on earlier versions
    }
    UILabel *buildingNumberLabel = [[UILabel alloc]init];
    buildingNumberLabel.text = @"01栋";

    if (@available(iOS 11.0, *)) {
        buildingNumberLabel.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:0.59] darkColor:[UIColor colorWithHexString:@"#EFEFF1" alpha:0.59]];
    } else {
        // Fallback on earlier versions
    }
    buildingNumberLabel.font = [UIFont fontWithName:PingFangSCRegular size:15];
    self.buildingNumberLabel = buildingNumberLabel;
    NSString * building = [UserItem defaultItem].building;
    if(building) {//如果用户曾经选择过，那么就显示曾见选择的那个
        self.buildingNumberLabel.text = [NSString stringWithFormat:@"%@栋",building];
        NSArray<NSNumber*>*chooseIndex = [self.pickerModel getBuildingNameIndexAndBuildingNumberIndexByNumberOfDormitory:building];
        [pickerView selectRow:chooseIndex.lastObject.intValue inComponent:1 animated:NO];
        [pickerView selectRow:chooseIndex.firstObject.intValue inComponent:0 animated:NO];
    }
    [bindingView addSubview:buildingNumberLabel];
    [buildingNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(roomNumberLabel);
        make.top.equalTo(roomNumberLabel.mas_bottom).offset(3);
    }];
    
    UIButton * button = [[UIButton alloc]init];
    [bindingView addSubview:button];
    button.backgroundColor = [UIColor colorWithHexString:@"#4841E2"];
    [button setTitle:@"确定" forState:normal];
    button.layer.cornerRadius = 20;
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bindingView);
        make.bottom.equalTo(bindingView).offset(-29);
        make.width.equalTo(@120);
        make.height.equalTo(@40);
    }];
    [button addTarget:self action:@selector(bindingDormitory) forControlEvents:UIControlEventTouchUpInside];
}
- (void)cancelSettingDormitory {
//    self.tabBarController.tabBar.hidden=NO;
    [self.bindingDormitoryContentView removeFromSuperview];
    [self.hideTabbarView removeFromSuperview];
    [self.tabBarController.tabBar setUserInteractionEnabled:YES];
    [((ClassTabBar *)(self.tabBarController.tabBar))
        .classScheduleTabBarView setUserInteractionEnabled:YES];
}
- (UIToolbar *)addToolbar {
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 35)];
    toolbar.tintColor = [UIColor blueColor];
//    toolbar.backgroundColor = [UIColor sy_grayColor];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(textFieldDone)];
    toolbar.items = @[space, bar];
    return toolbar;
}
- (void)textFieldDone {
    [self.view endEditing:YES];
}
- (void)bindingDormitory {
    UserItem *item = [UserItem defaultItem];
    if (self.buildingNumberLabel.text != nil) {
//        NSString *building = [NSString stringWithFormat:@"%d",self.buildingNumberLabel.text.intValue];//这里隐式的去掉了“栋”字
        NSString *building = [self.buildingNumberLabel.text stringByReplacingOccurrencesOfString:@"栋" withString:@""];

        item.building = building;
    }
        NSLog(@"*%@*",self.roomTextField.text);
    if(self.roomTextField.text != nil && ![self.roomTextField.text isEqual: @""]) {
        item.room = self.roomTextField.text;
    }else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.bindingView animated:YES];
        [hud setMode:(MBProgressHUDModeText)];
        hud.labelText = @"请输入宿舍号～";
        [hud hide:YES afterDelay:1];
        return;
    }
//    self.tabBarController.tabBar.hidden=NO;
    [self.bindingDormitoryContentView removeAllSubviews];
    [self.bindingDormitoryContentView removeFromSuperview];
    [self.hideTabbarView removeFromSuperview];
    [self.tabBarController.tabBar setUserInteractionEnabled:YES];
    [((ClassTabBar *)(self.tabBarController.tabBar))
        .classScheduleTabBarView setUserInteractionEnabled:YES];
    [self reloadElectricViewIfNeeded];
}
- (void)getPickerViewData {
    PickerModel *pickerModel = [[PickerModel alloc]init];
    self.pickerModel = pickerModel;
}

//MARK: - pickerView代理
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView {
    return 2; // 返回2表明该控件只包含2列
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component  {
    if (component == 0) {
        return self.pickerModel.allArray.count;
    }else {
        return [self.pickerModel.allArray objectAtIndex:self.selectedArrays].count;
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return self.pickerModel.placeArray[row];
    }else {
//        self.placeArray = @[@"宁静苑",@"明理苑",@"知行苑",@"兴业苑",@"四海苑"];
        NSInteger selectedRow = [pickerView selectedRowInComponent:0];
        NSArray *arr = [self.pickerModel.allArray objectAtIndex:selectedRow];
        if (row < arr.count){
            return [arr objectAtIndex:row];
        }else {
            return [arr objectAtIndex:0];
        }
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
       if (component == 0) {
        //如果滑动的是第 0 列, 刷新第 1 列
        //在执行完这句代码之后, 会重新计算第 1 列的行数, 重新加载第 1 列的标题内容
        [pickerView reloadComponent:1];//重新加载指定列的数据
       self.selectedArrays = row;
        [pickerView selectRow:0 inComponent:1 animated:YES];
        //
        //重新加载数据
        [pickerView reloadAllComponents];
       }else {
           //如果滑动的是右侧列，刷新上方label

//           [PickerModel getNumberOfDormitoryWith:self.pickerModel.placeArray[row] andPlace:self.pickerModel.allArray[row][row]];
       }
    NSInteger row0 = [pickerView selectedRowInComponent:0];
    NSInteger row1 = [pickerView selectedRowInComponent:1];
    self.buildingNumberLabel.text = [self.pickerModel getNumberOfDormitoryWith:self.pickerModel.placeArray[row0] andPlace:self.pickerModel.allArray[row0][row1]];
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
        return 100;
    }else{
        return 100;
    }
    
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    if (component == 0) {
        return 45;
    }else{
        return 45;
    }
}

- (void)updateFinderViewUI {
    [self.finderView remoreAllEnters];
    [self.finderView addSomeEnters];
    [self layoutSubviews];
}
- (void)reloadElectricViewIfNeeded {
//    NSLog(@"%@",[UserItem defaultItem].room);
//    NSLog(@"%@",[UserItem defaultItem].building);
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

//MARK: - DiscoverTodoView的代理方法：
- (void)addBtnClickedTodoView:(DiscoverTodoView *)todoView {
    //隐藏底部课表的tabBar
    [UIView animateWithDuration:0.5 animations:^{
        self.tabBarController.tabBar.alpha = 0;
    }];
    
    DiscoverTodoSheetView* sheetView = [[DiscoverTodoSheetView alloc] init];
    [self.view addSubview:sheetView];
    
    sheetView.delegate = self;
    //调用show方法让它弹出来
    [sheetView show];
}

- (void)todoView:(DiscoverTodoView *)todoView didAlterWithModel:(TodoDataModel *)model {
    [self.todoSyncTool alterTodoWithModel:model needRecord:YES];
}

- (void)localBtnClickedTodoView:(DiscoverTodoView *)todoView {
    CCLog(@"强推");
    [self.todoSyncTool forcePushLocalData];
}

- (void)cloudBtnClickedTodoView:(DiscoverTodoView *)todoView {
    CCLog(@"下载");
    [self.todoSyncTool forceLoadServerData];
}
//MARK:- DiscoverTodoView的数据源方法：
- (NSArray<TodoDataModel *> *)dataModelToShowForDiscoverTodoView:(DiscoverTodoView *)view {
    return [self.todoSyncTool getTodoForDiscoverMainPage];
}

//MARK: - DiscoverTodoSheetView的代理方法：
- (void)sheetViewSaveBtnClicked:(TodoDataModel *)dataModel {
    //显示底部课表的tabBar
    [UIView animateWithDuration:0.5 animations:^{
        self.tabBarController.tabBar.alpha = 1;
    }];
    
    [self.todoSyncTool saveTodoWithModel:dataModel needRecord:YES];
}
- (void)sheetViewCancelBtnClicked {
    //显示底部课表的tabBar
    [UIView animateWithDuration:0.5 animations:^{
        self.tabBarController.tabBar.alpha = 1;
    }];
}


//MARK: - 监听TodoSyncTool的通知
- (void)todoSyncToolDidSync:(NSNotification*)noti {
    TodoSyncMsg* msg = noti.object;
    NSString *str;
    switch (msg.syncState) {
        case TodoSyncStateSuccess:
            str = @"和服务器数据同步成功";
            break;
        case TodoSyncStateFailure:
            str = @" 网络错误，待接入网络时，再和服务器同步数据 ";
            break;
        case TodoSyncStateConflict:
            str = @" 产生了冲突 ";
            break;
        case TodoSyncStateUnexpectedError:
            str = @" 网络错误，待接入网络时，再和服务器同步数据 ";
            break;
    }
    
//    [NewQAHud showHudAtWindowWithStr:str enableInteract:YES];
    
    if (msg.syncState==TodoSyncStateConflict) {
        [self.todoView showConflictWithServerTime:msg.serverLastSyncTime localTime:msg.clientLastSyncTime];
    }else {
        [self.todoView removeConflictView];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.todoView reloadData];
        });
    }
}


//MARK: - FinderView代理
- (void)touchWriteButton {
    NSLog(@"点击了签到button");
    CheckInViewController * vc = [[CheckInViewController alloc]init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController presentViewController:vc animated:true completion:^{
        
    }];
}

- (void)touchNews {
    NSLog(@"👆点击了新闻");
//    JWZXNewsViewController *vc = [[JWZXNewsViewController alloc] initWithJWZXNewsModel:self.jwzxNewsModel];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)touchFindClass {
    NSLog(@"点击了空教室");
    EmptyClassViewController *vc = [[EmptyClassViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)touchSchoolCar {
    NSLog(@"点击了校车查询");
    SchoolBusVC *vc = [[SchoolBusVC alloc] init];
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
- (void)touchNoClassAppointment {
    NSLog(@"点击了没课约");
    UserItem *item = [[UserItem alloc] init];
    WeDateViewController *vc = [[WeDateViewController alloc] initWithInfoDictArray:[@[@{@"name":item.realName,@"stuNum":item.stuNum}] mutableCopy]];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)touchMyTest {
    NSLog(@"点击了我的考试");
    TestArrangeViewController *vc = [[TestArrangeViewController alloc] init];
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
- (void)touchEmptyClass {
    NSLog(@"点击了空教室");
    EmptyClassViewController *vc = [[EmptyClassViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)touchToDOList{
    NSLog(@"点击了邮子清单");
    TODOMainViewController *vc = [[TODOMainViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//MARK: - 监听键盘事件
 //当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification {
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{}
- (void)touchElectrictyView {
    [self bindingBuildingAndRoom];
}
//MARK: - 志愿服务view的代理
- (void)touchVolunteerView {
    [self bindingVolunteerButton];
}

- (void)backToThisController{
//    self.loginStatus = DidntLogin;
    
    self.navigationController.tabBarController.selectedIndex = 0;
    
    [self.navigationController popToRootViewControllerAnimated:NO];
}

#pragma mark - RisingRouterHandler

+ (NSArray<NSString *> *)routerPath {
    return @[
        @"DiscoverVC"
    ];
}

+ (void)responseRequest:(RisingRouterRequest *)request completion:(RisingRouterResponseBlock)completion {
    
    RisingRouterResponse *response = [[RisingRouterResponse alloc] init];
    
    switch (request.requestType) {
        case RouterRequestPush: {
            
            UINavigationController *nav = (request.requestController ? request.requestController : RisingRouterRequest.useTopController).navigationController;
            
            if (nav) {
                DiscoverViewController *vc = [[self alloc] init];
                response.responseController = vc;
                
                [nav pushViewController:vc animated:YES];
            } else {
                
                response.errorCode = RouterResponseWithoutNavagation;
            }
            
        } break;
            
        case RouterRequestParameters: {
            // TODO: 传回参数
        } break;
            
        case RouterRequestController: {
            
            DiscoverViewController *vc = [[self alloc] init];
            
            response.responseController = vc;
        } break;
    }
    
    if (completion) {
        completion(response);
    }
}

@end
