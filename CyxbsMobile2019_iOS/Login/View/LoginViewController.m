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

@interface LoginViewController() <LoginViewProtocol>

@property (nonatomic, strong) LoginPresenter *presenter;

@property (weak, nonatomic) IBOutlet UITextField *stuNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *idNumTextField;

typedef NS_ENUM(NSInteger, LZLoginState) {
    LZLoginStateLackPassword,
    LZLoginStateLackAccount,
    LZLoginStateAccountOrPasswordWrong,
    LZLoginStateNetWorkWrong
};

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
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.presenter detachView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (IBAction)loginButtonClicked:(UIButton *)sender {
    [_presenter loginWithStuNum:self.stuNumTextField.text andIdNum:self.idNumTextField.text];
}

- (void)loginSucceeded:(UserItem *)item {
    [UserDefaultTool saveStuNum:self.stuNumTextField.text];
    [UserDefaultTool saveIdNum:self.idNumTextField.text];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loginFailed {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"密码输错了吧小老弟？";
    [hud hide:YES afterDelay:1.5];
}

@end