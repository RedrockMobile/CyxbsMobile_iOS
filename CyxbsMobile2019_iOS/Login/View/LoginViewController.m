//
//  LoginViewController.m
//  MobileLogin
//
//  Created by GQuEen on 15/8/13.
//  Copyright (c) 2015年 GegeChen. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginPresenter.h"
#import "LoginViewProtocol.h"
#import "UserProtocolViewController.h"

typedef NS_ENUM(NSInteger, LZLoginState) {
    LZLoginStateLackPassword,
    LZLoginStateLackAccount,
    LZLoginStateAccountOrPasswordWrong,
    LZLoginStateOK
};

@interface LoginViewController() <LoginViewProtocol>

@property (nonatomic, strong) LoginPresenter *presenter;

@property (weak, nonatomic) IBOutlet UITextField *stuNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *idNumTextField;
@property (weak, nonatomic) IBOutlet UIButton *protocolCheckButton;
@property (weak, nonatomic) IBOutlet UILabel *loginTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *loginSubTitleLabel;


@property (weak, nonatomic) MBProgressHUD *loginHUD;

@end

@implementation LoginViewController

// iOS 13更新以后modal视图变成了卡片式视图，导致登陆界面可能被跳过。
// 因此在这里将登陆界面的视图样式改为“FullScreen”
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _presenter = [[LoginPresenter alloc] init];
    [_presenter attachView:self];
    
    self.protocolCheckButton.backgroundColor = [UIColor clearColor];
    self.protocolCheckButton.layer.cornerRadius = 8;
    self.protocolCheckButton.clipsToBounds = YES;
    self.protocolCheckButton.layer.borderWidth = 1;
    self.protocolCheckButton.layer.borderColor = [UIColor colorWithRed:75/255.0 green:69/255.0 blue:228/255.0 alpha:1].CGColor;
    
    if (@available(iOS 11.0, *)) {
        self.loginTitleLabel.textColor = [UIColor colorNamed:@"LoginTitleColor"];
        self.loginSubTitleLabel.textColor = [UIColor colorNamed:@"LoginTitleColor"];
        self.loginSubTitleLabel.alpha = 0.6;
        self.view.backgroundColor = [UIColor colorNamed:@"LoginBackgroundColor"];
        self.stuNumTextField.textColor = [UIColor colorNamed:@"LoginTextFieldColor"];
        self.idNumTextField.textColor = [UIColor colorNamed:@"LoginTextFieldColor"];
    } else {
        self.loginTitleLabel.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1];
        self.loginSubTitleLabel.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1];
        self.loginSubTitleLabel.alpha = 0.6;
        self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:252/255.0 alpha:1];
        self.stuNumTextField.textColor = [UIColor colorWithRed:28/255.0 green:48/255.0 blue:88/255.0 alpha:1];
        self.idNumTextField.textColor = [UIColor colorWithRed:28/255.0 green:48/255.0 blue:88/255.0 alpha:1];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.presenter detachView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (IBAction)loginButtonClicked:(UIButton *)sender {
    
    if ([self.stuNumTextField.text isEqualToString:@""] && [self.idNumTextField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"你账号密码都没输诶";
        [hud hide:YES afterDelay:1.5];
    } else if ([self.idNumTextField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"你没有输密码诶";
        [hud hide:YES afterDelay:1.5];
    } else if ([self.stuNumTextField.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"你没有输账号诶";
        [hud hide:YES afterDelay:1.5];
    } else  {
        [_presenter loginWithStuNum:self.stuNumTextField.text andIdNum:self.idNumTextField.text];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        self.loginHUD = hud;
    }
}

- (void)loginSucceeded:(UserItem *)item {
    [UserDefaultTool saveStuNum:self.stuNumTextField.text];
    [UserDefaultTool saveIdNum:self.idNumTextField.text];
    //设置umeng统计，用户id设为学号
    [MobClick profileSignInWithPUID:self.stuNumTextField.text];
    [self.loginHUD hide:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    ((UITabBarController *)([UIApplication sharedApplication].delegate.window.rootViewController)).selectedIndex = 0;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Login_LoginSuceeded" object:nil userInfo:@{@"userItem": [UserItemTool defaultItem]}];
}

- (void)loginFailed {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"密码输错了吧小老弟？";
    [hud hide:YES afterDelay:1.5];
    [self.loginHUD hide:YES];
}

- (IBAction)protocolButtonClicked:(id)sender {
    UserProtocolViewController *protocolVC = [[UserProtocolViewController alloc] init];
    [self presentViewController:protocolVC animated:YES completion:nil];
}

- (IBAction)protocolCheckButtonClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
}

@end
