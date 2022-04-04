//
//  NSDate+Day.h
//  SSRSwipe
//
//  Created by SSR on 2022/3/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - NSDate (Day)

@interface NSDate (Day)

/// 今天
+ (NSDate *)today;

/// 这天的前一天
- (NSDate *)yesterday;

/// 这天的后一天
- (NSDate *)tomorrow;

/// 通过dateStr和formatter一一对应获取date
+ (NSDate *)dateString:(NSString *)dateStr fromFormatter:(NSDateFormatter *)formatter withDateFormat:(NSString *)format;

/// 通过formate形式取出数据
- (NSString *)stringFromFormatter:(NSDateFormatter *)formatter withDateFormat:(NSString *)format;

@end

#pragma mark - NSDateFormatter (NSDate)

@interface NSDateFormatter (NSDate)

/// 默认formatter
@property (nonatomic, readonly, strong, class) NSDateFormatter *defaultFormatter;

/// 中文formatter
@property (nonatomic, readonly, strong, class) NSDateFormatter *ChineseFormatter;

@end

NS_ASSUME_NONNULL_END
