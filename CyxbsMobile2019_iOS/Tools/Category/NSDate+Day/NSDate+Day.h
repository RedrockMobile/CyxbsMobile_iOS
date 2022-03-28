//
//  NSDate+Day.h
//  ZhiHu
//
//  Created by SSR on 2022/2/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - NSDate (Day)

@interface NSDate (Day)

/**返回[NSDate date]*/
+ (NSDate *)today;

/**设置为昨天*/
- (NSDate *)yesterday;

/**设置为明天*/
- (NSDate *)tomorrow;

/**根据formatter取时间nsdate*/
+ (NSDate *)dateString:(NSString *)date WithFormatter:(NSString *)formatter;

/**根据formater取出nsstring*/
- (NSString *)stringWithFormatter:(NSString *)formatter;

/**快速取出日期(数字)*/
- (NSString *)day;

/**快速取出月(数字)*/
- (NSString *)month;

@end

typedef NS_ENUM(NSUInteger, DateTranslateMonth) {
    DateTranslateMonthSimpleChinese,// 12 = @"十二月"
    DateTranslateMonthTraditionalChinese,// 12 = @"腊月"
    DateTranslateMonthShortEnglish,// 12 = @"Dec."
    DateTranslateMonthLongEnglish// 12 = @"December"
};

#pragma mark - NSDate (TranslateMonth)

@interface NSDate (TranslateMonth)

/// 将month翻译
- (NSString *)monthWithTranslate:(DateTranslateMonth)translate;

@end

NS_ASSUME_NONNULL_END
