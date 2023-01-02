//
//  ScheduleModel.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/2.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleModel.h"

#import "ScheduleTimelineSupport.h"

#import "ScheduleTimelineSupport.h"

#pragma mark - ScheduleModel

@implementation ScheduleModel {
    NSMutableDictionary <ScheduleIdentifier *, NSArray<ScheduleCourse *> *> *_statusMap;
    NSMutableArray <NSMutableArray <NSIndexPath *> *> *_courseIdxPaths;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _statusMap = NSMutableDictionary.dictionary;
    }
    return self;
}

#pragma mark - Method

- (void)combineItem:(ScheduleCombineItem *)model {
    if (_statusMap[model.identifier]) {
        return;
    }
    [super combineItem:model];
    _statusMap[model.identifier] = model.value;
    _courseIdxPaths = nil;
    [self setBeginerWithExp:model.identifier.exp];
}

- (void)clear {
    [super clear];
    [_statusMap removeAllObjects];
    _courseIdxPaths = nil;
}

- (ScheduleCourse *)nowCourse {
    NSDate *nowDate = NSDate.date;
    NSDateComponents *components = [NSCalendar.currentCalendar componentsInTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Chongqing"] fromDate:nowDate];
    NSInteger inWeek = (components.weekday + 6) % 8 + (components.weekday + 6) / 8;
    NSInteger inSection = [nowDate timeIntervalSinceDate:self.startDate] / (7 * 24 * 60 * 60);
    NSInteger percent = [ScheduleTimeline.standardTimeLine percentWithDateComponents:components];
    
    ScheduleIdentifier *selfIdentifier = [ScheduleIdentifier identifierWithSno:self.sno type:ScheduleModelRequestStudent];
    for (ScheduleCourse *course in _statusMap[selfIdentifier]) {
        if ([course.inSections containsIndex:inSection] && course.inWeek == inWeek && NSLocationInRange(percent, course.period)) {
            return course;
        }
    }
    
    return nil;
}

- (NSArray<ScheduleCourse *> *)coursesWithLocationIdxPath:(NSIndexPath *)idxPath {
    NSMutableArray *ary = NSMutableArray.array;
    for (NSArray <ScheduleCourse *> *kind in _statusMap.allValues) {
        for (ScheduleCourse *course in kind) {
            if (course.inSections && course.inWeek == idxPath.week && NSLocationInRange(idxPath.location, course.period) ) {
                [ary addObject:course];
            }
        }
    }
    return ary;
}

#pragma mark - Getter

- (NSArray<NSArray<NSIndexPath *> *> *)courseIdxPaths {
    if (_courseIdxPaths == nil) {
        _courseIdxPaths = @[NSMutableArray.array].mutableCopy;
        
        NSEnumerator <NSIndexPath *> *idxEnum = self.mapTable.keyEnumerator;
        for (NSIndexPath *indexPath = idxEnum.nextObject; indexPath; indexPath = idxEnum.nextObject) {
            for (NSInteger i = _courseIdxPaths.count; i <= indexPath.section; i++) {
                [_courseIdxPaths addObject:NSMutableArray.array];
            }
            [_courseIdxPaths[indexPath.section] addObject:indexPath];
        }
    }
    return _courseIdxPaths;
}

#pragma mark - Private

- (void)setBeginerWithExp:(NSTimeInterval)exp {
    _startDate = [NSDate dateWithTimeIntervalSince1970:exp];
    _nowWeek = ceil([NSDate.date timeIntervalSinceDate:_startDate] / (7 * 24 * 60 * 60));
}

@end
