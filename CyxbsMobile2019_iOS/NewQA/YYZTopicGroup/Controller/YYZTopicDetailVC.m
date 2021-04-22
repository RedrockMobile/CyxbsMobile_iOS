//
//  YYZTopicDetailVC.m
//  CyxbsMobile2019_iOS
//
//  Created by 杨远舟 on 2021/3/16.
//  Copyright © 2021 Redrock. All rights reserved.
//
#import "YYZTopicDetailVC.h"
#import "YYZTopicGroupVC.h"
#import "YYZTopicCell.h"
#import "PostTableViewCell.h"
#import "PostArchiveTool.h"
#import "DynamicDetailMainVC.h"
#import "ClassTabBar.h"
#import "StarPostModel.h"
#import "YYZTopicModel.h"
#import "PostItem.h"
#import "MGDRefreshTool.h"

@interface YYZTopicDetailVC ()<UITableViewDelegate,UITableViewDataSource,PostTableViewCellDelegate,UITableViewDelegate,ReportViewDelegate,FuncViewProtocol,ShareViewDelegate,UIScrollViewDelegate>
@property(nonatomic,strong ) NSArray *array;  //所有圈子信息https://www.zhihu.com/people/yang-yuan-zhou/following/questions
@property(nonatomic,strong) YYZTopicCell *cell; //顶部cell
@property(nonatomic,strong) UIScrollView *backgroundScrollView;
@property(nonatomic,strong) UIScrollView *topicScrollView;
@property(nonatomic,strong) UITableView *topicLeftTableView;
@property(nonatomic,strong) UITableView *topicRightTableView;

@property(nonatomic,strong) UIButton *leftButton;
@property(nonatomic,strong) UIButton *rightButton;
//帖子数据
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *tableArray;
@property (nonatomic, strong) YYZTopicModel *postmodel;
//获取cell里item数据的NSDictionary
@property (nonatomic, strong) NSDictionary *itemDic;
//列表顶部底部刷新控件
@property (nonatomic, strong) MJRefreshBackNormalFooter *footer;
@property (nonatomic, strong) MJRefreshNormalHeader *header;

@end

@implementation YYZTopicDetailVC

#pragma mark  获取当前圈子ID

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.page = 1;//初始化当前页数
    //网络请求
    [[HttpClient defaultClient]requestWithPath:@"https://be-prod.redrock.team/magipoke-loop/ground/getTopicGround" method:HttpRequestPost parameters:nil prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *array = responseObject[@"data"];
        self.array = array;
        [self setCell];//设置cell;
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [NewQAHud showHudWith:@"圈子详情页请求失败" AddView:self.view];
        }];
    //设置导航栏
    self.tabBarController.tabBar.hidden = YES;//隐藏tabbar
    self.navigationController.navigationBar.hidden = NO;//显示nav_bar
    self.navigationItem.title = @"";
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorNamed:@"YYZColor2"],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:21], NSFontAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    self.navigationController.navigationBar.barTintColor = [UIColor colorNamed:@"YYZColor1"];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorNamed:@"YYZColor1"];
    self.navigationController.navigationBar.topItem.title = self.topicIdString;//设置返回按钮文字
    self.navigationController.navigationBar.tintColor = [UIColor colorNamed:@"YYZColor3"];//设置颜色
    self.navigationItem.leftBarButtonItem.width = -1000;
}
- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;//隐藏tabbar
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNotification];
    
    self.view.backgroundColor = [UIColor colorNamed:@"YYZColor1"];
    //self.tableArray = [NSMutableArray arrayWithArray:[PostArchiveTool getPostList]];
    self.tableArray = [[NSMutableArray alloc]init];
    YYZTopicModel *postmodel = [[YYZTopicModel alloc]init];
    self.postmodel = postmodel;
    [self setScroll];
    [self setMiddleLable];
    [self setBackTableView];
    [self loadData];
   
    NSLog(@"------3333333---------%@",self.postmodel.postArray);
   // [self setFrame];
}
- (void)setNotification{
    ///帖子列表请求成功
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(TopicLoadSuccess)
                                                 name:@"TopicDataLoadSuccess" object:nil];
    ///帖子列表请求失败
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(TopicLoadError)
                                                 name:@"TopicDataLoadFailure" object:nil];
    
}
- (void) setScroll {
    UIScrollView *backgroundScrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    self.backgroundScrollView = backgroundScrollView;
    backgroundScrollView.backgroundColor = [UIColor colorNamed:@"YYZColor1"];
    backgroundScrollView.contentSize = CGSizeMake(0,0);//先设置禁止滑动，以后适配动画效果
    [self.view addSubview:backgroundScrollView];
    
    UIScrollView *topicScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 185, SCREEN_WIDTH, SCREEN_HEIGHT-185)];
    self.topicScrollView = topicScrollView;
    topicScrollView.backgroundColor = [UIColor whiteColor];
    topicScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, SCREEN_HEIGHT-185);
    topicScrollView.pagingEnabled = YES;
    [self.backgroundScrollView addSubview:topicScrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //NSLog(@"11111111111");
    if([scrollView isEqual:self.topicScrollView]){
       // NSLog(@"222222222222");
        // 得到每页宽度
        CGFloat pageWidth = scrollView.frame.size.width;
        // 根据当前的x坐标和页宽度计算出当前页数
        int currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        NSLog(@"%d",currentPage);
        if(currentPage == 1){
            self.leftButton.highlighted = YES;
            self.rightButton.highlighted = NO;
        }
        else{
            self.leftButton.highlighted = NO;
            self.rightButton.highlighted = YES;
        }
    }
}
#pragma mark- 帖子列表的网络请求
- (void)loadData{
    NSLog(@"此时的page:%ld",(long)self.page);
    self.page += 1;
    [self.postmodel loadTopicWithLoop:self.topicID AndPage:self.page AndSize:6 AndType:@"hot"];
}
///上拉刷新
- (void)refreshData{
    [self.tableArray removeAllObjects];
    self.page = 1;
    NSLog(@"此时的page:%ld",(long)self.page);
    [self.postmodel loadTopicWithLoop:self.topicID AndPage:self.page AndSize:6 AndType:@"hot"];
}

///成功请求数据
- (void)TopicLoadSuccess {
    
    if (self.page == 1) {
        self.tableArray = self.postmodel.postArray;
    }else {
        [self.tableArray addObjectsFromArray:self.postmodel.postArray];
    }
    
    //根据当前加载的问题页数判断是上拉刷新还是下拉刷新
    if (self.page == 1) {
        [self.topicLeftTableView reloadData];
        [self.topicLeftTableView.mj_header endRefreshing];
    }else{
        [self.topicLeftTableView reloadData];
        [self.topicLeftTableView.mj_footer endRefreshing];
    }
   // [self setBackTableView];
    NSLog(@"成功请求列表数据");
}

///请求失败
- (void)TopicLoadError {
    [self.topicLeftTableView.mj_header endRefreshing];
    [self.topicLeftTableView.mj_footer endRefreshing];
    [NewQAHud showHudWith:@"网络异常" AddView:self.view];
}

///设置列表加载菊花
- (void)setUpRefresh {
    //上滑加载的设置
    _footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.topicLeftTableView.mj_footer = _footer;
    
    //下拉刷新的设置
    _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    self.topicLeftTableView.mj_header = _header;
    
    [MGDRefreshTool setUPHeader:_header AndFooter:_footer];
}
- (void) setBackTableView{
    UITableView *topicLeftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-185) style:UITableViewStylePlain];
    self.topicLeftTableView = topicLeftTableView;
    topicLeftTableView.delegate = self;
    topicLeftTableView.dataSource = self;
    [topicLeftTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    
    UITableView *topicRightTableView = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-185) style:UITableViewStylePlain];
    self.topicRightTableView = topicRightTableView;
    topicRightTableView.delegate = self;
    topicRightTableView.dataSource = self;
    [topicRightTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.topicScrollView addSubview:topicLeftTableView];
    [self.topicScrollView addSubview:topicRightTableView];
}

- (NSInteger)numberOfSectionsInTableView: (UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableArray.count;
}
#pragma mark 设置cell自适应高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;*/
    return UITableViewAutomaticDimension;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //创建单元格（用复用池）
    ///给每一个cell的identifier设置为唯一的
    NSString *identifier = [NSString stringWithFormat:@"post%ldcell",indexPath.row];
    PostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil) {
        _item = [[PostItem alloc] initWithDic:self.tableArray[indexPath.row]];
        //这里
        cell = [[PostTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.delegate = self;
        cell.item = _item;
        cell.commendBtn.tag = indexPath.row;
        cell.shareBtn.tag = indexPath.row;
        cell.starBtn.tag = indexPath.row;
        cell.tag = indexPath.row;
        if (cell.tag == 0) {
            cell.layer.cornerRadius = 10;
        }
    }
    [cell layoutSubviews];
    [cell layoutIfNeeded];
    return cell;
}
# pragma mark 初始化功能弹出页面
- (void)funcPopViewinit {
    // 创建分享页面
    _shareView = [[ShareView alloc] init];
    _shareView.delegate = self;
    
    // 创建功能页面
    _popView = [[FuncView alloc] init];
    _popView.delegate = self;
    
    // 创建举报页面
    _reportView = [[ReportView alloc]initWithPostID:[NSNumber numberWithInt:0]];
    _reportView.delegate = self;
    
}
///点击跳转到具体的帖子（与下方commentBtn的事件相同）
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DynamicDetailMainVC *dynamicDetailVC = [[DynamicDetailMainVC alloc]init];
    _item = [[PostItem alloc] initWithDic:self.tableArray[indexPath.row]];
    dynamicDetailVC.post_id = _item.post_id;
    dynamicDetailVC.hidesBottomBarWhenPushed = YES;
    ((ClassTabBar *)self.tabBarController.tabBar).hidden = NO;
    [self.navigationController pushViewController:dynamicDetailVC animated:YES];
}
#pragma mark- 配置相关弹出View和其蒙版的操作
///设置相关蒙版

- (void)setBackViewWithGesture {
    _backViewWithGesture = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _backViewWithGesture.backgroundColor = [UIColor blackColor];
    _backViewWithGesture.alpha = 0.36;
    UITapGestureRecognizer *dismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissBackViewWithGesture)];
    [self.backViewWithGesture addGestureRecognizer:dismiss];
}

- (void)dismissBackViewWithGestureAnd:(UIView *)view {
    [view removeFromSuperview];
    [_backViewWithGesture removeFromSuperview];
}

- (void)dismissBackViewWithGesture {
    [_popView removeFromSuperview];
    [_shareView removeFromSuperview];
    [_reportView removeFromSuperview];
    [_backViewWithGesture removeFromSuperview];
}
#pragma mark - Cell中的相关事件
- (void)showBackViewWithGesture {
    [self.view.window addSubview:_backViewWithGesture];
}

///点赞的逻辑：根据点赞按钮的tag来获取post_id，并传入后端
- (void)ClickedStarBtn:(PostTableViewCell *)cell{
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
    _itemDic = self.tableArray[cell.starBtn.tag];
    [model starPostWithPostID:[NSNumber numberWithString:_itemDic[@"post_id"]]];
}

///点击评论按钮跳转到具体的帖子详情:(可以通过帖子id跳转到具体的帖子页面，获取帖子id的方式如下方注释的代码)
- (void)ClickedCommentBtn:(PostTableViewCell *)cell{
    DynamicDetailMainVC *dynamicDetailVC = [[DynamicDetailMainVC alloc]init];
    _item = [[PostItem alloc] initWithDic:self.tableArray[cell.commendBtn.tag]];
    dynamicDetailVC.post_id = _item.post_id;
    dynamicDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:dynamicDetailVC animated:YES];
}

///分享帖子
- (void)ClickedShareBtn:(PostTableViewCell *)cell {
    [self showBackViewWithGesture];
    [self.view.window addSubview:_shareView];
    [_shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.window.mas_top).mas_offset(SCREEN_HEIGHT * 460/667);
        make.left.right.bottom.mas_equalTo(self.view.window);
    }];
    _itemDic = self.tableArray[cell.shareBtn.tag];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ClickedShareBtn" object:nil userInfo:nil];
    //此处还需要修改
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString *shareURL = [NSString stringWithFormat:@"redrock.zscy.youwen.share://token=%@&id=%@",[UserDefaultTool getToken],_itemDic[@"post_id"]];
    pasteboard.string = shareURL;
}

///点击标签跳转到相应的圈子
- (void)ClickedGroupTopicBtn:(PostTableViewCell *)cell {
    _itemDic = self.tableArray[cell.groupLabel.tag];
    NSString *groupName = _itemDic[@"topic"];
    YYZTopicDetailVC *detailVC = [[YYZTopicDetailVC alloc] initWithId:groupName];
    detailVC.hidesBottomBarWhenPushed = YES;
    ((ClassTabBar *)self.tabBarController.tabBar).hidden = NO;
    [self.navigationController pushViewController:detailVC animated:YES];
}

/**
 举报和屏蔽的多能按钮
 此处的逻辑：接收到cell里传来的多功能按钮的frame，在此frame上放置多功能View，同时加上蒙版
 */
- (void)ClickedFuncBtn:(PostTableViewCell *)cell{
    UIWindow* desWindow=self.view.window;
    CGRect frame = [cell.funcBtn convertRect:cell.funcBtn.bounds toView:desWindow];
    [self showBackViewWithGesture];

    _itemDic = self.tableArray[cell.tag];
    if ([_itemDic[@"is_follow_topic"] intValue] == 1) {
        NSLog(@"取消关注");
        [_popView.starGroupBtn setTitle:@"取消关注" forState:UIControlStateNormal];
    }else {
        NSLog(@"关注圈子");
        [_popView.starGroupBtn setTitle:@"关注圈子" forState:UIControlStateNormal];
    }
    _popView.layer.cornerRadius = 3;
    _popView.frame = CGRectMake(frame.origin.x - SCREEN_WIDTH * 0.27, frame.origin.y + 10, SCREEN_WIDTH * 0.3057, SCREEN_WIDTH * 0.3057 * 105/131.5);
    [self.view.window addSubview:_popView];
}


//设置顶部cell
- (void)setCell {
    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YYZTopicCell" owner:self options:nil]; //xib文件
    YYZTopicCell *cell = [nib objectAtIndex:0];
    self.cell = cell;
    for(int i=0;i<self.array.count;i++){
        NSDictionary *dic = self.array[i];
        if([dic[@"topic_name"]isEqualToString:self.topicIdString]){
            cell.topic_id.text = self.array[i][@"topic_name"];
            cell.topic_number.text = [NSString stringWithFormat:@"%@个成员",self.array[i][@"follow_count"]];
            cell.topic_introduce.text = self.array[i][@"introduction"];
            [cell.topic_logo sd_setImageWithURL:[NSURL URLWithString:self.array[i][@"topic_logo"]]];
            [cell.topic_isFollow setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:173/255.0 green:187/255.0 blue:213/255.0 alpha:1.0]] forState:UIControlStateDisabled];
            if([self.array[i][@"is_follow"] longValue] == 1){
                cell.topic_isFollow.clipsToBounds = YES;
                cell.topic_isFollow.layer.cornerRadius = 14;
                [cell.topic_isFollow setTitle:@"已关注" forState:UIControlStateNormal];
                cell.topic_isFollow.backgroundColor = RGBColor(171, 189, 215, 1);
            }
             cell.topic_isFollow.tag = self.array[i][@"topic_id"];
            [cell.topic_isFollow addTarget:self action:@selector(changeFollow:) forControlEvents:UIControlEventTouchUpInside];
            break;
        }
    }
     
    [self.backgroundScrollView addSubview:cell];
}

- (void) setMiddleLable {
    UILabel *middleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 130, SCREEN_WIDTH, 55)];
    middleLable.backgroundColor = [UIColor colorNamed:@"YYZColor5"];
    middleLable.layer.cornerRadius = 15;
    middleLable.clipsToBounds = YES;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftButton = leftButton;
    self.rightButton = rightButton;
    //leftButton.backgroundColor = [UIColor redColor];
    [leftButton setTitle:@"最新" forState:UIControlStateNormal];
    [rightButton setTitle:@"热门" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor colorNamed:@"YYZColor2"] forState:UIControlStateHighlighted];
    [rightButton setTitleColor:[UIColor colorNamed:@"YYZColor2"] forState:UIControlStateHighlighted];
    [leftButton setTitleColor:[UIColor colorNamed:@"YYZColor3"] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorNamed:@"YYZColor3"] forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(15, 133, 40, 45);
    rightButton.frame = CGRectMake(70, 133, 40, 45);
    leftButton.highlighted = YES;
    [self.backgroundScrollView addSubview:middleLable];
    [self.backgroundScrollView addSubview:leftButton];
    [self.backgroundScrollView addSubview:rightButton];

}

- (void) setFrame {
//    [self.cell mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view);
//        //make.right.equalTo(self.backgroundScrollView.right).offset(0);
//    }];
}
- (void)changeFollow:(UIButton *) btn {
    NSString *stringIsFollow = [NSString stringWithFormat:@"%@",btn.tag];
    [[HttpClient defaultClient]requestWithPath:@"https://be-prod.redrock.team/magipoke-loop/ground/followTopicGround" method:HttpRequestPost parameters:@{@"topic_id":stringIsFollow} prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                        //改变button状态
        if([btn.titleLabel.text isEqualToString:@"已关注"]){
            [NewQAHud showHudWith:@"取消关注圈子成功" AddView:self.view];
            btn.clipsToBounds = YES;
            btn.layer.cornerRadius = 14;
            [btn setTitle:@"+关注" forState:UIControlStateNormal];
            btn.backgroundColor = RGBColor(93, 94, 247, 1);
        }
        else{
            [NewQAHud showHudWith:@"关注圈子成功" AddView:self.view];
            btn.clipsToBounds = YES;
            btn.layer.cornerRadius = 14;
            [btn setTitle:@"已关注" forState:UIControlStateNormal];
            btn.backgroundColor = RGBColor(171, 189, 215, 1);
        }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [NewQAHud showHudWith:@"关注失败,请检查网络" AddView:self.view];
        }];
}
- (void)dealloc
{
    NSLog(@"bhbybyhbbb");
}
@end
