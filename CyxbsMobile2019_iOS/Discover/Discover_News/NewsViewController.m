//
//  NewsViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2019/11/28.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "NewsViewController.h"

@interface NewsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTableView];
    // Do any additional setup after loading the view.
}
- (void)addTableView {
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
}





@end
