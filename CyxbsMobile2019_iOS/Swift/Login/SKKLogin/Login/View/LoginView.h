//
//  LoginView.h
//  CyxbsMobile2019_iOS
//
//  Created by 宋开开 on 2022/8/12.
//  Copyright © 2022 Redrock. All rights reserved.
//

// 此类为登陆界面的View，主要在LoginBaseView的基础上再增加控件，减轻VC的负担
#import "LoginBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginView : LoginBaseView

/// 忘记密码按钮
@property (nonatomic, strong) UIButton *forgetPwdBtn;

/// "同意《掌上重邮用户协议》"按钮
@property (nonatomic, strong) UIButton *protocolBtn;

/// 勾选协议按钮
@property (nonatomic, strong) UIButton *agreeBtn;

@end

NS_ASSUME_NONNULL_END
