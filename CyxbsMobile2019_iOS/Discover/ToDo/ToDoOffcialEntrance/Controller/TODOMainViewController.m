//
//  TODOMainViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/8/22.
//  Copyright © 2021 Redrock. All rights reserved.
//

//controllers
#import "TODOMainViewController.h"

//Model
#import "TodoDataModel.h"

//Views
#import "ToDoMainBarView.h"
#import "ToDoTableView.h"

@interface TODOMainViewController ()<ToDoMainBarViewDelegate,UITableViewDelegate>
/// 顶层的View
@property (nonatomic, strong) ToDoMainBarView *barView;
/// 放置事项的table
@property (nonatomic, strong) ToDoTableView *tableView;
/// 数据源数组
@property (nonatomic, strong) NSMutableArray *dataSourceAry;

/// 是否折叠
@property (nonatomic, assign) BOOL isFold;
@end

@implementation TODOMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorNamed:@"255_255_255&0_0_0"];
    self.dataSourceAry = [NSMutableArray arrayWithArray:@[@[],@[]]];
    self.isFold = NO;
    [self setFrame];
    // Do any additional setup after loading the view.
}

#pragma mark- private methonds
- (void)setFrame{
    //顶部的bar
    [self.view addSubview:self.barView];
    [self.barView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_top).offset(NVGBARHEIGHT + STATUSBARHEIGHT);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT * 0.0637));
    }];
    
    //下面的table
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.barView.mas_bottom);
    }];
}

#pragma mark- event methonds
- (void)foldAction{
    NSLog(@"已经折叠");
    self.isFold = !self.isFold;
    self.tableView.isFoldTwoSection = self.isFold;
    [self.tableView reloadData];
}

#pragma mark- Delegate
//MARK:顶部bar的代理方法
/// 返回到上一界面
- (void)popVC{
    [self.navigationController popViewControllerAnimated:YES];
}
/// 添加待办事项
- (void)addMatter{
    NSLog(@"已经添加待办事项");
}

//MARK:UITableViewDelegate
///组头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView* firstview = [[UIView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH, 60.0)];
        UILabel *toDoLbl = [[UILabel alloc] initWithFrame:CGRectMake(15,30,50,34)];
        toDoLbl.font = [UIFont fontWithName:PingFangSCBold size:24];
        toDoLbl.textColor = [UIColor colorNamed:@"21_49_91&240_240_242"];
        toDoLbl.text = @"待办";
        [firstview addSubview:toDoLbl];
        return firstview;
    }else{
        UIView * secondview = [[UIView alloc] initWithFrame:CGRectMake(0,30, SCREEN_WIDTH,60.0)];
        //完成的label
        UILabel *doneLbl = [[UILabel alloc ]initWithFrame:CGRectMake(15,30,100,34) ];
        doneLbl.font = [UIFont fontWithName:PingFangSCBold size:24];
        doneLbl.textColor = [UIColor colorNamed:@"21_49_91&240_240_242"];
        doneLbl.text = @"已完成";
        [secondview addSubview:doneLbl];
        
        //折叠的按钮
        UIButton *foldBtn = [[UIButton alloc] initWithFrame:CGRectZero];;
        [foldBtn setImage:[UIImage imageNamed:@"foldImage"] forState:(UIControlStateNormal)];
        [foldBtn addTarget:self action:@selector(foldAction) forControlEvents:(UIControlEventTouchUpInside)];
        foldBtn.imageView.transform = !self.isFold ? CGAffineTransformIdentity :  CGAffineTransformMakeRotation(M_PI);
        [secondview addSubview:foldBtn];
        [foldBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(doneLbl);
            make.right.equalTo(secondview).offset(-SCREEN_WIDTH * 0.04);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.0533, SCREEN_WIDTH * 0.0266));
        }];
        
        return secondview;
    }
    return nil;
}
///cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *sectionAry = self.dataSourceAry[indexPath.section];
    if (sectionAry.count == 0) {
        return 220;
    }
    TodoDataModel *model = sectionAry[indexPath.row];
    if(model.timeStr.doubleValue > 0){
        return 110;
    }else{
        return 64;
    }
    return 0;
}
///组头视图高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 90;
    }else{
        return 60;
    }
    
}

#pragma mark- Getter
- (ToDoMainBarView *)barView{
    if (!_barView) {
        _barView = [[ToDoMainBarView alloc] initWithFrame:CGRectZero];
        _barView.delegate = self;
    }
    return _barView;
}

- (ToDoTableView *)tableView{
    if (!_tableView) {
        _tableView = [[ToDoTableView alloc] initWithFrame:CGRectZero];
        _tableView.delegate = self;
        _tableView.dataSourceAry = self.dataSourceAry;
    }
    return _tableView;
}


@end
