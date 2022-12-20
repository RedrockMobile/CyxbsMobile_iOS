//
//  ScheduleCombineItemSupport.mm
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/12/14.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleCombineItemSupport.h"

#import "ScheduleCourse.h"

#import "ScheduleCombineIdentifier+WCTTableCoding.h"

#import <YYKit/NSDate+YYAdd.h>

#pragma mark - ScheduleIdentifier

@implementation ScheduleIdentifier

WCDB_IMPLEMENTATION(ScheduleIdentifier)

WCDB_SYNTHESIZE(ScheduleIdentifier, sno)
WCDB_SYNTHESIZE(ScheduleIdentifier, type)
WCDB_SYNTHESIZE(ScheduleIdentifier, iat)

- (instancetype)initWithSno:(NSString *)name type:(ScheduleModelRequestType)type {
    self = [super init];
    if (self) {
        _sno = name.copy;
        _type = type;
        _iat = NSDate.date.timeIntervalSince1970;
    }
    return self;
}

+ (instancetype)identifierWithSno:(NSString *)sno type:(ScheduleModelRequestType)type {
    return [[ScheduleIdentifier alloc] initWithSno:sno type:type];
}

#pragma mark - Override

- (NSUInteger)hash {
    return self.key.hash;
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:ScheduleIdentifier.class]) {
        ScheduleIdentifier *obj = (ScheduleIdentifier *)object;
        return [self.sno isEqualToString:obj.sno] && self.type == obj.type;
    }
    return NO;
}

#pragma mark -

- (NSString *)key {
    return [_type stringByAppendingString:_sno].copy;
}

- (void)setExpWithNowWeek:(NSInteger)nowWeek {
    NSUInteger aboveWeek = NSDate.date.weekday + 6;
    NSUInteger todayWeek = aboveWeek % 8 + aboveWeek / 7;
    NSTimeInterval beforNow = (nowWeek - 1) * 7 * 24 * 60 * 60 + todayWeek * 24 * 60 * 60;
    _exp = [NSDate dateWithTimeIntervalSinceNow:-beforNow].timeIntervalSince1970;
}

#pragma mark - <NSSecureCoding>

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)decoder {
    NSString *sno = [decoder decodeObjectOfClass:NSString.class forKey:@"sno"];
    NSString *type = [decoder decodeObjectOfClass:NSString.class forKey:@"type"];
    NSTimeInterval iat = [decoder decodeDoubleForKey:@"iat"];
    NSTimeInterval exp = [decoder decodeDoubleForKey:@"exp"];
    self = [self initWithSno:sno type:type];
    self.iat = iat;
    self.exp = exp;
    if (!self) {
        return nil;
    }
    return self;
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:self.sno forKey:@"sno"];
    [coder encodeObject:self.type forKey:@"type"];
    [coder encodeDouble:self.iat forKey:@"iat"];
    [coder encodeDouble:self.exp forKey:@"exp"];
}

#pragma mark - <NSCopying>

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    ScheduleIdentifier *obj = [[ScheduleIdentifier alloc] initWithSno:self.sno type:self.type];
    obj.iat = self.iat;
    return obj;
}

@end

#pragma mark - ScheduleCombineItem

@implementation ScheduleCombineItem

- (instancetype)init {
    return [self initWithName:[ScheduleIdentifier alloc] value:nil];
}

- (instancetype)initWithName:(ScheduleIdentifier *)name value:(NSArray<ScheduleCourse *> *)value {
    self = [super init];
    if (self) {
        _identifier = name;
        _value = value;
    }
    return self;
}

+ (instancetype)combineItemWithIdentifier:(ScheduleIdentifier *)name value:(NSArray<ScheduleCourse *> *)value {
    return [[ScheduleCombineItem alloc] initWithName:name value:value];
}

#pragma mark - <NSSecureCoding>

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)decoder {
    ScheduleIdentifier *identifier = [decoder decodeObjectOfClass:ScheduleIdentifier. class forKey:@"name"];
    NSArray <ScheduleCourse *> *courses = [decoder decodeObjectOfClass:NSArray.class forKey:@"value"];
    self = [self initWithName:identifier value:courses];
    if (!self) {
        return nil;
    }
    return self;
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:_identifier forKey:@"name"];
    [coder encodeObject:_value forKey:@"value"];
}

#pragma mark - <NSCopying>

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    return [[ScheduleCombineItem allocWithZone:zone] initWithName:self.identifier value:self.value];
}

@end
