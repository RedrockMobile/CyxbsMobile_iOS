//
//  ScheduleDetailPartContext.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/2/22.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "ScheduleDetailPartContext.h"

#import "ScheduleTimelineSupport.h"

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


@implementation ScheduleDetailPartContext (Calender)

- (NSString *)keyTitle {
    return self.key.key.copy;
}

- (NSString *)calenderTitle {
    return [NSString stringWithFormat:@"%@ - %@", self.course.course, self.course.classRoom];
}

- (NSString *)calenderContent {
    return [NSString stringWithFormat:@"%@ - %@ - %@", self.course.courseID, self.course.teacher, self.course.rawWeek];
}

- (NSArray<NSDate *> *)froms {
    NSMutableArray <NSDate *> *dates = NSMutableArray.array;
    NSDate *fromDate = [NSDate dateWithTimeIntervalSince1970:self.key.exp];
    ScheduleTimeline *timeline = [[ScheduleTimeline alloc] init];
    [self.course.inSections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        NSDateComponents *fromComponents = [timeline partTimelineAtPosition:self.course.period.location].fromComponents;
        NSTimeInterval fromOffset = (idx - 1) * 7 * 24 * 60 * 60 +
            (self.course.inWeek - 1) * 24 * 60 * 60 +
            fromComponents.hour * 60 * 60 + fromComponents.minute * 60 + fromComponents.second;
        NSDate *from = [fromDate dateByAddingTimeInterval:fromOffset];
        [dates addObject:from];
    }];
    return dates;
}

- (NSTimeInterval)continues {
    ScheduleTimeline *timeline = [[ScheduleTimeline alloc] init];
    NSDateComponents *fromComponents = [timeline partTimelineAtPosition:self.course.period.location].fromComponents;
    NSDateComponents *toComponents = [timeline partTimelineAtPosition:NSMaxRange(self.course.period) - 1].toComponents;
    NSTimeInterval continues = (toComponents.hour * 60 * 60 + toComponents.minute * 60 + toComponents.second) - (fromComponents.hour * 60 * 60 + fromComponents.minute * 60 + fromComponents.second);
    return continues;
}

@end
