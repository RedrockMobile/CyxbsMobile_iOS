//
//  NSDate+Day.m
//  SSRSwipe
//
//  Created by SSR on 2022/3/29.
//

#import "NSDate+Day.h"

#pragma mark - NSDate (Day)

@implementation NSDate (Day)

+ (NSDate *)today {
    return  [NSDate date];
}

- (NSDate *)yesterday {
    return [self dateByAddingTimeInterval:- 24 * 60 * 60];
}

- (NSDate *)tomorrow {
    return [self dateByAddingTimeInterval:24 * 60 * 60];
}

+ (NSDate *)dateString:(NSString *)dateStr fromFormatter:(NSDateFormatter *)formatter withDateFormat:(NSString *)format {
    [formatter setDateFormat:format];
    return [formatter dateFromString:dateStr];
}

- (NSString *)stringFromFormatter:(NSDateFormatter *)formatter withDateFormat:(NSString *)format {
    [formatter setDateFormat:format];
    return [formatter stringFromDate:self];
}

@end

#pragma mark - NSDateFormatter (NSDate)

static NSDateFormatter *_defaultFormatter = nil;
static NSDateFormatter *_chineseFormatter = nil;

@implementation NSDateFormatter (NSDate)

+ (NSDateFormatter *)defaultFormatter {
    if (_defaultFormatter == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _defaultFormatter = [[NSDateFormatter alloc] init];
        });
    }
    return _defaultFormatter;
}

+ (NSDateFormatter *)ChineseFormatter {
    if (_chineseFormatter == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _chineseFormatter = [[NSDateFormatter alloc] init];
            _chineseFormatter.monthSymbols =
            @[@"一月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月", @"九月", @"十月", @"十一月", @"十二月"];
            _chineseFormatter.shortMonthSymbols =  @[@"一", @"二", @"三", @"四", @"五", @"六", @"七", @"八", @"九", @"十", @"十一", @"十二"];
            
            _chineseFormatter.veryShortMonthSymbols = _chineseFormatter.veryShortStandaloneMonthSymbols =  _chineseFormatter.shortMonthSymbols;
            
            _chineseFormatter.standaloneMonthSymbols = _chineseFormatter.shortStandaloneMonthSymbols = _chineseFormatter.monthSymbols;
            
            _chineseFormatter.weekdaySymbols = @[@"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", @"星期天"];
            _chineseFormatter.shortWeekdaySymbols = @[@"一", @"二", @"三", @"四", @"五", @"六", @"天"];
            _chineseFormatter.AMSymbol = @"上午";
            _chineseFormatter.PMSymbol = @"下午";
        });
    }
    return _chineseFormatter;
}

@end
