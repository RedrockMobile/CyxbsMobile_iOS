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
@property (nonatomic, assign) BOOL isChanged;
@end

@implementation YYZTopicGroupVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _isChanged = NO;
//    self.tabBarController.tabBar.hidden = YES;//隐藏tabbar
    self.navigationController.navigationBar.hidden = NO;
    //设置nav
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#14305B" alpha:1] darkColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1]],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:21], NSFontAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    self.navigationController.navigationBar.barTintColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#F0F3F8" alpha:1] darkColor:[UIColor colorWithHexString:@"#000000" alpha:1]];

    // 自定义返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 30, 30);
    [backButton setTitle:@"" forState:UIControlStateNormal];
    [backButton setImage:[[UIImage imageNamed:@"返回的小箭头"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];

    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HideBottomClassScheduleTabBarView" object:nil userInfo:nil];
    
    // 网络请求
    [HttpTool.shareTool
     request:NewQA_POST_QATopicGroup_API
     type:HttpToolRequestTypePost
     serializer:HttpToolRequestSerializerHTTP
     bodyParameters:nil
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        NSArray *array = object[@"data"];
        self.array = array;
        NSLog(@"圈子数据请求成功");
        [self.tableView reloadData];
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [NewQAHud showHudWith:@"  请求失败,请检查网络  " AddView:self.view];
    }];
    
//网络请求
//    [[HttpClient defaultClient]requestWithPath:NewQA_POST_QATopicGroup_API method:HttpRequestPost parameters:nil prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
//        NSArray *array = responseObject[@"data"];
//        self.array = array;
//        NSLog(@"圈子数据请求成功");
//        [self.tableView reloadData];
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//            [NewQAHud showHudWith:@"  请求失败,请检查网络  " AddView:self.view];
//        }
//     ];
//    
}
// 自定义返回方法
- (void)back {
    UIViewController *frontVC = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2];
    if ([frontVC isKindOfClass:[NewQAMainVC class]]) {
        NewQAMainVC * QAMainVC = (NewQAMainVC *)frontVC;
        QAMainVC.isNeedFresh = _isChanged;
        [self.navigationController popToViewController:QAMainVC animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;//退出时显示tabbar
    // 再你的popback的方法前加上这句话，通知NewQAMainPageViewController去刷新页面
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"圈子广场";
    [self setTableView];
}

- (void)setTableView {
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableView = tableView;
    self.tableView.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#F0F3F8" alpha:1] darkColor:[UIColor colorWithHexString:@"#000000" alpha:1]];
    self.tableView.separatorColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#ABBBD7" alpha:1] darkColor:[UIColor colorWithHexString:@"#838384" alpha:1]];
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
    return UITableViewAutomaticDimension;
}

- (void)changeFollow:(UIButton *) btn {
    NSString *stringIsFollow = [NSString stringWithFormat:@"%@",btn.tag];
    
    [HttpTool.shareTool
     request:NewQA_POST_followTopic_API
     type:HttpToolRequestTypePost
     serializer:HttpToolRequestSerializerHTTP
     bodyParameters:@{@"topic_id":stringIsFollow}
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        NSDictionary *dic = @{@"topic_ID":stringIsFollow};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MGD-FollowGroup" object:nil userInfo:dic];
            //改变button状态
        if ([btn.titleLabel.text isEqualToString:@"已关注"]){
            [NewQAHud showHudWith:@" 取消关注圈子成功  " AddView:self.view];
            btn.clipsToBounds = YES;
            btn.layer.cornerRadius = 14;
            [btn setTitle:@"+关注" forState:UIControlStateNormal];
            btn.backgroundColor = RGBColor(93, 94, 247, 1);
        } else{
            [NewQAHud showHudWith:@" 关注圈子成功  " AddView:self.view];
            btn.clipsToBounds = YES;
            btn.layer.cornerRadius = 14;
            [btn setTitle:@"已关注" forState:UIControlStateNormal];
            btn.backgroundColor = RGBColor(171, 189, 215, 1);
        }
        self->_isChanged = YES;
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [NewQAHud showHudWith:@"  关注失败,请检查网络  " AddView:self.view];
    }];
    
//    [[HttpClient defaultClient]requestWithPath:NewQA_POST_followTopic_API method:HttpRequestPost parameters:@{@"topic_id":stringIsFollow} prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSDictionary *dic = @{@"topic_ID":stringIsFollow};
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"MGD-FollowGroup" object:nil userInfo:dic];
//            //改变button状态
//        if ([btn.titleLabel.text isEqualToString:@"已关注"]){
//            [NewQAHud showHudWith:@" 取消关注圈子成功  " AddView:self.view];
//            btn.clipsToBounds = YES;
//            btn.layer.cornerRadius = 14;
//            [btn setTitle:@"+关注" forState:UIControlStateNormal];
//            btn.backgroundColor = RGBColor(93, 94, 247, 1);
//        } else{
//            [NewQAHud showHudWith:@" 关注圈子成功  " AddView:self.view];
//            btn.clipsToBounds = YES;
//            btn.layer.cornerRadius = 14;
//            [btn setTitle:@"已关注" forState:UIControlStateNormal];
//            btn.backgroundColor = RGBColor(171, 189, 215, 1);
//        }
//        self->_isChanged = YES;
//    }
//     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [NewQAHud showHudWith:@"  关注失败,请检查网络  " AddView:self.view];
//    }];
}

@end
