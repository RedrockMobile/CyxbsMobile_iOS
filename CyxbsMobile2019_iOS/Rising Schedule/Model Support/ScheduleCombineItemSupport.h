//
//  ScheduleCombineItemSupport.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/12/14.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScheduleType.h"

NS_ASSUME_NONNULL_BEGIN

/**MARK: ScheduleCombineIdentifier
 * you can use as a `KeyType`
 * like NSDictionary, NSMapTable, NSCache...
 * `- isEqual:` just compare \c sno and \c type
 */

@interface ScheduleIdentifier : NSObject <NSSecureCoding, NSCopying>

// Key

/// 学号
@property (nonatomic, readonly, nonnull, copy) NSString *sno;

/// 请求类型
@property (nonatomic, readonly, nonnull) ScheduleModelRequestType type;

/// 唯一标识符，用于各种key
@property (nonatomic, readonly, copy) NSString *key;

// TimeInterval

/// 开学的第一个"周一"的时间戳
@property (nonatomic) NSTimeInterval exp;
- (void)setExpWithNowWeek:(NSInteger)nowWeek;

/// 最近一次更新的时间戳
/// 可能来自后端，也可能来自内网
@property (nonatomic) NSTimeInterval iat;

// Service

/// 是否开启内网请求
@property (nonatomic) BOOL useWebView;

/// 是否添加到小组件
@property (nonatomic) BOOL useWidget;

/// 是否添加了本地通知
@property (nonatomic) BOOL useNotification;

/// 是否添加到了本地日历
@property (nonatomic) BOOL useCanlender;

// Method

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

- (nullable instancetype)initWithSno:(nullable NSString *)sno type:(nonnull ScheduleModelRequestType)type NS_DESIGNATED_INITIALIZER;

+ (nullable instancetype)identifierWithSno:(nullable NSString *)sno type:(nonnull ScheduleModelRequestType)type;

- (ScheduleIdentifier *)moveFrom:(nullable ScheduleIdentifier *)other;

@end

FOUNDATION_EXPORT NSArray <ScheduleIdentifier *> *ScheduleIdentifiersFromScheduleRequestDictionary(ScheduleRequestDictionary *dictionary);




/**MARK: ScheduleCombineItem
 * design refers to `NSURLQueryItem`
 */

@class ScheduleCourse;

@interface ScheduleCombineItem : NSObject <NSSecureCoding, NSCopying> {
@private
    ScheduleIdentifier *_identifier;
    NSArray <ScheduleCourse *> *_value;
}

- (nullable instancetype)initWithIdentifier:(nullable ScheduleIdentifier *)identifier value:(nullable NSArray <ScheduleCourse *> *)value NS_DESIGNATED_INITIALIZER;

+ (nullable instancetype)combineItemWithIdentifier:(nullable ScheduleIdentifier *)identifier value:(nullable NSArray <ScheduleCourse *> *)value;

@property (readonly) ScheduleIdentifier *identifier;

@property (nullable, readonly) NSArray <ScheduleCourse *> *value;

@end

NS_ASSUME_NONNULL_END
