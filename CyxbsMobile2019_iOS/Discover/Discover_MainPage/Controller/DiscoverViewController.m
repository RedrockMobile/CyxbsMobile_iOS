//
//  FirstViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/10/21.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "DiscoverViewController.h"
#import "LoginViewController.h"
#import "LQQFinderToolViewController.h"
#import "LQQFinderView.h"
#import "LQQGlanceView.h"
#import "EmptyClassViewController.h"
#import "ElectricFeeModel.h"
#import "OneNewsModel.h"

typedef NS_ENUM(NSUInteger, LoginStates) {
    DidntLogin,
    LoginTimeOut,
    AlreadyLogin,
};

@interface DiscoverViewController ()<UIScrollViewDelegate, LQQFinderViewDelegate>

@property (nonatomic, assign, readonly) LoginStates loginStatus;
//View
@property(nonatomic, weak) LQQFinderView *finderView;//上方发现页面
@property (nonatomic, weak) UIScrollView *contentView;
@property (nonatomic, weak) LQQGlanceView *glanceView;//下方剩余页面
//Model
@property ElectricFeeModel *elecModel;
@property OneNewsModel *oneNewsModel;
@property NSUserDefaults *defaults;
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
    if (self.loginStatus != AlreadyLogin) {
        [self presentToLogin];
    } else {
        [self RequestCheckinInfo];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addContentView];
    self.contentView.delegate = self;
    [self configDefaults];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configNavagationBar];
    [self addFinderView];
    [self addGlanceView];
    [self requestData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateElectricFeeUI) name:@"electricFeeDataSucceed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNewsUI) name:@"oneNewsSucceed" object:nil];

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
    if (@available(iOS 11.0, *)) {
        self.navigationController.navigationBar.backgroundColor = [UIColor colorNamed:@"color242_243_248&#000000" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil];
    } else {
        // Fallback on earlier versions
    }
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]}];
    //隐藏导航栏的分割线
    if (@available(iOS 11.0, *)) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorNamed:@"color242_243_248&#000000" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    } else {
        // Fallback on earlier versions
    }
    
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(scrollView.contentOffset.y >= self.navigationController.navigationBar.height + self.finderView.finderTitle.height){
        if (@available(iOS 11.0, *)) {
            [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorNamed:@"color242_243_248&#FFFFFF" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]}];
        } else {
            // Fallback on earlier versions
        }
    }else{
        if (@available(iOS 11.0, *)) {
            [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorNamed:@"color242_243_248&#000000" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]}];
        } else {
            // Fallback on earlier versions
        }
    }
}

- (void)addContentView {
    UIScrollView *contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
//    if(@available(iOS 11.0, *)){
        CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
        self.contentView.frame = CGRectMake(0,self.navigationController.navigationBar.height + [[UIApplication sharedApplication] statusBarFrame].size.height, self.view.width,self.view.height);


//    }
    self.contentView = contentView;
    contentView.backgroundColor = [UIColor colorWithRed:242/255.0 green:243/255.0 blue:248/255.0 alpha:1.0];
    contentView.contentSize = CGSizeMake(self.view.width, self.view.height);
    [self.view addSubview:contentView];
    contentView.backgroundColor = UIColor.greenColor;
    
}

- (void)addFinderView {
    //下策
    LQQFinderView *finderView;
    if(MAIN_SCREEN_W / MAIN_SCREEN_H == 320 / 568.0){
        finderView = [[LQQFinderView alloc]initWithFrame:CGRectMake(0, 0,self.view.width, self.view.height * 0.62)];
            self.contentView.contentSize = CGSizeMake(self.view.width,1.10*self.view.height);
    }else if(MAIN_SCREEN_W / MAIN_SCREEN_H == 375 / 667.0) {//6,6s,7,8
        finderView = [[LQQFinderView alloc]initWithFrame:CGRectMake(0, 0,self.view.width, self.view.height * 0.53)];
            self.contentView.contentSize = CGSizeMake(self.view.width,1.05*self.view.height);
    }else if(MAIN_SCREEN_W / MAIN_SCREEN_H == 414 / 736.0) {//plus
        finderView = [[LQQFinderView alloc]initWithFrame:CGRectMake(0, 0,self.view.width, self.view.height * 0.49)];
            self.contentView.contentSize = CGSizeMake(self.view.width,0.96*self.view.height);
    }else if(MAIN_SCREEN_W / MAIN_SCREEN_H == 375 / 812.0) {//11pro,x,xs
        finderView = [[LQQFinderView alloc]initWithFrame:CGRectMake(0, 0,self.view.width, self.view.height * 0.44)];
            self.contentView.contentSize = CGSizeMake(self.view.width,0.88*self.view.height);
    }else if(MAIN_SCREEN_W / MAIN_SCREEN_H == 414 / 896.0) {//11,11promax,xr,xsmax
        finderView = [[LQQFinderView alloc]initWithFrame:CGRectMake(0, 0,self.view.width, self.view.height * 0.40)];
            self.contentView.contentSize = CGSizeZero;

    }else {//以防万一
        finderView = [[LQQFinderView alloc]initWithFrame:CGRectMake(0, 0,self.view.width, self.view.height * 0.40)];
            self.contentView.frame = CGRectMake(0,self.navigationController.navigationBar.height + [[UIApplication sharedApplication] statusBarFrame].size.height, self.view.width,0.8*self.view.height);
    }
    self.finderView = finderView;
    self.finderView.delegate = self;
    [self.contentView addSubview:finderView];
}

- (void)addGlanceView {
    LQQGlanceView *glanceView = [[LQQGlanceView alloc]initWithFrame:CGRectMake(0, self.finderView.height, self.view.width, self.view.height * 0.7)];
    self.glanceView = glanceView;
    [self.contentView addSubview:glanceView];
//    glanceView.backgroundColor = [UIColor redColor];
}

- (void)requestData {
    ElectricFeeModel *elecModel = [[ElectricFeeModel alloc]init];
    self.elecModel = elecModel;
    OneNewsModel *oneNewsModel = [[OneNewsModel alloc]init];
    self.oneNewsModel = oneNewsModel;
    
}

- (void)updateElectricFeeUI {
    self.glanceView.electricFeeMoney.text = self.elecModel.electricFeeItem.money;
    self.glanceView.electricFeeDegree.text = self.elecModel.electricFeeItem.degree;
    self.glanceView.electricFeeTime.text = self.elecModel.electricFeeItem.time;
    //同时写入缓存
    [self.defaults setObject:self.elecModel.electricFeeItem.money forKey:@"ElectricFee_money"];
    [self.defaults setObject:self.elecModel.electricFeeItem.degree forKey:@"ElectricFee_degree"];
    [self.defaults setObject:self.elecModel.electricFeeItem.time forKey:@"ElectricFee_time"];
}

- (void)updateNewsUI {
    [self.finderView.news setTitle:self.oneNewsModel.oneNewsItem.oneNews forState:normal];
    
    //同时写入缓存
    [self.defaults setObject:self.oneNewsModel.oneNewsItem.oneNews forKey:@"OneNews_oneNews"];
}

//MARK: FinderView代理
- (void)touchWriteButton {
    NSLog(@"点击了签到button");
}

- (void)touchNewsSender {
    NSLog(@"点击了“教务在线”");
}

- (void)touchNews {
    NSLog(@"点击了新闻");
}

- (void)touchFindClass {
    NSLog(@"点击了教室查询");
    EmptyClassViewController *vc = [[EmptyClassViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)touchSchoolCar {
    NSLog(@"点击了校车查询");
}


- (void)touchSchedule {
    NSLog(@"点击了空课表");
}

- (void)touchMore {
    NSLog(@"点击了更多功能");
    LQQFinderToolViewController *vc = [[LQQFinderToolViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
