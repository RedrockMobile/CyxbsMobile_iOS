//
//  NewDetailViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/2/8.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "NewDetailViewController.h"

#import "JWZXDetailNewsModel.h"

#import "JWZXDetailNewsTopView.h"

#import "JWZXDetailView.h"


@interface NewDetailViewController ()

/// 干掉navigation的视图
@property (nonatomic, strong) JWZXDetailNewsTopView *topView;

/// 详情信息
@property (nonatomic, strong) JWZXDetailNewsModel *detailNewsModel;

/// 最重要的视图
@property (nonatomic, strong) JWZXDetailView *mainView;

@end

@implementation NewDetailViewController

#pragma mark - Life cycle

- (instancetype)initWithNewsID:(NSString *)newsID
                          date:(NSString *)date
                         title:(NSString *)title {
    self = [super init];
    if (self) {
        self.detailNewsModel = [[JWZXDetailNewsModel alloc] initWithNewsID:newsID];
        self.detailNewsModel.title = title;
        self.detailNewsModel.date = date;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    self.view.backgroundColor = [UIColor colorNamed:@"ColorBackground"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.topView];
    
    [self.view addSubview:self.mainView];
    
    [self requestData];
}

#pragma mark - Getter

- (JWZXDetailNewsTopView *)topView {
    if (_topView == nil) {
        _topView = [[JWZXDetailNewsTopView alloc] initWithSafeViewHeight:44];
        _topView.haveFiled = NO;
        [_topView addBackButtonTarget:self action:@selector(popController)];
        [_topView addDonwloadButtonTarget:self action:@selector(downLoadFiles)];
    }
    return _topView;
}

- (JWZXDetailView *)mainView {
    if (_mainView == nil) {
        _mainView = [[JWZXDetailView alloc] initWithFrame:CGRectMake(10, self.topView.bottom, self.view.width - 2 * 10, self.view.bottom - self.topView.bottom - TABBARHEIGHT)];
        [_mainView
         loadViewWithDate:self.detailNewsModel.date
         title:self.detailNewsModel.title
         detail:@"新闻详情加载中......"];
    }
    return _mainView;
}

#pragma mark - Method

- (void)requestData {
    [self.detailNewsModel
     requestNewsSuccess:^{
        if (self.detailNewsModel.annexModels && self.detailNewsModel.annexModels.count) {
            self.topView.haveFiled = YES;
        }
        
        [self.mainView
         loadViewWithDate:self.detailNewsModel.date
         title:self.detailNewsModel.title
         detail:self.detailNewsModel.content];
    }
     failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)downLoadFiles {
    [UIApplication.sharedApplication
      openURL:[NSURL URLWithString:
        [NSString stringWithFormat: @"%@?id=%@",
        [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-jwzx/jwNews/file"],
         self.detailNewsModel.annexModels[0].annexID]]
      options:@{}
      completionHandler:nil];
}

- (void)popController {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
