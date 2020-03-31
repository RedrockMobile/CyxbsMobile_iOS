//
//  QAQuestionsViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/10/21.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "QAQuestionsViewController.h"
#import "QAListViewController.h"
#import "QAListSegmentView.h"
#import "SYCSegmentView.h"
#import "QAListModel.h"
#import "QAAskViewController.h"
@interface QAQuestionsViewController ()
@property(strong,nonatomic)QAListModel *model;
@property(assign,nonatomic)BOOL isShowAlert;
@end

@implementation QAQuestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(QAListDataLoadFailure)
                                                 name:[NSString stringWithFormat:@"QAListDataLoadFailure"] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(QAListDataLoadError)
                                                 name:[NSString stringWithFormat:@"QAListDataLoadError"] object:nil];
    if (@available(iOS 11.0, *)) {
        self.view.backgroundColor = [UIColor colorNamed:@"ColorBackground" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil];
    } else {
        self.view.backgroundColor = [UIColor colorWithHexString:@"F8F9FC"];
    }
    self.isShowAlert = NO;
    
    [self setupUI];
    
}
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}
- (void)customNavigationBar{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, STATUSBARHEIGHT, SCREEN_WIDTH,70)];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *weekLabel = [[UILabel alloc]init];
    weekLabel.text = [self calculateDate];
    [weekLabel setFont:[UIFont fontWithName:PingFangSCLight size:10]];
    [weekLabel setTextColor:[UIColor colorWithHexString:@"#15315B"]];
    [view addSubview:weekLabel];
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"邮问" attributes:@{NSFontAttributeName: [UIFont fontWithName:PingFangSCMedium size: 35], NSForegroundColorAttributeName: [UIColor blackColor]}];
    titleLabel.attributedText = string;
    titleLabel.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0];
    [view addSubview:titleLabel];
    
    UIButton *btn = [[UIButton alloc]init];
    btn.backgroundColor = [UIColor colorWithHexString:@"#2921D1"];
    [btn setTitle:@"提问" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(tapAskBtn) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 16;
    [view addSubview:btn];
    
    [weekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).mas_offset(1);
        make.left.equalTo(view).mas_offset(17);
        make.height.equalTo(@15);
        make.width.equalTo(@100);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weekLabel).mas_offset(5);
        make.left.equalTo(view).mas_offset(17);
        make.bottom.equalTo(view).mas_offset(-1);
        make.width.equalTo(@75);
    }];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).mas_offset(-17);
        make.height.equalTo(@32);
        make.centerY.equalTo(view);
        make.width.equalTo(@58);
    }];
    
    
    [self.view addSubview:view];
}
-(NSString *)calculateDate{
    //计算星期几
    NSArray *weekday = @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:nowDate];
    NSString *weekDayStr = weekday[components.weekday - 1];
    
    //从字符串转换日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy.MM.d"];
    NSDate *resDate = [formatter dateFromString:DateStart];
    
    //计算当前是第几周
    NSInteger beginTime=[resDate timeIntervalSince1970];
    NSDate *now = [NSDate date];
    NSInteger nowTime = [now timeIntervalSince1970];
    double day = (float)(nowTime - beginTime)/(float)86400/(float)7;
    NSInteger nowWeek = (int)ceil(day) - 1;
    if(nowWeek < 0){
        nowWeek = 0;
    }
    NSArray *weekNumArray = @[@"第一周",@"第二周",@"第三周",@"第四周",@"第五周",@"第六周",@"第七周",@"第八周",@"第九周",@"第十周",@"第十一周",@"第十二周",@"第十三周",@"第十四周",@"第十五周",@"第十六周",@"第十七周",@"第十八周",@"第十九周",@"第二十周",@"二十一周",@"二十二周",@"二十三周",@"二十四周",@"二十五周"];
    NSString *weekNum = weekNumArray[nowWeek];
    NSString *weekStr = [NSString stringWithFormat:@"%@ %@",weekNum,weekDayStr];
    return weekStr;
    
}
- (void)setupUI{
    //加载5个分类板块，并添加进SegmentView
    NSArray *titleArray = @[@"最新",@"学习",@"匿名",@"生活",@"其他"];
    NSMutableArray *views = [NSMutableArray arrayWithCapacity:5];
    for (int i = 0;i < 5; i++) {
        QAListViewController *vc = [[QAListViewController alloc] initViewStyle:titleArray[i]];
        [views addObject:vc];
    }
    
    for (QAListViewController *view in views) {
        view.superController = self;
    }
    QAListSegmentView *segView = [[QAListSegmentView alloc] initWithFrame:CGRectMake(0, TOTAL_TOP_HEIGHT + 20, SCREEN_WIDTH, SCREEN_HEIGHT - TOTAL_TOP_HEIGHT - TABBARHEIGHT - 20) controllers:views];
    [self.view addSubview:segView];
}

- (void)QAListDataLoadError{
    if (self.isShowAlert == NO) {
        
        UIAlertController *controller=[UIAlertController alertControllerWithTitle:@"数据加载错误" message:@"网络数据解析错误" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *act1=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [controller addAction:act1];
        
        [self presentViewController:controller animated:YES completion:^{
            
        }];
        self.isShowAlert = YES;
    }
}

- (void)QAListDataLoadFailure{
    if(self.isShowAlert == NO){
        UIAlertController *controller=[UIAlertController alertControllerWithTitle:@"网络错误" message:@"数据加载失败" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *act1=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [controller addAction:act1];
        
        [self presentViewController:controller animated:YES completion:^{
            self.isShowAlert = NO;
        }];
        self.isShowAlert = YES;
    }
}

- (void)tapAskBtn{
    QAAskViewController *vc = [[QAAskViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
