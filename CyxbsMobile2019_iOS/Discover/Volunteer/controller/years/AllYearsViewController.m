//
//  AllYearsViewController.m
//  MoblieCQUPT_iOS
//
//  Created by MaggieTang on 08/10/2017.
//  Copyright © 2017 Orange-W. All rights reserved.
//

#import "AllYearsViewController.h"
#import "HeaderTableViewCell.h"
#import "QueryTableViewCell.h"
#import "BackgroundTableViewCell.h"
#import "HeaderGifRefresh.h"
#import "HttpClient.h"


@interface AllYearsViewController () <UITableViewDataSource, UITableViewDelegate>

//@property (strong, nonatomic) NSMutableArray *mutArray;
////@property (strong, nonatomic) NSMutableArray *mutableArray;
@property (strong, nonatomic) UIImageView *noRecordImage;
@property (strong, nonatomic) NSString *hour;
@property (strong, nonatomic) NSArray<VolunteeringEventItem *> *eventsSortedByYears;

@end

@implementation AllYearsViewController
#define REUESED_SIZE  100
static NSString *reUsedStr[REUESED_SIZE] = {nil}; // 重用标示
#define REUESED_FLAG  reUsedStr[0]

+ (void)initialize{
    if (self == [AllYearsViewController class]){
        for (int i = 0; i < REUESED_SIZE; i++){
            reUsedStr[i] = [NSString stringWithFormat:@"section_%d", i];
            if (i>=2) {
                reUsedStr[i] = [NSString stringWithFormat:@"section_2"];
            }
        }
    }
}

- (void)buildUI {
        if (((NSArray *)self.eventsSortedByYears[0]).count == 0) {
        self.noRecordImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_W, MAIN_SCREEN_H-64)];
        self.noRecordImage.image = [UIImage imageNamed:@"没有记录"];
        self.noRecordImage.contentMode = UIViewContentModeScaleAspectFit;
        
        [self.view addSubview:self.noRecordImage];
    } else {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,MAIN_SCREEN_W, MAIN_SCREEN_H-HEADERHEIGHT-39) style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        UIColor *backgroundColor = [UIColor colorWithRed:244/255.0 green:243/255.0 blue:243/255.0 alpha:1];
        self.tableView.backgroundColor = backgroundColor;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView reloadData];
        
        [self.view addSubview:self.tableView];
    }
}

- (instancetype)initWithVolunteer:(VolunteerItem *)volunteer andYearIndex:(NSInteger)index {
    self = [self init];
    self.volunteer = volunteer;
    self.index = index;
    if (index == 0) {
        self.eventsSortedByYears = volunteer.eventsSortedByYears;
    } else {
        self.eventsSortedByYears = @[volunteer.eventsSortedByYears[index - 1]];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    [self buildUI];
}

#pragma mark tableView数据源

// 分组数
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return self.eventsSortedByYears.count + 2;
}

// 每组行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 1;
    } else {
        // volunteer模型中的eventsSortedByYears是一个将志愿事件按照年份分组排序后的数组。
        // 其中每一个元素都是一个数组，分别为每一年的志愿活动
        return ((NSArray *)self.eventsSortedByYears[section - 2]).count;
    }
}

// 每行Cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 ){
        BackgroundTableViewCell *cell = [[BackgroundTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reUsedStr[indexPath.section]];
        UIColor *myColor = [UIColor colorWithRed:244/255.0 green:243/255.0 blue:243/255.0 alpha:1];
        cell.backgroundColor = myColor;
        
        NSInteger hours = 0;
        for (NSArray *eventArray in self.eventsSortedByYears) {
            for (VolunteeringEventItem *event in eventArray) {
                hours += [event.hour integerValue];
            }
        }
        cell.backgroundLabel3.text = [NSString stringWithFormat:@"%.1f", (CGFloat)hours];
        
        cell.userInteractionEnabled = NO;
        cell.selected = false;
        return cell;
    }
    else if (indexPath.section == 1 ){
        HeaderTableViewCell *cell = [[HeaderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reUsedStr[indexPath.section]];
        UIColor *myColor = [UIColor colorWithRed:244/255.0 green:243/255.0 blue:243/255.0 alpha:1];
        cell.backgroundColor = myColor;
        cell.userInteractionEnabled = NO;
        cell.selected = false;
        return cell;
    }
    QueryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reUsedStr[indexPath.section]];
    if (cell == nil){
        cell = [[QueryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reUsedStr[indexPath.section]];
    }

    [cell.yearsImageView removeFromSuperview];
    [cell.yearsLabel removeFromSuperview];
    
    if (indexPath.row == 0) {
//        NSDate  *currentDate = [NSDate date];
//        NSCalendar *calendar = [NSCalendar currentCalendar];
//        NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
//        NSInteger year=[components year];
        NSInteger year = [[((VolunteeringEventItem *)((NSArray *)self.eventsSortedByYears[0])[0]).creatTime substringToIndex:4] integerValue];
        cell.yearsImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"年份圆圈"]];
        cell.yearsImageView.frame = CGRectMake(15, 0, 31, 31);
        [cell.contentView addSubview:cell.yearsImageView];
        [cell.contentView bringSubviewToFront:cell.yearsImageView];
        cell.yearsLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 9, 28, 11)];
        cell.yearsLabel.textColor = [UIColor whiteColor];
        cell.yearsLabel.text = [NSString stringWithFormat:@"%ld",year - indexPath.section + 2];
        cell.yearsLabel.textAlignment = NSTextAlignmentCenter;
        cell.yearsLabel.font = [UIFont systemFontOfSize:11];
        cell.yearsLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:cell.yearsLabel];
    }
    
    // 每年的每一个志愿
    VolunteeringEventItem *event = ((NSArray *)self.eventsSortedByYears[indexPath.section - 2])[indexPath.row];

    NSDate *date = [NSDate dateWithString:event.creatTime format:@"yyyy-MM-dd"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"MM-dd"];
    cell.cellHourLabel.text = event.hour;
    cell.cellTimeLabel.text = [formatter stringFromDate:date];
    cell.cellAddressLabel.text = event.address;
    cell.cellContentLabel.text = event.eventName;
    cell.userInteractionEnabled = NO;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *redLine = [[UIView alloc]init];
    if (section == 2 || section == 3 || section == 4 || section == 5) {
        redLine.frame = CGRectMake(29, 0, 3, 11);
        redLine.backgroundColor = [UIColor colorWithRed:253/255.0 green:105/255.0 blue:103/255.0 alpha:1];
    }
    if (section == 1) {
        redLine.backgroundColor = [UIColor colorWithRed:244/255.0 green:243/255.0 blue:243/255.0 alpha:1];
    }
    
    return redLine;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *redLine = [[UIView alloc]init];
    if ( section == 3 || section == 4 || section == 5) {
        redLine.frame = CGRectMake(29, 0, 3, 11);
        redLine.backgroundColor = [UIColor colorWithRed:253/255.0 green:105/255.0 blue:103/255.0 alpha:1];
    }
    if (section == 1 ||section == 2) {
        redLine.backgroundColor = [UIColor colorWithRed:244/255.0 green:243/255.0 blue:243/255.0 alpha:1];
    }
    return redLine;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat headerHeight = 0;
    if(section == 2 || section == 3 || section == 4 || section == 5){
        headerHeight = 0;
    }
    if (section == 1) {
        headerHeight = 1;
    }
    if(section == 0){
        headerHeight = 0;
    }
    return headerHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    CGFloat footerHeight = 0;
    if(section == 2 || section == 3 || section == 4 || section == 5){
        footerHeight = 0;
    }
    if (section == 1) {
        footerHeight = 5;
    }
    if(section == 0){
        footerHeight = 0;
    }
    return footerHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowHeight = 0;
    if(indexPath.section == 0){
        rowHeight = (200.f/667)*MAIN_SCREEN_H;
    }
    if (indexPath.section == 1) {
        rowHeight = 20;
    }
    if (indexPath.section == 2 ||indexPath.section == 3 ||indexPath.section == 4 ||indexPath.section == 5 ) {
        rowHeight = 127;
    }
    return rowHeight;
}

@end
