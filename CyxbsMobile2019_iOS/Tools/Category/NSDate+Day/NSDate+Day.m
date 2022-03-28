//
//  NSDate+Day.m
//  ZhiHu
//
//  Created by SSR on 2022/2/6.
//

#import "NSDate+Day.h"

#pragma mark - NSDate (Day)

@implementation NSDate (Day)

/**返回[NSDate date]*/
+ (NSDate *)today {
    return  [NSDate date];
}

/**设置为昨天*/
- (NSDate *)yesterday {
    return [self dateByAddingTimeInterval:- 24 * 60 * 60];
}

/**设置为明天*/
- (NSDate *)tomorrow {
    return [self dateByAddingTimeInterval:24 * 60 * 60];
}

/**根据formatter取时间nsdate*/
+ (NSDate *)dateString:(NSString *)date WithFormatter:(NSString *)formatter {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:formatter];
    return [format dateFromString:date];
}

/**根据formater取出nsstring*/
- (NSString *)stringWithFormatter:(NSString *)formatter {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:formatter];
    return [format stringFromDate:self];
}

/**快速取出日期*/
- (NSString *)day {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"d"];
    return [format stringFromDate:self];
}

/**快速取出月(数字)*/
- (NSString *)month {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"M"];
    return [format stringFromDate:self];
}

@end

@implementation NSDate (TranslateMonth)

- (NSString *)monthWithTranslate:(DateTranslateMonth)translate {
    switch (translate) {
        case DateTranslateMonthSimpleChinese:
            return [self monthWithSimpleChinese];
        case DateTranslateMonthTraditionalChinese:
            
            break;
        case DateTranslateMonthShortEnglish:
            
            break;
        case DateTranslateMonthLongEnglish:
            
            break;
    }
    return @"";
}

/**将month转为中文@"一月"*/
- (NSString *)monthWithSimpleChinese {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"M"];
    NSInteger month = [[format stringFromDate:self] integerValue];
    switch (month) {
        case 1: return @"一月";
        case 2: return @"二月";
        case 3: return @"三月";
        case 4: return @"四月";
        case 5: return @"五月";
        case 6: return @"六月";
        case 7: return @"七月";
        case 8: return @"八月";
        case 9: return @"九月";
        case 10: return @"十月";
        case 11: return @"十一月";
        case 12: return @"十二月";
        default: return @"";
    }
    return @"";
}

- (NSString *)monthWithTraditionalChinese {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"M"];
    NSInteger month = [[format stringFromDate:self] integerValue];
    switch (month) {
        case 1: return @"正月";
        case 2: return @"如月";
        case 3: return @"辰月";
        case 4: return @"梅月";
        case 5: return @"仲夏";
        case 6: return @"季夏";
        case 7: return @"兰月";
        case 8: return @"桂月";
        case 9: return @"闰月";
        case 10: return @"猪月";
        case 11: return @"冬月";
        case 12: return @"腊月";
        default: return @"";
    }
    return @"";
}

- (NSString *)monthWithShortEnglish {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"M"];
    NSInteger month = [[format stringFromDate:self] integerValue];
    switch (month) {
        case 1: return @"Jan.";
        case 2: return @"Feb.";
        case 3: return @"Mar.";
        case 4: return @"Apr.";
        case 5: return @"May.";
        case 6: return @"Jun.";
        case 7: return @"Jul.";
        case 8: return @"Aug.";
        case 9: return @"Sept.";
        case 10: return @"Oct.";
        case 11: return @"Nov.";
        case 12: return @"Dec.";
        default: return @"";
    }
    return @"";
}

- (NSString *)monthWithLongEnglish {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"M"];
    NSInteger month = [[format stringFromDate:self] integerValue];
    switch (month) {
        case 1: return @"January";
        case 2: return @"February";
        case 3: return @"March";
        case 4: return @"April";
        case 5: return @"May";
        case 6: return @"June";
        case 7: return @"July";
        case 8: return @"August";
        case 9: return @"September";
        case 10: return @"October";
        case 11: return @"November";
        case 12: return @"December";
        default: return @"";
    }
    return @"";
}

@end
