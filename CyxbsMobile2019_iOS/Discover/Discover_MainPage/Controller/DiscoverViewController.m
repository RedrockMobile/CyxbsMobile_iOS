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
#import "ElectricFeeGlanceButton.h"
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
#import "PickerModel.h"
#import <MBProgressHUD.h>
#define Color242_243_248to000000 [UIColor colorNamed:@"color242_243_248&#000000" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]

#define ColorWhite  [UIColor colorNamed:@"whiteColor" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]
#define TextColor [UIColor colorNamed:@"color21_49_91_&#F2F4FF" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]
#define TextColor [UIColor colorNamed:@"color21_49_91_&#F2F4FF" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]
#define TextColorShallow [UIColor colorNamed:@"color21_49_91&#F0F0F2_alpha0.59" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]

typedef NS_ENUM(NSUInteger, LoginStates) {
    DidntLogin,
    LoginTimeOut,
    AlreadyLogin,
};

@interface DiscoverViewController ()<UIScrollViewDelegate, LQQFinderViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, assign, readonly) LoginStates loginStatus;
//View
@property(nonatomic, weak) FinderView *finderView;//上方发现页面
@property (nonatomic, weak) UIScrollView *contentView;
@property (nonatomic, weak) ElectricFeeGlanceButton *eleGlanceButton;//电费button页面
@property (nonatomic, weak) VolunteerGlanceView *volGlanceView;//志愿服务button页面
@property (nonatomic, weak) NotSetElectriceFeeButton *eleButton;//未绑定账号时电费button页面
@property (nonatomic, weak) NotSetVolunteerButton *volButton;//未绑定账号时电费button页面
@property (nonatomic, weak) UIView * bindingDormitoryContentView;//绑定宿舍页面的contentView
@property (nonatomic, weak)UILabel *buildingNumberLabel;//选择宿舍时候的宿舍号label
@property (nonatomic, weak)UITextField *roomTextField;//填写房间号的框框
//Model
@property ElectricFeeModel *elecModel;
@property (nonatomic, strong)OneNewsModel *oneNewsModel;
@property NSUserDefaults *defaults;
@property BannerModel *bannerModel;
@property PickerModel *pickerModel;
//pickerView
@property (nonatomic)NSInteger selectedArrays;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];//监听键盘出现
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];//监听键盘消失
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
        make.bottom.equalTo(self.view);
    }];
    contentView.contentInset = UIEdgeInsetsMake(0, 0, 70, 0);
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
            ElectricFeeGlanceButton *eleGlanceButton = [[ElectricFeeGlanceButton alloc]initWithFrame:CGRectMake(0, self.finderView.height, self.view.width,172)];
            self.eleGlanceButton = eleGlanceButton;
            [self.contentView addSubview:eleGlanceButton];
            VolunteerGlanceView *volGlanceView = [[VolunteerGlanceView alloc]initWithFrame:CGRectMake(0, self.finderView.height + self.eleGlanceButton.height - adjustToCorner, self.view.width, 182)];
            self.volGlanceView = volGlanceView;
            [self.contentView addSubview:volGlanceView];
    }else if(userItem.building != nil && userItem.room != nil && userItem.volunteerPassword == nil) {//用户仅绑定宿舍
        NSLog(@"用户仅绑定电费");
        ElectricFeeGlanceButton *eleGlanceButton = [[ElectricFeeGlanceButton alloc]initWithFrame:CGRectMake(0, self.finderView.height, self.view.width,172)];
        self.eleGlanceButton = eleGlanceButton;
        [self.contentView addSubview:eleGlanceButton];
        NotSetVolunteerButton *volButton = [[NotSetVolunteerButton alloc]initWithFrame:CGRectMake(0, self.finderView.height + self.eleGlanceButton.height - adjustToCorner, self.view.width, 182 + 12)];
        self.volButton = volButton;
        [volButton addTarget:self action:@selector(bindingVolunteerButton) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:volButton];
    }else if(userItem.building == nil && userItem.room == nil && userItem.volunteerPassword != nil) {//用户仅绑定了志愿服务账号
        NSLog(@"用户仅绑定了志愿服务账号");
        NotSetElectriceFeeButton *eleButton = [[NotSetElectriceFeeButton alloc]initWithFrame:CGRectMake(0, self.finderView.height, self.view.width,172 + 12)];
        self.eleButton = eleButton;
        [self.contentView addSubview:eleButton];
        VolunteerGlanceView *volGlanceView = [[VolunteerGlanceView alloc]initWithFrame:CGRectMake(0, self.finderView.height + self.eleButton.height - adjustToCorner, self.view.width, 182)];
        self.volGlanceView = volGlanceView;
        [self.contentView addSubview:volGlanceView];
    }else {//用户什么都没绑定
        NSLog(@"用户什么都没绑定");
        NotSetElectriceFeeButton *eleButton = [[NotSetElectriceFeeButton alloc]initWithFrame:CGRectMake(0, self.finderView.height, self.view.width,172 + 12)];
        self.eleButton = eleButton;
        [self.contentView addSubview:eleButton];
        
        NotSetVolunteerButton *volButton = [[NotSetVolunteerButton alloc]initWithFrame:CGRectMake(0, self.finderView.height + self.eleButton.height - adjustToCorner, self.view.width, 182 + 12)];
        self.volButton = volButton;
        [volButton addTarget:self action:@selector(bindingVolunteerButton) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:volButton];
    }
     [self.eleButton addTarget:self action:@selector(bundlingBuildingAndRoom) forControlEvents:UIControlEventTouchUpInside];
    [self.eleGlanceButton addTarget:self action:@selector(bundlingBuildingAndRoom) forControlEvents:UIControlEventTouchUpInside];

    
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
    
    self.eleGlanceButton.electricFeeMoney.text = self.elecModel.electricFeeItem.money;
    self.eleGlanceButton.electricFeeDegree.text = self.elecModel.electricFeeItem.degree;
    self.eleGlanceButton.electricFeeTime.text = self.elecModel.electricFeeItem.time;
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
//    NSLog(@"点击了绑定宿舍房间号");
//    InstallRoomViewController *vc = [[InstallRoomViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
    [self getPickerViewData];
    UIView * contentView = [[UIView alloc]initWithFrame:self.view.frame];
    self.bindingDormitoryContentView = contentView;
    [self.view addSubview:contentView];
    contentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    
    UIView *bindingView = [[UIView alloc]init];
    bindingView.layer.cornerRadius = 8;
    if (@available(iOS 11.0, *)) {
        bindingView.backgroundColor = ColorWhite;
    } else {
        bindingView.backgroundColor = UIColor.whiteColor;
    }
    [contentView addSubview:bindingView];
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
    pickerView.showsSelectionIndicator = YES;
    UILabel * roomNumberLabel = [[UILabel alloc]init];
    roomNumberLabel.font = [UIFont fontWithName:PingFangSCBold size: 24];
    roomNumberLabel.text = @"宿舍号：";
    if (@available(iOS 11.0, *)) {
        roomNumberLabel.textColor = TextColor;
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
    textField.placeholder = @"输入宿舍号";
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
        buildingNumberLabel.textColor = TextColorShallow;
    } else {
        // Fallback on earlier versions
    }
    buildingNumberLabel.font = [UIFont fontWithName:PingFangSCRegular size:15];
    self.buildingNumberLabel = buildingNumberLabel;
    [bindingView addSubview:buildingNumberLabel];
    [buildingNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(roomNumberLabel);
        make.top.equalTo(roomNumberLabel.mas_bottom).offset(3);
    }];
    UIButton * button = [[UIButton alloc]init];
    [bindingView addSubview:button];
    button.backgroundColor = UIColor.blueColor;
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
- (UIToolbar *)addToolbar
{
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 35)];
    toolbar.tintColor = [UIColor blueColor];
//    toolbar.backgroundColor = [UIColor sy_grayColor];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(textFieldDone)];
    toolbar.items = @[space, bar];
    return toolbar;
}
-(void)textFieldDone {
    [self.view endEditing:YES];
}
- (void)bindingDormitory {
    UserItem *item = [UserItem defaultItem];
    if (self.buildingNumberLabel.text != nil) {
        item.building = self.buildingNumberLabel.text;
    }
    if(self.roomTextField.text != nil) {
        item.room = self.roomTextField.text;
    }
    
    [self.bindingDormitoryContentView removeAllSubviews];
    [self.bindingDormitoryContentView removeFromSuperview];
    [self reloadElectricViewIfNeeded];

}
-(void)getPickerViewData {
    PickerModel *pickerModel = [[PickerModel alloc]init];
    self.pickerModel = pickerModel;
}
//MARK: - PickerViewDataSourse
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 2; // 返回2表明该控件只包含2列
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
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
         return [arr objectAtIndex:row];
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
    NSLog(@"%@",self.buildingNumberLabel.text = [self.pickerModel getNumberOfDormitoryWith:self.pickerModel.placeArray[row0] andPlace:self.pickerModel.allArray[row0][row1]]);
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
        return 100;
    }else{
        return 100;
    }
    
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    if (component == 0) {
        return 45;
    }else{
        return 45;
    }
}

-(void)updateFinderViewUI {
    [self.finderView remoreAllEnters];
    [self.finderView addSomeEnters];
}
-(void)reloadElectricViewIfNeeded {
//    NSLog(@"%@",[UserItem defaultItem].room);
//    NSLog(@"%@",[UserItem defaultItem].building);
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
//MARK: - 监听键盘事件
 //当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{}
@end
