//
//  CQUPTMapBeforeSearch.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/8/12.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "CQUPTMapBeforeSearchView.h"

@interface CQUPTMapBeforeSearchView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UILabel *historyLabel;
@property (nonatomic, weak) UIButton *clearAllButton;
@property (nonatomic, weak) UITableView *historyTableView;

@end



@implementation CQUPTMapBeforeSearchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *historyLabel = [[UILabel alloc] init];
        historyLabel.text = @"历史记录";
        historyLabel.font = [UIFont fontWithName:PingFangSCMedium size:15];
        [self addSubview:historyLabel];
        self.historyLabel = historyLabel;
        
        
        UIButton *clearAllButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [clearAllButton setTitle:@"清除全部" forState:UIControlStateNormal];
        clearAllButton.titleLabel.font = [UIFont fontWithName:PingFangSCMedium size:11];
        [clearAllButton addTarget:self action:@selector(clearAllHistory) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:clearAllButton];
        self.clearAllButton = clearAllButton;
        
        
        UITableView *historyTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        historyTableView.rowHeight = 37;
        historyTableView.dataSource = self;
        historyTableView.delegate = self;
        historyTableView.backgroundColor = [UIColor whiteColor];
        historyTableView.tableFooterView = [[UIView alloc] init];
        [self addSubview:historyTableView];
        self.historyTableView = historyTableView;
        
        
        if (@available(iOS 11.0, *)) {
            historyLabel.textColor = [UIColor colorNamed:@"Map_SearchHistoryColor"];
            [clearAllButton setTitleColor:[UIColor colorNamed:@"Map_SearchClearColor"] forState:UIControlStateNormal];
        } else {
            historyLabel.textColor = [UIColor colorWithHexString:@"#778AA9"];
            [clearAllButton setTitleColor:[UIColor colorWithHexString:@"#ABBCD8"] forState:UIControlStateNormal];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.historyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.top.equalTo(self).offset(34);
    }];
    
    [self.clearAllButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.historyLabel);
        make.trailing.equalTo(self).offset(-15);
        make.width.equalTo(@45);
        make.height.equalTo(@11);
    }];
    
    [self.historyTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self);
        make.top.equalTo(self.historyLabel.mas_bottom).offset(11);
    }];
}


#pragma mark - tableView数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"1"];
    cell.textLabel.text = @"历史记录";
    if (@available(iOS 11.0, *)) {
        cell.textLabel.textColor = [UIColor colorNamed:@""];
    } else {
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#234780"];
    }
    
    return cell;
}


- (void)clearAllHistory {
    
}

@end
