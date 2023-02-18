//
//  ScheduleCombineItemSupport.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/12/14.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ScheduleRequestType.h"

NS_ASSUME_NONNULL_BEGIN

/**MARK: ScheduleCombineIdentifier
 * you can use as a `KeyType`
 * like NSDictionary, NSMapTable, NSCache...
 * `- isEqual:` just compare \c sno and \c type
 */

@interface ScheduleIdentifier : NSObject <NSSecureCoding, NSCopying>

/// set as sno cause the key use
@property (nonatomic, readonly, copy) NSString *sno;

/// set cause the key use
@property (nonatomic, readonly) ScheduleModelRequestType type;

/// The time for nowWeek
@property (nonatomic) NSTimeInterval exp;
- (void)setExpWithNowWeek:(NSInteger)nowWeek;

/// The last request time you can save
@property (nonatomic) NSTimeInterval iat;

/// return type + name
@property (nonatomic, readonly, copy) NSString *key;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithSno:(NSString *)sno type:(ScheduleModelRequestType)type NS_DESIGNATED_INITIALIZER;

+ (instancetype)identifierWithSno:(NSString *)sno type:(ScheduleModelRequestType)type;

@end

FOUNDATION_EXPORT NSArray <ScheduleIdentifier *> *ScheduleIdentifiersFromScheduleRequestDictionary(ScheduleRequestDictionary *dictionary);
FOUNDATION_EXPORT ScheduleRequestDictionary *ScheduleRequestDictionaryFromScheduleIdentifiers(NSArray <ScheduleIdentifier *> *ary);




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