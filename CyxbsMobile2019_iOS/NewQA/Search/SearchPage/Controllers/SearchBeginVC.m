//
//  SearchBeginVC.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/1/25.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "SearchBeginVC.h"
#import "SearchBeiginView.h"
#import "SZHSearchDataModel.h"
#import "SZHSearchTableViewCell.h"
#import "SearchEndNoResultCV.h"     //搜索无结果cv
#import "SZHSearchEndCv.h"
@interface SearchBeginVC ()<SearchTopViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,SZHHotSearchViewDelegate,SZHSearchTableViewCellDelegate>
/// 上半部分视图
@property (nonatomic, strong) SearchBeiginView *searchBeginTopView;

@property (nonatomic, strong) SZHSearchDataModel *searchDataModel;

/// 历史记录的label
@property (nonatomic, strong) UILabel *historyLabel;

/// 清除所有历史记录的按钮
@property (nonatomic, strong) UIButton *clearAllHistoryRecordbtn;

/// 显示历史记录的table
@property (nonatomic, strong) UITableView *historyTable;

/// 保存的历史记录文本
@property (nonatomic, strong) NSMutableArray *historyRecordsAry;

@property (nonatomic, strong) NSDictionary *searchDynamicDic;    //相关动态数组
@property (nonatomic, strong) NSDictionary *searchKnowledgeDic;    //知识库数组
@property (nonatomic, assign) BOOL getDynamicFailure;   //获取动态失败
@property (nonatomic, assign) BOOL getKnowledgeFailure; //获取知识库失败
@end

@implementation SearchBeginVC
#pragma mark- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.historyRecordsAry = [NSMutableArray array];
    NSMutableArray *array = [[[NSUserDefaults standardUserDefaults] objectForKey:@"historyRecords"] mutableCopy];
    if (array != nil) {
        _historyRecordsAry = array;
    }
    //如果有历史记录就添加下半部分视图，否则就不添加
    if (self.historyRecordsAry.count != 0) {
        [self addSearchBottomView];
    }
    
    //model与View的数据支持
    [self.searchDataModel getHotArayWithProgress:^(NSArray * _Nonnull ary) {
        self.searchBeginTopView.hotSearchView.buttonTextAry = ary;
        [self.searchBeginTopView.hotSearchView updateBtns];
    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HideBottomClassScheduleTabBarView" object:nil userInfo:nil];
    
    //接收到搜索无结果页、搜索结果页的通知，刷新历史记录的table
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadHistoryRecord) name:@"reloadHistory" object:nil];
}

//进行控件布局
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    //上半部分视图
    [self.view addSubview:self.searchBeginTopView];
    self.searchBeginTopView.frame = self.view.frame;
    
}

#pragma mark- event response
//设置点击空白处收回键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

//点击清除所有按钮清除所有历史记录
- (void)clearAllrecords{
    //1.先清除历史数组
//    [self.historyRecordsAry removeAllObjects];
    NSMutableArray *array = [NSMutableArray array];
    self.historyRecordsAry = array;
    //2；再清除缓存数组
    NSUserDefaults *dfl = [NSUserDefaults standardUserDefaults];
    [dfl setObject:self.historyRecordsAry forKey:@"historyRecords"];
    //3.移除表格
    [self.historyTable removeFromSuperview];
    [self.historyLabel removeFromSuperview];
    [self.clearAllHistoryRecordbtn removeFromSuperview];
    NSLog(@"已经点击清除按钮");
}



/// 点击搜索按钮之后去进行的逻辑操作
/// @param searchString 搜索的文本
- (void)searchWithString:(NSString *)searchString{
    //1.如果内容为空仅提示
    if ([searchString isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.searchBeginTopView animated:YES];
        [hud setMode:(MBProgressHUDModeText)];
//        hud.label.text = @"输入为空";
        hud.labelText = @"输入为空";
        [hud hide:YES afterDelay:1];  //延迟一秒后消失
        return;                 //直接返回
    }
    
    //2.内容不为空
    /*
     进行网络请求获取数据
     先将搜索帖子和搜索知识库的网络请求全部获取后再进行后续逻辑判断
    */
    self.getDynamicFailure = NO;
    self.getKnowledgeFailure = NO;
    __weak typeof(self)weakSelf = self;
    //请求相关动态
    [self.searchDataModel getSearchDynamicWithStr:@"test" Sucess:^(NSDictionary * _Nonnull dynamicDic) {
        weakSelf.searchDynamicDic = dynamicDic;
        [weakSelf processData];
        } Failure:^{
            weakSelf.getDynamicFailure = YES;
            [weakSelf processData];
        }];
    //请求帖子
    [self.searchDataModel getSearchKnowledgeWithStr:@"test" Sucess:^(NSDictionary * _Nonnull knowledgeDic) {
        weakSelf.searchKnowledgeDic = knowledgeDic;
        [weakSelf processData];
        } Failure:^{
            weakSelf.getKnowledgeFailure = YES;
            [weakSelf processData];
        }];
    
    //清除缓存
    self.searchDynamicDic = nil;
    self.searchKnowledgeDic = nil;
    
    //3.添加历史记录
    [self wirteHistoryRecord:searchString];
}

#pragma mark- private methods
/// 添加下半部分视图，如果有历史记录就展示，否则就不展示
- (void)addSearchBottomView{
    //历史记录按钮
    _historyLabel = [[UILabel alloc] init];
    _historyLabel.font = [UIFont fontWithName:PingFangSCMedium size:18];
    _historyLabel.text = @"历史记录";
    if (@available(iOS 11.0, *)) {
        _historyLabel.textColor = [UIColor colorNamed:@"SZHHotHistoryKnowledgeLblColor"];
    } else {
        // Fallback on earlier versions
    }
    [self.searchBeginTopView addSubview:self.historyLabel];
    [self.historyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBeginTopView).offset(MAIN_SCREEN_H * 0.3613);
        make.left.equalTo(self.searchBeginTopView).offset(MAIN_SCREEN_W * 0.0426);
        make.height.mas_equalTo(17);
    }];

    //清除历史记录按钮
    _clearAllHistoryRecordbtn = [[UIButton alloc] init];
    [_clearAllHistoryRecordbtn setTitle:@"清除全部" forState:UIControlStateNormal];
    if (@available(iOS 11.0, *)) {
        [_clearAllHistoryRecordbtn setTitleColor:[UIColor colorNamed:@"SZHClearBtnTextColor"] forState:UIControlStateNormal];
    } else {
        // Fallback on earlier versions
    }
    _clearAllHistoryRecordbtn.titleLabel.font = [UIFont fontWithName:PingFangSCMedium size:16];
    [_clearAllHistoryRecordbtn addTarget:self action:@selector(clearAllrecords) forControlEvents:UIControlEventTouchUpInside];
    //button宽度随title字数自适应
    _clearAllHistoryRecordbtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.searchBeginTopView addSubview:self.clearAllHistoryRecordbtn];
    [self.clearAllHistoryRecordbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.searchBeginTopView.mas_right).offset(-MAIN_SCREEN_W * 0.0426);
        make.bottom.equalTo(self.historyLabel);
        make.height.mas_equalTo(15.5);
    }];

    //显示历史记录的table
    _historyTable = [[UITableView alloc] init];
    _historyTable.backgroundColor = [UIColor clearColor];
    [_historyTable setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
    _historyTable.showsHorizontalScrollIndicator = NO;
    _historyTable.showsVerticalScrollIndicator = NO;
    _historyTable.allowsSelection = NO;
    _historyTable.delegate = self;
    _historyTable.dataSource = self;
    //设置tableView可以被选中，如果不设置的话，点击cell无反应
    _historyTable.allowsSelection = YES;
    [self.searchBeginTopView addSubview:self.historyTable];
    [self.historyTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.historyLabel);
        make.top.equalTo(self.historyLabel.mas_bottom).offset(MAIN_SCREEN_H * 0.04);
        make.right.equalTo(self.clearAllHistoryRecordbtn);
        make.bottom.equalTo(self.searchBeginTopView);
    }];

}

//添加历史记录
- (void)wirteHistoryRecord:(NSString *)string{
        //如果是第一次，直接添加到UserDefaults里面
    if (self.historyRecordsAry.count == 0) {
        [self.historyRecordsAry addObject:string];
        NSUserDefaults *defaluts = [NSUserDefaults standardUserDefaults];
        [defaluts setObject:_historyRecordsAry forKey:@"historyRecords"];
        
        //此时已经有历史记录，添加下半部分视图
            //延迟0.5秒后执行
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self addSearchBottomView];
        });
    }
    else{
        //1.如果不是第一次，那么先获取到之前的数组
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        //2.从缓存取出来后要mutableCopy一下，不然会崩
        NSMutableArray *array = [[defaults objectForKey:@"historyRecords"] mutableCopy];
        //3.判断是否和以前的搜索内容一样，如果一样就移除旧的历史记录
        for (NSString *historyStr in array) {
            if ([historyStr isEqualToString:string]) {
                [array removeObject:historyStr];
                break;
            }
        }
        [array insertObject:string atIndex:0];
        //3.如果超出了最大容纳量（10）,则清除掉最后一条数据
        if (array.count > 10) {
            [array removeLastObject];
        }
        //5.重新添加到UserDefalut里面
        self.historyRecordsAry = array;
        [defaults setObject:self.historyRecordsAry forKey:@"historyRecords"];
        
        //6.刷新table
        [self.historyTable reloadData];
        NSLog(@"%@",array);
    }
}

/// 刷新历史记录表格
- (void)reloadHistoryRecord{
    self.historyRecordsAry = [[NSUserDefaults standardUserDefaults] objectForKey:@"historyRecords"];
    [self.historyTable reloadData];
}

/// 处理网络请求的数据，进行逻辑判断跳转界面
- (void)processData{
    //如果两个返回的response均有值，则可进行逻辑判断，否则直接返回
    if (self.searchDynamicDic == nil || self.searchKnowledgeDic == nil) {
        return;
    }else{
        //1.无网络连接
        if (self.getKnowledgeFailure == YES && self.getDynamicFailure == YES) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.searchBeginTopView animated:YES];
            [hud setMode:MBProgressHUDModeText];
            hud.labelText = @"无网络连接";
            [hud hide:YES afterDelay:1];  //延迟一秒后消失
            return;
        }
        //2.有网络连接
        NSDictionary *dynamicDic = self.searchDynamicDic;
        NSDictionary *knowledgeDic = self.searchKnowledgeDic;
        NSArray *dynamicAry = dynamicDic[@"data"];
        NSArray *knowledgeAry = knowledgeDic[@"data"];
//        NSArray *knowledgeAry = self.knowledgeDic[@"data"];
            //2.1加载提示
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.searchBeginTopView animated:YES];
        [hud setMode:MBProgressHUDModeText];
        hud.labelText = @"加载中";
        [hud hide:YES afterDelay:1];  //延迟一秒后消失
    
            //2.1无搜索内容，跳转到搜索无结果页
        if (dynamicAry == nil && knowledgeAry == nil) {
            SearchEndNoResultCV *vc = [[SearchEndNoResultCV alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else{//2.2 有搜索内容进行赋值，跳转到搜索结果页
            SZHSearchEndCv *vc = [[SZHSearchEndCv alloc] init];
//            vc.tableDataAry = dynamicAry;
//            vc.knowlegeAry = knowledgeAry;
            [self.navigationController pushViewController:vc animated:YES];
            NSLog(@"跳转时搜索帖子-----%@",dynamicAry);
            NSLog(@"跳转时搜索知识库-----%@",knowledgeAry);
        }
    }
    
}

#pragma mark- delegate
//MARK:上半部分视图的代理方法以及UITextfield的代理方法
- (void)jumpBack{
    [self.navigationController popViewControllerAnimated:YES];
}
///点击搜索后执行操作
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];                 //收回键盘
    [self searchWithString:textField.text];
    return YES;
}

//MARK:热门搜索视图
- (void)touchHotSearchBtnsThroughBtn:(UIButton *)btn{
    NSString *string = btn.titleLabel.text;
    [self searchWithString:string];
}

//MARK:历史记录cell的代理方法
/// 删除当前cell
/// @param string 当前cell的string
- (void)deleteHistoryCellThroughString:(NSString *)string{
//    NSLog(@"删除该cell %@",string);
    //1.删除历史记录数组中的数据
    NSMutableArray *copyarray = [self.historyRecordsAry mutableCopy];
    for ( NSString *cellString in copyarray) {
        if ([string isEqualToString:cellString]) {
            [copyarray removeObject:cellString];
            self.historyRecordsAry = copyarray;
            [self.historyTable reloadData];
            break;
        }
    }
    //2.删除储存在本地的历史记录
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    [userdef setObject:self.historyRecordsAry forKey:@"historyRecords"];
    [self.historyTable reloadData];
    
    NSLog(@"删除该cell");
}

//MARK:TableViewDelegate
//当历史记录cell被点中时，进行数据请求
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self searchWithString:_historyRecordsAry[indexPath.row]];
}


#pragma mark- 表格的数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.historyRecordsAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SZHSearchTableViewCell *cell = [[SZHSearchTableViewCell alloc] initWithString:self.historyRecordsAry[indexPath.row]];
    //设置cell的选中样式为无
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    return cell;
}




#pragma mark- getter
- (SearchBeiginView *)searchBeginTopView{
    if (_searchBeginTopView == nil) {
        _searchBeginTopView = [[SearchBeiginView alloc] initWithString:@"热门搜索"];
        //设置顶部搜索视图的代理
        _searchBeginTopView.searchTopView.delegate = self;
        _searchBeginTopView.hotSearchView.delegate = self;
        UITextField *textfield = _searchBeginTopView.searchTopView.searchTextfield;
        textfield.delegate = self;
        [textfield setReturnKeyType:UIReturnKeySearch];
        
    }
    return _searchBeginTopView;
}
- (SZHSearchDataModel *)searchDataModel{
    if (_searchDataModel == nil) {
        _searchDataModel = [[SZHSearchDataModel alloc] init];
    }
    return _searchDataModel;
}

@end
