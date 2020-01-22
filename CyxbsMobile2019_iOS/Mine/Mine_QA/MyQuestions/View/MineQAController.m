//
//  MineQAController.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/1/22.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "MineQAController.h"
#import "MineSegmentedView.h"
#import "MineQATableViewController.h"

@interface MineQAController ()

@end

@implementation MineQAController

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.alpha = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    
    self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:252/255.0 alpha:1];
    
    MineQATableViewController *vc1 = [[MineQATableViewController alloc] init];
    vc1.tableView.backgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:252/255.0 alpha:1];
    vc1.title = @"已发布";
    
    MineQATableViewController *vc2 = [[MineQATableViewController alloc] init];
    vc2.tableView.backgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:252/255.0 alpha:1];
    vc2.title = @"草稿箱";
    NSArray *arr = @[vc1, vc2];
    
    
    
    MineSegmentedView *segmentedView = [[MineSegmentedView alloc] initWithChildViewControllers:arr];
    segmentedView.frame = self.view.bounds;
    [self.view addSubview:segmentedView];
    
    UIView *navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_W, TOTAL_TOP_HEIGHT)];
    navigationBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navigationBar];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((MAIN_SCREEN_W - 85) / 2.0, 7 + STATUSBARHEIGHT, 85, 30)];
    titleLabel.text = self.title;
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 21];
    titleLabel.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0];
    [navigationBar addSubview:titleLabel];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    backButton.frame = CGRectMake(17, 12.5 + STATUSBARHEIGHT, 9, 19);
    backButton.backgroundColor = [UIColor blueColor];
    [navigationBar addSubview:backButton];
}

@end
