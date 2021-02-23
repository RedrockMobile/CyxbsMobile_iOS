//
//  RemarkViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/2/21.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "RemarkViewController.h"
#import "RemarkTableViewCell.h"

@interface RemarkViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;


@end

@implementation RemarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.VCTitleStr = @"评论回复";
    [self addTableView];
}


- (void)addTableView{
    UITableView *tableView = [[UITableView alloc] init];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = self.view.backgroundColor;
    [tableView setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
    
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 0.3 * SCREEN_WIDTH;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RemarkTableViewCell *cell = [[RemarkTableViewCell alloc] initWithReuseIdentifier:@"PraiseTableViewCellID"];
    [cell setModel:[[NSObject alloc]init]];
    return cell;
}
    




@end
