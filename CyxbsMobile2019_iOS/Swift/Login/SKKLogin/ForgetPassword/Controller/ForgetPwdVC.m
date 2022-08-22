//
//  ForgetPwdVC.m
//  CyxbsMobile2019_iOS
//
//  Created by 宋开开 on 2022/8/9.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ForgetPwdVC.h"

// VC
#import "ModifyVC.h"

@interface ForgetPwdVC () <
    UITextFieldDelegate,
    ModifyVCDelegate
>

@end

@implementation ForgetPwdVC


#pragma mark - Life cycle

- (void)viewDidLoad {
    self.isLoginView = NO;
    [super viewDidLoad];
    // 设置输入框View数据
    [self setTextFieldData];
    // 选择需要的UI
    [self setNeedUI];
    // 设置UI数据
    [self setUIData];
}

#pragma mark - Method

/// 设置输入框View数据
- (void)setTextFieldData {
    // 数组里面的每一个元素都是字典
    NSArray *keyArray = @[@"imgStr", @"contentStr"];
    NSArray *objArray0 = @[@"stuID", @"请输入您的学号"];
    NSArray *objArray1 = @[@"stuCode", @"请输入统一认证码"];
    NSArray *objArray2 = @[@"newPassword", @"请输入统一认证码密码"];
    NSArray *tempArray = @[objArray0, objArray1, objArray2];
    
    for (int i = 0; i < tempArray.count; i++) {
        NSDictionary *dic = [NSDictionary dictionary];
        dic = [NSDictionary dictionaryWithObjects:tempArray[i] forKeys:keyArray];
        [self.textFieldInformationArray addObject:dic];
    }
}

/// 选择需要的UI
- (void)setNeedUI {
    // 1.需要返回按钮
    self.mainView.isBack = YES;
    // 2.需要3个文本框
    self.mainView.textFieldCount = 3;
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
        // 1.4 此界面最后输入框的输入内容是密文，其他两个是数字键盘
        if (i != 2) {
            self.mainView.tfViewArray[i].keyboardType = UIKeyboardTypeNumberPad;
        }else {
            self.mainView.tfViewArray[i].secureTextEntry = YES;
        }
    }
    // 2.提示文字
    self.mainView.passwordTipLab.text = @"统一认证码账密为学生登录教务在线等校园服务所用账号密码";
    // 3.设置按钮
    [self.mainView.btn setTitle:@"验证" forState:UIControlStateNormal];
}

/// 失败后的弹窗数据设置
- (void)setFailureHudData {
    // 1.设置弹窗主体
    // 1.1 设置尺寸
    CGRect viewFrame = self.tipView.frame;
    viewFrame.size = CGSizeMake(275, 233);  // // 0.731  0.349
    self.tipView.frame = viewFrame;
    self.tipView.center = CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.5);
    // 2 设置标题
    self.tipTitleLab.text = @"错误";
    // 3 设置正文
    self.tipTextLab.numberOfLines = 4;
    self.tipTextLab.text = @"请重新核验学号是否与统一认\n证码绑定、密码是否正确，如\n若忘记统一认证码密码请前往\n教务在线进行改密操作";
    // 正文位置
    [self.tipTextLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tipView);
        make.top.equalTo(self.tipTitleLab.mas_bottom).offset(12);
        make.size.mas_equalTo(CGSizeMake(215, 100));
    }];
}

#pragma mark - ModifyVCDelegate
- (void)dismissVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}


// MARK: SEL

/// 在验证了两个输入框都有数据后，重写请求方法
- (void)clickBtn {
    // 1.首先先使键盘消失
    [self dismissKeyboardWithGesture];
//    // 1.检查学号格式
//    if (self.mainView.tfViewArray[0].textField.text.length != 10) {
//        NSLog(@"请输入正确格式的学号");
//        [NewQAHud showHudWith:@" 请输入正确格式的学号  " AddView:self.mainView];
//        return;
//    }
    NSString *stuIDStr = self.mainView.tfViewArray[0].text;
    NSString *stuCodeStr = self.mainView.tfViewArray[1].text;
    NSString *pwdStr = self.mainView.tfViewArray[2].text;
    
    NSLog(@"🍋stuID：%@", stuIDStr);
    NSLog(@"🍉stuCode：%@", stuCodeStr);
    NSLog(@"🍇pwdStr：%@", pwdStr);
    // 2.TODO: 请求验证
    NSDictionary *parameters =
    @{@"stu_num" : stuIDStr, @"ids_num" : stuCodeStr, @"password" : pwdStr};
    [HttpTool.shareTool
     request:Mine_POST_UserSecretIds_API
     type:HttpToolRequestTypePost
     serializer:HttpToolRequestSerializerJSON
     bodyParameters:parameters
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        // 成功:界面跳转
        ModifyVC *modifyVC = [[ModifyVC alloc] init];
        modifyVC.code = object[@"data"][@"code"];
        modifyVC.stuIDStr = stuIDStr;
        modifyVC.modifyDelegate = self;
        modifyVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:modifyVC animated:NO completion:nil];
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"🥐%@", error);
        // 失败:弹窗提示
        // 1.1 设置弹窗内容
        [self setFailureHudData];
        // 1.2 展示弹窗并且保存该弹窗
        self.tipHud = [NewQAHud showhudWithCustomView:self.tipView AddView:self.mainView];
    }];
}

/// 点击弹窗中的“确定”按钮
- (void)dismissHUD {
    [self.tipHud hide:YES afterDelay:0.1];
}

@end
