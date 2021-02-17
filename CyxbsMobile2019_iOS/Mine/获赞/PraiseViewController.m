//
//  PraiseViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/1/28.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "PraiseViewController.h"
#import "PraiseTableViewCell.h"
@interface PraiseViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation PraiseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.VCTitleStr = @"收到的赞";
    [self addTableView];
}


- (void)addTableView{
    UITableView *tableView = [[UITableView alloc] init];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = self.view.backgroundColor;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBarView.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
}


//MARK: - TableView代理方法:
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [[PraiseTableViewCell alloc] init];
}
@end
