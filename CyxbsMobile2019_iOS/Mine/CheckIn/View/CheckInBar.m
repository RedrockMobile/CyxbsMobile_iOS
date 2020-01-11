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
#import "CheckInModel.h"

@implementation CheckInBar

- (instancetype)initWithCheckInModel:(CheckInModel *)model {
    self = [super init];
    if (self) {
        // 添加圆点之间的杠杠
        // i表示“星期i”的前面一根杠，星期一前面没有杠
        int flag = 0;
        for (int i = 2; i <= 7; i++) {
            for (NSNumber *j in model.checkInDays) {
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
        
        // 添加小圆点
        for (int i = 1; i <= 7; i++) {
            NSInteger today = [NSDate date].weekday - 1;
            if (i == today) {
                TodaysDot *dot = [[TodaysDot alloc] init];
                dot.center = CGPointMake(8 + (i - 1) * 52.5, 6);
                 [self addSubview:dot];
                [self.dotArray addObject:dot];
                continue;
            }
            
            for (NSNumber *j in model.checkInDays) {
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
    }
    return self;
}

@end
