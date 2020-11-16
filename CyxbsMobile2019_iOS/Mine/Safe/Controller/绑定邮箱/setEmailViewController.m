//
//  setEmailViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/10/29.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "setEmailViewController.h"
#import "setEmail.h"
#import "sendCodeViewController.h"

@interface setEmailViewController ()<setEmailDelegate>
@property (nonatomic,strong) setEmail *setEmailView;
@property (nonatomic,assign) int count;
@end

@implementation setEmailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    setEmail *setEmailView = [[setEmail alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    setEmailView.delegate = self;
    setEmailView.placeholderLab.hidden = YES;
    [self.view addSubview:setEmailView];
    _setEmailView = setEmailView;
}


- (void)ClickedContactUS {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = @"570919844";
    
    UIAlertController *feedBackGroupAllert = [UIAlertController alertControllerWithTitle:@"欢迎加入反馈群" message:@"群号已复制到剪切板，快去QQ搜索吧～" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *certainAction = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:nil];
    
    [feedBackGroupAllert addAction:certainAction];
    
    [self presentViewController:feedBackGroupAllert animated:YES completion:nil];
}

- (void)ClickedNext {
    if (([_setEmailView.emailField.text rangeOfString:@"@"].location == NSNotFound || [_setEmailView.emailField.text rangeOfString:@".com"].location == NSNotFound) || _setEmailView.emailField.text.length == 0) {
        _setEmailView.placeholderLab.hidden = NO;
    } else {
        _setEmailView.placeholderLab.hidden = YES;
        sendCodeViewController *sendCodeVC = [[sendCodeViewController alloc] init];
        sendCodeVC.sendCodeToEmialLabel = _setEmailView.emailField.text;
        [self.navigationController pushViewController:sendCodeVC animated:YES];
    }
}

- (void)backButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
