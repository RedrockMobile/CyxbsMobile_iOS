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
#import "PostItem.h"

@interface YYZTopicDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) NSString *topicIdString; //当前圈子名
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong ) NSArray *array;  //所有圈子信息
@property(nonatomic,strong) YYZTopicCell *cell; //顶部cell
@property(nonatomic,strong) UIScrollView *backgroundScrollView;
@property(nonatomic,strong) UIScrollView *topicScrollView;
@property(nonatomic,strong) UITableView *topicLeftTableView;
@property(nonatomic,strong) UITableView *topicRightTableView;
//帖子数据
@property (nonatomic, strong) NSMutableArray *tableArray;
@property (nonatomic, strong) PostItem *item;
@property (nonatomic, strong) PostModel *postmodel;

@end

@implementation YYZTopicDetailVC

#pragma mark  获取当前圈子ID
- (instancetype)initWithId:(NSString *) topicID{
    self.topicIdString = topicID;
    NSLog(@"%@",self.topicIdString);
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[HttpClient defaultClient]requestWithPath:@"https://be-prod.redrock.team/magipoke-loop/ground/getTopicGround" method:HttpRequestPost parameters:nil prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        NSArray *array = responseObject[@"data"];
        self.array = array;
        NSLog(@"圈子数据请求成功");
        [self setCell];//设置cell
        NSLog(@"%@",array);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [NewQAHud showHudWith:@"圈子详情页请求失败" AddView:self.view];
        }];
    //设置导航栏
    self.tabBarController.tabBar.hidden = YES;//隐藏tabbar
    self.navigationController.navigationBar.hidden = NO;//显示nav_bar
    self.navigationItem.title = @"";
    self.navigationController.navigationBar.translucent=NO;//导航栏不透明
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorNamed:@"YYZColor2"],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:21], NSFontAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    self.navigationController.navigationBar.barTintColor = [UIColor colorNamed:@"YYZColor1"];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorNamed:@"YYZColor1"];
    self.navigationController.navigationBar.topItem.title = self.topicIdString;//设置返回按钮文字
    self.navigationController.navigationBar.tintColor = [UIColor colorNamed:@"YYZColor3"];//设置颜色
    self.navigationItem.leftBarButtonItem.width = -1000;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorNamed:@"YYZColor1"];
    
    self.tableArray = [NSMutableArray arrayWithArray:[PostArchiveTool getPostList]];
    self.postmodel = [[PostModel alloc] init];
    [self setScroll];
    [self setCell];
    [self setMiddleLable];
    [self setBackTableView];
    [self setFrame];
}

- (void) setScroll {
    UIScrollView *backgroundScrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    self.backgroundScrollView = backgroundScrollView;
    backgroundScrollView.backgroundColor = [UIColor colorNamed:@"YYZColor1"];
    backgroundScrollView.contentSize = CGSizeMake(0,0);//先设置禁止滑动，以后适配动画效果
    [self.view addSubview:backgroundScrollView];
    
    UIScrollView *topicScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 185, SCREEN_WIDTH, SCREEN_HEIGHT-185)];
    self.topicScrollView = topicScrollView;
    topicScrollView.backgroundColor         = [UIColor lightGrayColor];
    topicScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, SCREEN_HEIGHT-185);
    topicScrollView.pagingEnabled = YES;
    [self.backgroundScrollView addSubview:topicScrollView];
}
- (void) setBackTableView{
    UITableView *topicLeftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-185) style:UITableViewStylePlain];
    //topicLeftTableView.backgroundColor = [UIColor redColor];
    self.topicLeftTableView = topicLeftTableView;
    topicLeftTableView.delegate = self;
    topicLeftTableView.dataSource = self;
    
    UITableView *topicRightTableView = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-185) style:UITableViewStylePlain];
    //topicRightTableView.backgroundColor = [UIColor greenColor];
    self.topicRightTableView = topicRightTableView;
    topicRightTableView.delegate = self;
    topicRightTableView.dataSource = self;
    [self.topicScrollView addSubview:topicLeftTableView];
    [self.topicScrollView addSubview:topicRightTableView];
}

- (NSInteger)numberOfSectionsInTableView: (UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
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
    return cell;

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
    //leftButton.backgroundColor = [UIColor redColor];
    [leftButton setTitle:@"最新" forState:UIControlStateNormal];
    [rightButton setTitle:@"热门" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor colorNamed:@"YYZColor2"] forState:UIControlStateHighlighted];
    [rightButton setTitleColor:[UIColor colorNamed:@"YYZColor2"] forState:UIControlStateHighlighted];
    [leftButton setTitleColor:[UIColor colorNamed:@"YYZColor3"] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorNamed:@"YYZColor3"] forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(15, 133, 40, 45);
    rightButton.frame = CGRectMake(70, 133, 40, 45);
    [self.backgroundScrollView addSubview:middleLable];
    [self.backgroundScrollView addSubview:leftButton];
    [self.backgroundScrollView addSubview:rightButton];

}

- (void) setFrame {
    [self.cell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        //make.right.equalTo(self.backgroundScrollView.right).offset(0);
    }];
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

@end
