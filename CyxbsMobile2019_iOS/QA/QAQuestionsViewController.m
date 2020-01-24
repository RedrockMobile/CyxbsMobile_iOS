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
@end

@implementation QAQuestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(QAListDataLoadSuccess)
                                                 name:@"QAListDataLoadSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(QAListDataLoadError)
                                                 name:@"QAListDataLoadError" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(QAListDataLoadFailure)
                                                 name:@"QAListDataLoadFailure" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadView)
                                                 name:@"QAListDataReLoad" object:nil];
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:243/255.0 blue:248/255.0 alpha:1.0];
    [self configNavagationBar];
    [self addContentView];
    [self loadData];

    
    
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
    [btn addTarget:self action:@selector(tapAskBtn) forControlEvents:UIControlEventTouchUpInside];
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
    NSArray *titleArray = @[@"最新",@"学习",@"匿名",@"生活",@"更多"];
    NSMutableArray *views = [NSMutableArray arrayWithCapacity:5];
    for (int i = 0;i < 5; i++) {
        QAListViewController *vc = [[QAListViewController alloc] initViewStyle:titleArray[i] dataArray:self.model.dataArray[i]];
        vc.title = titleArray[i];
        [views addObject:vc];
    }
   
    for (QAListViewController *view in views) {
        view.superController = self;
    }
    QAListSegmentView *segView = [[QAListSegmentView alloc] initWithFrame:CGRectMake(0, TOTAL_TOP_HEIGHT + 50, SCREEN_WIDTH, SCREEN_HEIGHT - TOTAL_TOP_HEIGHT - TABBARHEIGHT - 50) controllers:views];
    [self.view addSubview:segView];
}

-(void)loadData{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载数据中...";
    hud.color = [UIColor colorWithWhite:0.f alpha:0.4f];
    self.model = [[QAListModel alloc]init];
    [self.model getData];
}
-(void)QAListDataLoadSuccess{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self setupUI];
//    NSLog(@"%D,%@",self.model.dataArray.count, self.model.dataArray[0]);
}
-(void)QAListDataLoadError{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    UIAlertController *controller=[UIAlertController alertControllerWithTitle:@"数据加载错误" message:@"网络数据解析错误" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *act1=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [controller addAction:act1];
    
    [self presentViewController:controller animated:YES completion:^{
        
    }];
}

-(void)QAListDataLoadFailure{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    UIAlertController *controller=[UIAlertController alertControllerWithTitle:@"网络错误" message:@"数据加载失败" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *act1=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [controller addAction:act1];
    
    [self presentViewController:controller animated:YES completion:^{
        
    }];
}
-(void)reloadView{
    [self.view removeAllSubviews];
    [self addContentView];
    [self.model getData];
    
}
-(void)tapAskBtn{
    QAAskViewController *vc = [[QAAskViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
