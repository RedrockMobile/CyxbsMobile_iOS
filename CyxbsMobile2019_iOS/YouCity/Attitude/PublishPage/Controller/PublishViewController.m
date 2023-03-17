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

/// 输入框
@property (nonatomic, strong) PublishTextView *publishTextView;

@end

@implementation PublishViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F2F3F8"];
    [self.view addSubview:self.topView];
    
}



#pragma mark - Method


/// 点击title跳转提示框方法
- (void)clickTitle {
    
}


/// 点击cell跳转提示框方法
- (void)clickCell {
    
}


// MARK: SEL

- (void)didClickBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Delegate

// MARK: <UITextViewDelegate>

- (void)textViewDidChange:(UITextView *)textView {
    // 获取字数
    NSInteger stringsCount = textView.text.length;
    if (stringsCount > 30) {
        // TODO: 弹出提示框 您已达到最大输入限制
        
        return;
    }
    // 不断输入
    // 字数显示
    self.publishTextView.stringsLab.text = [NSString stringWithFormat:@"%ld/30", stringsCount];
    
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

- (PublishTextView *)publishTextView {
    if (_publishTextView == nil) {
        
    }
    return _publishTextView;
}

@end
