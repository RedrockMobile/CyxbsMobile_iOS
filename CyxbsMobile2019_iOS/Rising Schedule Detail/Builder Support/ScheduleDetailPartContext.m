//
//  ScheduleDetailPartContext.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/2/22.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "ScheduleDetailPartContext.h"

@implementation ScheduleDetailPartContext

- (instancetype)init {
    return [self initWithKey:nil course:nil];
}

- (instancetype)initWithKey:(ScheduleIdentifier *)identifier course:(ScheduleCourse *)course {
    if (!identifier || !course) {
        return nil;
    }
    self = [super init];
    if (self) {
        _key = identifier;
        _course = course;
    }
    return self;
}

+ (instancetype)contextWithKey:(ScheduleIdentifier *)identifier course:(ScheduleCourse *)course {
    return [[self alloc] initWithKey:identifier course:course];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@, %p> [%@ : %@]", NSStringFromClass(self.class), self, self.key, self.course];
}

#pragma mark - <NSSecureCoding>

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.key forKey:@"key"];
    [coder encodeObject:self.course forKey:@"course"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    ScheduleIdentifier *key = [coder decodeObjectForKey:@"key"];
    ScheduleCourse *course = [coder decodeObjectForKey:@"course"];
    self = [self initWithKey:key course:course];
    return self;
}

#pragma mark - <NSCopying>

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    return [[ScheduleDetailPartContext alloc] initWithKey:self.key course:self.course];
}

@end
