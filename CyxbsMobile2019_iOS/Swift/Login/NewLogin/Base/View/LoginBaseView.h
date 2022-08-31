//
//  LoginBaseView.h
//  CyxbsMobile2019_iOS
//
//  Created by 宋开开 on 2022/8/9.
//  Copyright © 2022 Redrock. All rights reserved.
//

// 此类为登陆及帐密界面View的基类
#import <UIKit/UIKit.h>

// View
#import "LoginTextFieldView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginBaseView : UIView

/// 是否需要添加顶部返回按钮和“忘记密码”文字
@property (nonatomic, assign) bool isBack;

/// 在顶部返回的按钮
@property (nonatomic, strong) UIButton *backBtn;

/// 输入框个数
@property (nonatomic, assign) NSUInteger textFieldCount;

/// 装着输入框View的数组（便于约束位置）
@property (nonatomic, strong) NSMutableArray <LoginTextFieldView *> *tfViewArray;

/// 是否有提示文本（研究生和20级以后...）
@property (nonatomic, assign) bool isPasswordtip;

/// 提示文本
@property (nonatomic, strong) UILabel *passwordTipLab;

/// 登陆 / 验证 / 修改 按钮
@property (nonatomic, strong) UIButton *btn;


#pragma mark - Method

/// 添加顶部返回按钮
- (void)addBackItem;

/// 根据输入框个数来展示输入框
- (void)addTextField;

/// 如果有提示文字，设置提示文字数据
- (void)addPasswordTip;

/// 按钮
- (void)addBtn;

@end

NS_ASSUME_NONNULL_END
