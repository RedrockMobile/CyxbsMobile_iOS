//
//  AttitudeMainPageVC.m
//  CyxbsMobile2019_iOS
//
//  Created by 艾 on 2023/2/7.
//  Copyright © 2023 Redrock. All rights reserved.
//

// 鉴权：判断id -> 发布
// 加载更多内容
// cell点击 ->投票

// VC
#import "AttitudeMainPageVC.h"
#import "ExpressDetailPageVC.h"
#import "PublishViewController.h"
// Model
/// 主页数据
#import "AttitudeMainModel.h"
#import "AttitudeMainPageItem.h"
/// 详情数据
#import "ExpressPickGetModel.h"
#import "ExpressPickGetItem.h"
// View
#import "AttitudeHomeCell.h"
#import "AttitudeMainDefaultView.h"

@interface AttitudeMainPageVC () <
    UITableViewDelegate,
    UITableViewDataSource
>
@property (nonatomic, strong) AttitudeMainModel *attitudeModel;
@property (nonatomic, strong) AttitudeMainPageItem *modelItem;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataArray;
@property (nonatomic, strong) AttitudeMainDefaultView *defaultView;

@end

@implementation AttitudeMainPageVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarView];
    
    if (self.dataArray.count == 0) {
        [self.view addSubview:self.defaultView];
    }
    else {
        [self getRequestData];
        [self.view addSubview:self.tableView];
    }
}
// 表态Bar
- (void)setBarView {
    self.view.backgroundColor = [UIColor whiteColor];
    self.VCTitleStr = @"表态区";
    self.splitLineHidden = YES;
    self.titlePosition = TopBarViewTitlePositionLeft;
    self.topBarView.backgroundColor = [UIColor whiteColor];
    self.titleFont = [UIFont fontWithName:PingFangSCBold size:22];
    // 按钮
//    UIBarButtonItem *publishBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Express_mainPublish"] style:UIBarButtonItemStylePlain target:self action:@selector(clickPublishBtn)];
//    [publishBtn setImage:[UIImage imageNamed:@"Express_mainPublish"]];
    UIButton *publishBtn = [[UIButton alloc] init];
    [publishBtn setImage:[UIImage imageNamed:@"Express_mainPublish"] forState:UIControlStateNormal];
    [publishBtn addTarget:self action:@selector(clickPublishBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.topBarView addSubview:publishBtn];
    [publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topBarView);
        make.right.equalTo(self.topBarView).mas_offset(-16);
        make.height.equalTo(@18);
        make.width.equalTo(@18);
    }];
    
    // MARK: Test详情页
//    ExpressDetailPageVC *exVC = [[ExpressDetailPageVC alloc] initWithTheId:0];
//    [self.view addSubview:exVC];
    
}

- (void)clickPublishBtn {
    NSLog(@"点击发布按钮");
    PublishViewController *publishVC = [[PublishViewController alloc] init];
    [self.navigationController pushViewController:publishVC animated:YES];
}

- (void)getRequestData {
    NSLog(@"1⃣️");
    [self.attitudeModel requestAttitudeDataWithOffset:0 Limit:20 Success:^(NSArray *array) {
        self.dataArray = array;
        NSLog(@"%ld", self.dataArray.count);
        } Failure:^{
            NSLog(@"falure");
        }];
    NSLog(@"1⃣️1⃣️");
    NSLog(@"%ld", self.dataArray.count);
}

// 加载更多数据
- (void)loadMoreData {
    
}

// 缺省页
/*
- (void)setDefaultView {
//    [self.view removeAllSubviews];
    UIImageView *defaultView = [[UIImageView alloc] init];
    defaultView.image = [UIImage imageNamed:@"Attitude_defaultPage"];
    UILabel *defaultLabel = [[UILabel alloc] init];
    defaultLabel.text = @"菌似乎还没有发布过话题,点击右上角去发布吧!";
    defaultLabel.font = [UIFont fontWithName:PingFangSC size:16];
    defaultLabel.textColor = [UIColor colorWithHexString:@"#112C54" alpha:0.6];
    defaultLabel.numberOfLines = 0;
    [self.view addSubview:defaultView];
    [self.view addSubview:defaultLabel];
    [defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).mas_offset(245);
        make.width.equalTo(@170);
        make.height.equalTo(@102);
    }];
    [defaultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(defaultView.mas_bottom).mas_offset(16);
        make.height.equalTo(@50);
        make.width.equalTo(@201);
    }];
}
*/

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.dataArray.count;
    return 2;
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"2⃣️");
    static NSString *identify = @"identify";
    AttitudeHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[AttitudeHomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
    self.modelItem = self.dataArray[indexPath.row];
    cell.title.text = self.modelItem.title;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

// 点击cell跳进投票
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 传入当前id
    ExpressPickGetItem *item = self.dataArray[indexPath.row];
    NSNumber *theId = item.getId;
    ExpressDetailPageVC *detailPage = [[ExpressDetailPageVC alloc] initWithTheId:theId];
    [self.navigationController pushViewController:detailPage animated:YES];
    NSLog(@"页面跳转");
}


- (UITableView *)tableView {
    if (!_tableView) {
        CGFloat y = self.topBarView.bottom;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, kScreenWidth, kScreenHeight - y) style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithRed:0.949 green:0.953 blue:0.973 alpha:1];
    }
    return _tableView;
}

- (AttitudeMainModel *)attitudeModel {
    if (!_attitudeModel) {
        _attitudeModel = [[AttitudeMainModel alloc] init];
    }
    return _attitudeModel;
}
// 缺省页
- (AttitudeMainDefaultView *)defaultView {
    CGFloat y = self.topBarView.bottom;
    if (!_defaultView) {
        _defaultView = [[AttitudeMainDefaultView alloc] initWithDefaultPage];
        _defaultView.frame = CGRectMake(0, y, kScreenWidth, kScreenHeight - y);
    }
    return _defaultView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
