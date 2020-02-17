//
//  MineQAController.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/1/22.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "MineQAController.h"
#import "MineSegmentedView.h"
#import "MineQATableViewController.h"
#import "MineQAPresenter.h"

@interface MineQAController ()<MineQAProtocol>

@property (nonatomic, weak) MineQATableViewController *vc1;
@property (nonatomic, weak) MineQATableViewController *vc2;

@end

@implementation MineQAController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.presenter = [[MineQAPresenter alloc] init];
    [self.presenter attachView:self];
    
    self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:252/255.0 alpha:1];
    
    MineQATableViewController *vc1 = [[MineQATableViewController alloc] initWithTitle:self.title andSubTitle:@"已发布"];
    if ([self.title isEqualToString:@"评论回复"]) {
        vc1.subTittle = @"发出评论";
    }
    
    if (@available(iOS 11.0, *)) {
        vc1.tableView.backgroundColor = [UIColor colorNamed:@"Mine_QA_BackgroundColor"];
    } else {
        // Fallback on earlier versions
    }
    vc1.superController = self;
    self.vc1 = vc1;
    
    
    MineQATableViewController *vc2 = [[MineQATableViewController alloc] initWithTitle:self.title andSubTitle:@"草稿箱"];
    if ([self.title isEqualToString:@"评论回复"]) {
        vc2.subTittle = @"收到回复";
    }
    
    if (@available(iOS 11.0, *)) {
        vc2.tableView.backgroundColor = [UIColor colorNamed:@"Mine_QA_BackgroundColor"];
    } else {
        // Fallback on earlier versions
    }
    vc2.superController = self;
    self.vc2 = vc2;
    
    NSArray *arr = @[vc1, vc2];
    
    
    MineSegmentedView *segmentedView = [[MineSegmentedView alloc] initWithChildViewControllers:arr];
    segmentedView.frame = self.view.bounds;
    if (@available(iOS 11.0, *)) {
        segmentedView.backgroundColor = [UIColor colorNamed:@"Mine_QA_BackgroundColor"];
    } else {
        // Fallback on earlier versions
    }
    [self.view addSubview:segmentedView];
    
    UIView *navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_W, TOTAL_TOP_HEIGHT)];
    if (@available(iOS 11.0, *)) {
        navigationBar.backgroundColor = [UIColor colorNamed:@"Mine_QA_HeaderBarColor"];
    } else {
        // Fallback on earlier versions
    }
    [self.view addSubview:navigationBar];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((MAIN_SCREEN_W - 85) / 2.0, 7 + STATUSBARHEIGHT, 85, 30)];
    titleLabel.text = self.title;
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 21];
    if (@available(iOS 11.0, *)) {
        titleLabel.textColor = [UIColor colorNamed:@"Mine_QA_TitleLabelColor"];
    } else {
        // Fallback on earlier versions
    }
    [navigationBar addSubview:titleLabel];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    backButton.frame = CGRectMake(17, 12.5 + STATUSBARHEIGHT, 19, 19);
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    backButton.backgroundColor = [UIColor blueColor];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [navigationBar addSubview:backButton];
    
    
    // 请求数据
    if ([self.title isEqualToString:@"我的提问"]) {
        [self.presenter requestQuestionsListWithPageNum:@(self.vc1.pageNum) andSize:@6];
        [self.presenter requestQuestionsDraftListWithPageNum:@(self.vc2.pageNum) andSize:@6];
    } else if ([self.title isEqualToString:@"我的回答"]) {
        [self.presenter requestAnswerListWithPageNum:@(self.vc1.pageNum) andSize:@6];
        [self.presenter requestAnswerDraftListWithPageNum:@(self.vc2.pageNum) andSize:@6];
    } else if ([self.title isEqualToString:@"评论回复"]) {
        [self.presenter requestCommentListWithPageNum:@(self.vc1.pageNum) andSize:@6];
        [self.presenter requestReCommentListWithPageNum:@(self.vc2.pageNum) andSize:@6];
    }
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    [self.presenter dettachView];
}

#pragma mark - presenter回调
- (void)questionListRequestSucceeded:(NSArray<MineQAMyQuestionItem *> *)itemsArray {
    self.vc1.itemsArray = [[self.vc1.itemsArray arrayByAddingObjectsFromArray:itemsArray] mutableCopy];
    [self.vc1.tableView reloadData];
}

- (void)questionDraftListRequestSucceeded:(NSArray<MineQAMyQuestionDraftItem *> *)itemsArray {
    self.vc2.itemsArray = [[self.vc2.itemsArray arrayByAddingObjectsFromArray:itemsArray] mutableCopy];
    [self.vc2.tableView reloadData];
}

- (void)answerListRequestSucceeded:(NSArray<MineQAMyAnswerItem *> *)itemsArray {
    self.vc1.itemsArray = [[self.vc1.itemsArray arrayByAddingObjectsFromArray:itemsArray] mutableCopy];
    [self.vc1.tableView reloadData];
}

- (void)answerDraftListRequestSucceeded:(NSArray<MineQAMyAnswerDraftItem *> *)itemsArray {
    self.vc2.itemsArray = [[self.vc2.itemsArray arrayByAddingObjectsFromArray:itemsArray] mutableCopy];
    [self.vc2.tableView reloadData];
}

- (void)commentListRequestSucceeded:(NSArray<MineQACommentItem *> *)itemsArray {
    self.vc1.itemsArray = [[self.vc1.itemsArray arrayByAddingObjectsFromArray:itemsArray] mutableCopy];
    [self.vc1.tableView reloadData];
}

@end
