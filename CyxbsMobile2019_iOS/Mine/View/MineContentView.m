//
//  MineContentView.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/10/30.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "MineContentView.h"
#import "MineContentViewProtocol.h"

@interface MineContentView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSArray<NSDictionary<NSString *, id> *> *settingsArray;
@property (nonatomic, assign) BOOL isFold;

@end

@implementation MineContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:252/255.0 alpha:1];
        
        // NSArray<NSDictionary<NSString *, id> *> *settingsArray;
        self.settingsArray = @[
            @{
                @"sectionTitle": @"课前提醒",
                @"settings": @[
                        @{
                            @"title": @"上课前提醒我",
                            @"hasSwitch": @YES
                        },
                        @{
                            @"title": @"每天推送课表给我",
                            @"hasSwitch": @YES
                        },
                        @{
                            @"title": @"在没课的地方显示备忘录",
                            @"hasSwitch": @YES
                        }
                ]
            },
            @{
                @"sectionTitle": @"其他设置",
                @"settings": @[
                        @{
                            @"title": @"启动APP时优先显示课表页面",
                            @"hasSwitch": @YES
                        },
                        @{
                            @"title": @"自定义桌面小图标",
                            @"hasSwitch": @NO
                        },
                        @{
                            @"title": @"意见与反馈",
                            @"hasSwitch": @NO
                        },
                        @{
                            @"title": @"红岩网校",
                            @"hasSwitch": @NO
                        }
                ]
            }
        ];
        
        // 添加课前提醒TableView
        UITableView *classScheduleSettingsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_W, MAIN_SCREEN_H) style:UITableViewStyleGrouped];
        classScheduleSettingsTable.delegate = self;
        classScheduleSettingsTable.dataSource = self;
        classScheduleSettingsTable.backgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:252/255.0 alpha:1];
        classScheduleSettingsTable.rowHeight = 55;
        classScheduleSettingsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        classScheduleSettingsTable.showsVerticalScrollIndicator = NO;
        [self addSubview:classScheduleSettingsTable];
        self.classScheduleTableView = classScheduleSettingsTable;
        
        // 添加headerView（个人信息相关）
        MineHeaderView *headerView = [[MineHeaderView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_W, MAIN_SCREEN_W * 0.776)];
        classScheduleSettingsTable.tableHeaderView = headerView;
        self.headerView = headerView;
        [headerView.editButton addTarget:self action:@selector(editButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        // 添加FooterView（APP设置TableView）
        UITableView *appSettingTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_W, 55 * ((NSArray *)(self.settingsArray[1][@"settings"])).count + 58) style:UITableViewStyleGrouped];
        appSettingTabelView.delegate = self;
        appSettingTabelView.dataSource = self;
        appSettingTabelView.backgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:252/255.0 alpha:1];
        appSettingTabelView.rowHeight = 55;
        appSettingTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
        appSettingTabelView.showsVerticalScrollIndicator = NO;
        appSettingTabelView.scrollEnabled = NO;
        self.appSettingTableView = appSettingTabelView;
        classScheduleSettingsTable.tableFooterView = appSettingTabelView;
    }
    return self;
}


#pragma mark - TableVIew数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.classScheduleTableView) {
        if (self.isFold) {
            return 0;
        } else {
            return ((NSArray *)(self.settingsArray[0][@"settings"])).count;;
        }
    } else {
        return ((NSArray *)(self.settingsArray[1][@"settings"])).count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
    
    cell.backgroundColor = tableView.backgroundColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [UIColor colorWithRed:25/255.0 green:56/255.0 blue:102/255.0 alpha:1.0];
    if (tableView == self.classScheduleTableView) {
        cell.textLabel.font = [UIFont systemFontOfSize:13];
    } else {
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    
    if (tableView == self.classScheduleTableView) {
        cell.textLabel.text = ((NSArray *)(self.settingsArray[0][@"settings"]))[indexPath.row][@"title"];
        
        // 添加开关
        if ([((NSArray *)(self.settingsArray[0][@"settings"]))[indexPath.row][@"hasSwitch"] boolValue]) {
            UISwitch *settingSwitch = [[UISwitch alloc] init];
            settingSwitch.frame = CGRectMake(MAIN_SCREEN_W - 80, 11.5, 53, 27);
            settingSwitch.onTintColor = [UIColor colorWithRed:41/255.0 green:33/255.0 blue:214/255.0 alpha:1.0];
            settingSwitch.backgroundColor = [UIColor colorWithRed:195/255.0 green:212/255.0 blue:238/255.0 alpha:1.0];
            settingSwitch.layer.cornerRadius = settingSwitch.height / 2.0;
            [cell.contentView addSubview:settingSwitch];
        }
    } else {
        cell.textLabel.text = ((NSArray *)(self.settingsArray[1][@"settings"]))[indexPath.row][@"title"];
        
        // 添加开关
        if ([((NSArray *)(self.settingsArray[1][@"settings"]))[indexPath.row][@"hasSwitch"] boolValue]) {
            UISwitch *settingSwitch = [[UISwitch alloc] init];
            settingSwitch.frame = CGRectMake(MAIN_SCREEN_W - 80, 11.5, 53, 27);
            settingSwitch.onTintColor = [UIColor colorWithRed:41/255.0 green:33/255.0 blue:214/255.0 alpha:1.0];
            settingSwitch.backgroundColor = [UIColor colorWithRed:200/255.0 green:217/255.0 blue:243/255.0 alpha:1.0];
            settingSwitch.layer.cornerRadius = settingSwitch.height / 2.0;
            [cell.contentView addSubview:settingSwitch];
        }
    }
    
    return  cell;
}

// Section的header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.classScheduleTableView) {
        tableView.sectionHeaderHeight = 54;
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_W, 32)];
        headerView.backgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:252/255.0 alpha:1];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, 70, 21)];
        titleLabel.text = self.settingsArray[section][@"sectionTitle"];
        titleLabel.font = [UIFont fontWithName:@"PingFang SC-Medium" size:15];
        titleLabel.textColor = [UIColor colorWithRed:17/255.0 green:44/255.0 blue:84/255.0 alpha:1.0];
        [headerView addSubview:titleLabel];
        
        UIButton *foldButton = [[UIButton alloc] initWithFrame:CGRectMake(MAIN_SCREEN_W - 27 - 19, 15, 22, 22)];
        foldButton.imageEdgeInsets = UIEdgeInsetsMake(7, 3, 7, 3);
        foldButton.backgroundColor = [UIColor colorWithRed:195/255.0 green:212/255.0 blue:238/255.0 alpha:1.0];
        if (self.isFold) {
            foldButton.transform = CGAffineTransformMakeRotation(-M_PI_2);
        }
        [foldButton addTarget:self action:@selector(foldButtonClicked:foldState:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:foldButton];
        
        return headerView;
    } else {
        tableView.sectionHeaderHeight = 24;
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_W, 22)];
        headerView.backgroundColor = tableView.backgroundColor;
        UIView *separateLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_W, 1)];
        separateLine.backgroundColor = [UIColor colorWithRed:228/255.0 green:232/255.0 blue:238/255.0 alpha:1.0];
        [headerView addSubview:separateLine];
        return headerView;
    }
}


#pragma mark - 按钮回调
- (void)editButtonClicked {
    if ([self.delegate respondsToSelector:@selector(editButtonClicked)]) {
        [self.delegate editButtonClicked];
    }
}

- (void)foldButtonClicked:(UIButton *)foldButton foldState:(BOOL)isFold {
    if ([self.delegate respondsToSelector:@selector(foldButtonClicked:foldState:)]) {
        [UserDefaultTool saveValue:@(![[UserDefaultTool valueWithKey:@"Mine_isFold"] boolValue]) forKey:@"Mine_isFold"];
        [self.delegate foldButtonClicked:foldButton foldState:self.isFold];
    }
}


#pragma mark - getter, setter
- (BOOL)isFold {
    BOOL Mine_isFold = [[UserDefaultTool valueWithKey:@"Mine_isFold"] boolValue];
    if (!Mine_isFold) {
        [UserDefaultTool saveValue:@NO forKey:@"Mine_isFold"];
        _isFold = NO;
    } else {
        _isFold = Mine_isFold;
    }
    return _isFold;
}

@end
