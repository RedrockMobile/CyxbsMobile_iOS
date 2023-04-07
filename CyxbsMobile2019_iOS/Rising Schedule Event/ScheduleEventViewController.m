//
//  ScheduleEventViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/4/3.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "ScheduleEventViewController.h"

@interface ScheduleEventViewController () <
    UITableViewDelegate,
    UITableViewDataSource
>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ScheduleEventViewController

- (void)loadView {
    [super loadView];
    
    self.navigationItem.title = @"Reminder";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(_cancel)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor =
    [UIColor Light:UIColorHex(#FFFFFF)
              Dark:UIColorHex(#1D1D1D)];
}

#pragma mark - Lazy

- (UITableView *)tableView {
    if (_tableView == nil) {
        
    }
    return _tableView;
}

#pragma mark - Private

- (void)_cancel {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
