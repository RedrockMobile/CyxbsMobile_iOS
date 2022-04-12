//
//  DiscoverJWZXVC.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/4/12.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "DiscoverJWZXVC.h"

#import "JWZXNewsViewController.h"
#import "NewDetailViewController.h"

#import "SSRTextCycleView.h"

#import "JWZXNewsModel.h"

#pragma mark - DiscoverJWZXVC ()

/// 暴露在外面的教务新闻VC
@interface DiscoverJWZXVC () <
    TextCycleViewDelegate
>

/// 教务在线数据模型
@property (nonatomic, strong) JWZXNewsModel *newsModel;

/// 进入主页的btn
@property (nonatomic, strong) UIButton *jwNewsBtn;

/// 直接进入详情页的btn
@property (nonatomic, strong) SSRTextCycleView *textCycleView;

@end

#pragma mark - DiscoverJWZXVC

@implementation DiscoverJWZXVC

#pragma mark - Life cycle

- (instancetype)initWithViewFrame:(CGRect)frame {
    self = [super init];
    if (self) {
        self.view.frame = frame;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.newsModel = [[JWZXNewsModel alloc] init];
    [self.newsModel
     requestJWZXPage:1
     success:^{
        NSMutableArray <NSString *> *titleAry = NSMutableArray.array;
        for (JWZXNew *aNew in self.newsModel.jwzxNews.news) {
            [titleAry addObject:aNew.title];
        }
        self.textCycleView.textAry = titleAry.copy;
    }
     failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.view addSubview:self.jwNewsBtn];
    [self.view addSubview:self.textCycleView];
}

#pragma mark - Method

- (void)pushToJWZXNewsController {
    JWZXNewsViewController *vc = [[JWZXNewsViewController alloc] initWithJWZXNewsModel:self.newsModel];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Getter

- (UIButton *)jwNewsBtn {
    if (_jwNewsBtn == nil) {
        _jwNewsBtn = [[UIButton alloc] initWithFrame:CGRectMake(16, 0, 68, self.view.height)];
        [_jwNewsBtn setTitle:@"教务在线" forState:UIControlStateNormal];
        [_jwNewsBtn setBackgroundImage:[UIImage imageNamed:@"教务在线背景"] forState:normal];
        [_jwNewsBtn setTitleColor:[UIColor colorNamed:@"whiteColor"] forState:normal];
        _jwNewsBtn.titleLabel.font = [UIFont fontWithName:PingFangSCBold size: 11];
        _jwNewsBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_jwNewsBtn addTarget:self action:@selector(pushToJWZXNewsController) forControlEvents:UIControlEventTouchUpInside];
    }
    return _jwNewsBtn;
}

- (SSRTextCycleView *)textCycleView {
    if (_textCycleView == nil) {
        CGFloat left = self.jwNewsBtn.right + 14;
        _textCycleView = [[SSRTextCycleView alloc] initWithFrame:CGRectMake(left, 0, self.view.width - left - 16, self.view.height)];
        _textCycleView.backgroundColor = UIColor.clearColor;
        _textCycleView.autoTimeInterval = 3;
        
        NSString *oneNew = [NSUserDefaults.standardUserDefaults objectForKey:@"OneNews_oneNews"];
        _textCycleView.textAry = oneNew ? @[oneNew] : @[];
        _textCycleView.textCycleView_delegate = self;
    }
    return _textCycleView;
}

#pragma mark - <TextCycleViewDelegate>

- (void)textCycleView:(SSRTextCycleView *)view didSelectedAtIndex:(NSInteger)index {
    JWZXNew *aNew = self.newsModel.jwzxNews.news
    [index % self.newsModel.jwzxNews.news.count];
    
    NewDetailViewController *vc =
    [[NewDetailViewController alloc]
     initWithNewsID:aNew.NewsID
     date:aNew.date
     title:aNew.title];
    
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController
     pushViewController:vc
     animated:YES];
}

- (SSRTextCycleCell *)textCycleView:(SSRTextCycleView *)view cellForIndex:(NSInteger)index {
    SSRTextCycleCell *cell = [self.textCycleView dequeueReusableCellWithIdentifier:SSRTextCycleCellReuseIdentifier];
    
    if (cell) {
        cell = [[SSRTextCycleCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:SSRTextCycleCellReuseIdentifier];
        cell.ssrTextLab.textColor = [UIColor colorNamed:@"color21_49_91&#F0F0F2"];
        cell.ssrTextLab.backgroundColor = UIColor.clearColor;
        cell.ssrTextLab.font = [UIFont fontWithName:@".PingFang SC" size:15];
        cell.backgroundColor = UIColor.clearColor;
        cell.contentView.backgroundColor = UIColor.clearColor;
        cell.frame = view.SuperFrame;
        cell.contentView.frame = cell.SuperFrame;
        [cell drawTextLab];
    }
    return cell;
}

@end
