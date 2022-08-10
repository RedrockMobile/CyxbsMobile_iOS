//
//  SportAttendanceViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 潘申冰 on 2022/8/3.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "SportAttendanceViewController.h"
#import "SportAttendanceModel.h"
#import "SportAttendanceHeadView.h"
#import "SportAttendanceTableViewCell.h"
#import "DateModle.h"

@interface SportAttendanceViewController ()<UITableViewDelegate, UITableViewDataSource>

/// 详细打卡记录列表
@property (nonatomic, strong) UITableView *sADetails;
/// SportAttendance数据模型
@property (nonatomic, strong) SportAttendanceModel *sAModel;
//日期数据模型
@property (nonatomic, strong) DateModle *dateModel;

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation SportAttendanceViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addSussesView];
    self.sAModel = [[SportAttendanceModel alloc] init];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

#pragma mark- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
}

#pragma mark - UITableViewDataSource
//设置每个分区的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 15;
//    return self.sAModel.sAItemModel.itemAry.count;
}

//设置一行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 92;
}

//具体数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reusedId = @"sportAttendance";
    SportAttendanceTableViewCell *cell = (SportAttendanceTableViewCell *) [tableView dequeueReusableHeaderFooterViewWithIdentifier:reusedId];
    if (!cell) {
        cell = [[SportAttendanceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedId];
    }
    //禁止点击
    cell.userInteractionEnabled =NO;
    //   显示所有内容
    if (!self.sAModel.sAItemModel.itemAry) {
        cell.sa = self.sAModel.sAItemModel.itemAry[indexPath.row];
    }
    return cell;
}

#pragma mark - getter

- (UITableView *)sADetails{
    if (!_sADetails) {
        _sADetails = [[UITableView alloc] initWithFrame:CGRectMake(0, 240, SCREEN_WIDTH, SCREEN_HEIGHT - 240)];
        _sADetails.delegate = self;
        _sADetails.dataSource = self;
        _sADetails.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#FBFCFF"] darkColor:[UIColor colorWithHexString:@"#1D1D1D"]];
        _sADetails.separatorStyle = UITableViewCellSeparatorStyleNone;
        _sADetails.layer.cornerRadius = 20;

        MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
        NSMutableArray *refreshingImages = [NSMutableArray array];
        for (NSUInteger i = 1; i<=12; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"sportrefreshIcon%zd", i]];
            [refreshingImages addObject:image];
        }
        // 设置下拉刷新状态的动画图片
        [header setImages:refreshingImages forState:MJRefreshStateIdle];
        // 设置正在刷新状态的动画图片
        [header setImages:refreshingImages forState:MJRefreshStateRefreshing];
        _sADetails.mj_header = header;
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
    }
    return _sADetails;
}

//获取当前周数
- (DateModle *)dateModel{
    if(_dateModel==nil){
        _dateModel = [DateModle initWithStartDate:getDateStart_NSString];
    }
    return _dateModel;
}

#pragma mark - 返回条
//自定义的Tabbar
- (void)addCustomTabbarView {
    UIView *backgroundView;
    backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, NVGBARHEIGHT, SCREEN_WIDTH, STATUSBARHEIGHT)];
    self.backgroundView = backgroundView;
    backgroundView.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:0] darkColor:[UIColor colorWithHexString:@"#1D1D1D" alpha:0]];
    [self.view addSubview:backgroundView];
    //addTitleView
    UILabel *titleLabel = [[UILabel alloc]init];
    self.titleLabel = titleLabel;
    titleLabel.text = @"体育打卡";
    titleLabel.font = [UIFont fontWithName:PingFangSCBold size:22];
    [self.backgroundView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.backgroundView);
    }];
    titleLabel.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];

    //获取当前周数
    int count = [getNowWeek_NSString.numberValue intValue] ;
    NSLog(@"%d",count);
    
    //获取当前月份
    NSDate *currentDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
    long month = [components month];
    long year = [components year];
    
    UILabel *timeLabel = [[UILabel alloc]init];
    self.timeLabel = timeLabel;
    
    if (count > 50) {
        timeLabel.text = @"放假中";
    }else{
        if (month > 1 && month < 9) {
            timeLabel.text = [NSString stringWithFormat:@"%ld年 春", year];
        }else{
            timeLabel.text = [NSString stringWithFormat:@"%ld年 秋", year];
        }
    }
    
    timeLabel.font = [UIFont fontWithName:PingFangSCBold size:18];
    [self.backgroundView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).offset(100);
        make.centerY.equalTo(self.backgroundView);
    }];
    timeLabel.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
    
    //添加返回按钮
    [self addBackButton];
}

//添加退出的按钮
- (void)addBackButton {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.backgroundView addSubview:backButton];
    [backButton setImage:[UIImage imageNamed:@"空教室返回"] forState:UIControlStateNormal];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(17);
        make.centerY.equalTo(self.titleLabel);
        make.width.equalTo(@9);
        make.height.equalTo(@19);
    }];
    [backButton addTarget:self action: @selector(back) forControlEvents:UIControlEventTouchUpInside];
}

//返回的方法
- (void) back {
     [self.navigationController popViewControllerAnimated:YES];
}

- (void) loadNewData{
    [self.sAModel requestSuccess:^{
        if (self.sAModel.status == 10000) {
           
            [self addSussesView];
           
        }
        [self.sADetails.mj_header endRefreshing];
    }
        failure:^(NSError * _Nonnull error) {
            NSLog(@"体育打卡刷新失败");
        [self.sADetails.mj_header endRefreshing];
    }];
    
}
#pragma mark - Method

//获取数据成功加载此视图
- (void) addSussesView{
    //先移除所有View
    [self.view removeAllSubviews];
    //添加头视图
    SportAttendanceHeadView *headView = [[SportAttendanceHeadView alloc] init];
    [headView loadViewWithDate:self.sAModel];
    [self.view addSubview:headView];
    //添加返回条
    [self addCustomTabbarView];
    //添加跑步的详情列表
    [self.view addSubview:self.sADetails];
}

#pragma mark - RisingRouterHandler

+ (NSArray<NSString *> *)routerPath {
    return @[
        @"SportController"
    ];
}

+ (void)responseRequest:(RisingRouterRequest *)request completion:(RisingRouterResponseBlock)completion {
    
    RisingRouterResponse *response = [[RisingRouterResponse alloc] init];
    
    switch (request.requestType) {
        case RouterRequestPush: {
            
            UINavigationController *nav = (request.requestController ? request.requestController : RisingRouterRequest.useTopController).navigationController;
            
            if (nav) {
                SportAttendanceViewController *vc = [[self alloc] init];
                response.responseController = vc;
                
                [nav pushViewController:vc animated:YES];
            } else {
                
                response.errorCode = RouterWithoutNavagation;
            }
            
        } break;
            
        case RouterRequestParameters: {
            // TODO: 传回参数
        } break;
            
        case RouterRequestController: {
            
            SportAttendanceViewController *vc = [[self alloc] init];
            
            response.responseController = vc;
        } break;
    }
    
    if (completion) {
        completion(response);
    }
}


@end
