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
    self.tableView = [[UITableView alloc]init];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.bottom.left.right.equalTo(self.view);
    }];
//    self.tableView.estimatedRowHeight = 145;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"QAListTableViewCell" bundle:nil] forCellReuseIdentifier:@"QAListTableViewCell"];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadData)];
    self.model = [[QAListModel alloc]init];
    [self loadData];
    return self;
}
-(void)setNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(QAListDataLoadSuccess)
                                                 name:[NSString stringWithFormat:@"QAList%@DataLoadSuccess",self.title] object:nil];
  
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(QAListMoreDataLoadError)
                                                 name:[NSString stringWithFormat:@"QAList%@MoreDataLoadError",self.title]object:nil];
    
  

}
-(void)loadData{
    self.page += 1;
    [self.model loadData:self.title page:self.page];
}
-(void)reloadData{
    self.page = 1;
    [self.model loadData:self.title page:self.page];
}
-(void)QAListDataLoadSuccess{
    self.dataArray = [self.model.dataDictionary valueForKey:self.title];
    self.newRowCount = self.dataArray.count - self.newRowCount;
    if (self.page == 1) {
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }else{
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    }
}
-(void)QAListMoreDataLoadError{
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
    NSString *date = [dic objectForKey:@"disappear_at"];
    [cell.date setText:[date substringWithRange:NSMakeRange(0, 10)]];
    [cell.content setText:[dic objectForKey:@"description"]];
    [cell.answerNum setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"answer_num"]]];
    //后端数据还没有点赞数和浏览数，先用回答数
    [cell.integralNum setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"answer_num"]]];
    [cell.viewNum setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"answer_num"]]];
    NSString *userIconUrl = [dic objectForKey:@"photo_thumbnail_src"];
    [cell.userIcon setImageWithURL:[NSURL URLWithString:userIconUrl] placeholder:[UIImage imageNamed:@"userIcon"]];
    
//    NSLog(@"%@",dic);
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = _dataArray[indexPath.row];
    NSNumber *id = [dic objectForKey:@"id"];
    NSString *title = [dic objectForKey:@"title"];
    QADetailViewController *detailVC = [[QADetailViewController alloc] initViewWithId:id title:title];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.superController.navigationController pushViewController:detailVC animated:YES];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSLog(@"y:%f",self.scrollView.contentOffset.y);
    if (self.tableView.contentOffset.y <= -100) {
//       [[NSNotificationCenter defaultCenter] postNotificationName:@"QAListDataReLoad" object:nil];
    }
    
}
@end
