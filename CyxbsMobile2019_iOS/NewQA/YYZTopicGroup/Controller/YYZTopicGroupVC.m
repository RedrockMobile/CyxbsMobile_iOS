//
//  YYZTopicGroupVC.m
//  CyxbsMobile2019_iOS
//
//  Created by 杨远舟 on 2021/3/7.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "YYZTopicGroupVC.h"
#import "YYZTopicCell.h"
#import "NewQAHud.h"

@interface YYZTopicGroupVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong ) NSArray *array; //存储网络请求数据
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) YYZTopicCell *cell;
@end

@implementation YYZTopicGroupVC

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"%@", NSStringFromCGRect(self.tableView.frame));
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;//隐藏tabbar
    self.navigationController.navigationBar.hidden = NO;
    //设置nav
    self.navigationItem.title = @"圈子广场";
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorNamed:@"YYZColor2"],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:21], NSFontAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    self.navigationController.navigationBar.barTintColor = [UIColor colorNamed:@"YYZColor1"];
    self.navigationController.navigationBar.topItem.title = @"";//设置返回按钮只保留箭头
    self.navigationController.navigationBar.tintColor = [UIColor colorNamed:@"YYZColor3"];//设置颜色
    self.navigationItem.leftBarButtonItem.width = -1000;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HideBottomClassScheduleTabBarView" object:nil userInfo:nil];
    //网络请求
    [[HttpClient defaultClient]requestWithPath:@"https://be-prod.redrock.team/magipoke-loop/ground/getTopicGround" method:HttpRequestPost parameters:nil prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        NSArray *array = responseObject[@"data"];
        self.array = array;
        NSLog(@"圈子数据请求成功");
        [self.tableView reloadData];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [NewQAHud showHudWith:@"  请求失败,请检查网络  " AddView:self.view];
        }
     ];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;//退出时显示tabbar
    // 再你的popback的方法前加上这句话，通知NewQAMainPageViewController去刷新页面
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reSetTopFollowUI" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableView];
}

- (void)setTableView {
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableView = tableView;
    self.tableView.backgroundColor = [UIColor colorNamed:@"YYZColor1"];
    self.tableView.separatorColor = [UIColor colorNamed:@"YYZColor6"];
    self.tableView.separatorInset = UIEdgeInsetsMake(0,0,0,0);
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:tableView];
}
- (NSInteger)numberOfSectionsInTableView: (UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*YYZTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YYZTopicCell"];
    if(cell == nil){
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YYZTopicCell" owner:self options:nil];
                //xib文件
        cell = [nib objectAtIndex:0];
    }*/
    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YYZTopicCell" owner:self options:nil]; //xib文件
    YYZTopicCell *cell = [nib objectAtIndex:0];
    self.cell = cell;
    for(int i=0;i<self.array.count;i++){
        NSDictionary *dic = self.array[i];
        if([dic[@"topic_id"] longValue] == indexPath.row+1){
            cell.topic_id.text = self.array[i][@"topic_name"];
            cell.topic_number.text = [NSString stringWithFormat:@"%@个成员",self.array[i][@"follow_count"]];
            cell.topic_introduce.text = self.array[i][@"introduction"];
            [cell.topic_logo sd_setImageWithURL:[NSURL URLWithString:self.array[i][@"topic_logo"]]];
            [cell.topic_isFollow setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:173/255.0 green:187/255.0 blue:213/255.0 alpha:1.0]] forState:UIControlStateDisabled];
            //如果已经关注，更改关注按钮的状态
            if([self.array[i][@"is_follow"] longValue] == 1){
                cell.topic_isFollow.clipsToBounds = YES;
                cell.topic_isFollow.layer.cornerRadius = 14;
                [cell.topic_isFollow setTitle:@"已关注" forState:UIControlStateNormal];
                cell.topic_isFollow.backgroundColor = RGBColor(171, 189, 215, 1);
            }
            cell.topic_isFollow.tag = self.array[i][@"topic_id"];
            [cell.topic_isFollow addTarget:self action:@selector(changeFollow:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath* indexPath2 = [self.tableView indexPathForSelectedRow];
    YYZTopicCell *cell = [self.tableView cellForRowAtIndexPath:indexPath2];
    //获取当前圈子编号
    int topicID = 0;
    for(int i=0;i<self.array.count;i++){
        NSDictionary *dic = self.array[i];
        if([dic[@"topic_name"]isEqualToString:cell.topic_id.text])
            topicID = i+1;
    }
    YYZTopicDetailVC *detailView = [[YYZTopicDetailVC alloc]init];
    detailView.topicID = topicID;
    detailView.topicIdString = cell.topic_id.text;
    [self.navigationController pushViewController:detailView animated:YES];
}
#pragma mark 设置cell自适应高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (void)changeFollow:(UIButton *) btn {
    NSString *stringIsFollow = [NSString stringWithFormat:@"%@",btn.tag];
    [[HttpClient defaultClient]requestWithPath:@"https://be-prod.redrock.team/magipoke-loop/ground/followTopicGround" method:HttpRequestPost parameters:@{@"topic_id":stringIsFollow} prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            //改变button状态
        if([btn.titleLabel.text isEqualToString:@"已关注"]){
            [NewQAHud showHudWith:@"  取消关注圈子成功  " AddView:self.view AndToDo:^{
                NSDictionary *dic = @{@"topic_ID":stringIsFollow};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MGD-FollowGroup" object:nil userInfo:dic];
            }];
            btn.clipsToBounds = YES;
            btn.layer.cornerRadius = 14;
            [btn setTitle:@"+关注" forState:UIControlStateNormal];
            btn.backgroundColor = RGBColor(93, 94, 247, 1);
        }
        else{
            [NewQAHud showHudWith:@"  关注圈子成功  " AddView:self.view AndToDo:^{
                NSDictionary *dic = @{@"topic_ID":stringIsFollow};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MGD-FollowGroup" object:nil userInfo:dic];
            }];
            btn.clipsToBounds = YES;
            btn.layer.cornerRadius = 14;
            [btn setTitle:@"已关注" forState:UIControlStateNormal];
            btn.backgroundColor = RGBColor(171, 189, 215, 1);
        }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [NewQAHud showHudWith:@"  关注失败,请检查网络  " AddView:self.view];
        }];
}

@end
