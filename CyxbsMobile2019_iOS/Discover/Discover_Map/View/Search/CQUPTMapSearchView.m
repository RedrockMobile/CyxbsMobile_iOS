//
//  CQUPTMapBeforeSearch.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/8/12.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "CQUPTMapSearchView.h"
#import "CQUPTMapBeforeSearchCell.h"
#import "CQUPTMapSearchResultCell.h"
#import "CQUPTMapDataItem.h"
#import "CQUPTMapPlaceItem.h"
#import "CQUPTMapSearchItem.h"

@interface CQUPTMapSearchView () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, weak) UILabel *historyLabel;
@property (nonatomic, weak) UIButton *clearAllButton;
//@property (nonatomic, weak) UITableView *historyTableView;    // 声明在头文件中

//@property (nonatomic, weak) UITableView *resultTableView;     // 声明在头文件中

@property (nonatomic, copy) NSArray *historyArray;
@property (nonatomic, copy) NSArray<CQUPTMapPlaceItem *> *resultArray;

@end



@implementation CQUPTMapSearchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.historyArray = [[UserDefaultTool valueWithKey:CQUPTMAPHISTORYKEY] copy];
        
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
        historyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    if (tableView == self.historyTableView) {
        return self.historyArray.count;
    } else {
        return self.resultArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.historyTableView) {
        CQUPTMapBeforeSearchCell *cell = [[CQUPTMapBeforeSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[@(indexPath.row) stringValue]];
        cell.titleLabel.text = self.historyArray[indexPath.row];
        [cell.deleteButton addTarget:self action:@selector(deleteAHistory:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    } else {
        CQUPTMapSearchResultCell *cell = [[CQUPTMapSearchResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[@(indexPath.row) stringValue]];
        cell.titleLabel.text = self.resultArray[indexPath.row].placeName;
        return cell;
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.viewController.view endEditing:YES];
}


- (void)searchPlaceSuccess:(NSArray<CQUPTMapSearchItem *> *)placeIDArray {
    CQUPTMapDataItem *mapData = [NSKeyedUnarchiver unarchiveObjectWithFile:[CQUPTMapDataItem archivePath]];
    
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (CQUPTMapSearchItem *placeID in placeIDArray) {
        for (CQUPTMapPlaceItem *place in mapData.placeList) {
            if (placeID.placeID == [place.placeId intValue]) {
                [tmpArray addObject:place];
            }
        }
    }
    self.resultArray = [tmpArray copy];
    
    if (!self.resultTableView) {
        UITableView *resultTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        resultTableView.rowHeight = 37;
        resultTableView.dataSource = self;
        resultTableView.delegate = self;
        resultTableView.backgroundColor = [UIColor whiteColor];
        resultTableView.tableFooterView = [[UIView alloc] init];
        resultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        resultTableView.alpha = 0;
        [self addSubview:resultTableView];
        self.resultTableView = resultTableView;
        
        
        [resultTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.equalTo(self);
            make.top.equalTo(self).offset(34);
        }];
    }
    [self.resultTableView reloadData];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        self.historyTableView.alpha = 0;
        self.resultTableView.alpha = 1;
    } completion:^(BOOL finished) {
        self.historyArray = [[UserDefaultTool valueWithKey:CQUPTMAPHISTORYKEY] copy];
        [self.historyTableView reloadData];
    }];
}


#pragma mark - 删除记录
- (void)clearAllHistory {
    [UserDefaultTool saveValue:@[] forKey:CQUPTMAPHISTORYKEY];
    self.historyArray = @[];
    [self.historyTableView reloadData];
}

- (void)deleteAHistory:(UIButton *)sender {
    NSString *removeData = ((CQUPTMapBeforeSearchCell *)(sender.superview.superview)).titleLabel.text;
    
    NSMutableArray *historys = [[UserDefaultTool valueWithKey:CQUPTMAPHISTORYKEY] mutableCopy];
    [historys removeObject:removeData];
    
    [UserDefaultTool saveValue:historys forKey:CQUPTMAPHISTORYKEY];
    
    self.historyArray = historys;
    
    [self.historyTableView reloadSection:0 withRowAnimation:UITableViewRowAnimationFade];
}

@end
