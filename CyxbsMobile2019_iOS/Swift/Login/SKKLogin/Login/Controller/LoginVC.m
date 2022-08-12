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


#import "掌上重邮-Swift.h"        // 将Swift中的类暴露给OC

@interface LoginVC () < PrivacyTipViewDelegate>

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
//    PrivacyTipView *pvc
}

#pragma mark - Method

/// 设置输入框View数据
- (void)setTextFieldData {
    // 数组里面的每一个元素都是字典
    NSArray *keyArray = @[@"imgStr", @"textStr", @"contentStr"];
    NSArray *objArray0 = @[@"7", @"账号", @"输入您的学号"];
    NSArray *objArray1 = @[@"7", @"密码", @"初始为身份证或统一认证码后6位"];
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
        // 1.2 输入框上方的文字
        NSString *textStr = self.textFieldInformationArray[i][@"textStr"];
        self.mainView.tfViewArray[i].textLab.text = textStr;
        // 1.3 输入框里的提示内容
        NSString *contentStr = self.textFieldInformationArray[i][@"contentStr"];
        self.mainView.tfViewArray[i].textField.placeholder = contentStr;
        // 1.4 键盘上的placeholder
        self.mainView.tfViewArray[i].keyboardPlaceholderLab.text = contentStr;
    }
    // 1.5 此界面最后输入框的输入内容是密文，第一个是数字键盘
    self.mainView.tfViewArray[0].textField.keyboardType = UIKeyboardTypeNumberPad;
    self.mainView.tfViewArray[1].textField.secureTextEntry = YES;
    
    // 2.提示文字
    self.mainView.passwordTipLab.text = @"研究生和20级及以后的学生默认登陆密码为统一认证码后6位，其余同学默认为身份证后6位。";
    // 3.设置按钮
    [self.mainView.btn setTitle:@"登 陆" forState:UIControlStateNormal];
}

/// 密码错误后的弹窗数据设置
- (void)setFailureHudData {
    // 1.设置弹窗主体
    // 1.1 设置尺寸
    CGRect viewFrame = self.tipView.frame;
    viewFrame.size = CGSizeMake(SCREEN_WIDTH * 0.8, SCREEN_HEIGHT * 0.3);
    self.tipView.frame = viewFrame;
    self.tipView.center = CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.5);
    // 2 设置标题
    self.tipTitleLab.text = @"错误";
    // 3 设置正文
    self.tipTextLab.numberOfLines = 2;
    self.tipTextLab.text = @"账号和密码错误，请重新输入\n或进行忘记密码操作";
    // 正文位置
    [self.tipTextLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tipView);
        make.top.equalTo(self.tipTitleLab).offset(25);
        make.left.right.equalTo(self.tipView);
        make.height.mas_equalTo(140);
    }];
}

// MARK: SEL

/// 在验证了两个输入框都有数据后，重写请求方法
- (void)clickBtn {
    // 1.检查学号格式
    if (self.mainView.tfViewArray[0].textField.text.length != 10) {
        NSLog(@"请输入正确格式的学号");
        [NewQAHud showHudWith:@" 请输入正确格式的学号  " AddView:self.mainView];
        return;
    }
    
    // 2.检查有没有勾选
    if (!self.mainView.agreeBtn.selected) {
        [NewQAHud showHudWith:@"请阅读并同意《掌上重邮用户协议》" AddView:self.mainView];
        return;
    }
    
    // 3.请求验证
    NSString *stuIDStr = self.mainView.tfViewArray[0].textField.text;
    NSString *pwdStr = self.mainView.tfViewArray[1].textField.text;
    
    NSLog(@"🍋stuID：%@", stuIDStr);
    NSLog(@"🍉stuCode：%@", pwdStr);
    // TODO: 请求验证
    // TODO: 成功:
    
    
    
    
//    // 失败:弹窗提示
//    // 1.1 设置弹窗内容
//    [self setFailureHudData];
//    // 1.2 展示弹窗并且保存该弹窗
//    self.tipHud = [NewQAHud showhudWithCustomView:self.tipView AddView:self.mainView];
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
        [self.mainView.agreeBtn setImage:[UIImage imageNamed: @"ProtocolCheckButton"] forState:UIControlStateNormal];
    }else {
        [self.mainView.agreeBtn setImage:[UIImage imageNamed: @"checkMarkCircle"] forState:UIControlStateNormal];
    }
}

/// 弹出协议VC
- (void)lookOverProtocol {
    UserProtocolViewController *userProtocolVC = [[UserProtocolViewController alloc] init];
    [self.navigationController presentViewController:userProtocolVC animated:YES completion:nil];
}

/// 跳转到忘记密码界面
- (void)jumpToForgetPwdVC {
    
    ForgetPwdVC *forgetPwdVC = [[ForgetPwdVC alloc] init];
    [self.navigationController pushViewController:forgetPwdVC animated:NO];
}

/// 点击弹窗中的“确定”按钮
- (void)dismissHUD {
    [self.tipHud hide:YES afterDelay:0.1];
}


@end
