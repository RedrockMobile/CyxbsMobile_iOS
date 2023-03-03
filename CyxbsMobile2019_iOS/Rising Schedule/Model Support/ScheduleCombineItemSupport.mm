//
//  ScheduleCombineItemSupport.mm
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/12/14.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleCombineItemSupport.h"

#import "ScheduleCourse.h"

#pragma mark - ScheduleIdentifier

#import "ScheduleIdentifier+WCTTableCoding.h"

#ifdef WCDB_h

@implementation ScheduleIdentifier

WCDB_IMPLEMENTATION(ScheduleIdentifier)

WCDB_SYNTHESIZE(ScheduleIdentifier, sno)
WCDB_SYNTHESIZE(ScheduleIdentifier, type)
WCDB_SYNTHESIZE(ScheduleIdentifier, iat)
WCDB_SYNTHESIZE(ScheduleIdentifier, exp)

#else

@implementation ScheduleIdentifier

#endif

- (instancetype)initWithSno:(NSString *)name type:(ScheduleModelRequestType)type {
    self = [super init];
    if (self) {
        _sno = name.copy;
        _type = requestTypeForString(type);
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

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@, %p>; [%@, %@] : (exp: %.0lf, iat: %.0lf)", NSStringFromClass(self.class), self, self.sno, self.type, self.exp, self.iat];
}

#pragma mark - Method

- (NSString *)key {
    return [_type stringByAppendingString:_sno].copy;
}

- (void)setExpWithNowWeek:(NSInteger)nowWeek {
    NSUInteger weekday = [NSCalendar.currentCalendar components:NSCalendarUnitWeekday fromDate:NSDate.date].weekday;
    NSUInteger aboveWeek = weekday + 6;
    NSUInteger todayWeek = aboveWeek % 8 + aboveWeek / 8;
    NSTimeInterval beforNow = 0;
    if (nowWeek > 0) {
        beforNow = (nowWeek - 1) * 7 * 24 * 60 * 60 + (todayWeek - 1) * 24 * 60 * 60;
    } else if (nowWeek == 0) {
        beforNow = -(fabs(8 - todayWeek) * 24 * 60 * 60);
    } else {
        beforNow = -((nowWeek + 1) * 7 * 24 * 60 * 60 + fabs(8 - todayWeek) * 24 * 60 * 60);
    }
    _exp = [NSDate dateWithTimeIntervalSinceNow:-beforNow].timeIntervalSince1970;
}

#pragma mark - WCDB

- (void)setSno:(NSString *)sno {
    _sno = sno.copy;
}

- (void)setType:(ScheduleModelRequestType)type {
    _type = requestTypeForString(type);
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
    self = [self initWithSno:sno type:requestTypeForString(type)];
    self.iat = iat;
    self.exp = exp;
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
    ScheduleIdentifier *obj = [[ScheduleIdentifier alloc] initWithSno:self.sno.copy type:self.type];
    obj.iat = self.iat;
    obj.exp = self.exp;
    return obj;
}

@end

NSArray <ScheduleIdentifier *> *ScheduleIdentifiersFromScheduleRequestDictionary(ScheduleRequestDictionary *dictionary) {
    NSMutableArray *ary = NSMutableArray.array;
    for (NSString *key in dictionary.allKeys) {
        for (NSString *sno in dictionary[key]) {
            ScheduleIdentifier *identifier = [ScheduleIdentifier identifierWithSno:sno type:key];
            [ary addObject:identifier];
        }
    }
    return ary;
}

ScheduleRequestDictionary *ScheduleRequestDictionaryFromScheduleIdentifiers(NSArray <ScheduleIdentifier *> *ary) {
    NSMutableDictionary *finDic = NSMutableDictionary.dictionary;
    for (ScheduleIdentifier *identifier in ary) {
        if ([finDic objectForKey:identifier.type] == nil) {
            [finDic setObject:NSMutableArray.array forKey:identifier.type];
        }
        [finDic[identifier.type] addObject:identifier.sno];
    }
    return finDic.copy;
}




#pragma mark - ScheduleCombineItem

@implementation ScheduleCombineItem

- (instancetype)init {
    return [self initWithIdentifier:nil value:nil];
}

- (instancetype)initWithIdentifier:(ScheduleIdentifier *)name value:(NSArray<ScheduleCourse *> *)value {
    if (name == nil && value == nil) {
        return nil;
    }
    self = [super init];
    if (self) {
        _identifier = name;
        _value = value;
    }
    return self;
}

+ (instancetype)combineItemWithIdentifier:(ScheduleIdentifier *)name value:(NSArray<ScheduleCourse *> *)value {
    return [[ScheduleCombineItem alloc] initWithIdentifier:name value:value];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@, %p> [%@ : count: %ld]", NSStringFromClass(self.class), self, self.identifier, self.value.count];
}

#pragma mark - <NSSecureCoding>

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)decoder {
    ScheduleIdentifier *identifier = [decoder decodeObjectOfClass:ScheduleIdentifier. class forKey:@"name"];
    NSArray <ScheduleCourse *> *courses = [decoder decodeObjectForKey:@"value"];
    self = [self initWithIdentifier:identifier value:courses];
    return self;
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:_identifier forKey:@"name"];
    [coder encodeObject:_value forKey:@"value"];
}

#pragma mark - <NSCopying>

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    return [[ScheduleCombineItem allocWithZone:zone] initWithIdentifier:self.identifier.copy value:self.value.copy];
}

@end
