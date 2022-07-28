//
//  SearchBeginVC.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/1/25.
//  Copyright © 2021 Redrock. All rights reserved.
//

//工具类
#import "SZHArchiveTool.h"      //网络请求缓存数据
#import "PostArchiveTool.h"

#import "SearchBeginVC.h"
#import "SearchBeiginView.h"
#import "SZHSearchTableViewCell.h"

#import "SZHSearchDataModel.h"
#import "SearchEndNoResultCV.h"     //搜索无结果cv
#import "SZHSearchEndCv.h"
#import "QASearchResultVC.h"    //搜索结果VC

@interface SearchBeginVC ()<SearchTopViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,SZHHotSearchViewDelegate,SZHSearchTableViewCellDelegate>
/// 上半部分视图
@property (nonatomic, strong) SearchBeiginView *searchBeginTopView;

///请求数据的model
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

/// 热门搜索的临时变量btn
@property (nonatomic, strong) UIButton *tempBtn;

@property (nonatomic, assign) BOOL getDynamicFailure;   //获取动态失败
@property (nonatomic, assign) BOOL getKnowledgeFailure; //获取知识库失败
@end

@implementation SearchBeginVC
#pragma mark- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化设置
    self.searchDynamicDic = nil;
    self.searchKnowledgeDic = nil;
    
    [self setTopFrame];
    self.view.backgroundColor = self.searchBeginTopView.backgroundColor;
//
    self.historyRecordsAry = [NSMutableArray array];
    NSMutableArray *array = [[NSUserDefaults.standardUserDefaults objectForKey:@"historyRecords"] mutableCopy];
    if (array != nil) {
        self.historyRecordsAry = array;
    }
    //如果有历史记录就添加下半部分视图，否则就不添加
    if (self.historyRecordsAry.count != 0) {
        [self setBottomView];
    }
//   
    //网络请求热搜列表并归档
    [self.searchDataModel getHotArayWithProgress:^(NSArray * _Nonnull ary) {
        [SZHArchiveTool saveHotWordsList:ary];
        NSLog(@"成功解档-----%@",[SZHArchiveTool getHotWordsListAry]);
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

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.tabBarController.tabBar.hidden = NO;
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
    [NSUserDefaults.standardUserDefaults setObject:self.historyRecordsAry forKey:@"historyRecords"];
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
        [NewQAHud showHudWith:@"输入为空" AddView:self.view];
        return;                 //直接返回
    }
    
    //2.内容不为空
    [NewQAHud showHudWith:@"  加载中  " AddView:self.view];
    /*
     进行网络请求获取数据
     先将搜索帖子和搜索知识库的网络请求全部获取后再进行后续逻辑判断
    */
    self.getDynamicFailure = NO;
    self.getKnowledgeFailure = NO;
    __weak typeof(self)weakSelf = self;
    //请求相关动态
    [self.searchDataModel getSearchDynamicWithStr:searchString Success:^(NSDictionary * _Nonnull dynamicDic) {
        weakSelf.searchDynamicDic = dynamicDic;
        [weakSelf processData:searchString];
        } Failure:^{
            weakSelf.getDynamicFailure = YES;
            weakSelf.searchDynamicDic = [NSDictionary dictionary];
            [weakSelf processData:searchString];
        }];
    //请求帖子
    [self.searchDataModel getSearchKnowledgeWithStr:searchString Success:^(NSDictionary * _Nonnull knowledgeDic) {
        weakSelf.searchKnowledgeDic = knowledgeDic;
        [weakSelf processData:searchString];
        } Failure:^{
            weakSelf.getKnowledgeFailure = YES;
            weakSelf.searchKnowledgeDic = [NSDictionary dictionary];
            [weakSelf processData:searchString];
        }];

    //清除缓存
    self.searchDynamicDic = nil;
    self.searchKnowledgeDic = nil;
    
    //设置热搜按钮可用
    if (self.tempBtn != nil) {
        self.tempBtn.enabled = YES;
    }
    //3.添加历史记录
    [self wirteHistoryRecord:searchString];
}

#pragma mark- private methods
//添加历史记录
- (void)wirteHistoryRecord:(NSString *)string{
        //如果是第一次，直接添加到UserDefaults里面
    if (self.historyRecordsAry.count == 0) {
        [self.historyRecordsAry addObject:string];
        [NSUserDefaults.standardUserDefaults setObject:_historyRecordsAry forKey:@"historyRecords"];
        
        //此时已经有历史记录，添加下半部分视图
            //延迟0.5秒后执行
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setBottomView];
        });
    }
    else{
        //1.如果不是第一次，那么先获取到之前的数组，从缓存取出来后要mutableCopy一下，不然会崩
        NSMutableArray *array = [[NSUserDefaults.standardUserDefaults objectForKey:@"historyRecords"] mutableCopy];
        //2.判断是否和以前的搜索内容一样，如果一样就移除旧的历史记录
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
        //4.重新添加到UserDefalut里面
        self.historyRecordsAry = array;
        [NSUserDefaults.standardUserDefaults setObject:self.historyRecordsAry forKey:@"historyRecords"];
        
        //5.刷新table
        [self.historyTable reloadData];
        NSLog(@"%@",array);
    }
}
/// 刷新历史记录表格
- (void)reloadHistoryRecord{
    self.historyRecordsAry = [NSUserDefaults.standardUserDefaults objectForKey:@"historyRecords"];
    [self.historyTable reloadData];
}
/// 处理网络请求的数据，进行逻辑判断跳转界面
- (void)processData:(NSString *)str{
    //如果两个返回的response均有值，则可进行逻辑判断，否则直接返回
    if (self.searchDynamicDic == nil || self.searchKnowledgeDic == nil) {
        return;
    }else{
        //1.无网络连接
        if (self.getKnowledgeFailure == YES && self.getDynamicFailure == YES) {
            [NewQAHud showHudWith:@"无网络连接" AddView:self.view];
            return;
        }
        //2.有网络连接
        NSDictionary *dynamicDic = self.searchDynamicDic;
        NSDictionary *knowledgeDic = self.searchKnowledgeDic;
        NSArray *dynamicAry = dynamicDic[@"data"];
        NSArray *knowledgeAry = knowledgeDic[@"data"];
            //2.1加载提示
        [NewQAHud showHudWith:@"  加载中  " AddView:self.view];
    
            //2.1无搜索内容，跳转到搜索无结果页
        if (dynamicAry.count == 0 && knowledgeAry.count == 0) {
            SearchEndNoResultCV *vc = [[SearchEndNoResultCV alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else{//2.2 有搜索内容进行赋值，跳转到搜索结果页
            SZHSearchEndCv *vc = [[SZHSearchEndCv alloc] init];
            vc.tableDataAry = dynamicAry;
            vc.knowlegeAry = knowledgeAry;
            vc.searchStr = str;
//            QASearchResultVC *vc = [[QASearchResultVC alloc] init];
            //暂时砍掉知识库
            vc.knowlegeAry = knowledgeAry;
//            vc.searchStr = str;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
}
//添加上半部分视图
- (void)setTopFrame{
    [self.view addSubview:self.searchBeginTopView];
    [self.searchBeginTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo([self.searchBeginTopView searchBeginViewHeight]);
    }];
}
///添加下半部分视图
-  (void)setBottomView{
    //历史记录的label
    [self.view addSubview:self.historyLabel];
    [self.historyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBeginTopView.mas_bottom).offset(MAIN_SCREEN_H * 0.0374);
        make.left.equalTo(self.view).offset(MAIN_SCREEN_W * 0.0426);
    }];
    
    //清除历史按钮
    [self.view addSubview:self.clearAllHistoryRecordbtn];
    [self.clearAllHistoryRecordbtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-MAIN_SCREEN_W * 0.0426);
        make.bottom.equalTo(self.historyLabel);
        make.height.mas_equalTo(15.5);
    }];

    //历史记录的table
    [self.view addSubview:self.historyTable];
    [self.historyTable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.historyLabel);
        make.top.equalTo(self.historyLabel.mas_bottom).offset(MAIN_SCREEN_H * 0.0352);
        make.right.equalTo(self.clearAllHistoryRecordbtn);
        make.bottom.equalTo(self.view);
    }];
}

#pragma mark- delegate
//MARK:上半部分视图的代理方法以及UITextfield的代理方法
- (void)jumpBack{
    [self.navigationController popViewControllerAnimated:YES];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"reSetTopFollowUI" object:nil];
}
///点击搜索后执行操作
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];                 //收回键盘
    [self searchWithString:textField.text];
    return YES;
}

//MARK:热门搜索视图的代理方法
- (void)touchHotSearchBtnsThroughBtn:(UIButton *)btn{
    NSString *string = btn.titleLabel.text;
    self.tempBtn = btn;
    self.tempBtn.enabled = NO; //设置此按钮禁用
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
    [NSUserDefaults.standardUserDefaults setObject:self.historyRecordsAry forKey:@"historyRecords"];
    [self.historyTable reloadData];
    
    NSLog(@"删除该cell");
}

//MARK:TableViewDelegate
//当历史记录cell被点中时，进行数据请求
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self searchWithString:self.historyRecordsAry[indexPath.row]];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
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
- (SZHSearchDataModel *)searchDataModel{
    if (_searchDataModel == nil) {
        _searchDataModel = [[SZHSearchDataModel alloc] init];
    }
    return _searchDataModel;
}

- (SearchBeiginView *)searchBeginTopView{
    if (!_searchBeginTopView) {
        _searchBeginTopView = [[SearchBeiginView alloc] initWithString:@"热门搜索"];
        //设置顶部搜索视图的代理
        _searchBeginTopView.searchTopView.delegate = self;
        _searchBeginTopView.hotSearchView.delegate = self;
        
        _searchBeginTopView.userInteractionEnabled = YES;
        //设置键盘的返回键为搜索的样式
        UITextField *textfield = _searchBeginTopView.searchTopView.searchTextfield;
        textfield.delegate = self;
        [textfield setReturnKeyType:UIReturnKeySearch];
        
        //设置热搜词汇
        NSMutableArray *muteAry = [NSMutableArray arrayWithArray:[PostArchiveTool getHotWords].hotWordsArray];
        _searchBeginTopView.searchTopView.placeholderArray = muteAry;
        
        //设置热搜列表
        _searchBeginTopView.hotSearchView.buttonTextAry = [SZHArchiveTool getHotWordsListAry];
        [_searchBeginTopView.hotSearchView updateBtns];
        [_searchBeginTopView updateHotSearchViewFrame];
       
        //如果热搜列表无缓存，网络请求之后再归档
        if (_searchBeginTopView.hotSearchView.buttonTextAry.count == 0) {
            //model与View的数据支持
            [self.searchDataModel getHotArayWithProgress:^(NSArray * _Nonnull ary) {
                //赋值
                self->_searchBeginTopView.hotSearchView.buttonTextAry = ary;
                [self->_searchBeginTopView.hotSearchView updateBtns];
                //缓存
                [SZHArchiveTool saveHotWordsList:ary];
            }];
        }
    }
    return _searchBeginTopView;
}

//显示历史记录的table
- (UITableView *)historyTable{
    if (!_historyTable) {
        _historyTable = [[UITableView alloc] initWithFrame:CGRectZero];
        _historyTable.backgroundColor = [UIColor clearColor];
        [_historyTable setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
        _historyTable.showsHorizontalScrollIndicator = NO;
        _historyTable.showsVerticalScrollIndicator = NO;
        _historyTable.delegate = self;
        _historyTable.dataSource = self;
        //设置tableView可以被选中，如果不设置的话，点击cell无反应
        _historyTable.allowsSelection = YES;
    }
    return _historyTable;
}

//历史记录的label
- (UILabel *)historyLabel{
    if (!_historyLabel) {
        _historyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _historyLabel.font = [UIFont fontWithName:PingFangSCBold size:18];
        _historyLabel.text = @"历史记录";
        if (@available(iOS 11.0, *)) {
            _historyLabel.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
        } else {
            // Fallback on earlier versions
        }
    }
    return _historyLabel;
}

//清除历史记录按钮
- (UIButton *)clearAllHistoryRecordbtn{
    if (!_clearAllHistoryRecordbtn) {
        //清除历史记录按钮
        _clearAllHistoryRecordbtn = [[UIButton alloc] init];
        [_clearAllHistoryRecordbtn setTitle:@"清除全部" forState:UIControlStateNormal];
        if (@available(iOS 11.0, *)) {
            [_clearAllHistoryRecordbtn setTitleColor:[UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#93A3BF" alpha:1] darkColor:[UIColor colorWithHexString:@"#838384" alpha:1]] forState:UIControlStateNormal];
        } else {
            // Fallback on earlier versions
        }
        _clearAllHistoryRecordbtn.titleLabel.font = [UIFont fontWithName:PingFangSCMedium size:16];
        [_clearAllHistoryRecordbtn addTarget:self action:@selector(clearAllrecords) forControlEvents:UIControlEventTouchUpInside];
        //button宽度随title字数自适应
        _clearAllHistoryRecordbtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _clearAllHistoryRecordbtn;
}

@end
