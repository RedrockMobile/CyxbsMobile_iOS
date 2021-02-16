//
//  SZHSearchEndCv.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/1/27.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "SZHSearchEndCv.h"
#import "SearchEndNoResultCV.h" //搜索无结果vc
#import "SZHSearchDataModel.h"  //搜索模型
#import "SearchBeiginView.h"    //本界面上半部分
#import "RecommendedTableView.h"//下半部分相关动态表格
#import "PostTableViewCell.h"   //相关动态表格cell
#import "ReportView.h"          //举报界面
#import "ShareView.h"           //分享界面
#import "FuncView.h"            //cell上的三个点点击后界面
@interface SZHSearchEndCv ()<UITextFieldDelegate,SearchTopViewDelegate,SZHHotSearchViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) SearchBeiginView *searchEndTopView;   //上半部分视图
    ///顶部搜索逻辑相关
@property (nonatomic, strong) SZHSearchDataModel *searchDataModel;
@property (nonatomic, strong) NSDictionary *searchDynamicDic;    //相关动态数组
@property (nonatomic, strong) NSDictionary *searchKnowledgeDic;    //知识库数组
@property (nonatomic, assign) BOOL getDynamicFailure;   //获取动态失败
@property (nonatomic, assign) BOOL getKnowledgeFailure; //获取知识库失败


///下半部分视图相关
    ///视图
@property(nonatomic, strong) UILabel *relevantDynamicLbl;   //相关动态标题
@property (nonatomic, strong) RecommendedTableView *relevantDynamicTable;   //展示相关动态的表格
@property (nonatomic, strong) FuncView *popView;    //多功能View（点击cell上的三个小点后出来的view）
@property (nonatomic, strong) ReportView *reportView;   //举报页面
@property (nonatomic, strong) ShareView *shareView; //分享页面
    ///模型相关
@property (nonatomic, assign) NSInteger page;   //列表分页展示


@end

@implementation SZHSearchEndCv

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addSearchEndTopView];
    //如果数据源数组为空，无数据，则不展示下半部分页面
//    if (self.tableDataAry.count == 0) {
        [self addSearchEndBottomView];
//    }
    
  
}

#pragma mark- event response
/// 点击搜索按钮之后去进行的逻辑操作
/// @param searchString 搜索的文本
- (void)searchWithString:(NSString *)searchString{
    //1.如果内容为空仅提示
    if ([searchString isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud setMode:(MBProgressHUDModeText)];
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

#pragma mark- private methonds
/// 将搜索的内容添加到历史记录
/// @param string 搜索的内容
- (void)wirteHistoryRecord:(NSString *)string{
    //1.取出userDefault的历史数组
    NSUserDefaults *userdefaulte = [NSUserDefaults standardUserDefaults];
        //从缓存中取出数组的时候要mutablyCopy一下，不然会崩溃
    NSMutableArray *array = [[userdefaulte objectForKey:@"historyRecords"] mutableCopy];
    
    //2.判断当前搜素内容是否与历史记录重合，如果重合就删除历史记录中原存在的数组
    for (NSString *historyStr in array) {
        if ([historyStr isEqualToString:string]) {
            [array removeObject:historyStr];        //从数组中移除
            break;                                  //直接退出
        }
    }
    //3.将内容加入到历史记录数组里面
    [array insertObject:string atIndex:0];
    
    //4.将历史数组重新存入UserDefault
    [userdefaulte setObject:array forKey:@"historyRecords"];
    
    //5.发出通知，在搜索开始页去刷新历史记录（在willAppear里面调用）
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadHistory" object:nil];
}
/// 处理网络请求的数据，进行逻辑判断跳转界面
- (void)processData{
    //如果两个返回的response均有值，则可进行逻辑判断，否则直接返回
    if (self.searchDynamicDic == nil || self.searchKnowledgeDic == nil) {
        return;
    }else{
        //1.无网络连接
        if (self.getKnowledgeFailure == YES && self.getDynamicFailure == YES) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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

#pragma mark- 代理方法
//MARK:上半部分视图以及UITextField的代理方法
//返回上一界面
- (void)jumpBack{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
//点击重邮知识库后
- (void)touchCQUPTKonwledgeThroughBtn:(UIButton *)btn{
    NSString *str = btn.titleLabel.text;
    NSLog(@"点击重邮知识库---%@",str);
}
//点击搜索后执行
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    [self searchWithString:textField.text];
    return YES;
}

//MARK:相关动态table的数据源和代理方法
///数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableDataAry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //创建单元格（用复用池）
    ///给每一个cell的identifier设置为唯一的
    NSString *identifier = [NSString stringWithFormat:@"dynamicCell%ld",indexPath.row];
    PostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil) {
        PostItem *item = [[PostItem alloc] initWithDic:self.tableDataAry[indexPath.row]];
        //这里
        cell = [[PostTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.delegate = self;
        cell.item = item;
        cell.commendBtn.tag = indexPath.row;
        cell.shareBtn.tag = indexPath.row;
        cell.starBtn.tag = indexPath.row;
        cell.tag = indexPath.row;
        if (cell.tag == 0) {
            cell.layer.cornerRadius = 10;
        }
    }
    return cell;
}

#pragma mark- 添加界面控件
/// 添加上半部分视图
- (void)addSearchEndTopView{
    self.searchEndTopView = [[SearchBeiginView alloc] initWithString:@"重邮知识库"];
    //设置代理
    self.searchEndTopView.searchTopView.delegate = self;
    self.searchEndTopView.hotSearchView.delegate = self;
    self.searchEndTopView.searchTopView.searchTextfield.delegate = self;
    [ self.searchEndTopView.searchTopView.searchTextfield setReturnKeyType:UIReturnKeySearch];
    //设置frame
    [self.view addSubview:self.searchEndTopView];
    self.searchEndTopView.frame = self.view.frame;
}
/// 添加底部视图，主要为一个label和一个table
- (void)addSearchEndBottomView{
    //相关动态的label
    if (self.relevantDynamicLbl == nil) {
        self.relevantDynamicLbl = [[UILabel alloc] init];
        self.relevantDynamicLbl.text = @"相关动态";
        self.relevantDynamicLbl.font = [UIFont fontWithName:PingFangSCMedium size:18];
            //设置字体和背景颜色
        if (@available(iOS 11.0, *)) {
            self.relevantDynamicLbl.textColor = [UIColor colorNamed:@"SZHHotHistoryKnowledgeLblColor"];
            self.relevantDynamicLbl.backgroundColor = [UIColor colorNamed:@"QAMainPageBackGroudColor"];
        } else {
            // Fallback on earlier versions
        }
        [self.searchEndTopView addSubview:self.relevantDynamicLbl];
        [self.relevantDynamicLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.searchEndTopView).offset(MAIN_SCREEN_W * 0.0427);
            make.top.equalTo(self.searchEndTopView).offset(MAIN_SCREEN_H * 0.3613);
            make.height.mas_equalTo(17);
        }];
    }
    
    //相关动态的table
    if (self.relevantDynamicTable == nil) {
        self.relevantDynamicTable = [[RecommendedTableView alloc] init];
//        self.relevantDynamicTable.delegate = self;
//        self.relevantDynamicTable.dataSource = self;
        [self.view addSubview:self.relevantDynamicTable];
        [self.relevantDynamicTable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.searchEndTopView);
            make.top.equalTo(self.relevantDynamicLbl.mas_bottom).offset(MAIN_SCREEN_H * 0.0299);
        }];
    }
}

#pragma mark- getter
- (SZHSearchDataModel *)searchDataModel{
    if (_searchDataModel == nil) {
        _searchDataModel = [[SZHSearchDataModel alloc] init];
    }
    return _searchDataModel;
}
@end
