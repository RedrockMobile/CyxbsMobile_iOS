//
//  LoginBaseVC.m
//  HUDDemo
//
//  Created by 宋开开 on 2022/8/10.
//

#import "LoginBaseVC.h"


@interface LoginBaseVC () <
    UITextFieldDelegate
>

@end

@implementation LoginBaseVC

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.mainView];
    // 验证按钮无法点击
    [self.mainView.btn setBackgroundColor:[UIColor colorWithHexString:@"#C5C5C5" alpha:1.0]];
    self.mainView.btn.enabled = NO;
    // 手势取消键盘
    [self gestureDismissKeyboard];
}

#pragma mark - Method
// 子类需要在调用 setUIIfNeeded 方法前先设置是否需要该控件
/// 设置UI数据
- (void)setUIIfNeeded {
    // 1.返回按钮
    [self.mainView addBackItem];
    [self.mainView.backBtn addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    
    // 2.输入框
    [self.mainView addTextField];
    // 数据展示
    for (int i = 0; i < self.mainView.tfViewArray.count; i++) {
        // 2.1 添加代理
        self.mainView.tfViewArray[i].delegate = self;
        // 2.2 给键盘上方加一个提示框toolBar
        [self addKeyBoardToolBarforTextField:self.mainView.tfViewArray[i] AndPlaceholder:self.mainView.tfViewArray[i].keyboardPlaceholderLab];
    }
    // 3.提示文字
    [self.mainView addPasswordTip];
    
    // 4.按钮
    [self.mainView addBtn];
    [self.mainView.btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
}

/// 给键盘上方加一个提示框toolBar
- (void)addKeyBoardToolBarforTextField:(UITextField *)textField AndPlaceholder:(UILabel *)placeholderLab {
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    // 完成按钮，点击后会退出键盘
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, 0, 50, 44)];
    [btn setTitleColor:UIColor.systemBlueColor forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(doneClicked) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:btn];
    
    // placeholderLabel
    [toolBar addSubview:placeholderLab];
    [placeholderLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(toolBar);
        make.top.equalTo(toolBar);
        make.bottom.equalTo(toolBar);
    }];
    textField.inputAccessoryView = toolBar;
}

/// 点击键盘右上角的完成按钮后调用,会取消键盘
- (void)doneClicked {
    [self.mainView endEditing:YES];
}

// 三种返回方式： 1.点击return或者“完成”返回 2.点击空白处 3.上下滑动
- (void)gestureDismissKeyboard {
    // 键盘消失方式2 点击界面
    UITapGestureRecognizer *dismissKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboardWithGesture)];
    [self.mainView addGestureRecognizer:dismissKeyboard];
    // 键盘消失方式3 上下滑动界面
    UISwipeGestureRecognizer *swipeUP = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboardWithGesture)];
    swipeUP.direction = UISwipeGestureRecognizerDirectionUp;
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboardWithGesture)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.mainView addGestureRecognizer:swipeUP];
    [self.mainView addGestureRecognizer:swipeDown];
}

/// 手势键盘消失方法
- (void)dismissKeyboardWithGesture {
    for (int i = 0; i < self.mainView.tfViewArray.count; i++) {
        if (self.mainView.tfViewArray[i].isFirstResponder) {
            [self.mainView.tfViewArray[i] resignFirstResponder];
        }
    }
}

// MARK: SEL

/// 返回
- (void)clickBack {
    [self dismissViewControllerAnimated:NO completion:nil];
}

/// 点击按钮，具体实现由各子类决定
- (void)clickBtn {
    
}

/// 点击弹窗上的按钮，具体实现由各子类决定
- (void)dismissHUD {
    
}

/// 当网络错误或者有其他情况的时候，点击弹窗中的确认按钮，使弹窗消失
- (void)dismissNetworkHUD {
    [self.networkWrongHud hide:YES afterDelay:0.1];
}

#pragma mark - UITextFieldDelegate

/// 监测输入，用于判断是否应该使验证按钮可点击
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // 获取输入框里的实时数据
    NSMutableString *newtxt = [NSMutableString stringWithString:textField.text];
    [newtxt replaceCharactersInRange:range withString:string];
    
    // 当三个输入框都有数据时，按钮才可点击
    int noInputCount = 0;
    for (int i = 0; i < self.mainView.tfViewArray.count; i++) {
        // 循环遍历，同时要排除正在输入的输入框
        if (self.mainView.tfViewArray[i].text.length == 0 && (![textField isEqual:self.mainView.tfViewArray[i]])) {
            noInputCount++;
        }
    }
    // 只有当其他输入框都有数据，并且当前输入框的当前输入不为0时，按钮可点击
    if (!noInputCount && newtxt.length != 0) {
        [self.mainView.btn setBackgroundColor:UIColor.clearColor];
        [self.mainView.btn setBackgroundImage:[UIImage imageNamed:@"loginBtnImg"] forState:UIControlStateNormal];
        self.mainView.btn.enabled = YES;
    }else {
        [self.mainView.btn setBackgroundImage:nil forState:UIControlStateNormal];
        [self.mainView.btn setBackgroundColor:[UIColor colorWithHexString:@"#C5C5C5" alpha:1.0]];
        self.mainView.btn.enabled = NO;
    }
    return YES;
}

/// 键盘消失方式1. 键盘上的return键被点击后调用
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //键盘上的return键被点击后调用
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Getter

- (NSMutableArray *)textFieldInformationArray {
    if (_textFieldInformationArray == nil) {
        _textFieldInformationArray = [NSMutableArray array];
    }
    return _textFieldInformationArray;
}

- (LoginBaseView *)mainView {
    if (_mainView == nil) {
        if (self.isLoginView) {
            _mainView = [[LoginView alloc] initWithFrame:self.view.bounds];
        }else {
            _mainView = [[LoginBaseView alloc] initWithFrame:self.view.bounds];
        }
    }
    return _mainView;
}

- (UIView *)networkWrongView {
    if (_networkWrongView == nil) {
        _networkWrongView = [[UIView alloc] init];
        _networkWrongView.backgroundColor = UIColor.whiteColor;
        _networkWrongView.layer.cornerRadius = 8;
        CGRect viewFrame = _networkWrongView.frame;
        viewFrame.size = CGSizeMake(275, 177);
        _networkWrongView.frame = viewFrame;
        _networkWrongView.center = CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.5);
        
        // "错误"Lab
        UILabel *wrongTitleLab = [[UILabel alloc] init];
        wrongTitleLab.text = @"错误";
        wrongTitleLab.textColor = [UIColor colorWithHexString:@"#242424" alpha:1.0];
        wrongTitleLab.font = [UIFont fontWithName:PingFangSCSemiBold size:18];
        wrongTitleLab.textAlignment = NSTextAlignmentCenter;
        [_networkWrongView addSubview:wrongTitleLab];
        
        // “当前网络异常 请重试“
        UILabel *textLab = [[UILabel alloc] init];
        textLab.text = @"当前网络异常\n请重试";
        textLab.textColor = [UIColor colorWithHexString:@"#8B8B8B" alpha:1.0];
        textLab.font = [UIFont fontWithName:PingFangSCMedium size:16];
        textLab.textAlignment = NSTextAlignmentCenter;
        [_networkWrongView addSubview:textLab];
        
        // 一条横线
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.05];
        
        [_networkWrongView addSubview:lineView];
        
        // ”确定“按钮
        UIButton *sureBtn = [[UIButton alloc] init];
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        sureBtn.titleLabel.font = [UIFont fontWithName:PingFangSCSemiBold size:16];
        [sureBtn setTitleColor:[UIColor colorWithHexString:@"#625AF8" alpha:1.0] forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(dismissNetworkHUD) forControlEvents:UIControlEventTouchUpInside];
        [_networkWrongView addSubview:sureBtn];
        
        // 设置位置
        // wrongTitleLab
        [wrongTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_networkWrongView);
            make.top.equalTo(_networkWrongView).offset(22);
            make.size.mas_equalTo(CGSizeMake(36, 18));
        }];
        // textLab
        [textLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_networkWrongView);
            make.top.equalTo(_networkWrongView).offset(52);
            make.size.mas_equalTo(CGSizeMake(215, 44));
        }];
        // lineView
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(_networkWrongView);
            make.bottom.equalTo(_networkWrongView).offset(-56);
            make.height.mas_equalTo(1);
        }];
        // sureBtn
        [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_networkWrongView);
            make.bottom.equalTo(_networkWrongView).offset(-19);
            make.size.mas_equalTo(CGSizeMake(32, 18));
        }];
        
    }
    return _networkWrongView;
}

- (UIView *)tipView {
    if (_tipView == nil) {
        _tipView = [[UIView alloc] init];
        _tipView.backgroundColor = UIColor.whiteColor;
        _tipView.layer.cornerRadius = 8;
        
        // 标题
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.textColor = [UIColor colorWithHexString:@"#242424" alpha:1.0];
        titleLab.font = [UIFont fontWithName:PingFangSCSemiBold size:18];
        titleLab.textAlignment = NSTextAlignmentCenter;
        self.tipTitleLab = titleLab;
        [_tipView addSubview:self.tipTitleLab];
        
        // 三个弹窗的标题位置一样
        [self.tipTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_tipView);
            make.top.equalTo(_tipView).offset(22);
            make.size.mas_equalTo(CGSizeMake(36, 18));
        }];
        
        // 正文
        UILabel *textLab = [[UILabel alloc] init];
        textLab.textColor = [UIColor colorWithHexString:@"#8B8B8B" alpha:1.0];
        textLab.font = [UIFont fontWithName:PingFangSCMedium size:16];
        textLab.textAlignment = NSTextAlignmentCenter;
        self.tipTextLab = textLab;
        [_tipView addSubview:self.tipTextLab];
        
        // 一条横线
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.05];
        [_tipView addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(275);
            make.bottom.equalTo(_tipView).offset(-56);
            make.height.mas_equalTo(1);
        }];
        
        // 按钮
        UIButton *btn = [[UIButton alloc] init];
        [btn setTitle:@"确定" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:PingFangSCSemiBold size:16];
        [btn setTitleColor:[UIColor colorWithHexString:@"#625AF8" alpha:1.0] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(dismissHUD) forControlEvents:UIControlEventTouchUpInside];
        self.tipBtn = btn;
        [_tipView addSubview:self.tipBtn];
        
        // 按钮始终保持和弹窗底部的约束
        [self.tipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_tipView);
            make.bottom.equalTo(_tipView).offset(-19);
            make.size.mas_equalTo(CGSizeMake(42, 18));
        }];
    }
    return _tipView;
}

@end
