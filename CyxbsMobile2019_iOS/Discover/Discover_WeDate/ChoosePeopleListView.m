//
//  ChoosePeopleListView.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/7/30.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "ChoosePeopleListView.h"

@interface ChoosePeopleListView()<UITableViewDelegate,UITableViewDataSource,PeopleListTableViewCellDelegateAdd>
@property (nonatomic, strong)UIView *peopleListView;
@property (nonatomic, strong)ClassmatesList *list;
@end
@implementation ChoosePeopleListView
- (instancetype)initWithClassmatesList:(ClassmatesList*)list;{
    self = [super init];
    if(self){
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithRed:83/255.0 green:105/255.0 blue:188/255.0 alpha:0.27];
        self.list = list;
    }
    return self;
}

-(void)addPeopleListView{
    UIButton *btn = [[UIButton alloc] init];
    [self.peopleListView addSubview:btn];
    [btn setTitle:@"取消" forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0] forState:(UIControlStateNormal)];
    btn.titleLabel.font = [UIFont fontWithName:@".PingFang SC" size: 15];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.peopleListView).offset(MAIN_SCREEN_H*0.0484);
        make.left.equalTo(self.peopleListView).offset(MAIN_SCREEN_W*0.0427);
        make.height.mas_equalTo(MAIN_SCREEN_H*0.0484);
        make.width.mas_equalTo(MAIN_SCREEN_H*0.08);
    }];
    
    [btn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:(UIControlEventTouchUpInside)];
    
    UITableView *tableView = [[UITableView alloc] init];
    [self.peopleListView addSubview:tableView];
    tableView.rowHeight = MAIN_SCREEN_H*0.0875;
    tableView.delegate = self;
    tableView.dataSource = self;
    
}

- (void)cancelBtnClicked{
    
}


//MARK:需实现的协议：

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.list.classmatesArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ClassmateItem *item = self.list.classmatesArray[indexPath.row];
    PeopleListTableViewCell *cell = [[PeopleListTableViewCell alloc] initWithInfoDict:@{
        @"name":item.name,
        @"stuNum":item.stuNum
    } andRightBtnType:(PeopleListTableViewCellRightBtnTypeAdd)];
    
    cell.delegateAdd = self;
    return cell;
}

- (void)PeopleListTableViewCellAddBtnClickInfoDict:(NSDictionary *)infoDict{
    [self.delegate PeopleListTableViewCellAddBtnClickInfoDict:infoDict];
}
@end
