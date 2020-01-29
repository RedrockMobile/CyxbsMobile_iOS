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

@interface MineQATableViewController ()

@end

@implementation MineQATableViewController

- (instancetype)initWithTitle:(NSString *)title andSubTitle:(nonnull NSString *)subTitle {
    if (self = [super init]) {
        self.title = title;
        self.subTittle = subTitle;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorColor = [UIColor clearColor];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.title isEqualToString:@"我的提问"]) {
        if ([self.subTittle isEqualToString:@"已发布"]) {
            self.tableView.rowHeight = 135;
            return [[MyQuestionsReleasedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
        } else {
            self.tableView.rowHeight = 139;
            return [[MyQuestionsDraftCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
        }
    } else if ([self.title isEqualToString:@"我的回答"]) {
        if ([self.subTittle isEqualToString:@"已发布"]) {
            self.tableView.rowHeight = 112;
            return [[MyAnswerReleasedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
        } else {
            self.tableView.rowHeight = 106;
            return [[MyAnswerDraftCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
        }
    } else if ([self.title isEqualToString:@"评论回复"]) {
        if ([self.subTittle isEqualToString:@"发出评论"]) {
            self.tableView.rowHeight = 81;
            return [[MyResponseSentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
        } else {
            self.tableView.rowHeight = 71;
            return [[MyResponseRecievedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
        }
    } else {
        return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
}


@end
