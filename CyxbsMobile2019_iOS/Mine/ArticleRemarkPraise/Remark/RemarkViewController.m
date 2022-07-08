//
//  RemarkViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/2/21.
//  Copyright © 2021 Redrock. All rights reserved.
//  评论回复页面的控制器

#import "RemarkViewController.h"
#import "RemarkTableViewCell.h"
#import "RemarkModel.h"
//是否开启CCLog
#define CCLogEnable 0

//GYY的动态详情页控制器
//#import "GYYDynamicDetailViewController.h"

@interface RemarkViewController ()<UITableViewDelegate, UITableViewDataSource, MainPage2RequestModelDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)RemarkModel *remarkModel;
@property(nonatomic,strong)NothingStateView *nothingView;
@property(nonatomic,strong)NSMutableDictionary <NSString*,RemarkParseModel*>* parseModelDict;
@end

@implementation RemarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.VCTitleStr = @"评论回复";
    self.parseModelDict = [[NSMutableDictionary alloc] init];
    //这里因为tableview的刷新是直接绑定remarkModel的加载数据方法，所以remarkModel得比tableview先加载
    [self addRemarkModel];
    [self addTableView];
}

/// 数据加载模型
- (void)addRemarkModel {
    self.remarkModel = [[RemarkModel alloc] initWithUrl:getReplyAPI];
    self.remarkModel.delegate = self;
//    [self.remarkModel loadMoreData];
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
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self.remarkModel refreshingAction:@selector(loadMoreData)];
    [tableView.mj_footer setState:MJRefreshStateRefreshing];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBarView.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
}

/// 数据加载模型的代理方法，数据加载完成后调用
/// @param state 加载状态
- (void)MainPage2RequestModelLoadDataFinishWithState:(MainPage2RequestModelState)state {
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
    }
    
    [self.tableView reloadData];
    if (self.remarkModel.dataArr.count==0) {
        self.nothingView.alpha = 1;
    }else {
        self.nothingView.alpha = 0;
    }
}

//MARK: - TableView代理方法:
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.remarkModel.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 0.4733* SCREEN_WIDTH;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RemarkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PraiseTableViewCellID"];
    if (cell==nil) {
        cell = [[RemarkTableViewCell alloc] initWithReuseIdentifier:@"PraiseTableViewCellID"];
    }
    
    RemarkParseModel *model = self.parseModelDict[[NSString stringWithFormat:@"%ld",indexPath.row]];
    if(model==nil) {
        model = [[RemarkParseModel alloc]initWithDict:self.remarkModel.dataArr[indexPath.row]];
        self.parseModelDict[[NSString stringWithFormat:@"%ld",indexPath.row]] = model;
        CCLog(@"1%ld,,%@",indexPath.row,self.parseModelDict[[NSString stringWithFormat:@"%ld",indexPath.row]]);
    }else {
        CCLog(@"2%ld,,%@",indexPath.row,model);
    }
    [cell setModel:model];
    return cell;
}

//MARK: - 懒加载
- (NothingStateView *)nothingView {
    if (_nothingView==nil) {
        _nothingView = [[NothingStateView alloc] initWithTitleStr:@"暂时还没收到评论噢～"];
        [self.view addSubview:_nothingView];
    }
    return _nothingView;
}
@end
