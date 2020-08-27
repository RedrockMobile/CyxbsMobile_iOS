//
//  MineAboutController.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/2/4.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "MineAboutController.h"
#import "MineAboutContentView.h"
#import "ProductWebsiteViewController.h"
#import "IntroductionController.h"

@interface MineAboutController () <MineAboutContentViewDelegate>

@end

@implementation MineAboutController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    if (@available(iOS 13.0, *)) {
//        self.view.backgroundColor = [UIColor systemBackgroundColor];
    } else {
        // Fallback on earlier versions
    }
    
    MineAboutContentView *contentView = [[MineAboutContentView alloc] init];
    contentView.delegate = self;
    [self.view addSubview:contentView];
}


#pragma mark - contentView代理
- (void)backButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectedIntroduction {
    IntroductionController *introductionVC = [[IntroductionController alloc] init];
    [self presentViewController:introductionVC animated:YES completion:nil];
}

- (void)selectedProductWebsite {
    ProductWebsiteViewController *vc = [[ProductWebsiteViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)selectedFeedBack {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = @"570919844";
    
    UIAlertController *feedBackGroupAllert = [UIAlertController alertControllerWithTitle:@"欢迎加入反馈群" message:@"群号已复制到剪切板，快去QQ搜索吧～" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *certainAction = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:nil];
    
    [feedBackGroupAllert addAction:certainAction];
    
    [self presentViewController:feedBackGroupAllert animated:YES completion:nil];
}

- (void)selectedUpdateCheck {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"已经是最新版本";
    [hud hide:YES afterDelay:0.7];
}


@end
