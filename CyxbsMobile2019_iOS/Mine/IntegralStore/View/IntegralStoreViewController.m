//
//  IntegralStoreViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/1/16.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "IntegralStoreViewController.h"

@interface IntegralStoreViewController ()

@end

@implementation IntegralStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:242/255.0 blue:247/255.0 alpha:1];

    IntegralStoreContentView *contentView = [[IntegralStoreContentView alloc] init];
    [self.view addSubview:contentView];
    self.contentView = contentView;
    
    
    // 临时返回
    UIButton *back = [UIButton buttonWithType:UIButtonTypeSystem];
    back.frame = CGRectMake(200, 200, 100, 30);
    [back setTitle:@"back" forState:UIControlStateNormal];
    [self.contentView addSubview:back];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
