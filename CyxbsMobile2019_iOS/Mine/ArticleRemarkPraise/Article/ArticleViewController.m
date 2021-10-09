//
//  ArticleViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/2/21.
//  Copyright © 2021 Redrock. All rights reserved.
//  动态页的控制器

#import "ArticleViewController.h"
#import "ArticleTableViewCell.h"
#import "ShareViewPlus.h"
#import "DeleteArticleTipView.h"
#import "ArticleModel.h"
#import "StarPostModel.h"

//动态详情页控制器
#import "DynamicDetailMainVC.h"
@interface ArticleViewController ()<
    UITableViewDelegate,
    UITableViewDataSource,
    PostTableViewCellDelegate,
    ShareViewPlusDelegate,
    ArticleModelDelegate
>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)ShareViewPlus *shareView;
@property(nonatomic,strong)ArticleModel *articleModel;
@property(nonatomic,strong)NothingStateView *nothingView;
@end

@implementation ArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.VCTitleStr = @"动态";
    self.articleModel = [[ArticleModel alloc] init];
    self.articleModel.delegate = self;
//    [self.articleModel loadMoreData];
    [self addTableView];
}


- (void)addTableView{
    UITableView *tableView = [[UITableView alloc] init];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = self.view.backgroundColor;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self.articleModel refreshingAction:@selector(loadMoreData)];
    [tableView.mj_footer setState:MJRefreshStateRefreshing];
    
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
    ArticleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArticleTableViewCellID"];
    if (cell==nil) {
        cell = [[ArticleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ArticleTableViewCellID"];
    }
    cell.delegate = self;
    PostItem *item = [[PostItem alloc] initWithDic:self.articleModel.dataArr[indexPath.row]];
    [cell setItem:item];
    return cell;
}

//MARK:-ArticleModel的代理方法：
- (void)mainPageModelLoadDataFinishWithState:(MainPageModelDataState)state {
    switch (state) {
        case MainPageModelStateNoMoreDate:
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            if (self.articleModel.dataArr.count==0) {
                [self.tableView.mj_footer setHidden:YES];
            }
            break;
        case MainPageModelStateEndRefresh:
            [self.tableView.mj_footer endRefreshing];
            break;
        case MainPageModelStateFailure:
            [self mainPageModelLoadDataFailue];
            break;
        default:
            break;
    }
    
    [self.tableView reloadData];
    if (self.articleModel.dataArr.count==0) {
        self.nothingView.alpha = 1;
    }else {
        self.nothingView.alpha = 0;
    }
}

- (void)mainPageModelLoadDataFailue {
    if (self.articleModel.dataArr.count==0) {
        self.nothingView.alpha = 1;
    }
    [self.tableView.mj_footer endRefreshing];
//    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView reloadData];
    [NewQAHud showHudWith:@"加载失败，上拉刷新试试～" AddView:self.view];
}

//MARK: - ArticleModel删除动态的代理回调：
- (void)deleteArticleSuccess {
    if (self.articleModel.dataArr.count==0) {
        self.nothingView.alpha = 1;
    }
    [self.tableView reloadData];
    [NewQAHud showHudWith:@"删除成功" AddView:self.view];
}

- (void)deleteArticleFailure {
    [NewQAHud showHudWith:@"网络错误" AddView:self.view];
}


//MARK: - cell的代理方法:
//评论
- (void)ClickedCommentBtn:(PostTableViewCell *)cell {
    DynamicDetailMainVC *dynamicDetailVC = [[DynamicDetailMainVC alloc]init];
    dynamicDetailVC.post_id = cell.item.post_id;
    dynamicDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:dynamicDetailVC animated:YES];
}

//话题标签
- (void)ClickedGroupTopicBtn:(PostTableViewCell *)cell {
    
}
//转发按钮
- (void)ClickedShareBtn:(PostTableViewCell *)cell {
//    [[UIApplication sharedApplication].keyWindow addSubview:self.shareView];
    [[[[UIApplication sharedApplication] windows] firstObject]addSubview:self.shareView];
}

//点击删除按钮后调用(父类是三个点点图标的按钮，子类重写为垃圾桶图标了)
- (void)ClickedFuncBtn:(PostTableViewCell *)cell {
    __weak typeof(self) weakSelf = self;
    DeleteArticleTipView *tipView = [[DeleteArticleTipView alloc] initWithDeleteBlock:^{
        [weakSelf.articleModel deleteArticleWithID:cell.item.post_id];
    }];
    [self.view addSubview:tipView];
}
//点赞
- (void)ClickedStarBtn:(PostTableViewCell *)cell {
    if (cell.starBtn.selected == YES) {
        cell.starBtn.selected = NO;
        cell.starBtn.iconView.image = [UIImage imageNamed:@"未点赞"];
        NSString *count = cell.starBtn.countLabel.text;
        cell.starBtn.countLabel.text = [NSString stringWithFormat:@"%d",[count intValue] - 1];
        if (@available(iOS 11.0, *)) {
            cell.starBtn.countLabel.textColor = [UIColor colorNamed:@"FuncBtnColor"];
        } else {
            // Fallback on earlier versions
        }
    }else {
        cell.starBtn.selected = YES;
        cell.starBtn.iconView.image = [UIImage imageNamed:@"点赞"];
        NSString *count = cell.starBtn.countLabel.text;
        cell.starBtn.countLabel.text = [NSString stringWithFormat:@"%d",[count intValue] + 1];
        if (@available(iOS 11.0, *)) {
            cell.starBtn.countLabel.textColor = [UIColor colorNamed:@"countLabelColor"];
            
        } else {
            // Fallback on earlier versions
        }
        
    }
    StarPostModel *model = [[StarPostModel alloc] init];
    [model starPostWithPostID:cell.item.post_id.numberValue];
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

- (NothingStateView *)nothingView {
    if (_nothingView==nil) {
        _nothingView = [[NothingStateView alloc] initWithTitleStr:@"暂时还没有发布过动态噢～"];
        [self.view addSubview:_nothingView];
    }
    return _nothingView;
}
@end
