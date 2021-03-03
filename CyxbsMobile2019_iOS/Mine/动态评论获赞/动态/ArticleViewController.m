//
//  ArticleViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/2/21.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "ArticleViewController.h"
#import "ArticleTableViewCell.h"
#import "ShareViewPlus.h"
#import "DeleteArticleTipView.h"
#import "ArticleModel.h"
#import "NewQAHud.h"
@interface ArticleViewController ()<UITableViewDelegate, UITableViewDataSource,PostTableViewCellDelegate,ShareViewPlusDelegate,MainPageModelDelegate,DeleteArticleTipViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)ShareViewPlus *shareView;
@property(nonatomic,strong)ArticleModel *articleModel;
@end

@implementation ArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.VCTitleStr = @"动态";
    self.articleModel = [[ArticleModel alloc] init];
    self.articleModel.delegate = self;
    [self.articleModel loadMoreData];
    [self addTableView];
}



- (void)addTableView{
    UITableView *tableView = [[UITableView alloc] init];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = self.view.backgroundColor;
    tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self.articleModel refreshingAction:@selector(loadMoreData)];
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
    return self.articleModel.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ArticleTableViewCell *cell = [[ArticleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    cell.delegate = self;
    PostItem *item = [[PostItem alloc] initWithDic:self.articleModel.dataArr[indexPath.row]];
    [cell setItem:item];
    return cell;
}

//MARK:-ArticleModel的代理方法：
- (void)mainPageModelLoadDataSuccessWithState:(MainPageModelDataState)state {
    if (state==StateNoMoreDate) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else {
        [self.tableView.mj_footer endRefreshing];
    }
    [self.tableView reloadData];
}

- (void)mainPageModelLoadDataFailue {
    [NewQAHud showHudWith:@"加载失败" AddView:self.view];
}

//MARK: - 处理cell的代理事件:
//评论
- (void)ClickedCommentBtn:(nonnull FunctionBtn *)sender { 
    
}
//右上角三个点点（这里子类重写了，变成删除按钮了）
- (void)ClickedFuncBtn:(nonnull UIButton *)sender {
    NSLog(@"sender:%ld",sender.tag);
    DeleteArticleTipView *tipView = [[DeleteArticleTipView alloc] init];
    tipView.delegate = self;
    [self.view addSubview:tipView];
}

//话题标签
- (void)ClickedGroupTopicBtn:(nonnull UIButton *)sender {
    
}
//转发按钮
- (void)ClickedShareBtn:(nonnull UIButton *)sender {
//    [[UIApplication sharedApplication].keyWindow addSubview:self.shareView];
    [[[[UIApplication sharedApplication] windows] firstObject]addSubview:self.shareView];
}


//点赞
- (void)ClickedStarBtn:(nonnull FunctionBtn *)sender {
    
}

//MARK:- 删除动态的弹窗的代理：
- (void)sureBtnClicked{
    
    NSLog(@"sureBtnClicked");
}


//MARK: - 以下是点击分享按钮后调用
- (void)ClickedQQZone{
    [self.shareView disMiss];
    
}
- (void)ClickedVXGroup{
    [self.shareView disMiss];
    
}
- (void)ClickedQQ{
    [self.shareView disMiss];
    
}
- (void)ClickedVXFriend{
    [self.shareView disMiss];
    
}
- (void)ClickedUrl{
    [self.shareView disMiss];
    
}

//懒加载：
- (ShareViewPlus *)shareView{
    if (_shareView==nil) {
        _shareView = [[ShareViewPlus alloc] init];
        _shareView.delegate = self;
    }
    return _shareView;
}
@end
