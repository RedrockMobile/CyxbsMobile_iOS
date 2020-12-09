//
//  TimeTableViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/11/11.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "TimeTableViewController.h"
#import "TimeTableViewCell.h"
#import "YearTableViewCell.h"

@interface TimeTableViewController ()<YearTableViewCellDelegate>

@property (strong, nonatomic) NSString *hour;
@property (strong, nonatomic) NSArray<VolunteeringEventItem *> *eventArray;
@property (strong, nonatomic) NSArray<NSMutableArray<VolunteeringEventItem *> *> *eventsSortedByYears;

@end

@implementation TimeTableViewController


- (instancetype)initWithVolunteer:(VolunteerItem *)volunteer andYearIndex:(NSInteger)index {
    self = [self init];
    self.index = index;
    self.volunteer = volunteer;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hour = self.volunteer.hour;
    self.eventArray = self.volunteer.eventsArray;
    self.eventsSortedByYears = self.volunteer.eventsSortedByYears;
    if (@available(iOS 11.0, *)) {
        self.view.backgroundColor = [UIColor colorNamed:@"MGDActivityBackColor"];
    } else {
        // Fallback on earlier versions
    }
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
}

#pragma mark - Table view data source

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
    if (self.index == 0) {
        return self.eventArray.count+1;
    }else {
        return self.eventsSortedByYears[self.index-1].count + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static NSString *ID1 = @"year";
        YearTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID1];
        if (!cell) {
            cell = [[YearTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID1];
            cell.userInteractionEnabled = YES;
            cell.yearLabel.text = [self showYearLabel];
            if (self.index == 0) {
                cell.totalLabel.text = [NSString stringWithFormat:@"共%@小时",self.volunteer.hour];
            }else {
                int totalTime = 0;
                for (VolunteerItem *event in self.eventsSortedByYears[self.index-1]) {
                    totalTime += [event.hour intValue];
                }
                cell.totalLabel.text = [NSString stringWithFormat:@"共%d小时",totalTime];
            }
            //志愿活动的页面，年份选择的cell，设置其代理
            cell.delegate = self;
        }
        return cell;
    } else {
        static NSString *ID2 = @"time";
        TimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID2];
        if (!cell) {
            cell = [[TimeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID2];
        }
        
        VolunteeringEventItem *event = [[VolunteeringEventItem alloc] init];
        if (self.index == 0) {
            event = self.eventArray[indexPath.row-1];
        }else {
            event = self.eventsSortedByYears[self.index-1][indexPath.row-1];
        }
        
        cell.dateLabel.text = [event.start_time substringFromIndex:5];
        cell.volunteerLabel.text = event.content;
        cell.timeLabel.text = event.hour;
        cell.areaLabel.text = event.addWay;
        cell.groupLabel.text = event.server_group;
        /// new model (包括时间，项目名称，时长等信息取出来）
        cell.userInteractionEnabled = NO;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 45;
    }
    return 190;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


#pragma mark -YearTableViewCellDelegate
///代理方法为发送通知，通知QueryViewController弹出UIPickView
- (void)yearChooseBtnClicked {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"YearChoose" object:nil];
}

- (NSString *)showYearLabel {
    NSString *year = [[NSString alloc] init];
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
   
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *lastYear1 = [[NSDateComponents alloc] init];
    NSDateComponents *lastYear2 = [[NSDateComponents alloc] init];
    NSDateComponents *lastYear3 = [[NSDateComponents alloc] init];
    NSDateComponents *lastYear4 = [[NSDateComponents alloc] init];
    [lastYear1 setYear:0];
    [lastYear2 setYear:-1];
    [lastYear3 setYear:-2];
    [lastYear4 setYear:-3];
    NSDate *newdate1 = [calendar dateByAddingComponents:lastYear1 toDate:currentDate options:0];
    NSDate *newdate2 = [calendar dateByAddingComponents:lastYear2 toDate:currentDate options:0];
    NSDate *newdate3 = [calendar dateByAddingComponents:lastYear3 toDate:currentDate options:0];
    NSDate *newdate4 = [calendar dateByAddingComponents:lastYear4 toDate:currentDate options:0];
    NSString *dateStr1 = [formatter stringFromDate:newdate1];
    NSString *dateStr2 = [formatter stringFromDate:newdate2];
    NSString *dateStr3 = [formatter stringFromDate:newdate3];
    NSString *dateStr4 = [formatter stringFromDate:newdate4];
    
    if (self.index == 0) year = @"全部";
    if (self.index == 1) year = [NSString stringWithFormat:@"%@",dateStr1];
    if (self.index == 2) year = [NSString stringWithFormat:@"%@",dateStr2];
    if (self.index == 3) year = [NSString stringWithFormat:@"%@",dateStr3];
    if (self.index == 4) year = [NSString stringWithFormat:@"%@",dateStr4];
    
    return year;
}






@end
