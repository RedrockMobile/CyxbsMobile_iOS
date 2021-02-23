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
@interface ArticleViewController ()<UITableViewDelegate, UITableViewDataSource,PostTableViewCellDelegate,ShareViewPlusDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)ShareViewPlus *shareView;

@end

@implementation ArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.VCTitleStr = @"动态";
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
    ArticleTableViewCell *cell = [[ArticleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    cell.delegate = self;
    PostItem *item = [[PostItem alloc] initWithDic:@{
        @"avatar" : @"",
        @"comment_count" : @0,
        @"content" : @"包含中文2",
        @"is_follow_topic" : @0,
        @"is_praised" : @0,
        @"is_self" : @0,
        @"nickname" : @"包含中文3",
        @"pics" : @[
        ],
        @"post_id" : @2817,
        @"praise_count" : @0,
        @"publish_time" : @1613877199,
        @"topic" : @"QA",
        @"uid" : @"28d8e2839cb84ded98b5ddc03218cd2dd21a8934",
        }];
    [cell setItem:item];
    return cell;
}



//评论
- (void)ClickedCommentBtn:(nonnull FunctionBtn *)sender { 
    
}
//右上角三个点点
- (void)ClickedFuncBtn:(nonnull UIButton *)sender { 
    DeleteArticleTipView *tipView = [[DeleteArticleTipView alloc] init];
    [self.view addSubview:tipView];
}
//话题标签
- (void)ClickedGroupTopicBtn:(nonnull UIButton *)sender {
    
}
//转发按钮
- (void)ClickedShareBtn:(nonnull UIButton *)sender {
    [[UIApplication sharedApplication].keyWindow addSubview:self.shareView];
}

- (ShareViewPlus *)shareView{
    if (_shareView==nil) {
        _shareView = [[ShareViewPlus alloc] init];
        _shareView.delegate = self;
    }
    return _shareView;
}
//点赞
- (void)ClickedStarBtn:(nonnull FunctionBtn *)sender {
    
}

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

@end
