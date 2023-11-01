//
//  LoginVC.m
//  HUDDemo
//
//  Created by 宋开开 on 2022/8/11.
//

#import "LoginVC.h"

// VC
#import "ForgetPwdVC.h"
#import "UserProtocolViewController.h"  // 协议

// Tool
#import "TodoSyncTool.h"
#import "sys/utsname.h"
#include <ifaddrs.h>
#include <arpa/inet.h>

#import "掌上重邮-Swift.h"        // 将Swift中的类暴露给OC

@interface LoginVC () <
    UITextFieldDelegate,
    PrivacyTipViewDelegate
>

/// 新的隐私协议弹窗
@property (nonatomic, strong) PrivacyTipView *privacyView;

/// "登录中“弹窗
@property (nonatomic, strong) MBProgressHUD *loginingHud;

@end

@implementation LoginVC

#pragma mark - Life cycle

- (void)viewDidLoad {
    self.isLoginView = YES;
    [super viewDidLoad];
    // 设置输入框View数据
    [self setTextFieldData];
    // 选择需要的UI
    [self setNeedUI];
    // 设置UI数据
    [self setUIData];
    // 加入Logo和忘记密码按钮
    [self setBtnSEL];
    // 展示新协议
    [self showPrivacyTip];
}

#pragma mark - Method

/// 设置输入框View数据
- (void)setTextFieldData {
    // 数组里面的每一个元素都是字典
    NSArray *keyArray = @[@"imgStr", @"contentStr"];
    NSArray *objArray0 = @[@"loginStuID", @"请输入学号"];
    NSArray *objArray1 = @[@"loginPwd", @"身份证/统一认证码后6位"];
    NSArray *tempArray = @[objArray0, objArray1];
    
    for (int i = 0; i < tempArray.count; i++) {
        NSDictionary *dic = [NSDictionary dictionary];
        dic = [NSDictionary dictionaryWithObjects:tempArray[i] forKeys:keyArray];
        [self.textFieldInformationArray addObject:dic];
    }
}

/// 选择需要的UI
- (void)setNeedUI {
    // 1.需要返回按钮
    self.mainView.isBack = NO;
    // 2.需要2个文本框
    self.mainView.textFieldCount = 2;
    // 3.需要密码提示文本
    self.mainView.isPasswordtip = YES;
    // 4.根据需求设置控件
    [self setUIIfNeeded];
    // 5.设置UI数据
    [self setUIData];
}

/// 设置UI数据
- (void)setUIData {
    // 1.输入框数据
    for (int i = 0; i < self.mainView.tfViewArray.count; i++) {
        // 1.1 输入框上的图标
        NSString *iconStr = self.textFieldInformationArray[i][@"imgStr"];
        self.mainView.tfViewArray[i].iconImgView.image = [UIImage imageNamed:iconStr];
        // 1.2 输入框里的提示内容
        NSString *contentStr = self.textFieldInformationArray[i][@"contentStr"];
        self.mainView.tfViewArray[i].placeholder = contentStr;
        // 1.3 键盘上的placeholder
        self.mainView.tfViewArray[i].keyboardPlaceholderLab.text = contentStr;
    }
    // 1.4 此界面最后输入框的输入内容是密文，第一个是数字键盘
    self.mainView.tfViewArray[0].keyboardType = UIKeyboardTypeNumberPad;
    self.mainView.tfViewArray[1].secureTextEntry = YES;
    
    // 2.提示文字
    self.mainView.passwordTipLab.text = @"2020级及以后学生默认密码为统一认证码后六位，其余同学默认密码为身份证后六位。";
    [self.mainView.passwordTipLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mainView.tfViewArray.lastObject).offset(-10);
            make.height.mas_equalTo(34);
    }];
    // 3.设置按钮
    [self.mainView.btn setTitle:@"登 陆" forState:UIControlStateNormal];
    [self.mainView.btn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainView).offset(30);
    }];
    // 4.忘记密码与同意协议的位置设置
    [self.mainView setPositionAccordingToBtn];
}

/// 密码错误后的弹窗数据设置
- (void)setFailureHudData {
    // 1.设置弹窗主体
    // 1.1 设置尺寸
    CGRect viewFrame = self.tipView.frame;
    viewFrame.size = CGSizeMake(275, 177);
    self.tipView.frame = viewFrame;
    self.tipView.center = CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.5);
    // 2.设置标题
    self.tipTitleLab.text = @"错误";
    // 3.设置正文
    self.tipTextLab.numberOfLines = 2;
    self.tipTextLab.text = @"账号和密码错误，请重新输入\n或进行忘记密码操作";
    // 正文位置
    [self.tipTextLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tipView);
        make.top.equalTo(self.tipTitleLab.mas_bottom).offset(12);
        make.size.mas_equalTo(CGSizeMake(215, 50));
    }];
}

- (void)showPrivacyTip {
    // 弹出隐私协议窗口;
    if (![NSUserDefaults.standardUserDefaults boolForKey:@"ReadPrivacyTip"]) {
        [self.mainView addSubview:self.privacyView];
    }
}

/// 获取设备的Vendor标识符
- (NSString *)identifierForVendor {
    NSString *vendorID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return vendorID;
}

/// 获取设备的IP地址
- (NSString *)getLocalWifiIPAddress {
    NSString *address = nil;
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // 通过调用 getifaddrs 函数获取所有接口的列表信息
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // 如果成功，循环遍历所有接口
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            // 判断当前接口是否为 Wi-Fi
            if(temp_addr->ifa_addr->sa_family == AF_INET && [[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                // 如果是 Wi-Fi 接口，获取 IPv4 地址
                struct sockaddr_in *addr = (struct sockaddr_in *)temp_addr->ifa_addr;
                char *ip = inet_ntoa(addr->sin_addr);
                address = [NSString stringWithUTF8String:ip];
                break;
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // 释放 getifaddrs 函数返回的内存空间
    freeifaddrs(interfaces);
    
    // 如果获取地址失败，返回默认值
    if (address == nil) {
        address = @"Unknown";
    }
    
    return address;
}

/// 获取生产厂商
- (NSString *)deviceManufacturer {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return platform;
}

// MARK: SEL

/// 在验证了两个输入框都有数据后，重写请求方法
- (void)clickBtn {
    // 1.首先先使键盘消失
    [self dismissKeyboardWithGesture];
    // 2.检查学号格式
    if (self.mainView.tfViewArray[0].text.length != 10) {
        NSLog(@"请输入正确格式的学号");
        [NewQAHud showHudWith:@"  请输入正确格式的学号 " AddView:self.mainView];
        return;
    }
    
    // 3.检查有没有勾选
    if (!self.mainView.agreeBtn.selected) {
        [NewQAHud showHudWith:@"请阅读并同意《掌上重邮用户协议》" AddView:self.mainView];
        return;
    }
    
    // 4.请求验证
    NSString *stuIDStr = self.mainView.tfViewArray[0].text;
    NSString *pwdStr = self.mainView.tfViewArray[1].text;
    
    // 4.1 展示hud
    self.loginingHud = [NewQAHud showNotHideHudWith:@"登录中..." AddView:self.mainView];
    
    // 4.2 model
    [LoginModel loginWithStuNum:stuIDStr
    idNum:pwdStr
    success:^{
        // 4.2.1 AppDelegate
        self.tabBarController.selectedIndex = 0;
        // 4.2.2 隐藏hud
        [self.loginingHud hide:YES afterDelay:0.1];
        // 4.2.3 自己消失,进入主界面
        [self dismissViewControllerAnimated:YES completion:nil];
        // 4.2.4 完成登录成功后todo的一些配置
        TodoSyncTool *todoTool = [[TodoSyncTool alloc] init];
        [todoTool logInSuccess];
        // 4.2.5 得到用户信息
        [[UserItem defaultItem] getUserInfo];
        // 4.2.5 上传用户手机信息
        NSDictionary *param = @{@"phone": [self identifierForVendor],
                                @"manufacturer": [self deviceManufacturer],
                                @"ip": [self getLocalWifiIPAddress]
        };
        [HttpTool.shareTool
         request:Mine_POST_loginInformation_API
         type:HttpToolRequestTypePost
         serializer:HttpToolRequestSerializerJSON
         bodyParameters:param
         progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
            
        }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
    failed:^(BOOL isNet) {
        // 隐藏hud
        [self.loginingHud hide:YES afterDelay:0.1];
        // 产看是否是网络的问题
        if (isNet) {
            // 网络弹窗
            self.networkWrongHud = [NewQAHud showhudWithCustomView:self.networkWrongView AddView:self.mainView];
        } else {  // 网络没问题则是账号密码有问题
            // 1 设置弹窗内容
            [self setFailureHudData];
            // 2 展示弹窗并且保存该弹窗
            self.tipHud = [NewQAHud showhudWithCustomView:self.tipView AddView:self.mainView];
        }
    }];
    
}

- (void)setBtnSEL {
    // 1.点击同意协议按钮
    [self.mainView.agreeBtn addTarget:self action:@selector(agreeProtocol) forControlEvents:UIControlEventTouchUpInside];
    // 2.点击协议按钮
    [self.mainView.protocolBtn addTarget:self action:@selector(lookOverProtocol) forControlEvents:UIControlEventTouchUpInside];
    // 2.点击忘记密码按钮
    [self.mainView.forgetPwdBtn addTarget:self action:@selector(jumpToForgetPwdVC) forControlEvents:UIControlEventTouchUpInside];
}

/// 按钮图案变化
- (void)agreeProtocol {
    self.mainView.agreeBtn.selected = !self.mainView.agreeBtn.selected;
    if (self.mainView.agreeBtn.selected) {
        [self.mainView.agreeBtn setImage:[UIImage imageNamed:@"ProtocolCheckButton"] forState:UIControlStateNormal];
    }else {
        [self.mainView.agreeBtn setImage:[UIImage imageNamed:@"checkMarkCircle"] forState:UIControlStateNormal];
    }
}

/// 弹出协议VC
- (void)lookOverProtocol {
    UserProtocolViewController *userProtocolVC = [[UserProtocolViewController alloc] init];
    [self presentViewController:userProtocolVC animated:YES completion:nil];
}

/// 跳转到忘记密码界面
- (void)jumpToForgetPwdVC {
    
    ForgetPwdVC *forgetPwdVC = [[ForgetPwdVC alloc] init];
    forgetPwdVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:forgetPwdVC animated:NO completion:nil];
}

/// 点击弹窗中的“确定”按钮
- (void)dismissHUD {
    [self.tipHud hide:YES afterDelay:0.1];
}

#pragma mark - PrivacyTipViewDelegate

- (void)showPrivacyPolicy:(PrivacyTipView * _Nonnull)view {
    UserProtocolViewController *userProtocolVC = [[UserProtocolViewController alloc] init];
    [self.navigationController presentViewController:userProtocolVC animated:YES completion:nil];
}

/// 点击 “同意” 按钮后调用
- (void)allowBtnClik:(PrivacyTipView * _Nonnull)view {
    self.mainView.agreeBtn.selected = YES;
    [NSUserDefaults.standardUserDefaults setBool:YES forKey:@"ReadPrivacyTip"];
    [self.mainView.agreeBtn setImage:[UIImage imageNamed:@"ProtocolCheckButton"] forState:UIControlStateNormal];
}

/// 不同意
- (void)notAllowBtnClik:(PrivacyTipView * _Nonnull)view {
    self.mainView.agreeBtn.selected = NO;
    [self.mainView.agreeBtn setImage:[UIImage imageNamed:@"checkMarkCircle"] forState:UIControlStateNormal];
}

#pragma mark - Getter

- (PrivacyTipView *)privacyView {
    if (_privacyView == nil) {
        _privacyView = [[PrivacyTipView alloc] init];
        _privacyView.delegate = self;
    }
    return _privacyView;
}


@end
