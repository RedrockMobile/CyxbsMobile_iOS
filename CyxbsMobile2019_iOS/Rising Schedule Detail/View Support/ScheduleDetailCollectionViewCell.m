//
//  ScheduleDetailCollectionViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/10/18.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleDetailCollectionViewCell.h"

#import "ScheduleDetailMessageTableViewCell.h"

#import "ScheduleDetailTableHeaderView.h"

NSString *ScheduleDetailCollectionViewCellReuseIdentifier = @"ScheduleDetailCollectionViewCellReuseIdentifier";

#pragma mark - ScheduleDetailCollectionViewCell ()

@interface ScheduleDetailCollectionViewCell () <
    UITableViewDataSource,
    UITableViewDelegate
>

/// table veiw
@property (nonatomic, strong) UITableView *tableView;

/// table header view
@property (nonatomic, strong) ScheduleDetailTableHeaderView *tableHeaderView;

@end

#pragma mark - ScheduleDetailCollectionViewCell

@implementation ScheduleDetailCollectionViewCell

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        self.contentView.backgroundColor = UIColor.clearColor;
        [self.contentView addSubview:self.tableView];
        self.tableView.tableHeaderView = self.tableHeaderView;
    }
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    self.tableView.size = layoutAttributes.size;
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.contentView.SuperFrame style:UITableViewStylePlain];
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.bounces = NO;
        [_tableView registerClass:ScheduleDetailMessageTableViewCell.class forCellReuseIdentifier:ScheduleDetailMessageTableViewCellReuseIdentifier];
        }
    return _tableView;
}

- (ScheduleDetailTableHeaderView *)tableHeaderView {
    if (_tableHeaderView == nil) {
        _tableHeaderView = [[ScheduleDetailTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, 100)];
        _tableHeaderView.title = @"正在加载课程名...";
        _tableHeaderView.detail = @"正在加载时间与老师...";
    }
    return _tableHeaderView;
}

#pragma mark - Setter

- (void)setCourse:(ScheduleCourse *)scheduleCourse {
    _course = scheduleCourse;
    [self.tableView reloadData];
    self.tableHeaderView.title = scheduleCourse.course;
    self.tableHeaderView.detail =
    [NSString stringWithFormat:@"%@ > %@", scheduleCourse.classRoom, scheduleCourse.teacher];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ScheduleDetailMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ScheduleDetailMessageTableViewCellReuseIdentifier forIndexPath:indexPath];
    
    switch (indexPath.item) {
        case 0: {
            cell.leftDescription = @"周期";
            cell.rightDetail = [NSString stringWithFormat:@"%@ %lu节连上", self.course.rawWeek, self.course.period.length];
        } break;
            
        case 1: {
            static NSArray *ary;
            if (!ary) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
                ary = formatter.weekdaySymbols;
            }
            cell.leftDescription = @"时间";
            cell.rightDetail = [NSString stringWithFormat:@"%@ %@", ary[self.course.inWeek % 7], self.course.timeStr];
        } break;
            
        case 2: {
            cell.leftDescription = @"课程类型";
            cell.rightDetail = self.course.type;
        } break;
            
        default:
            break;
    }
    
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

@end
