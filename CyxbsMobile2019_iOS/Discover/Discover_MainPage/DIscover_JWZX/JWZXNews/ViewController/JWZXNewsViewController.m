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

#define Color21_49_91_F0F0F2  [UIColor colorNamed:@"color21_49_91&#F0F0F2" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]
#define ColorWhite  [UIColor colorNamed:@"colorLikeWhite&#1D1D1D" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]

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

- (instancetype)initWithJWZXNewsModel:(JWZXNewsModel *)model {
    self = [super init];
    if (self) {
        self.jwzxNewsModel = model;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 白天和黑夜的颜色适配未完成
    self.view.backgroundColor = UIColor.whiteColor;
    
    // 替代navigation的需要封装
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.topView];
    
    // 正常的逻辑交互
    [self.view addSubview:self.jwzxNewsTableView];
    [self requestData];
}

#pragma mark - Getter

- (SSRTopBarBaseView *)topView {
    if (_topView == nil) {
        _topView = [[SSRTopBarBaseView alloc] initWithSafeViewHeight:44];
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

#pragma mark - Method

- (void)JWZXNewVC_pop {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestData {
    if (self.jwzxNewsModel) {
        [self.jwzxNewsTableView reloadData];
    } else {
        self.jwzxNewsModel = [[JWZXNewsModel alloc] init];
        [self.jwzxNewsModel
         requestJWZXPage:1 success:^{
            [self.jwzxNewsTableView reloadData];
         }
         failure:^(NSError * _Nonnull error) {
            NSLog(@"%@", error);
         }];
    }
}

#pragma mark - Delegate

// MARK: <UITableViewDataSource>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 86;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.jwzxNewsModel.jwzxNews.news.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    JWZXNew *aNew = self.jwzxNewsModel.jwzxNews.news[indexPath.row];
    
    JWZXNewsCell *cell = [self.jwzxNewsTableView dequeueReusableCellWithIdentifier:JWZXNewsCellReuseIdentifier];
    
    if (cell == nil) {
        cell = [[JWZXNewsCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"NewsCell"];
    }
    
    [cell showNewsWithTimeString:aNew.date withDetail:aNew.title];
    
    return cell;
}

// MARK: <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JWZXNew *aNew = self.jwzxNewsModel.jwzxNews.news[indexPath.row];
    
    NewDetailViewController *vc =
        [[NewDetailViewController alloc]
         initWithNewsTime:aNew.date
         NewsTitle:aNew.title
         NewsID:aNew.NewsID];
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
