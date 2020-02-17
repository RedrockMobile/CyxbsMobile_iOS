//
//  MineQATableViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/1/22.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "MineQATableViewController.h"
#import "MyQuestionsReleasedCell.h"
#import "MyQuestionsDraftCell.h"
#import "MyAnswerReleasedCell.h"
#import "MyAnswerDraftCell.h"
#import "MyResponseSentCell.h"
#import "MyResponseRecievedCell.h"
#import "MineQAController.h"
#import <MJRefresh.h>

@interface MineQATableViewController ()

@end

@implementation MineQATableViewController

- (instancetype)initWithTitle:(NSString *)title andSubTitle:(nonnull NSString *)subTitle {
    if (self = [super init]) {
        self.pageNum = 1;
        self.title = title;
        self.subTittle = subTitle;
        self.itemsArray = [NSMutableArray array];
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(lodaMoreData)];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.allowsSelection = NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.title isEqualToString:@"我的提问"]) {
        if ([self.subTittle isEqualToString:@"已发布"]) {
            MyQuestionsReleasedCell *cell = [[MyQuestionsReleasedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
            self.tableView.rowHeight = 110;
            [cell layoutSubviews];
            cell.item = self.itemsArray[indexPath.row];
            return cell;
        } else {
            self.tableView.rowHeight = 114;
            MyQuestionsDraftCell *cell = [[MyQuestionsDraftCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
            cell.item = self.itemsArray[indexPath.row];
            return cell;
        }
    } else if ([self.title isEqualToString:@"我的回答"]) {
        if ([self.subTittle isEqualToString:@"已发布"]) {
            self.tableView.rowHeight = 87;
            MyAnswerReleasedCell *cell = [[MyAnswerReleasedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
            cell.item = self.itemsArray[indexPath.row];
            return cell;
        } else {
            self.tableView.rowHeight = 81;
            MyAnswerDraftCell *cell = [[MyAnswerDraftCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
            cell.item = self.itemsArray[indexPath.row];
            return cell;
        }
    } else if ([self.title isEqualToString:@"评论回复"]) {
        if ([self.subTittle isEqualToString:@"发出评论"]) {
            self.tableView.rowHeight = 81;
            MyResponseSentCell *cell = [[MyResponseSentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
            cell.item = self.itemsArray[indexPath.row];
            return cell;
        } else {
            self.tableView.rowHeight = 81;
            MyResponseRecievedCell *cell = [[MyResponseRecievedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
            cell.item = self.itemsArray[indexPath.row];
            return cell;
        }
    } else {
        return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
}

- (void)lodaMoreData {
    [self.superController pullUpToLoadWithTitle:self.title andSubTitle:self.subTittle];
}

@end
