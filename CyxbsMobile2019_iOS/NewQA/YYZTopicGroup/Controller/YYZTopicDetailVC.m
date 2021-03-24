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
@property(nonatomic,strong) NSString *topicIdString; //当前圈子名
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong ) NSArray *array;  //所有圈子信息
@property(nonatomic,strong) YYZTopicCell *cell; //顶部cell
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
    //网络请求
    [[HttpClient defaultClient]requestWithPath:@"https://cyxbsmobile.redrock.team/wxapi/magipoke-loop/ground/getTopicGround" method:HttpRequestPost parameters:nil prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
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
}

- (void)setCell {
    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"YYZTopicCell" owner:self options:nil]; //xib文件
    YYZTopicCell *cell = [nib objectAtIndex:0];
    self.cell = cell;
    NSLog(@"-------------11---------%@",self.array);
    for(int i=0;i<self.array.count;i++){
        NSDictionary *dic = self.array[i];
        if([dic[@"topic_name"]isEqualToString:self.topicIdString]){
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
    [self.view addSubview:cell];
}



@end
