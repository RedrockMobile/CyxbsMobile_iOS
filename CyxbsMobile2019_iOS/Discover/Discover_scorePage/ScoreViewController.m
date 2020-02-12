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


#define ColorWhite  [UIColor colorNamed:@"colorWhite&#1D1D1D" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]

@interface ScoreViewController ()<SCChartDataSource>
@property (nonatomic, weak)UserInfoView *userInfoView;
@property (nonatomic, weak)UIScrollView *contentView;
@property (nonatomic, weak)UIView *twoTitleView;//学风成绩平均绩点
@property (nonatomic, weak)UIView *ABScoreView;//AB学分
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
    
    // Do any additional setup after loading the view.
}
- (void) addContentView {
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    self.contentView = scrollView;
    scrollView.backgroundColor = UIColor.purpleColor;
    [self.view addSubview:scrollView];
}
- (void)addUserInfoView {
    UserInfoView *userInfoView  = [[UserInfoView alloc]initWithFrame:CGRectMake(0, 0, self.view.width,86)];
    self.userInfoView = userInfoView;
    [self.contentView addSubview:userInfoView];
}
- (void)addTwoTitleView {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, self.userInfoView.origin.y + self.userInfoView.height + 2, self.view.width, 128)];
    self.twoTitleView = view;
    view.backgroundColor = UIColor.greenColor;
    [self.contentView addSubview:view];
}
- (void)addChartView {
    SCChart *chartView = [[SCChart alloc]initwithSCChartDataFrame:CGRectMake(0, self.twoTitleView.origin.y + self.twoTitleView.height + 2, self.view.width, 180) withSource:self withStyle:SCChartLineStyle];
    [chartView showInView:self.contentView];
}
- (NSArray *)getXTitles:(int)num {
    NSMutableArray *xTitles = [NSMutableArray array];
    xTitles = @[@"大一上", @"大一下", @"大二上", @"大二下", @"大三上", @"大三下", @"大四上", @"大四下"];
    return xTitles;
}

#pragma mark - @required
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
    return @[[UIColor colorWithHexString:@"#2921D1"]];
}
- (BOOL)SCChart:(SCChart *)chart ShowHorizonLineAtIndex:(NSInteger)index {
    return YES;
}
@end
