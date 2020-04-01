//
//  QAListViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 王一成 on 2020/1/20.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "QAListViewController.h"
#import "QAListTableViewCell.h"
#import "QADetailViewController.h"
#import "QAListModel.h"

@interface QAListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)UITableView *tableView;
@property(strong,nonatomic)NSMutableArray *dataArray;
@property(strong,nonatomic)QAListModel *model;
@property(assign,nonatomic)NSInteger page;
@property(assign,nonatomic)NSInteger newRowCount;
@end

@implementation QAListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}
- (instancetype)initViewStyle:(NSString *)style{
    self = [super init];
    self.title = style;
    [self setNotification];
    self.dataArray = [NSMutableArray array];
    self.page = 0;
    self.newRowCount = 0;

    self.view.backgroundColor = [UIColor whiteColor];

    self.model = [[QAListModel alloc]init];
    [self loadData];
    return self;
}
- (void)setNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(QAListDataLoadSuccess)
                                                 name:[NSString stringWithFormat:@"QAList%@DataLoadSuccess",self.title] object:nil];
  
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(QAListMoreDataLoadError)
                                                 name:[NSString stringWithFormat:@"QAList%@MoreDataLoadError",self.title]object:nil];
    
  

}
- (void)loadData{
    self.page += 1;
    [self.model loadData:self.title page:self.page];
}
- (void)reloadData{
    self.page = 1;
    [self.model loadData:self.title page:self.page];
}
- (void)setupTableView{
    self.tableView = [[UITableView alloc]init];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.bottom.left.right.equalTo(self.view);
    }];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"QAListTableViewCell" bundle:nil] forCellReuseIdentifier:@"QAListTableViewCell"];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadData)];
}
- (void)setupNoDataView{
    UIImageView *imgView = [[UIImageView alloc]init];
    [imgView setImage:[UIImage imageNamed:@"QANoDataImg"]];
    [self.view addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-100);
        make.height.equalTo(@127);
        make.width.equalTo(@167);
    }];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"邮问 问你想问~";
    label.font = [UIFont fontWithName:PingFangSCRegular size:12];
    label.textColor = [UIColor colorWithHexString:@"#15315B"];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(imgView.mas_bottom).mas_offset(20);
        
    }];
    
}
- (void)QAListDataLoadSuccess{
    //根据title获取对应数据
    self.dataArray = [self.model.dataDictionary valueForKey:self.title];
    self.newRowCount = self.dataArray.count - self.newRowCount;
    //判断是否有数据
    if (self.dataArray.count == 0) {
        [self setupNoDataView];
    }else{
        if(!self.tableView){
        [self setupTableView];
        }
        //根据当前加载的问题页数判断是上拉刷新还是下拉刷新
        if (self.page == 1) {
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }else{
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        }
    }
    
}
- (void)QAListMoreDataLoadError{
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 145;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // always reuse the cell
    QAListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QAListTableViewCell" forIndexPath:indexPath];
    NSDictionary *dic = _dataArray[indexPath.row];
    [cell.name setText:[dic objectForKey:@"nickname"]];
    NSString *date = [dic objectForKey:@"created_at"];
    [cell.date setText:[date substringWithRange:NSMakeRange(0, 10)]];
    [cell.content setText:[dic objectForKey:@"title"]];
    [cell.answerNum setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"answer_num"]]];
    [cell.integralNum setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"reward"]]];
    [cell.viewNum setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"views_num"]]];
    NSString *userIconUrl = [dic objectForKey:@"photo_thumbnail_src"];
    [cell.userIcon setImageWithURL:[NSURL URLWithString:userIconUrl] placeholder:[UIImage imageNamed:@"userIcon"]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = _dataArray[indexPath.row];
    NSNumber *question_id = [dic objectForKey:@"id"];
    NSString *title = [dic objectForKey:@"title"];
    QADetailViewController *detailVC = [[QADetailViewController alloc] initViewWithId:question_id title:title];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.superController.navigationController pushViewController:detailVC animated:YES];
}

@end
