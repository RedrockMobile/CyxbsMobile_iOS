//
//  QueryLoginViewController.m
//  MoblieCQUPT_iOS
//
//  Created by 方昱恒 on 2019/7/14.
//  Copyright © 2019 Orange-W. All rights reserved.
//

#import "QueryLoginViewController.h"
#import "QueryViewController.h"
#import "VolunteeringEventItem.h"
#import "VolunteerItem.h"
#import <AFNetworking.h>

@interface QueryLoginViewController ()

@property (nonatomic, strong) UIImageView *accountImageView;
@property (nonatomic, strong) UIImageView *passwordImageView;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UITextField *accountField;
@property (nonatomic, strong) VolunteerItem *volunteer;
@property (nonatomic, strong) MBProgressHUD *loadHud;

@end

@implementation QueryLoginViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([user objectForKey:@"volunteer_account"]) {
        self.loadHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.loadHud.labelText = @"正在登录";
        NSDictionary *account = [user objectForKey:@"volunteer_account"];
        self.accountField.text = account[@"username"];
        self.passwordField.text = account[@"password"];
        
        self.volunteer = [[VolunteerItem alloc] init];
        [self.volunteer getVolunteerInfoWithUserName:account[@"username"] andPassWord:account[@"password"] finishBlock:^(VolunteerItem *volunteer) {
            self.volunteer = volunteer;
            QueryViewController *queryVC = [[QueryViewController alloc] initWithVolunteerItem:self.volunteer];
            queryVC.view.backgroundColor = [UIColor whiteColor];
            [self.navigationController pushViewController:queryVC animated:YES];
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFailed) name:@"loginFailed" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    [self biuldUI];
}

#pragma mark - 搭建界面
- (void)biuldUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc]init];
    self.navigationItem.title =@"完善信息";
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 0.328)];
    imageView.image = [UIImage imageNamed:@"志愿时长_volunteer"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imageView];
    //设置返回按钮
    UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake((16.f/375)*MAIN_SCREEN_W,(37.f/667)*MAIN_SCREEN_H,(12.f/375)*MAIN_SCREEN_W,(20.f/667)*MAIN_SCREEN_H)];
    [back addTarget:self action:@selector(clickedBackButton) forControlEvents:UIControlEventTouchUpInside];
    [back setBackgroundImage:[UIImage imageNamed:@"login_back"] forState:UIControlStateNormal];
    [self.view addSubview:back];
    //设置bartitle
    int padding1 = (145.f/375)*MAIN_SCREEN_W;
    UILabel *tilte = [[UILabel alloc]initWithFrame:CGRectMake(padding1, (35.f/667)*MAIN_SCREEN_H, MAIN_SCREEN_W-2*padding1, (20.f/667)*MAIN_SCREEN_H)];
    tilte.text = @"完善信息";
    tilte.font = [UIFont systemFontOfSize:18];
    tilte.textAlignment = NSTextAlignmentCenter;
    tilte.textColor = [UIColor whiteColor];
    [self.view addSubview:tilte];
    
    int padding = (35.f/375)*MAIN_SCREEN_W;
    //设置保存按钮
    UIButton *save = [[UIButton alloc]initWithFrame:CGRectMake(padding, (483.f/667)*MAIN_SCREEN_H, MAIN_SCREEN_W-2*padding, (MAIN_SCREEN_W-2*padding) * 0.12)];
    [save addTarget:self action:@selector(tapSaveBtn) forControlEvents:UIControlEventTouchUpInside];
    [save setBackgroundImage:[UIImage imageNamed:@"login_icon"] forState:UIControlStateNormal];
    [save setTitle:@"登 陆" forState:UIControlStateNormal];
    save.titleEdgeInsets = UIEdgeInsetsMake(0, save.imageView.frame.size.width, 0, 0);
    [save setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:save];
    //设置textfield
    self.accountField=[self createTextFielfFrame:CGRectMake((76.f/375)*MAIN_SCREEN_W, (335.f/667)*MAIN_SCREEN_H, MAIN_SCREEN_W-padding*2-36, (30.f/667)*MAIN_SCREEN_H) font:[UIFont systemFontOfSize:15] placeholder:@"请输入志愿重庆账号"];
    self.accountField.clearButtonMode = UITextFieldViewModeWhileEditing;
    UIView *accountLine = [[UIView alloc]initWithFrame:CGRectMake(padding, (367.f/667)*MAIN_SCREEN_H, MAIN_SCREEN_W-padding*2, (2.f/667)*MAIN_SCREEN_H)];
    accountLine.backgroundColor = [UIColor grayColor];
    accountLine.alpha = 0.2;
    [self.view addSubview:accountLine];
    
    self.passwordField=[self createTextFielfFrame:CGRectMake((76.f/375)*MAIN_SCREEN_W, (395.f/667)*MAIN_SCREEN_H, MAIN_SCREEN_W-padding*2-36, (30.f/667)*MAIN_SCREEN_H) font:[UIFont systemFontOfSize:15] placeholder:@"请输入密码" ];
    self.passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordField.secureTextEntry=YES;
    UIView *passwordLine = [[UIView alloc]initWithFrame:CGRectMake(padding, (428.f/667)*MAIN_SCREEN_H, MAIN_SCREEN_W-padding*2, (2.f/667)*MAIN_SCREEN_H)];
    passwordLine.backgroundColor = [UIColor grayColor];
    passwordLine.alpha = 0.2;
    [self.view addSubview:passwordLine];
    
    //设置图标的imageview
    UIImage *accountImage = [UIImage imageNamed:@"login_number"];
    self.accountImageView = [[UIImageView alloc]initWithImage:accountImage];
    self.accountImageView.frame = CGRectMake((42.f/375)*MAIN_SCREEN_W, (339.f/667)*MAIN_SCREEN_H, (19.f/375)*MAIN_SCREEN_W, (20.f/667)*MAIN_SCREEN_H);
    
    
    UIImage *passwordImage = [UIImage imageNamed:@"login_password"];
    self.passwordImageView = [[UIImageView alloc]initWithImage:passwordImage];
    self.passwordImageView.frame = CGRectMake((42.f/375)*MAIN_SCREEN_W, (399.f/667)*MAIN_SCREEN_H, (19.f/375)*MAIN_SCREEN_W, (20.f/667)*MAIN_SCREEN_H);
    
    
    [self.view addSubview:self.accountField];
    [self.view addSubview:self.passwordField];
    
    [self.view addSubview:self.accountImageView];
    [self.view addSubview:self.passwordImageView];
}

#pragma mark - 创建输入框
- (UITextField *)createTextFielfFrame:(CGRect)frame font:(UIFont *)font placeholder:(NSString *)placeholder{
    UITextField *textField=[[UITextField alloc]initWithFrame:frame];
    textField.font=font;
    textField.textColor=[UIColor grayColor];
    textField.borderStyle=UITextBorderStyleNone;
    textField.placeholder=placeholder;
    return textField;
}

#pragma mark - 按钮的actions

// 返回按钮
- (void)clickedBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}

// 保存按钮
- (void)tapSaveBtn{
    self.loadHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.loadHud.labelText = @"正在登录";
    NSString *account = self.accountField.text;
    NSString *password = self.passwordField.text;
    
    self.volunteer = [[VolunteerItem alloc] init];
    dispatch_async(dispatch_queue_create("build volunteer model", DISPATCH_QUEUE_CONCURRENT), ^{
        [self.volunteer getVolunteerInfoWithUserName:account andPassWord:password finishBlock:^(VolunteerItem *volunteer) {
            self.volunteer = volunteer;
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            if (![user objectForKey:@"volunteer_account"]) {
                NSDictionary *volAcc = @{
                                         @"username": account,
                                         @"password": password,
                                         @"uid": volunteer.uid
                                         };
                [user setObject:volAcc forKey:@"volunteer_account"];
                [user synchronize];
            }
            
            QueryViewController *queryVC = [[QueryViewController alloc] initWithVolunteerItem:self.volunteer];
            queryVC.view.backgroundColor = [UIColor whiteColor];
            [self.navigationController pushViewController:queryVC animated:YES];
        }];
    });
}

#pragma mark - 登陆失败
- (void)loginFailed {
    [self.loadHud hide:YES];
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"账号或密码错误" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
    [alertC addAction:cancel];
    [self presentViewController:alertC animated:YES completion:nil];
}

#pragma mark - 键盘展开与收起
- (void)keyboardWasShown:(NSNotification *)notification {
    CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect oldFrame = self.view.frame;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.view.frame = CGRectMake(oldFrame.origin.x, 0 - keyboardFrame.size.height + 60, oldFrame.size.width, oldFrame.size.height);
    } completion:nil];
}

- (void)keyboardWasHidden:(NSNotification *)notification {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.view.frame = CGRectMake(0, 0, MAIN_SCREEN_W, MAIN_SCREEN_H);
    } completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
