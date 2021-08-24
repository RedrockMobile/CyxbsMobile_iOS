//
//  FeedBackMainPageViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 钟文韬 on 2021/8/23.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "FeedBackMainPageViewController.h"
#import "ZWTMacro.h"
#import "UIView+XYView.h"
#import "HintView.h"
@interface FeedBackMainPageViewController ()<UITableViewDelegate,UITableViewDataSource>
///常见问题标题
@property (nonatomic,strong) UILabel *commonQuestionsLbl;
///table
@property (nonatomic,strong) UITableView *table;
///意见反馈入口按钮
@property (nonatomic,strong) UIButton *feedBackEntranceBtn;
///提示反馈qq群View
@property (nonatomic,strong) HintView *hintView;

@end

@implementation FeedBackMainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBar];
    [self.view addSubview:self.commonQuestionsLbl];
    [self.view addSubview:self.table];
    [self.view addSubview:self.feedBackEntranceBtn];
    [self.view addSubview:self.hintView];
    
}
#pragma mark - getter
- (UILabel *)commonQuestionsLbl{
    if (!_commonQuestionsLbl) {
        _commonQuestionsLbl = [[UILabel alloc]initWithFrame:CGRectMake(0.042*SCREEN_WIDTH, Bar_H+27, 83, 28)];
        _commonQuestionsLbl.textColor = [UIColor colorNamed:@"21_49_91_1"];
        _commonQuestionsLbl.text = @"常见问题";
        _commonQuestionsLbl.font = [UIFont fontWithName:PingFangSCSemibold size:20];
    }
    return _commonQuestionsLbl;
}

- (UITableView *)table{
    if (!_table) {
        _table = [[UITableView alloc]initWithFrame:CGRectMake(0, Bar_H+65, SCREEN_WIDTH, 500)];
        _table.delegate = self;
        _table.dataSource = self;
        _table.backgroundColor = [UIColor colorNamed:@"248_249_252_1"];
        _table.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return _table;
}

- (UIButton *)feedBackEntranceBtn{
    if (!_feedBackEntranceBtn) {
        _feedBackEntranceBtn = [[UIButton alloc]init];
        _feedBackEntranceBtn.size = CGSizeMake(155, 39);
        _feedBackEntranceBtn.centerX = self.view.centerX;
        _feedBackEntranceBtn.y = 0.733*SCREEN_HEIGHT+Bar_H;
        [_feedBackEntranceBtn setImage:[UIImage imageNamed:@"Entrance"] forState:UIControlStateNormal];
        [_feedBackEntranceBtn addTarget:self action:@selector(entrance) forControlEvents:UIControlEventTouchUpInside];
    }
    return _feedBackEntranceBtn;
}
- (HintView *)hintView{
    if (!_hintView) {
        _hintView = [[HintView alloc]init];
        _hintView.size = CGSizeMake(202, 15);
        _hintView.y = 0.82*SCREEN_HEIGHT+Bar_H;
        _hintView.centerX = self.view.centerX;
    }
    return _hintView;
}


#pragma mark - Table数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    return cell;
}

#pragma mark - 私有方法
- (void)setupBar{
    self.view.backgroundColor = [UIColor colorNamed:@"248_249_252_1"];
    self.VCTitleStr = @"意见与反馈";
    self.topBarView.backgroundColor = [UIColor colorNamed:@"248_249_252_1"];
    self.splitLineColor = [UIColor systemGray5Color];
    self.titlePosition = TopBarViewTitlePositionLeft;
    self.titleFont = [UIFont fontWithName:PingFangSCBold size:21];
}
- (void)entrance{
    NSLog(@"正在进入意见与反馈");
}
@end
