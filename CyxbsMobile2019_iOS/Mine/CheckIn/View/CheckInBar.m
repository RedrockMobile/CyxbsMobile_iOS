//
//  CheckInBar.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/1/10.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "CheckInBar.h"
#import "CheckedInDot.h"
#import "DidNotCheckInDot.h"
#import "TodaysDot.h"

@interface CheckInBar ()

@property (nonatomic, copy) NSArray *weekInfo;
@property (nonatomic, assign) int isCheckedInToday;

@end

@implementation CheckInBar

#pragma mark - Getter
- (NSArray *)weekInfo {
    NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:7];
    for (int i = 0; i < [UserItemTool defaultItem].week_info.length; i++) {
        if ([[[UserItemTool defaultItem].week_info substringWithRange:NSMakeRange(i, 1)] isEqualToString:@"1"]) {
            [tmp addObject:@(7 - i)];
        }
    }
    return tmp;
}

- (int)isCheckedInToday {
    if ([UserItemTool defaultItem].rank.intValue == 0) {
        return 0;
    } else {
        return 1;
    }
}


- (instancetype)init {
    self = [super init];
    if (self) {
        [self drawBars];
        [self drawDots];
    }
    return self;
}

- (void)drawBars {
    // 添加圆点之间的杠杠
    // i表示“星期i”的前面一根杠，星期一前面没有杠
    int flag = 0;
    for (int i = 2; i <= 7; i++) {
        for (NSNumber *j in self.weekInfo) {
            if (i == j.intValue) {
                flag = 1;
                break;
            }
        }
        
        if (flag == 1) {
            UIView *bar = [[UIView alloc] init];
            bar.backgroundColor = [UIColor colorWithRed:58/255.0 green:53/255.0 blue:210/255.0 alpha:1];
            bar.frame = CGRectMake(16 + (i - 2) * 52.5, 13.5, 52.5, 5);
            [self addSubview:bar];
            [self.barArray addObject:bar];
        } else {
            UIView *bar = [[UIView alloc] init];
            bar.backgroundColor = [UIColor colorWithRed:225/255.0 green:230/255.0 blue:240/255.0 alpha:1];
            bar.frame = CGRectMake(16 + (i - 2) * 52.5, 13.5, 52.5, 5);
            [self addSubview:bar];
            [self.barArray addObject:bar];
        }
        flag = 0;
    }
}

- (void)drawDots {
    // 添加小圆点
    int flag = 0;
    NSInteger today;
    if ([NSDate date].weekday == 1) {
        today = 7;
    } else {
        today = [NSDate date].weekday - 1;
    }
    
    for (int i = 1; i <= 7; i++) {
        
        if (i == today) {
            TodaysDot *dot = [[TodaysDot alloc] init];
            dot.center = CGPointMake(6 + (i - 1) * 52.5, 6);
             [self addSubview:dot];
            [self.dotArray addObject:dot];
            continue;
        }
        
        for (NSNumber *j in self.weekInfo) {
            if (i == j.intValue) {
                flag = 1;
                break;
            }
        }
        
        if (flag == 1) {
            CheckedInDot *dot = [[CheckedInDot alloc] init];
            dot.center = CGPointMake(8 + (i - 1) * 52.5, 8);
            [self addSubview:dot];
            [self.dotArray addObject:dot];
        } else {
            DidNotCheckInDot *dot = [[DidNotCheckInDot alloc] init];
            dot.center = CGPointMake(8 + (i - 1) * 52.5, 8);
            [self addSubview:dot];
            [self.dotArray addObject:dot];
        }
        flag = 0;
    }
    
    // 添加显示星期几的label
    // 第0个空字符串是为了对齐下标和星期几，占位用的
    NSArray *weekdays = @[@"", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", @"周日"];
    for (int i = 1; i <= 7; i++) {
        UILabel *weekdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(5 + (i - 1) * 52.5, 32, 23, 16)];
        weekdayLabel.text = weekdays[i];
        weekdayLabel.font = [UIFont systemFontOfSize:11];
        weekdayLabel.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:0.35];
        [self addSubview:weekdayLabel];
    }
    
    UIImageView *integralImageView = [[UIImageView alloc] init];
    integralImageView.frame = CGRectMake(-11 + (today - 1) * 52, -39, 53, 29);
    integralImageView.backgroundColor = [UIColor colorWithRed:212/255.0 green:218/255.0 blue:255/255.0 alpha:1];
    [self addSubview:integralImageView];
    
    // 计算签到可获得积分
    NSInteger checkInDays = [UserItemTool defaultItem].checkInDay.integerValue;
    NSInteger integral = 0;
    // 签到天数大于星期数
    if (checkInDays > today) {
        integral = 10 + today * 5 - self.isCheckedInToday * 5;
    } else {
        integral = 10 + checkInDays * 5 - self.isCheckedInToday * 5;
    }
    if (integral > 30) {
        integral = 30;
    }
    
    UILabel *integralLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, 38, 16)];
    integralLabel.text = [NSString stringWithFormat:@"%ld积分", integral];
    integralLabel.textColor = [UIColor colorWithRed:72/255.0 green:65/255.0 blue:226/255.0 alpha:0.73];
    integralLabel.font = [UIFont systemFontOfSize:11];
    [integralImageView addSubview:integralLabel];
}

@end
