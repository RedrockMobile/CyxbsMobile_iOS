//
//  ActivityTableViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/11/11.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "ActivityTableViewController.h"
#import "ActivityTableViewCell.h"
#import "ActivityView.h"
#import "VolunteerActivity.h"
#import "ActivityItem.h"

@interface ActivityTableViewController ()

@end

@implementation ActivityTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.itemsArray = [NSMutableArray array];
    [self setVolunteerActivityList];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
}

- (void)setVolunteerActivityList {
    VolunteerActivity *model = [[VolunteerActivity alloc] init];
    [model loadActivityList];
    
    [model setBlock:^(id  _Nonnull info) {
        NSArray *dataArray = info[@"data"];
        for (NSDictionary *dic in dataArray) {
            ActivityItem *item = [[ActivityItem alloc] initWithDic:dic];
            [self->_itemsArray addObject:item];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (!self.vcCanScroll) {
        scrollView.contentOffset = CGPointZero;
    }
    if (scrollView.contentOffset.y <= 0) {
        self.vcCanScroll = NO;
        scrollView.contentOffset = CGPointZero;
        //到顶通知父视图改变状态
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leaveTop" object:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"activity"];
    if (cell == nil) {
        cell = [[ActivityTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"activity"];
    }
    ActivityItem *item = self.itemsArray[indexPath.row];
    cell.activityLabel.text = item.name;
    cell.hourLabel.text = [NSString stringWithFormat:@"志愿时长：%@",item.hour];
    cell.dateLabel.text = [NSString stringWithFormat:@"志愿服务时间：%@",[self getDateStringWithTimeStr:item.last_date]];
    NSString *day = [self theDay:[self currentTimeStr] And:item.sign_up_last];
    cell.countdownLabel.textColor = [day intValue] < 3 ? [UIColor colorWithRed:255.0/255.0 green:98.0/255.0 blue:98.0/255.0 alpha:1] : [UIColor colorWithRed:58.0/255.0 green:57.0/255.0 blue:211.0/255.0 alpha:1];
    cell.countdownLabel.text = [day intValue] < 0 ? @"已结束" : [NSString stringWithFormat:@"距离报名结束：%@天",day];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREEN_HEIGHT * 0.1912;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ///通过通知中心，通知QueryController弹出志愿活动的详细信息，并传出一个dictionary，将cell里的相关信息传出去
    ActivityItem *item = self.itemsArray[indexPath.row];
    NSDictionary *dic = @{@"Activity":item.name,
                          @"describe":item.descript,
                          @"signUpTime":[self getDateStringWithTimeStr:item.sign_up_last],
                          @"activityTime":[self getDateStringWithTimeStr:item.last_date],
                          @"activityHour":item.hour
    };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ClickedActivityCell" object:nil userInfo:dic];
}


- (NSString *)getDateStringWithTimeStr:(NSString *)str{
    NSTimeInterval time=[str doubleValue]/1000;
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    return currentDateStr;
}

//获取当前时间戳
- (NSString *)currentTimeStr{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time=[date timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}

- (NSString *)theDay:(NSString *)str1 And:(NSString *)str2 {
        
    NSTimeInterval timer1 = [str1 doubleValue];
    NSTimeInterval timer2 = [str2 doubleValue];
        
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timer1];
    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:timer2];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit =NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *cmps = [calendar components:unit fromDate:date toDate:date2 options:0];
    return [NSString stringWithFormat:@"%ld",(long)cmps.day];
}

@end
