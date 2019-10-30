//
//  FirstViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/10/21.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "DiscoverViewController.h"
#import "LoginViewController.h"
#import "LQQFinderView.h"
#import "LQQGlanceView.h"
#import "ElectricFeeModel.h"
typedef NS_ENUM(NSUInteger, LoginStates) {
    DidntLogin,
    LoginTimeOut,
    AlreadyLogin,
};

@interface DiscoverViewController ()<UIScrollViewDelegate>

@property (nonatomic, assign, readonly) LoginStates loginStatus;
//View
@property(nonatomic, weak) LQQFinderView *finderView;//上方发现页面
@property (nonatomic, weak) UIScrollView *contentView;
@property (nonatomic, weak) LQQGlanceView *glanceView;//下方剩余页面
//Model
@property ElectricFeeModel *elecModel;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.loginStatus != AlreadyLogin) {
        [self presentToLogin];
    }
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]}];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addContentView];
    [self configNavagationBar];
    [self addFinderView];
    [self addGlanceView];
    [self requestData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI) name:@"electricFeeDataSucceed" object:nil];
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
- (void)configNavagationBar {
    self.contentView.delegate = self;
}
//这个方法中零零散散的注释了四行代码是因为我想加动画但是失败了
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(scrollView.contentOffset.y >= self.navigationController.navigationBar.height + self.finderView.finderTitle.height){
//        [UIView animateWithDuration:1 animations:^{
            [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]}];
//        }];
    }else{
//        [UIView animateWithDuration:1 animations:^{
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]}];
//        }];
    }
}

- (void)addContentView {
    UIScrollView *contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    if(@available(iOS 11.0, *)){
        CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
        contentView.frame = CGRectMake(0,self.navigationController.navigationBar.height + statusBarFrame.size.height, self.view.width, self.view.height);
    }
    self.contentView = contentView;
    contentView.backgroundColor = [UIColor colorWithRed:242/255.0 green:243/255.0 blue:248/255.0 alpha:1.0];
    contentView.backgroundColor = [UIColor greenColor];
    contentView.contentSize = CGSizeMake(self.view.width, 1.5 * self.view.height);
    [self.view addSubview:contentView];
    
}

- (void)addFinderView {
    //下策
    LQQFinderView *finderView;
    if(MAIN_SCREEN_W / MAIN_SCREEN_H == 320 / 568.0){
        NSLog(@"iphoneSE");
        finderView = [[LQQFinderView alloc]initWithFrame:CGRectMake(0, 0,self.view.width, self.view.height * 0.62)];
    }else if(MAIN_SCREEN_W / MAIN_SCREEN_H == 375 / 667.0) {
        NSLog(@"iphone6,6S,7,8");
        finderView = [[LQQFinderView alloc]initWithFrame:CGRectMake(0, 0,self.view.width, self.view.height * 0.53)];
    }else if(MAIN_SCREEN_W / MAIN_SCREEN_H == 414 / 736.0) {
        NSLog(@"iphonePlus");
        finderView = [[LQQFinderView alloc]initWithFrame:CGRectMake(0, 0,self.view.width, self.view.height * 0.49)];
    }else if(MAIN_SCREEN_W / MAIN_SCREEN_H == 375 / 812.0) {
        NSLog(@"11Pro/X/XS");
        finderView = [[LQQFinderView alloc]initWithFrame:CGRectMake(0, 0,self.view.width, self.view.height * 0.44)];
    }else if(MAIN_SCREEN_W / MAIN_SCREEN_H == 414 / 896.0) {
        NSLog(@"11/11ProMax/XR/XS Max");
        finderView = [[LQQFinderView alloc]initWithFrame:CGRectMake(0, 0,self.view.width, self.view.height * 0.40)];
    }else {//以防万一
        finderView = [[LQQFinderView alloc]initWithFrame:CGRectMake(0, 0,self.view.width, self.view.height * 0.40)];
    }
    self.finderView = finderView;
    [self.contentView addSubview:finderView];
}

- (void)addGlanceView {
    LQQGlanceView *glanceView = [[LQQGlanceView alloc]initWithFrame:CGRectMake(0, self.finderView.height, self.view.width, self.view.height * 0.7)];
    self.glanceView = glanceView;
    [self.contentView addSubview:glanceView];
    glanceView.backgroundColor = [UIColor redColor];
}
- (void)requestData {
    ElectricFeeModel *elecModel = [[ElectricFeeModel alloc]init];
    self.elecModel = elecModel;
}
- (void)updateUI {
    self.glanceView.electricFeeMoney.text = self.elecModel.money;
    self.glanceView.electricFeeDegree.text = self.elecModel.degree;
    self.glanceView.electricFeeTime.text = self.elecModel.time;
}

@end
