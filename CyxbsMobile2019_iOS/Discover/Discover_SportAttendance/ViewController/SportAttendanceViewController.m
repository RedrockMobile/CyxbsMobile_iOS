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
    //添加跑步的详情列表
    [self.view addSubview:self.sADetails];
    self.sAModel = [[SportAttendanceModel alloc] init];
    
    //获取当前周数
    int count = [getNowWeek_NSString.numberValue intValue] ;
    NSLog(@"%d",count);
    
    //获取当前月份
    NSDate *currentDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
    long month = [components month];
    long year = [components year];
    NSLog(@"%ld", month);
    
    [self addCustomTabbarView];
    [self addBackButton];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.sAModel requestSuccess:^{
        SportAttendanceHeadView *headView = [[SportAttendanceHeadView alloc] init];
        if (self.sAModel.status == 10000) {
            [headView loadViewWithDate:self.sAModel];
        }
        self.sADetails.tableHeaderView = headView;
        [self.sADetails reloadData];
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"体育打卡加载失败");
    }];
}

#pragma mark- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
}

#pragma mark - UITableViewDataSource
//设置每个分区的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sAModel.sAItemModel.itemAry.count;
}

//设置一行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
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
    cell.sa = _sAModel.sAItemModel.itemAry[indexPath.row];
    return cell;
}

#pragma mark - lan加载

- (UITableView *)sADetails{
    if (!_sADetails) {
        _sADetails = [[UITableView alloc] initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH, SCREEN_HEIGHT - 90)];
        _sADetails.delegate = self;
        _sADetails.dataSource = self;
        _sADetails.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _sADetails;
}

- (DateModle *)dateModel{
    if(_dateModel==nil){//@"2020-09-07"
        //@"2020-08-24" @"2020-07-20" DateStart
        _dateModel = [DateModle initWithStartDate:getDateStart_NSString];
    }
    return _dateModel;
}

#pragma mark - 返回条
//自定义的Tabbar（显示“查课表”的那块）
- (void)addCustomTabbarView {
    UIView *backgroundView;
    backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, NVGBARHEIGHT, SCREEN_WIDTH, STATUSBARHEIGHT)];
    self.backgroundView = backgroundView;
    backgroundView.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1] darkColor:[UIColor colorWithHexString:@"#1D1D1D" alpha:1]];
    [self.view addSubview:backgroundView];
    //addTitleView
    UILabel *titleLabel = [[UILabel alloc]init];
    self.titleLabel = titleLabel;
    titleLabel.text = @"体育打卡";
    titleLabel.font = [UIFont fontWithName:PingFangSCBold size:21];
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
}

//添加退出的按钮
- (void)addBackButton {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:backButton];
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


@end
