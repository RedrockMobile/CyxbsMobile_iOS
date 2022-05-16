//
//  JWZXNewsViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/2/8.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "JWZXNewsViewController.h"

#import "NewDetailViewController.h"

#import "SSRTopBarBaseView.h"
#import "JWZXNewsCell.h"
#import "JWZXNewsModel.h"

#pragma mark - NewsViewController ()

@interface JWZXNewsViewController () <
    UITableViewDelegate,
    UITableViewDataSource
>

/// 干掉系统的topView
@property (nonatomic, strong) SSRTopBarBaseView *topView;

/// 教务新闻视图
@property (nonatomic, strong) UITableView *jwzxNewsTableView;

/// 教务在线模型（需要进一步确认逻辑，避免两次请求）
@property (nonatomic, strong) JWZXNewsModel *jwzxNewsModel;

@end

#pragma mark - NewsViewController

@implementation JWZXNewsViewController

#pragma mark - Life cycle

- (instancetype)initWithRootJWZXSectionModel:(JWZXSectionNews *)rootModel {
    self = [super init];
    if (self) {
        self.jwzxNewsModel = [[JWZXNewsModel alloc] initWithRootNews:rootModel];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 白天和黑夜的颜色适配未完成
    self.view.backgroundColor = [UIColor colorNamed:@"ColorBackground"];
    
    // 替代navigation的需要封装
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.topView];
    
    [self.view addSubview:self.jwzxNewsTableView];
    
    [self requestData];
}

#pragma mark - Method

- (void)requestData {
    [self.jwzxNewsModel
    requestMoreSuccess:^(BOOL hadMore) {
        if (hadMore) {
            [self.jwzxNewsTableView reloadData];
        }
    }
     failure:^(NSError * _Nonnull error) {
        
    }];
}

// MARK: SEL

- (void)JWZXNewVC_pop {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Getter

- (SSRTopBarBaseView *)topView {
    if (_topView == nil) {
        _topView = [[SSRTopBarBaseView alloc] initWithSafeViewHeight:44];
        _topView.hadLine = NO;
        [_topView addTitle:@"教务新闻"
              withTitleLay:SSRTopBarBaseViewTitleLabLayLeft
                 withStyle:nil];
        [_topView addBackButtonTarget:self action:@selector(JWZXNewVC_pop)];
    }
    return _topView;
}

- (UITableView *)jwzxNewsTableView {
    if (_jwzxNewsTableView == nil) {
        CGFloat top = self.topView.bottom;
        _jwzxNewsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, top + 5, self.view.width, self.view.height - top) style:UITableViewStylePlain];
        [_jwzxNewsTableView registerClass:[JWZXNewsCell class] forCellReuseIdentifier:JWZXNewsCellReuseIdentifier];
        _jwzxNewsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _jwzxNewsTableView.delegate = self;
        _jwzxNewsTableView.dataSource = self;
    }
    return _jwzxNewsTableView;
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.jwzxNewsModel.sectionNewsAry.count;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.jwzxNewsModel.sectionNewsAry[section].newsAry.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    JWZXNew *aNew = self.jwzxNewsModel.sectionNewsAry[indexPath.section].newsAry[indexPath.row];
    
    JWZXNewsCell *cell = [self.jwzxNewsTableView dequeueReusableCellWithIdentifier:JWZXNewsCellReuseIdentifier];
    
    if (cell == nil) {
        cell = [[JWZXNewsCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"NewsCell"];
    }
    
    [cell showNewsWithTimeString:aNew.date withDetail:aNew.title];
    
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JWZXNew *aNew = self.jwzxNewsModel.sectionNewsAry[indexPath.section].newsAry[indexPath.row];
    
    NewDetailViewController *vc =
        [[NewDetailViewController alloc]
         initWithNewsID:aNew.NewsID
         date:aNew.date
         title:aNew.title];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 86;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == self.jwzxNewsModel.sectionNewsAry.count - 1) {
        if (indexPath.row == self.jwzxNewsModel.sectionNewsAry[indexPath.section].newsAry.count - 1) {
            [self requestData];
        }
    }
}

@end
