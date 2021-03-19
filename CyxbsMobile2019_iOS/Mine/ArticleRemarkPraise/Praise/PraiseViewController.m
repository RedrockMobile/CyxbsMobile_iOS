//
//  PraiseViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/1/28.
//  Copyright © 2021 Redrock. All rights reserved.
//  点赞页面的控制器

#import "PraiseViewController.h"
#import "PraiseTableViewCell.h"
#import "PraiseModel.h"
#import "PraiseParseModel.h"

@interface PraiseViewController ()<UITableViewDelegate, UITableViewDataSource, MainPage2RequestModelDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)PraiseModel *praiseModel;
@property(nonatomic,strong)NothingStateView *nothingView;
@end

@implementation PraiseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.VCTitleStr = @"收到的赞";
    [self addPraiseModel];
    [self addTableView];
}

/// 数据加载模型
- (void)addPraiseModel {
    self.praiseModel = [[PraiseModel alloc] initWithUrl:getPraiseAPI];
    self.praiseModel.delegate = self;
    [self.praiseModel loadMoreData];
}

/// 添加tableView
- (void)addTableView{
    UITableView *tableView = [[UITableView alloc] init];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = self.view.backgroundColor;
    [tableView setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
    tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self.praiseModel refreshingAction:@selector(loadMoreData)];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBarView.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
}

/// 数据加载模型的代理方法，数据加载完成后调用
/// @param state 加载状态
- (void)MainPage2RequestModelLoadDataFinishWithState:(MainPage2RequestModelState)state{
    //刷新UI的操作放主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (state) {
                //加载成功，而且还有数据
            case MainPage2RequestModelStateEndRefresh:
                [self.tableView.mj_footer endRefreshing];
                break;
                //加载成功，而且没有数据了
            case MainPage2RequestModelStateNoMoreDate:
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                break;
                //加载失败
            case MainPage2RequestModelStateFailure:
                [self.tableView.mj_footer endRefreshing];
                [NewQAHud showHudWith:@"加载失败" AddView:self.view];
                break;
                //部分数据加载失败
            case MainPage2RequestModelStateFailureAndSuccess:
                [self.tableView.mj_footer endRefreshing];
                [NewQAHud showHudWith:@"部分数据加载失败" AddView:self.view];
                break;
        }
        
        [self.tableView reloadData];
        if (self.praiseModel.dataArr.count==0) {
            self.nothingView.alpha = 1;
        }else {
            self.nothingView.alpha = 0;
        }
    });
}

//MARK: - TableView代理方法:
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.praiseModel.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 0.3 * SCREEN_WIDTH;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PraiseTableViewCell *cell = [[PraiseTableViewCell alloc] initWithReuseIdentifier:@"PraiseTableViewCellID"];
    [cell setModel:[[PraiseParseModel alloc]initWithDict:self.praiseModel.dataArr[indexPath.row]]];
    return cell;
}

//MARK: - 懒加载
- (NothingStateView *)nothingView {
    if (_nothingView==nil) {
        _nothingView = [[NothingStateView alloc] initWithTitleStr:@"暂时还没收到赞噢～"];
        [self.view addSubview:_nothingView];
    }
    return _nothingView;
}
@end
