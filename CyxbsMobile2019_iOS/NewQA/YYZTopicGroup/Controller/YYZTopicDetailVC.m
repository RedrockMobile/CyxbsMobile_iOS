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

@interface YYZTopicDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) NSString *topicIdString;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong ) NSArray *array;
@property(nonatomic,strong) YYZTopicCell *cell;
@end

@implementation YYZTopicDetailVC
- (instancetype)initWithId:(NSString *) topicID{
    self.topicIdString = topicID;
    NSLog(@"%@",self.topicIdString);
    return self;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;//隐藏tabbar
    self.navigationItem.title = @"";
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorNamed:@"YYZColor2"],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:21], NSFontAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    self.navigationController.navigationBar.barTintColor = [UIColor colorNamed:@"YYZColor1"];
    self.navigationController.navigationBar.topItem.title = @"";//设置返回按钮只保留箭头
    self.navigationController.navigationBar.tintColor = [UIColor colorNamed:@"YYZColor3"];//设置颜色
    self.navigationItem.leftBarButtonItem.width = -1000;

    //网络请求
    [[HttpClient defaultClient]requestWithPath:@"https://cyxbsmobile.redrock.team/wxapi/magipoke-loop/ground/getTopicGround" method:HttpRequestPost parameters:nil prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        NSArray *array = responseObject[@"data"];
        self.array = array;
        NSLog(@"圈子数据请求成功");
        NSLog(@"%@",array);
        [self.tableView reloadData];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"-------------error");
        }];
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorNamed:@"YYZColor1"];
    NSLog(@"%@",self.topicIdString);
    [self setTableView];
    
}


- (void)setTableView {
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 130) style:UITableViewStylePlain];
    self.tableView = tableView;
    self.tableView.backgroundColor = [UIColor colorNamed:@"YYZColor1"];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:tableView];
}
- (NSInteger)numberOfSectionsInTableView: (UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*YYZTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YYZTopicCell"];
    if(cell == nil){
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YYZTopicCell" owner:self options:nil];
                //xib文件
        cell = [nib objectAtIndex:0];
    }*/
    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YYZTopicCell" owner:self options:nil];
            //xib文件
    YYZTopicCell *cell = [nib objectAtIndex:0];
    self.cell = cell;
    for(int i=0;i<self.array.count;i++){
        NSDictionary *dic = self.array[i];
        
        if(dic[@"topic_name"]  == self.topicIdString){
            cell.topic_id.text = self.array[i][@"topic_name"];
            cell.topic_number.text = [NSString stringWithFormat:@"%@个成员",self.array[i][@"follow_count"]];
            cell.topic_introduce.text = self.array[i][@"introduction"];
            [cell.topic_logo sd_setImageWithURL:[NSURL URLWithString:self.array[i][@"topic_logo"]]];
            [cell.topic_isFollow setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:173/255.0 green:187/255.0 blue:213/255.0 alpha:1.0]] forState:UIControlStateDisabled];
            if([self.array[i][@"is_follow"] longValue] == 1){
                cell.topic_isFollow.enabled = NO;
                cell.topic_isFollow.clipsToBounds = YES;
                cell.topic_isFollow.layer.cornerRadius = 14;

            }
            cell.topic_isFollow.tag = self.array[i][@"topic_id"];
            [cell.topic_isFollow addTarget:self action:@selector(changeFollow:) forControlEvents:UIControlEventTouchUpInside];
            break;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}



@end
