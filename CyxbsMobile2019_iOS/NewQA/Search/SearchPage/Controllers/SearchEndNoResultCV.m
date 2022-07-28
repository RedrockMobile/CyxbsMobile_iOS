//
//  SearchEndNoResultCV.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/1/27.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "SearchEndNoResultCV.h"
#import "SearchTopView.h"               //顶部的搜索视图
#import "SZHReleaseDynamic.h"
#import "SZHSearchEndCv.h"              //搜索结果界面
#import "SZHSearchDataModel.h"          //搜索模型
@interface SearchEndNoResultCV ()<SearchTopViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong) SearchTopView *searchTopView;

/// 屏幕正中间的图片
@property (nonatomic, strong) UIImageView *centerImageView;

///无相关内容的label
@property (nonatomic, strong) UILabel *NoContentlabel;

/// 去提问的button
@property (nonatomic, strong) UIButton *askBtn;

@property (nonatomic, strong) SZHSearchDataModel *searchDataModel;
@property (nonatomic, strong) NSDictionary *searchDynamicDic;    //相关动态数组
@property (nonatomic, strong) NSDictionary *searchKnowledgeDic;    //知识库数组
@property (nonatomic, assign) BOOL getDynamicFailure;   //获取动态失败
@property (nonatomic, assign) BOOL getKnowledgeFailure; //获取知识库失败
@end

@implementation SearchEndNoResultCV
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化设置
    self.searchDynamicDic = nil;
    self.searchKnowledgeDic = nil;
    if (@available(iOS 11.0, *)) {
        self.view.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#F1F3F8" alpha:1] darkColor:[UIColor colorWithHexString:@"#000001" alpha:1]];
    } else {
        // Fallback on earlier versions
    }
    [self buildFrame];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.tabBarController.tabBar setHidden:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    //点属性设置不行，必须用set
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)buildFrame{
    //顶部搜索框
    [self.view addSubview:self.searchTopView];
    [self.searchTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_top).offset(NVGBARHEIGHT + STATUSBARHEIGHT);
        make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W, MAIN_SCREEN_H * 0.0462));
    }];
    
    //屏幕正中间的图片框
    [self.view addSubview:self.centerImageView];
    [self.centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(MAIN_SCREEN_W * 0.2227);
        make.top.equalTo(self.view).offset(MAIN_SCREEN_H * 0.2631);
        make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W * 0.5387, MAIN_SCREEN_H * 0.1964));
    }];
    
    //提示框
    [self.view addSubview:self.NoContentlabel];
    [self.NoContentlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerImageView);
        make.top.equalTo(self.centerImageView.mas_bottom).offset(MAIN_SCREEN_H * 0.0495);
        make.height.mas_equalTo(11.5);
    }];
    
    //提问按钮
    [self.view addSubview:self.askBtn];
    [self.askBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(MAIN_SCREEN_W * 0.3453);
        make.top.equalTo(self.centerImageView.mas_bottom).offset(MAIN_SCREEN_H * 0.1364);
    }];
}

#pragma mark-  event response
//到去提问页面
- (void)goAskPage{
    SZHReleaseDynamic *cv = [[SZHReleaseDynamic alloc] init];
    [self.navigationController pushViewController:cv animated:YES];
}

//设置点击空白处收回键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

///点击搜索后执行操作
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];                 //收回键盘
    [self searchWithString:textField.text];
    return YES;
}


#pragma mark- private methods
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
        [weakSelf processDataWithString:searchString];
        } Failure:^{
            weakSelf.getDynamicFailure = YES;
            weakSelf.searchDynamicDic = [NSDictionary dictionary];
            [weakSelf processDataWithString:searchString];
        }];
    //请求帖子
    [self.searchDataModel getSearchKnowledgeWithStr:searchString Success:^(NSDictionary * _Nonnull knowledgeDic) {
        weakSelf.searchKnowledgeDic = knowledgeDic;
        [weakSelf processDataWithString:searchString];
        } Failure:^{
            weakSelf.getKnowledgeFailure = YES;
            weakSelf.searchKnowledgeDic = [NSDictionary dictionary];
            [weakSelf processDataWithString:searchString];
        }];

    //清除缓存
    self.searchDynamicDic = nil;
    self.searchKnowledgeDic = nil;
    
    //3.添加历史记录
    [self wirteHistoryRecord:searchString];
}

/// 将搜索的内容添加到历史记录
/// @param string 搜索的内容
- (void)wirteHistoryRecord:(NSString *)string{
    //1.取出userDefault的历史数组，从缓存中取出数组的时候要mutablyCopy一下，不然会崩溃
    NSMutableArray *array = [[NSUserDefaults.standardUserDefaults objectForKey:@"historyRecords"] mutableCopy];
    
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
    [NSUserDefaults.standardUserDefaults setObject:array forKey:@"historyRecords"];
    
    //5.发出通知，在搜索开始页去刷新历史记录（在willAppear里面调用）
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadHistory" object:nil];
}

/// 处理网络请求的数据，进行逻辑判断跳转界面
- (void)processDataWithString:(NSString *)str{
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
//        NSArray *knowledgeAry = self.knowledgeDic[@"data"];
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
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
}

#pragma mark- delegate
- (void)jumpBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- getter
- (SearchTopView *)searchTopView{
    if (_searchTopView == nil) {
        _searchTopView = [[SearchTopView alloc] init];
        _searchTopView.delegate = self;             //设置代理
        _searchTopView.searchTextfield.delegate = self;
        [_searchTopView.searchTextfield setReturnKeyType:UIReturnKeySearch];
    }
    return _searchTopView;
}

- (UIImageView *)centerImageView{
    if (_centerImageView == nil) {
        self.centerImageView = [[UIImageView alloc] init];
        _centerImageView.image = [UIImage imageNamed:@"人在手机里"];
    }
    return _centerImageView;
}

- (UILabel *)NoContentlabel{
    if (_NoContentlabel == nil) {
        _NoContentlabel = [[UILabel alloc] init];
        _NoContentlabel.text = @"没有相关内容哦～";
        _NoContentlabel.font = [UIFont fontWithName:PingFangSCMedium size:12];
        if (@available(iOS 11.0, *)) {
            _NoContentlabel.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#556C89" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
        } else {
            // Fallback on earlier versions
        }
    }
    return _NoContentlabel;
}

- (UIButton *)askBtn{
    if (_askBtn == nil) {
        _askBtn = [[UIButton alloc] init];
        [_askBtn setBackgroundImage:[UIImage imageNamed:@"去提问按钮的背景图片"] forState:UIControlStateNormal];
        [_askBtn setTitle:@"去提问" forState:UIControlStateNormal];
        _askBtn.titleLabel.font = [UIFont fontWithName:PingFangSCBold size:15];
        [_askBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_askBtn addTarget:self action:@selector(goAskPage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _askBtn;
}

- (SZHSearchDataModel *)searchDataModel{
    if (_searchDataModel == nil) {
        _searchDataModel = [[SZHSearchDataModel alloc] init];
    }
    return _searchDataModel;
}
@end
