//
//  PublishViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 艾 on 2023/3/8.
//  Copyright © 2023 Redrock. All rights reserved.
//

// VC
#import "PublishViewController.h"
// View
#import "PublishTopView.h"
#import "PublishTextView.h"

@interface PublishViewController () <
    UITextViewDelegate
>

@property (nonatomic, strong) PublishTopView *topView;

/// title输入框
@property (nonatomic, strong) PublishTextView *publishTitleTextView;

/// 选项Option输入框
@property (nonatomic, strong) PublishTextView *publishOptionTextView;

/// 背景蒙版
@property (nonatomic, strong) UIView *backView;

@end

@implementation PublishViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F2F3F8"];
    [self.view addSubview:self.topView];
    
}



#pragma mark - Method

/// TODO: 点击title跳转提示框方法
- (void)clickTitle {
    UIWindow *window = self.view.window;
    // 加入背景蒙版
    [self.view.window addSubview:self.backView];
    // 加入输入框
    [self.view.window addSubview:self.publishTitleTextView];
}

/// TODO: 点击cell跳转提示框方法
- (void)clickCell {
    UIWindow *window = self.view.window;
    // 加入背景蒙版
    [self.view.window addSubview:self.backView];
    // 加入输入框
    [self.view.window addSubview:self.publishOptionTextView];
}

/// 给按钮加SEL
- (void)addTargetToBtn {
    // 1.取消按钮都是一样的
    [self.publishTitleTextView.cancelBtn addTarget:self action:@selector(cancelInput) forControlEvents:UIControlEventTouchUpInside];
    [self.publishOptionTextView.cancelBtn addTarget:self action:@selector(cancelInput) forControlEvents:UIControlEventTouchUpInside];
    // 2.publishTitleTextView 的确认，textView 里面的内容被放到title 中
    [self.publishTitleTextView.sureBtn addTarget:self action:@selector(sureTitle) forControlEvents:UIControlEventTouchUpInside];
    // 3.publishOptionTextView 的确认，textView 里面的内容被放到option 中
    [self.publishOptionTextView.sureBtn addTarget:self action:@selector(sureOption) forControlEvents:UIControlEventTouchUpInside];
}

// MARK: SEL

- (void)didClickBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

/// 取消输入
- (void)cancelInput {
    if (self.publishTitleTextView == nil) {
        [self.publishTitleTextView removeFromSuperview];
    } else if (self.publishOptionTextView == nil) {
        [self.publishOptionTextView removeFromSuperview];
    }
    // 取消蒙版
    [self.backView removeFromSuperview];
}

/// 确认标题
- (void)sureTitle {
    NSString *titleStr = self.publishTitleTextView.publishTextView.text;
    NSLog(@"🥑%@", titleStr);
    // TODO: 传输文字
    
    // 取消蒙版
    [self.backView removeFromSuperview];
}

/// 确认选项
- (void)sureOption {
    NSString *optionStr = self.publishOptionTextView.publishTextView.text;
    NSLog(@"🌮%@", optionStr);
    // TODO: 传输文字
    
    // 取消蒙版
    [self.backView removeFromSuperview];
}

#pragma mark - Delegate

// MARK: <UITextViewDelegate>

// 监听文本框输入内容
- (void)textViewDidChange:(UITextView *)textView {
    // 获取字数
    NSInteger stringsCount = textView.text.length;
    
    if ([textView isEqual:self.publishTitleTextView]) {
        // 输入为0
        if (stringsCount == 0) {
            self.publishTitleTextView.sureBtn.enabled = NO;
            self.publishTitleTextView.sureBtn.backgroundColor = [UIColor colorWithHexString:@"#C3D4EE" alpha:1.0];
        } else {
            // 不断改变现在的字数
            self.publishTitleTextView.stringsLab.text = [NSString stringWithFormat:@"%ld/30", stringsCount];
        }
    } else if ([textView isEqual:self.publishOptionTextView]) {
        if (stringsCount == 0) {
            self.publishOptionTextView.sureBtn.enabled = NO;
            self.publishOptionTextView.sureBtn.backgroundColor = [UIColor colorWithHexString:@"#C3D4EE" alpha:1.0];
        } else {
            self.publishOptionTextView.stringsLab.text = [NSString stringWithFormat:@"%ld/15", stringsCount];
        }
    }
}

/// 超过字数不再输入
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (([textView isEqual:self.publishTitleTextView] && range.location >= 30) || ([textView isEqual:self.publishOptionTextView] && range.location >= 15)) {
        // TODO: 弹出提示框 您已达到最大输入限制
        
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - Geter

- (PublishTopView *)topView {
    if (!_topView) {
        CGFloat h = getStatusBarHeight_Double + 44;
        _topView = [[PublishTopView alloc] initWithTopView];
        _topView.frame = CGRectMake(0, 0, kScreenWidth, h);
        [_topView.backBtn addTarget:self action:@selector(didClickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topView;
}

- (PublishTextView *)publishTitleTextView {
    if (_publishTitleTextView == nil) {
        _publishTitleTextView = [[PublishTextView alloc] initWithFrame:CGRectMake(15, STATUSBARHEIGHT + 190, SCREEN_WIDTH - 30, 250)];
        _publishTitleTextView.publishTextView.text = @"0/30";
    }
    return _publishTitleTextView;
}

- (PublishTextView *)publishOptionTextView {
    if (_publishOptionTextView == nil) {
        _publishOptionTextView = [[PublishTextView alloc] initWithFrame:CGRectMake(15, STATUSBARHEIGHT + 190, SCREEN_WIDTH - 30, 210)];
        _publishOptionTextView.publishTextView.text = @"0/15";
    }
    return _publishOptionTextView;
}

- (UIView *)backView {
    if (_backView == nil) {
        _backView = [[UIView alloc] initWithFrame:self.view.bounds];
        _backView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.47];
    }
    return _backView;
}
@end
