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
@property (nonatomic, weak)UIView *seperateLine;//分割线
@property (nonatomic, weak)UILabel *backButtonTitle;//“考试成绩”
@property (nonatomic, weak)UIButton *backButton;//返回按钮
@property (nonatomic, weak)UIView *hideView;
@end

@implementation TestArrangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    [self addBackButtonTitle];
    [self addSeperateLine];
    [self addTableView];
    self.navigationController.navigationBar.topItem.title = @"";
    self.view.backgroundColor = color242_243_248toFFFFFF;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:self.view.backgroundColor}];
    [self addHideView];//添加一个隐藏View防止滑动tableView的时候出现字体重叠的问题
    [self addBackButton];
    [self addTitleLabel];
    // Do any additional setup after loading the view.
    [self getExamArrangeData];
    [self updateUI];
}
-(void)addBackButtonTitle {
    UILabel *label = [[UILabel alloc]init];
    self.backButtonTitle = label;
    label.text = @"考试成绩";
    [label setFont:[UIFont fontWithName:PingFangSCBold size:21]];
    label.textColor = Color21_49_91_F0F0F2;
    [self.view addSubview:label];
//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(@37);
//        make.bottom.equalTo(self.navigationController.navigationBar).offset(-5);
//    }];
}
- (void)addBackButton {
    UIButton *button = [[UIButton alloc]init];
    [self.hideView addSubview:button];
    self.backButton = button;
    [button setImage:[UIImage imageNamed:@"LQQBackButton"] forState:normal];
    [button setImage: [UIImage imageNamed:@"EmptyClassBackButton"] forState:UIControlStateHighlighted];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(17);
        make.top.equalTo(self.view).offset(53);
        make.width.equalTo(@7);
        make.height.equalTo(@14);
    }];
    [button addTarget:self action:@selector(popController) forControlEvents:UIControlEventTouchUpInside];
}
-(void)removeBackButtonTitle {
    [self.backButtonTitle removeFromSuperview];
}

- (void)addTableView {
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(53, [[UIApplication sharedApplication] statusBarFrame].size.height + 120, self.view.width - 53 - 19, self.view.height - 87 -  TABBARHEIGHT) style:UITableViewStylePlain];
    self.tableView = tableView;
    tableView.backgroundColor = self.view.backgroundColor;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
}
- (void)addSeperateLine {
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, self.navigationController.navigationBar.origin.y + self.navigationController.navigationBar.height, self.view.width, 1)];
    line.backgroundColor = [UIColor colorWithRed:42/255.0 green:78/255.0 blue:132/255.0 alpha:0.1];
    [self.view addSubview:line];
    self.seperateLine = line;
}
- (void)addHideView {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 112 - 25)];//112是字体顶部到手机屏幕顶部的距离，25是字体高度
    self.hideView = view;
    view.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:view];
}
- (void)addTitleLabel {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(-34, -48, 250, 40)];
    self.titleLabel = label;
    label.text = @"考试安排";
    [label setFont:[UIFont fontWithName:PingFangSCBold size:22]];
    label.textColor = Color21_49_91_F0F0F2;
    [self.tableView addSubview:label];

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
    int pointCount = (int)self.examArrangeModel.examArrangeData.data.count;
    CGFloat spacing = 166.13;
    PointAndDottedLineView *pointAndDottedLineView = [[PointAndDottedLineView alloc]initWithPointCount:pointCount Spacing:spacing];
    [pointAndDottedLineView setFrame:CGRectMake(-30, 7, 11, pointAndDottedLineView.bigCircle.width + spacing * (pointCount - 1))];
    self.tableView.clipsToBounds = NO;

    NSLog(@"%f",self.titleLabel.origin.y + self.titleLabel.height + 18);
    [self.tableView addSubview:pointAndDottedLineView];
    
}
- (void)popController {
    [self.navigationController popViewControllerAnimated:YES];
//    self.navigationController.navigationBar.hidden = NO;
    [self removeBackButtonTitle];
}


//MARK: - tableView代理

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TestCardTableViewCell *cell = [[TestCardTableViewCell alloc]init];
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    
    cell.weekTimeLabel.text = [NSString stringWithFormat:@"%@周周%@",[self translationArabicNum:self.examArrangeModel.examArrangeData.data[indexPath.row].week.intValue], [self translationArabicNum: self.examArrangeModel.examArrangeData.data[indexPath.row].weekday.intValue]];
    cell.leftDayLabel.text = [NSString stringWithFormat:@"还剩_天考试"];
    cell.subjectLabel.text = self.examArrangeModel.examArrangeData.data[indexPath.row].course;
    cell.testNatureLabel.text = self.examArrangeModel.examArrangeData.data[indexPath.row].type;
    cell.dayLabel.text = [NSString stringWithFormat:@"%@月%@日", [self getArrayWithString: self.examArrangeModel.examArrangeData.data[indexPath.row].date][1], [self getArrayWithString: self.examArrangeModel.examArrangeData.data[indexPath.row].date][2]];
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

/// 获得一个字符串例如:2019-12-28，返回一个两个元素的数组@[2019, 12, 28]，元素为年，月，日
/// @param string 字符串
- (NSArray *)getArrayWithString:(NSString*)string {
    NSMutableArray<NSString*> *array = [NSMutableArray arrayWithArray:[string componentsSeparatedByString:@"-"]];
    if([array[1] hasPrefix:@"0"]) {
        NSString *month = [array[1] substringFromIndex:1];
        array[1] = month;
    }
    if([array[2] hasPrefix:@"0"]) {
        NSString *day = [array[2] substringFromIndex:1];
        array[2] = day;
    }
    return array;
    
}
//MARK: - 阿拉伯数字转汉字
- (NSString *)translationArabicNum:(NSInteger)arabicNum
{
    NSString *arabicNumStr = [NSString stringWithFormat:@"%ld",(long)arabicNum];
    NSArray *arabicNumeralsArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    NSArray *chineseNumeralsArray = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"零"];
    NSArray *digits = @[@"个",@"十",@"百",@"千",@"万",@"十",@"百",@"千",@"亿",@"十",@"百",@"千",@"兆"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:chineseNumeralsArray forKeys:arabicNumeralsArray];
    
    if (arabicNum < 20 && arabicNum > 9) {
        if (arabicNum == 10) {
            return @"十";
        }else{
            NSString *subStr1 = [arabicNumStr substringWithRange:NSMakeRange(1, 1)];
            NSString *a1 = [dictionary objectForKey:subStr1];
            NSString *chinese1 = [NSString stringWithFormat:@"十%@",a1];
            return chinese1;
        }
    }else{
        NSMutableArray *sums = [NSMutableArray array];
        for (int i = 0; i < arabicNumStr.length; i ++)
        {
            NSString *substr = [arabicNumStr substringWithRange:NSMakeRange(i, 1)];
            NSString *a = [dictionary objectForKey:substr];
            NSString *b = digits[arabicNumStr.length -i-1];
            NSString *sum = [a stringByAppendingString:b];
            if ([a isEqualToString:chineseNumeralsArray[9]])
            {
                if([b isEqualToString:digits[4]] || [b isEqualToString:digits[8]])
                {
                    sum = b;
                    if ([[sums lastObject] isEqualToString:chineseNumeralsArray[9]])
                    {
                        [sums removeLastObject];
                    }
                }else
                {
                    sum = chineseNumeralsArray[9];
                }
                
                if ([[sums lastObject] isEqualToString:sum])
                {
                    continue;
                }
            }
            
            [sums addObject:sum];
        }
        NSString *sumStr = [sums  componentsJoinedByString:@""];
        NSString *chinese = [sumStr substringToIndex:sumStr.length-1];
        return chinese;
    }
}
@end
