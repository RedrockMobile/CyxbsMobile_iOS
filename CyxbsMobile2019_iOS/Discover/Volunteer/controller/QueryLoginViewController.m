//
//  QueryLoginViewController.m
//  MoblieCQUPT_iOS
//
//  Created by 方昱恒 on 2019/7/14.
//  Copyright © 2019 Orange-W. All rights reserved.
//

#pragma mark -志愿部分新版
#import "QueryLoginViewController.h"
#import "QueryViewController.h"
#import "VolunteeringEventItem.h"
#import "VolunteerItem.h"
#import <AFNetworking.h>
#import "VolunteerLoginView.h"

@interface QueryLoginViewController ()

@property (nonatomic, strong) VolunteerLoginView *loginView;
@property (nonatomic, strong) UIImageView *accountImageView;
@property (nonatomic, strong) UIImageView *passwordImageView;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UITextField *accountField;
@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) VolunteerItem *volunteer;
@property (nonatomic, strong) MBProgressHUD *loadHud;

@end

@implementation QueryLoginViewController

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self.view endEditing:YES];
//}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
      self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFailed) name:@"QueryVolunteerInfoFailed" object:nil];

    ///加载登陆界面
    VolunteerLoginView *view = [[VolunteerLoginView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:view];
    _loginView = view;

    [self buildLoginViewActions];
}

#pragma mark - 登陆界面的功能
- (void) buildLoginViewActions {
    ///返回按钮的点击事件
    [_loginView.backBtn addTarget:self action:@selector(clickedBackButton) forControlEvents:UIControlEventTouchUpInside];

    ///绑定按钮的点击事件
    [_loginView.loginBtn addTarget:self action:@selector(tapLoginBtn) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - 按钮的actions

// 返回按钮
- (void)clickedBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}

// 绑定按钮
- (void)tapLoginBtn{
    self.loadHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.loadHud.labelText = @"正在登录";
    self.account = _loginView.accountField.text;
    self.password = _loginView.passwordField.text;

    self.volunteer = [[VolunteerItem alloc] init];
    dispatch_async(dispatch_queue_create("build volunteer model", DISPATCH_QUEUE_CONCURRENT), ^{
        [self.volunteer getVolunteerInfoWithUserName:self.account andPassWord:self.password finishBlock:^(VolunteerItem *volunteer) {
            self.volunteer = volunteer;
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            NSDictionary *volAcc = @{
                @"volunteer_account": self.account,
                @"volunteer_password": self.password
            };
            [user setObject:volAcc forKey:@"volunteer_information"];
            [user synchronize];
            QueryViewController *queryVC = [[QueryViewController alloc] initWithVolunteerItem:self.volunteer];
            [self.navigationController pushViewController:queryVC animated:YES];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginVolunteerAccountSucceed" object:nil];
        }];
    });
 
//    HttpClient *client = [HttpClient defaultClient];
//    //完成绑定志愿者账号任务 (只需要点击按钮即可，未判断是否绑定成功 2021年9月22日 志愿者服务不可用状态)
//    [client.httpSessionManager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[UserItem defaultItem].token] forHTTPHeaderField:@"authorization"];
//    [client.httpSessionManager POST:TASK parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        NSString *target = @"绑定志愿者账号";
//        NSData *data = [target dataUsingEncoding:NSUTF8StringEncoding];
//        [formData appendPartWithFormData:data name:@"title"];
//        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//            NSLog(@"成功了");
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshPage" object:nil];
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            NSLog(@"失败了");
//        }];
//
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

#pragma mark - 登陆失败
- (void)loginFailed {
    [self.loadHud hide:YES];
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"账号密码错误或网络异常" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
    [alertC addAction:cancel];
    [self presentViewController:alertC animated:YES completion:nil];
}



#pragma mark - 键盘展开与收起
//- (void)keyboardWasShown:(NSNotification *)notification {
//    CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    CGRect oldFrame = self.view.frame;
//    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//        self.view.frame = CGRectMake(oldFrame.origin.x, 0 - keyboardFrame.size.height + 60, oldFrame.size.width, oldFrame.size.height);
//    } completion:nil];
//}
//
//- (void)keyboardWasHidden:(NSNotification *)notification {
//    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//        self.view.frame = CGRectMake(0, 0, MAIN_SCREEN_W, MAIN_SCREEN_H);
//    } completion:nil];
//}

@end
