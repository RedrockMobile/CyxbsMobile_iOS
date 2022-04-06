//
//  JWZXNewsViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/2/8.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "JWZXNewsViewController.h"

#import "NewsCell.h"
#import "JWZXNewsModel.h"
#import "NewDetailViewController.h"

#define Color21_49_91_F0F0F2  [UIColor colorNamed:@"color21_49_91&#F0F0F2" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]
#define ColorWhite  [UIColor colorNamed:@"colorLikeWhite&#1D1D1D" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]

#pragma mark - NewsViewController ()

@interface JWZXNewsViewController () <
    UITableViewDelegate,
    UITableViewDataSource
>

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UILabel *titleLab;

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
    
    // 下面两个需要被封装到navigation的替代View
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.titleLab];
    
    // 正常的逻辑交互
    [self.view addSubview:self.jwzxNewsTableView];
    [self requestData];
}

#pragma mark - Getter

- (UITableView *)jwzxNewsTableView {
    if (_jwzxNewsTableView == nil) {
        CGFloat top = self.titleLab.bottom;
        _jwzxNewsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, top + 5, self.view.width, self.view.height - top) style:UITableViewStylePlain];
        _jwzxNewsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _jwzxNewsTableView.delegate = self;
        _jwzxNewsTableView.dataSource = self;
    }
    return _jwzxNewsTableView;
}

- (UIButton *)backButton {
    if (_backButton == nil) {
        _backButton = [[UIButton alloc] init];
        [_backButton setImage:[UIImage imageNamed:@"LQQBackButton"] forState:normal];
        [_backButton setImage: [UIImage imageNamed:@"EmptyClassBackButton"] forState:UIControlStateHighlighted];
        // UI需要封装
        _backButton.left = 17;
        _backButton.top = (IS_IPHONEX ? 53 : 35);
        _backButton.width = 7;
        _backButton.height = 14;
        [_backButton addTarget:self action:@selector(popController) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UILabel *)titleLab {
    if (_titleLab == nil) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(self.backButton.right + 10, self.backButton.top - 2, 200, 18)];
        
        _titleLab.text = @"教务新闻";
        _titleLab.textColor = Color21_49_91_F0F0F2;
    }
    return _titleLab;
}

#pragma mark - Method

- (void)popController {
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
    
    NewsCell *cell = [[NewsCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"NewsCell"];
    cell.textLabel.text = self.jwzxNewsModel.jwzxNews.news[indexPath.row].date;
    cell.detailTextLabel.text = self.jwzxNewsModel.jwzxNews.news[indexPath.row].title;
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
