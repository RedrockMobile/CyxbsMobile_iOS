//
//  ModifyVC.m
//  HUDDemo
//
//  Created by 宋开开 on 2022/8/10.
//

#import "ModifyVC.h"

// VC
#import "LoginVC.h"

@interface ModifyVC ()

/// 两次密码不一致时的文字提示
@property (nonatomic, strong) UILabel *PwdNotMatchLab;

/// 成功后15秒弹窗自动关闭并执行回到登陆界面方法
@property (nonatomic) NSTimer *timer;

@end

@implementation ModifyVC

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
    // 初始时刻PwdNotMatchLab不显示，但是是用Masonry定位的，所以先加入父控件，alpha值为0
    [self.mainView addSubview:self.PwdNotMatchLab];
    [self setPosition];
    self.PwdNotMatchLab.alpha = 0;
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.timer invalidate];  // 可以打破相互强引用，真正销毁NSTimer对象
    self.timer = nil;  // 对象置nil是一种规范和习惯
}
#pragma mark - Method

/// 设置输入框View数据
- (void)setTextFieldData {
    // 数组里面的每一个元素都是字典
    NSArray *keyArray = @[@"imgStr", @"contentStr"];
    NSArray *objArray0 = @[@"newPassword", @"输入你需要修改的新密码"];
    NSArray *objArray1 = @[@"pwdAgain", @"再次输入新密码"];
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
    self.mainView.isBack = YES;
    // 2.需要2个文本框
    self.mainView.textFieldCount = 2;
    // 3.不需要密码提示文本
    self.mainView.isPasswordtip = NO;
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
        // 1.4 此界面两个输入框的输入内容都是密文
        self.mainView.tfViewArray[i].secureTextEntry = YES;
    }
    // 2.设置按钮
    [self.mainView.btn setTitle:@"修改" forState:UIControlStateNormal];
}

/// 成功后的弹窗数据设置
- (void)setSuccessHudData {
    // 1.设置弹窗主体
    // 1.1 设置尺寸
    CGRect viewFrame = self.tipView.frame;
    viewFrame.size = CGSizeMake(275, 177);
    self.tipView.frame = viewFrame;
    self.tipView.center = CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.5);
    // 2 设置标题
    self.tipTitleLab.text = @"成功";
    // 3 设置正文
    self.tipTextLab.numberOfLines = 2;
    self.tipTextLab.text = @"新密码修改成功请重新登录后\n再进行操作";
    // 正文位置
    [self.tipTextLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tipView);
        make.top.equalTo(self.tipTitleLab.mas_bottom).offset(12);
        make.size.mas_equalTo(CGSizeMake(215, 50));
    }];
}

/// 设置控件位置
- (void)setPosition {
    [self.PwdNotMatchLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainView.tfViewArray.lastObject);
        make.top.equalTo(self.mainView.tfViewArray.lastObject.mas_bottom).offset(12);
        make.size.mas_equalTo(CGSizeMake(212, 19));
    }];
}

// MARK: SEL

/// 在验证了两个输入框都有数据后，重写请求方法
- (void)clickBtn {
    // 1.首先先使键盘消失
    [self dismissKeyboardWithGesture];
    NSString *newPwdStr = self.mainView.tfViewArray[0].text;
    NSString *againPwdStr = self.mainView.tfViewArray[1].text;
    
    NSLog(@"🍋newPwdStr:%@", newPwdStr);
    // 两次密码相同
    if ([newPwdStr isEqualToString:againPwdStr]) {
        self.PwdNotMatchLab.alpha = 0;
        // TODO: 网络请求
    }else {
        // 不同的话显示提示信息
        self.PwdNotMatchLab.alpha = 1;
        return;
    }
    // 网络请求
    NSDictionary *parameters =
    @{@"stu_num":self.stuIDStr, @"new_password":newPwdStr, @"code":self.code};
    [HttpTool.shareTool request:Mine_POST_changePassword_API type:HttpToolRequestTypePost serializer:HttpToolRequestSerializerHTTP bodyParameters:parameters
        progress:nil
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        // 2.成功，弹出弹窗，跳转到登陆界面
        // 2.1 设置弹窗内容
        [self setSuccessHudData];
        // 2.2 展示弹窗并且保存该弹窗
        self.tipHud = [NewQAHud showhudWithCustomView:self.tipView AddView:self.mainView];
        // 15秒后自动关闭并跳转到登陆界面
        self.timer = [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(dismissHUD) userInfo:nil repeats:NO];
        NSRunLoop *runloop=[NSRunLoop currentRunLoop];
        [runloop addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 3. 失败网络错误的弹窗
        self.networkWrongHud = [NewQAHud showhudWithCustomView:self.networkWrongView AddView:self.mainView];
    }];
}

/// 点击弹窗中的“确定”按钮
- (void)dismissHUD {
    [self.tipHud hide:YES afterDelay:0.1];
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.modifyDelegate dismissVC];
}

#pragma mark - Getter

- (UILabel *)PwdNotMatchLab {
    if (_PwdNotMatchLab == nil) {
        _PwdNotMatchLab = [[UILabel alloc] init];
        _PwdNotMatchLab.text = @"两次密码不一致，请重试";
        _PwdNotMatchLab.textColor =
        [UIColor dm_colorWithLightColor:
            [UIColor colorWithHexString:@"#FF406E" alpha:1.0]
                              darkColor:
            [UIColor colorWithHexString:@"#FF7B9B" alpha:1.0]];
        _PwdNotMatchLab.font = [UIFont fontWithName:PingFangSCMedium size:12];
    }
    return _PwdNotMatchLab;
}

@end
