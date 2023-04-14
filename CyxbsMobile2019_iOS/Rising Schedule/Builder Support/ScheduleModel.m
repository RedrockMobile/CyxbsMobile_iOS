//
//  ScheduleModel.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/2.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleModel.h"

#import "ScheduleTimelineSupport.h"

#import "ScheduleNeedsSupport.h"

#pragma mark - ScheduleModel

@implementation ScheduleModel {
    NSMutableDictionary <ScheduleIdentifier *, NSArray<ScheduleCourse *> *> *_statusMap;
    NSMutableArray <NSMutableArray <NSIndexPath *> *> *_courseIdxPaths;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _statusMap = NSMutableDictionary.dictionary;
        _touchItem = [[ScheduleTouchItem alloc] init];
    }
    return self;
}

#pragma mark - Method

- (void)combineItem:(ScheduleCombineItem *)model {
    if (_statusMap[model.identifier] || model.identifier == nil) {
        return;
    }
    [super combineItem:model];
    _statusMap[model.identifier] = model.value;
    _courseIdxPaths = nil;
    if (self.sno && [model.identifier isEqual:[ScheduleIdentifier identifierWithSno:self.sno type:ScheduleModelRequestStudent]]) {
        self.touchItem.combining = model;
    }
    if (!self.sno && model.identifier.type != ScheduleModelRequestCustom) {
        self.touchItem.combining = model;
    }
}

- (void)clear {
    [super clear];
    [_statusMap removeAllObjects];
    _courseIdxPaths = nil;
    self.touchItem.combining = nil;
}


- (NSArray <ScheduleDetailPartContext *> *)contextsWithLocationIdxPath:(NSIndexPath *)idxPath {
    NSMutableSet *set = NSMutableSet.set;
    for (ScheduleIdentifier *key in _statusMap.allKeys) {
        NSArray <ScheduleCourse *> *kind = [_statusMap objectForKey:key];
        for (ScheduleCourse *course in kind) {
            if (course.inWeek == idxPath.week) {
                ScheduleDetailPartContext *context = [ScheduleDetailPartContext contextWithKey:key course:course];
                for (NSInteger i = 0; i < [self.mapTable objectForKey:idxPath].lenth; i++) {
                    if (NSLocationInRange(idxPath.location + i, course.period)) {
                        if (idxPath.section) {
                            if ([course.inSections containsIndex:idxPath.section]) {
                                [set addObject:context];
                            }
                        } else {
                            [set addObject:context];
                        }
                    }
                }
            }
        }
    }
    return set.allObjects;
}

- (void)changeCustomTo:(ScheduleCombineItem *)item {
    _statusMap[item.identifier] = item.value;
    NSDictionary <ScheduleIdentifier *, NSArray<ScheduleCourse *> *> *dic = _statusMap.copy;
    [self clear];
    [dic enumerateKeysAndObjectsUsingBlock:^(ScheduleIdentifier * _Nonnull key, NSArray<ScheduleCourse *> * _Nonnull obj, BOOL * __unused stop) {
        [self combineItem:[ScheduleCombineItem combineItemWithIdentifier:key value:obj]];
    }];
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

- (NSUInteger)showWeek {
    if (self.touchItem.nowWeek >= self.courseIdxPaths.count || self.touchItem.nowWeek < 0) {
        return 0;
    } else {
        return self.touchItem.nowWeek;
    }
}

@end
