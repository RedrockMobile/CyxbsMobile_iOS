//
//  MessageSettingVC.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/4/21.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "MessageSettingVC.h"
#import <UserNotifications/UserNotifications.h>

#import "SSRTopBarBaseView.h"

#import "MessageSettingCell.h"

#pragma mark -  MessageSettingVC ()

@interface MessageSettingVC () <
    UITableViewDelegate,
    UITableViewDataSource,
    MessageSettingCellDelegate
>

/// 顶视图
@property (nonatomic, strong) SSRTopBarBaseView *topView;

/// 设置的东西
@property (nonatomic, strong) UITableView *tableView;

@end

#pragma mark - MessageSettingVC

@implementation MessageSettingVC

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorNamed:@"242_243_248_1&29_29_29_1"];
    
    [self.view addSubview:self.topView];
    [self.view addSubview:self.tableView];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    if ([USER_DEFAULT boolForKey:MineMessage_needSignWarn_BOOL]) {
        NSDateComponents *components = [[NSDateComponents alloc] init];
        components.hour = 18;
        
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        content.title = @"今日你签到了吗？";
        content.body = @"一定要记得签到哟～";
        content.sound = UNNotificationSound.defaultSound;
        
        UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:YES];
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:MineMessage_notificationRequest_identifier content:content.copy trigger:trigger];
        [center addNotificationRequest:request withCompletionHandler:nil];
    } else {
        [center removePendingNotificationRequestsWithIdentifiers:@[MineMessage_notificationRequest_identifier]];
    }
}

#pragma mark - Method

// MARK: SEL

- (void)messageSetingVC_pop {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    switch (section) {
        case 0: return @"关闭后不再显示活动消息";
        case 1: return @"打开后18点提醒签到（需要获取系统消息推送权限）";
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:MessageSettingCellReuseIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    
    NSString *name ;
    BOOL shouldOn = NO;
    switch (indexPath.section) {
        case 0: {
            name = @"消息提醒";
            shouldOn = [USER_DEFAULT boolForKey:MineMessage_needMsgWarn_BOOL];
            break;
        }
        case 1: {
            name = @"签到提醒";
            shouldOn = [USER_DEFAULT boolForKey:MineMessage_needSignWarn_BOOL];
            break;
        }
    }
    [cell drawWithTitle:name switchOn:shouldOn];
    
    return cell;
}

#pragma mark - <MessageSettingCellDelegate>

- (void)messageSettingCell:(MessageSettingCell *)cell swipeSwitch:(UISwitch *)aSwitch {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    switch (indexPath.section) {
        case 0: {
            [USER_DEFAULT setBool:aSwitch.on forKey:MineMessage_needMsgWarn_BOOL];
            return;
        }
        case 1: {
            [USER_DEFAULT setBool:aSwitch.on forKey:MineMessage_needSignWarn_BOOL];
            return;
        }
    }
}

#pragma mark - Getter

- (SSRTopBarBaseView *)topView {
    if (_topView == nil) {
        _topView = [[SSRTopBarBaseView alloc] initWithSafeViewHeight:44];
        _topView.hadLine = NO;
        [_topView addTitle:@"设置"
              withTitleLay:SSRTopBarBaseViewTitleLabLayLeft
                 withStyle:nil];
        [_topView addBackButtonTarget:self action:@selector(messageSetingVC_pop)];
    }
    return _topView;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(16, self.topView.bottom, self.view.width - 2 * 16, self.view.height - self.topView.bottom) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.contentSize = CGSizeZero;
        [_tableView registerClass:MessageSettingCell.class forCellReuseIdentifier:MessageSettingCellReuseIdentifier];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
