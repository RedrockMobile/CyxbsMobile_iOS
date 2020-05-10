//
//  ScoreViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/2/12.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "ScoreViewController.h"
#import "SCChart.h"
#import "UserInfoView.h"
#import "ScoreTwoTitleView.h"
#import "ABScoreView.h"
#import "DetailScorePerYearCell.h"
#define ColorWhite  [UIColor colorNamed:@"colorLikeWhite&#1D1D1D" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]
#define Color21_49_91_F0F0F2  [UIColor colorNamed:@"color21_49_91&#F0F0F2" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]
#define Color42_78_132to2D2D2D [UIColor colorNamed:@"Color42_78_132&#2D2D2D" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]

#define Color_chartLine [UIColor colorNamed:@"Color_chartLine" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]

@interface ScoreViewController ()<SCChartDataSource, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak)UserInfoView *userInfoView;
@property (nonatomic, weak)UIScrollView *contentView;
@property (nonatomic, weak)UIView *twoTitleView;//学风成绩平均绩点
@property (nonatomic, weak)SCChart *chartView;
@property (nonatomic, weak)ABScoreView *ABScoreView;//AB学分
@property (nonatomic, weak)UIView *termBackView;
@property (nonatomic, weak)UILabel *termLabel;//"学期成绩"
@property (nonatomic, weak)UITableView *tableView;//每学年的成绩
@end

@implementation ScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.view.backgroundColor = ColorWhite;
    } else {
        // Fallback on earlier versions
    }
    [self addContentView];//scrollView
    [self addUserInfoView];
    [self addTwoTitleView];
    [self addChartView];
    [self addABScoreView];//AB学分
    [self addTermScoreView];//“学期成绩”
    [self addTableView];
    // Do any additional setup after loading the view.
}
- (void) addContentView {
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    self.contentView = scrollView;
    if (@available(iOS 11.0, *)) {
        scrollView.backgroundColor = Color42_78_132to2D2D2D;
    }
    [self.view addSubview:scrollView];
}
- (void)addUserInfoView {
    UserInfoView *userInfoView  = [[UserInfoView alloc]initWithFrame:CGRectMake(0, 0, self.view.width,86)];
    self.userInfoView = userInfoView;
    [self.contentView addSubview:userInfoView];
}
- (void)addTwoTitleView {
    ScoreTwoTitleView *view = [[ScoreTwoTitleView alloc]initWithFrame:CGRectMake(0, self.userInfoView.origin.y + self.userInfoView.height + 2, self.view.width, 128)];
    self.twoTitleView = view;
//    view.backgroundColor = UIColor.greenColor;
    [self.contentView addSubview:view];
}
- (void)addChartView {
    SCChart *chartView = [[SCChart alloc]initwithSCChartDataFrame:CGRectMake(0, self.twoTitleView.origin.y + self.twoTitleView.height + 2, self.view.width, 180) withSource:self withStyle:SCChartLineStyle];
    
    if (@available(iOS 11.0, *)) {
        chartView.backgroundColor = Color42_78_132to2D2D2D;
    } else {
        // Fallback on earlier versions
    }
    [chartView showInView:self.contentView];
    self.chartView = chartView;
}
- (void)addABScoreView {
    ABScoreView *view = [[ABScoreView alloc]initWithFrame:CGRectMake(0, self.chartView.origin.y + self.chartView.size.height, self.view.width, 90)];
    self.ABScoreView = view;
    [self.contentView addSubview:view];
}
- (void)addTermScoreView {
    UIView *termBackView = [[UIView alloc]initWithFrame:CGRectMake(0, self.ABScoreView.origin.y + self.ABScoreView.height + 2, self.view.width, 53)];
    self.termBackView = termBackView;
    if (@available(iOS 11.0, *)) {
        termBackView.backgroundColor = ColorWhite;
    } else {
        // Fallback on earlier versions
    }
    [self.contentView addSubview:termBackView];
    UILabel *termLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 27, 200, 26)];
    termLabel.font = [UIFont fontWithName:PingFangSCBold size:18];
    if (@available(iOS 11.0, *)) {
        termLabel.textColor = Color21_49_91_F0F0F2;
    } else {
        // Fallback on earlier versions
    }
    termLabel.text = @"学期成绩";
    self.termLabel = termLabel;
    [self.termBackView addSubview:termLabel];
    
}
#warning 修改tableView高度
- (void)addTableView {
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.termBackView.origin.y + self.termBackView.size.height, self.view.width, 300) style:UITableViewStylePlain];
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = NO;
    [self.contentView addSubview:tableView];
}

//MARK: - 折线图代理

- (NSArray *)getXTitles:(int)num {
    NSMutableArray *xTitles = [NSMutableArray array];
    xTitles = @[@"大一上", @"大一下", @"大二上", @"大二下", @"大三上", @"大三下", @"大四上", @"大四下"];
    return xTitles;
}

//横坐标标题数组
- (NSArray *)SCChart_xLableArray:(SCChart *)chart {
    return [self getXTitles:7];
}

- (NSArray *)SCChart_yValueArray:(SCChart *)chart {
            NSMutableArray *ary = [NSMutableArray array];
            ary = @[@1.2, @2.2, @3.1, @4.0, @2.1, @3.5, @1.8, @3.3];
            return @[ary];
}
- (NSArray *)SCChart_ColorArray:(SCChart *)chart {
    if (@available(iOS 11.0, *)) {
        return @[Color_chartLine];
    } else {
        // Fallback on earlier versions
        return @[[UIColor colorWithHexString:@"#2921D1"]];
    }
}
- (BOOL)SCChart:(SCChart *)chart ShowHorizonLineAtIndex:(NSInteger)index {
    return YES;
}
//MARK: - tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailScorePerYearCell *cell = [[DetailScorePerYearCell alloc]init];
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 144;
}
@end
