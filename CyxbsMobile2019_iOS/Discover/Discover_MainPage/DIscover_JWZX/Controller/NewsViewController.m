//
//  NewsViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/2/8.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsCell.h"
#import "JWZXNewsModel.h"
#import "NewDetailViewController.h"

#define Color21_49_91_F0F0F2  [UIColor colorNamed:@"color21_49_91&#F0F0F2" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]
#define ColorWhite  [UIColor colorNamed:@"colorLikeWhite&#1D1D1D" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]


@interface NewsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak)UIButton *backButton;
@property (nonatomic, weak)UILabel *titleLabel;
@property (nonatomic, weak)UITableView *tableView;
@property (nonatomic, strong)JWZXNewsModel *model;

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    if (@available(iOS 11.0, *)) {
        self.view.backgroundColor = ColorWhite;
    } else {
        self.view.backgroundColor = UIColor.whiteColor;
    }
    [self addBackButton];
    [self addTitleLabel];
    [self addTableView];
    [self requestData];
    // Do any additional setup after loading the view.
}

- (void)addBackButton {
    UIButton *button = [[UIButton alloc]init];
    [self.view addSubview:button];
    self.backButton = button;
    [button setImage:[UIImage imageNamed:@"LQQBackButton"] forState:normal];
    [button setImage: [UIImage imageNamed:@"EmptyClassBackButton"] forState:UIControlStateHighlighted];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(17);
        if IS_IPHONEX {
            make.top.equalTo(self.view).offset(53);
        }else {
            make.top.equalTo(self.view).offset(35);
        }
        make.width.equalTo(@7);
        make.height.equalTo(@14);
    }];
    [button addTarget:self action:@selector(popController) forControlEvents:UIControlEventTouchUpInside];
}
- (void)popController {
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)addTitleLabel {
    UILabel *label = [[UILabel alloc]init];
    self.titleLabel = label;
    self.titleLabel.text = @"教务新闻";
    label.font = [UIFont fontWithName:PingFangSCBold size:21];
    if (@available(iOS 11.0, *)) {
        label.textColor = Color21_49_91_F0F0F2;
    } else {
        label.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1];
    }
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backButton).offset(14);
        make.centerY.equalTo(self.backButton);
    }];
}

- (void)requestData {
    
    [self.model
     requestJWZXPage:1 success:^{
        [self.tableView reloadData];
    }
     failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
}

- (void)addTableView {
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 87, self.view.width, self.view.height - 87) style:UITableViewStylePlain];
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.width.equalTo(@(self.view.width));
        make.height.equalTo(@(self.self.view.height - 87));
    }];
}

//MARK: - tableView代理
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NewsCell *cell = [[NewsCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"NewsCell"];
    cell.textLabel.text = self.model.jwzxNews.news[indexPath.row].date;
    cell.detailTextLabel.text = self.model.jwzxNews.news[indexPath.row].title;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.haveFileLabel.text = @"有附件";
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 86;
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.jwzxNews.news.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NewDetailViewController *vc = [[NewDetailViewController alloc]initWithNewsTime:self.model.jwzxNews.news[indexPath.row].date NewsTitle:self.model.jwzxNews.news[indexPath.row].title NewsID:self.model.jwzxNews.news[indexPath.row].NewsID] ;
    [self.navigationController pushViewController:vc animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
