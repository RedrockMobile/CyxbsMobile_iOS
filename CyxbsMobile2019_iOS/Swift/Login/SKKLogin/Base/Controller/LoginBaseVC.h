//
//  LoginBaseVC.h
//  HUDDemo
//
//  Created by 宋开开 on 2022/8/10.
//

// 此类为登陆界面与忘记密码界面三个界面的基类
#import <UIKit/UIKit.h>

// View
#import "LoginBaseView.h"
#import "LoginView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginBaseVC : UIViewController

/// 判断是不是登陆界面，是的话使用LoginView
@property (nonatomic, assign) bool isLoginView;

/// View
@property (nonatomic, strong) LoginView *mainView;

/// 输入框的信息数组
@property (nonatomic, strong) NSMutableArray *textFieldInformationArray;

/// 网络错误显示的弹窗的View
@property (nonatomic, strong) UIView *networkWrongView;

/// 弹窗依据封装过的第三方库展示
@property (nonatomic, strong) MBProgressHUD *networkWrongHud;

/// 每个界面都有一个独有的hud弹窗View（登陆界面和忘记密码的第一个界面是当密码输入错误时的错误弹窗，忘记密码的第二个界面时当修改成功时的弹窗
@property (nonatomic, strong) UIView *tipView;

/// 弹窗标题
@property (nonatomic, strong) UILabel *tipTitleLab;

/// 弹窗正文
@property (nonatomic, strong) UILabel *tipTextLab;

/// 弹窗的按钮
@property (nonatomic, strong) UIButton *tipBtn;

/// 三个弹窗依据封装过的第三方库展示
@property (nonatomic, strong) MBProgressHUD *tipHud;

/// 设置UI数据（子类需要在调用 setUIIfNeeded 方法前先设置是否需要该控件）
- (void)setUIIfNeeded;

/// 点击按钮
- (void)clickBtn;

@end

NS_ASSUME_NONNULL_END
