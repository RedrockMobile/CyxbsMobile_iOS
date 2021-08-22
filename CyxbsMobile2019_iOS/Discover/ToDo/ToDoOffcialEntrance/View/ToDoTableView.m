//
//  ToDoTableView.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/8/22.
//  Copyright © 2021 Redrock. All rights reserved.
//

//Model
#import "TODOModel.h"

//View
#import "ToDoTableView.h"
#import "TodoTableViewCell.h"
#import "ToDoEmptyCell.h"
@interface ToDoTableView()<UITableViewDataSource,UITableViewDelegate>
@end

@implementation ToDoTableView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorNamed:@"225_225_225&0_0_0"];
        //设置cell无分割线
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.estimatedRowHeight = 64;   //设置一个预估高度
        self.dataSource = self;
        
    }
    return self;
}

#pragma mark- TableDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *sectionAry = self.dataSourceAry[section];
    if (sectionAry.count == 0) {
        return 1;
    }
    if (section == 1 && self.isFoldTwoSection) {
        return 0;
    }
    return sectionAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *sectionAry = self.dataSourceAry[indexPath.section];
    //如果无内容则设置为空cell的样式
    if (sectionAry.count == 0) {
        ToDoEmptyCell *cell = [[ToDoEmptyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ToDoEmptyCell"];
        cell.type = indexPath.section;
        return cell;
    }
    TodoTableViewCell *cell = [[TodoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ToDoCell"];
    TODOModel *model = sectionAry[indexPath.row];
    cell.model = model;
    return cell;
}


@end
