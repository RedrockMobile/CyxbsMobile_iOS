//
//  MineViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/10/21.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "MineViewController.h"
#import "LoginViewController.h"

@interface MineViewController ()

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *quitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    quitButton.frame = CGRectMake(10, 100, 100, 40);
    [quitButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [quitButton addTarget:self action:@selector(quit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:quitButton];
    
    UIButton *printButton = [UIButton buttonWithType:UIButtonTypeSystem];
    printButton.frame = CGRectMake(120, 100, 100, 40);
    [printButton setTitle:@"打印信息" forState:UIControlStateNormal];
    [printButton addTarget:self action:@selector(print) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:printButton];
}

- (void)quit {
    [UserItemTool logout];
    NSLog(@"%@", [UserItemTool defaultItem].realName);
}

- (void)print {
    NSLog(@"%@", [UserItemTool defaultItem].realName);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
