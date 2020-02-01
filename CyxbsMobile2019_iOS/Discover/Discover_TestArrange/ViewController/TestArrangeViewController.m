//
//  TestArrangeViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/1/30.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "TestArrangeViewController.h"
#import "TestCardTableViewCell.h"
#import "PointAndDottedLineView.h"
#import "ExamArrangeModel.h"
#import "ExamArrangeData.h"
#define Color21_49_91_F0F0F2  [UIColor colorNamed:@"color21_49_91&#F0F0F2" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]
#define color242_243_248toFFFFFF [UIColor colorNamed:@"color242_243_248&#FFFFFF" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]

@interface TestArrangeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak)UILabel *titleLabel;
@property (nonatomic, strong)ExamArrangeModel *examArrangeModel;
@end

@implementation TestArrangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTableView];
    self.navigationController.navigationBar.topItem.title = @"";
    self.view.backgroundColor = color242_243_248toFFFFFF;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:self.view.backgroundColor}];
    [self addTitleLabel];
    // Do any additional setup after loading the view.
    [self getExamArrangeData];
    [self updateUI];
}

- (void)addTableView {
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(53, 160, self.view.width - 53 - 19, self.view.height - 87 -  [[UIApplication sharedApplication] statusBarFrame].size.height) style:UITableViewStylePlain];
    self.tableView = tableView;
    tableView.backgroundColor = self.view.backgroundColor;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
}
- (void)addTitleLabel {
    UILabel *label = [[UILabel alloc]init];
    self.titleLabel = label;
    label.text = @"考试安排";
    [label setFont:[UIFont fontWithName:PingFangSCBold size:22]];
    label.textColor = Color21_49_91_F0F0F2;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(19);
        make.top.equalTo(self.view).offset(112);
    }];
}
- (void)getExamArrangeData {
    ExamArrangeModel *model = [[ExamArrangeModel alloc]init];
    self.examArrangeModel = model;
    
}
- (void)updateUI {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getExamArrangeDataSucceed) name:@"getExamArrangeSucceed" object:nil];
}
- (void)getExamArrangeDataSucceed {
    NSLog(@"%@",self.examArrangeModel.examArrangeData);
    [self.tableView reloadData];
    //展示左边的小球和点点
//    int pointCount = (int)self.examArrangeModel.examArrangeData.data.count;
//    CGFloat spacing = 166.13;
//    PointAndDottedLineView *pointAndDottedLineView = [[PointAndDottedLineView alloc]initWithPointCount:pointCount Spacing:spacing];
//    [pointAndDottedLineView setFrame:CGRectMake(-30, 167, 11, pointAndDottedLineView.bigCircle.width + spacing * (pointCount - 1))];
//    self.tableView.clipsToBounds = NO;
//    [self.tableView.layer setFrame:CGRectMake(53,self.titleLabel.origin.y + self.titleLabel.height + 18, self.tableView.layer.frame.size.width, self.tableView.layer.frame.size.height)];
//    NSLog(@"%f",self.titleLabel.origin.y + self.titleLabel.height + 18);
//    pointAndDottedLineView.backgroundColor = [UIColor yellowColor];
//    [self.tableView addSubview:pointAndDottedLineView];
    
}
- (void)popController {
    [self.navigationController popViewControllerAnimated:YES];
}




- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TestCardTableViewCell *cell = [[TestCardTableViewCell alloc]init];
    cell.weekTimeLabel.text = [NSString stringWithFormat:@"%@周周%@",self.examArrangeModel.examArrangeData.data[indexPath.row].week,self.examArrangeModel.examArrangeData.data[indexPath.row].weekday];
    cell.leftDayLabel.text = [NSString stringWithFormat:@"还剩_天考试"];
    cell.subjectLabel.text = self.examArrangeModel.examArrangeData.data[indexPath.row].course;
    cell.testNatureLabel.text = self.examArrangeModel.examArrangeData.data[indexPath.row].type;
    cell.dayLabel.text = self.examArrangeModel.examArrangeData.data[indexPath.row].date;
    cell.timeLabel.text = [NSString stringWithFormat:@"%@ - %@",self.examArrangeModel.examArrangeData.data[indexPath.row].begin_time, self.examArrangeModel.examArrangeData.data[indexPath.row].end_time];
    cell.classLabel.text = self.examArrangeModel.examArrangeData.data[indexPath.row].classroom;
    cell.seatNumLabel.text = [NSString stringWithFormat:@"%@号", self.examArrangeModel.examArrangeData.data[indexPath.row].seat];
    [self.view addSubview:cell];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.examArrangeModel.examArrangeData.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 166;
}

@end
