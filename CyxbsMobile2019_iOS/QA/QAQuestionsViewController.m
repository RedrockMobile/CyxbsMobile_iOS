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

@interface QAQuestionsViewController ()

@end

@implementation QAQuestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:243/255.0 blue:248/255.0 alpha:1.0];
    [self configNavagationBar];
    [self addContentView];
    [self setupUI];
    
}
-(void)addContentView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, TOTAL_TOP_HEIGHT, SCREEN_WIDTH,50)];
    view.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    [self.view addSubview:label];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"邮问" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: 35], NSForegroundColorAttributeName: [UIColor blackColor]}];
    
    label.attributedText = string;
    label.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0];
//    label.alpha = 1.0;
    [view addSubview:label];
    UIButton *btn = [[UIButton alloc]init];
    btn.backgroundColor = [UIColor colorWithHexString:@"#2921D1"];
    [btn setTitle:@"提问" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    btn.layer.cornerRadius = 16;
    [view addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(view).mas_offset(-17);
        make.height.equalTo(@32);
        make.centerY.equalTo(view);
        make.width.equalTo(@58);
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).mas_offset(1);
        make.left.equalTo(view).mas_offset(17);
        make.bottom.equalTo(view).mas_offset(-1);
//        make.height.equalTo(@48);
        make.width.equalTo(@75);
    }];
    [self.view addSubview:view];
}
- (void)configNavagationBar {
    if (@available(iOS 11.0, *)) {
        self.navigationController.navigationBar.backgroundColor = [UIColor colorNamed:@"navicolor" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil];
    } else {
        // Fallback on earlier versions
    }
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]}];
    //隐藏导航栏的分割线
    if (@available(iOS 11.0, *)) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorNamed:@"navicolor" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    } else {
        // Fallback on earlier versions
    }
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
}
-(void)setupUI{
    //加载4个分类板块，并添加进SegmentView
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    QAListViewController *latestView = [[QAListViewController alloc] initViewStyle:@"最新"];
    latestView.title = @"最新";
    QAListViewController *learningView = [[QAListViewController alloc] initViewStyle:@"学习"];
    learningView.title = @"学习";
    QAListViewController *anonymousView = [[QAListViewController alloc] initViewStyle:@"匿名"];
    anonymousView.title = @"匿名";
    QAListViewController *lifeView = [[QAListViewController alloc] initViewStyle:@"生活"];
    lifeView.title = @"生活";
    QAListViewController *moreView = [[QAListViewController alloc] initViewStyle:@"更多"];
    moreView.title = @"更多";
    
    NSArray *views = @[latestView, learningView, anonymousView, lifeView,moreView];
   
//    QAListSegmentView *segView = [[QAListSegmentView alloc] initWithFrame:CGRectMake(0, TOTAL_TOP_HEIGHT + 50, SCREEN_WIDTH, SCREEN_HEIGHT - TOTAL_TOP_HEIGHT - TABBARHEIGHT - 50)];
//    SYCSegmentView *segView = [[SYCSegmentView alloc] initWithFrame:CGRectMake(0, TOTAL_TOP_HEIGHT + 50, SCREEN_WIDTH, SCREEN_HEIGHT - TOTAL_TOP_HEIGHT - TABBARHEIGHT - 50) controllers:views type:SYCSegmentViewTypeNormal];
    QAListSegmentView *segView = [[QAListSegmentView alloc] initWithFrame:CGRectMake(0, TOTAL_TOP_HEIGHT + 50, SCREEN_WIDTH, SCREEN_HEIGHT - TOTAL_TOP_HEIGHT - TABBARHEIGHT - 50) controllers:views];
    [self.view addSubview:segView];
}
@end
