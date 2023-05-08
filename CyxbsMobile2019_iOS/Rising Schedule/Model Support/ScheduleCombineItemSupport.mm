//
//  ScheduleCombineItemSupport.mm
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/12/14.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleCombineItemSupport.h"

#import "ScheduleNeedsSupport.h"
#import "ScheduleCourse.h"

#pragma mark - ScheduleIdentifier

#import "ScheduleIdentifier+WCTTableCoding.h"

@implementation ScheduleIdentifier

#ifdef WCDB_h

WCDB_IMPLEMENTATION(ScheduleIdentifier)

WCDB_SYNTHESIZE(ScheduleIdentifier, sno)
WCDB_SYNTHESIZE(ScheduleIdentifier, type)

WCDB_SYNTHESIZE(ScheduleIdentifier, useWebView)
WCDB_SYNTHESIZE(ScheduleIdentifier, useWidget)
WCDB_SYNTHESIZE(ScheduleIdentifier, useNotification)
WCDB_SYNTHESIZE(ScheduleIdentifier, useCanlender)

WCDB_SYNTHESIZE(ScheduleIdentifier, iat)
WCDB_SYNTHESIZE(ScheduleIdentifier, exp)

#endif

- (instancetype)initWithSno:(NSString *)name type:(ScheduleModelRequestType)type {
    if (!name || !type) { return nil; }
    self = [super init];
    if (self) {
        _sno = name.copy;
        _type = ScheduelModelRequestTypeForString(type);
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
    return [NSString stringWithFormat:@"<%@, %p>; [%@, %@] : (exp: %.0lf, iat: %.0lf) (web%d, wgt%d, not%d, cal%d)", NSStringFromClass(self.class), self, self.sno, self.type, self.exp, self.iat, self.useWebView, self.useWidget, self.useNotification, self.useCanlender];
}

#pragma mark - Method

- (NSString *)key {
    return [_type stringByAppendingString:_sno].copy;
}

- (void)setExpWithNowWeek:(NSInteger)nowWeek {
    NSUInteger weekday = [NSCalendar.currentCalendar components:NSCalendarUnitWeekday fromDate:NSDate.date].scheduleWeekday;
    NSTimeInterval beforNow = 0; CGFloat aDay = 24 * 60 * 60;
    if (nowWeek > 0) {
        beforNow = (nowWeek - 1) * 7 * 24 * 60 * 60 + (weekday - 1) * aDay;
    } else if (nowWeek == 0) {
        beforNow = -(fabs(8 - weekday) * 24 * 60 * 60);
    } else {
        beforNow = -((nowWeek + 1) * 7 * 24 * 60 * 60 + fabs(8 - weekday) * aDay);
    }
    beforNow = ((NSInteger)(beforNow / aDay)) * aDay;
    _exp = [NSDate dateWithTimeIntervalSinceNow:-beforNow].timeIntervalSince1970;
}

- (ScheduleIdentifier *)moveFrom:(ScheduleIdentifier *)other {
    if (other == self || !other) { return self; }
    ScheduleIdentifier *fin = self;
    if ([fin.key isEqualToString:other.key]) {
        fin.useWebView |= other.useWebView;
        fin.useWidget |= other.useWidget;
        fin.useNotification |= other.useNotification;
        fin.useCanlender |= other.useCanlender;
    }
    fin.exp = MAX(fin.exp, other.exp);
    fin.iat = MAX(fin.iat, other.iat);
    return fin;
}

#pragma mark - WCDB

- (void)setSno:(NSString *)sno {
    _sno = sno.copy;
}

- (void)setType:(ScheduleModelRequestType)type {
    _type = ScheduelModelRequestTypeForString(type);
}

#pragma mark - <NSSecureCoding>

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)decoder {
    NSString *sno = [decoder decodeObjectOfClass:NSString.class forKey:@"sno"];
    NSString *type = [decoder decodeObjectOfClass:NSString.class forKey:@"type"];
    
    BOOL useWebView = [decoder decodeBoolForKey:@"useWebView"];
    BOOL useWidget = [decoder decodeBoolForKey:@"useWidget"];
    BOOL useNotification = [decoder decodeBoolForKey:@"useNotification"];
    BOOL useCanlender = [decoder decodeBoolForKey:@"useCanlender"];
    
    NSTimeInterval iat = [decoder decodeDoubleForKey:@"iat"];
    NSTimeInterval exp = [decoder decodeDoubleForKey:@"exp"];
    
    self = [self initWithSno:sno type:ScheduelModelRequestTypeForString(type)];
    
    self.useWebView = useWebView;
    self.useWidget = useWidget;
    self.useNotification = useNotification;
    self.useCanlender = useCanlender;
    
    self.iat = iat;
    self.exp = exp;
    
    return self;
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:self.sno forKey:@"sno"];
    [coder encodeObject:self.type forKey:@"type"];
    
    [coder encodeBool:self.useWebView forKey:@"useWebView"];
    [coder encodeBool:self.useWidget forKey:@"useWidget"];
    [coder encodeBool:self.useNotification forKey:@"useNotification"];
    [coder encodeBool:self.useCanlender forKey:@"useCanlender"];
    
    [coder encodeDouble:self.iat forKey:@"iat"];
    [coder encodeDouble:self.exp forKey:@"exp"];
}

#pragma mark - <NSCopying>

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    ScheduleIdentifier *key = [[ScheduleIdentifier alloc] initWithSno:self.sno type:self.type];
    key.useWebView = self.useWebView;
    key.useWidget = self.useWidget;
    key.useNotification = self.useNotification;
    key.useCanlender = self.useCanlender;
    return key;
}

@end

NSArray <ScheduleIdentifier *> *ScheduleIdentifiersFromScheduleRequestDictionary(ScheduleRequestDictionary *dictionary) {
    NSMutableArray *ary = NSMutableArray.array;
    for (NSString *key in dictionary) {
        for (NSString *sno in dictionary[key]) {
            ScheduleIdentifier *identifier = [ScheduleIdentifier identifierWithSno:sno type:key];
            [ary addObject:identifier];
        }
    }
    return ary;
}



#pragma mark - ScheduleCombineItem

@implementation ScheduleCombineItem

- (instancetype)init {
    return [self initWithIdentifier:nil value:nil];
}

- (instancetype)initWithIdentifier:(ScheduleIdentifier *)name value:(NSArray<ScheduleCourse *> *)value {
    if (name == nil) { return nil; }
    value = value ? value : NSArray.array;
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
    return [NSString stringWithFormat:@"<%@, %p> [%@ : count: %ld]", NSStringFromClass(self.class), self, self.identifier.key, self.value.count];
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
    return self;
}

@end
