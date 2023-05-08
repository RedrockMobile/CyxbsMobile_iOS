//
//  ScheduleMapModel.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/12/3.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleMapModel.h"

@implementation ScheduleMapModel {
    NSMapTable <NSIndexPath *, ScheduleCollectionViewModel *> *_mapTable;
    BOOL _finished;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _mapTable = [NSMapTable mapTableWithKeyOptions: NSPointerFunctionsStrongMemory | NSPointerFunctionsObjectPersonality valueOptions: NSPointerFunctionsStrongMemory | NSPointerFunctionsObjectPersonality];
        
        NSPointerFunctions *dayPointerFunctions = [NSPointerFunctions pointerFunctionsWithOptions: NSPointerFunctionsStrongMemory | NSPointerFunctionsObjectPersonality];
        dayPointerFunctions.hashFunction = schedule_section_week_hash;
        dayPointerFunctions.isEqualFunction = schedule_section_week_equal;
        _dayMap = [[NSMapTable alloc]  initWithKeyPointerFunctions:dayPointerFunctions valuePointerFunctions:[NSPointerFunctions pointerFunctionsWithOptions: NSPointerFunctionsStrongMemory | NSPointerFunctionsObjectPersonality]
                   capacity:7];
        _timeline = [[ScheduleTimeline alloc] init];
    }
    return self;
}

#pragma mark - Method

- (void)combineItem:(ScheduleCombineItem *)item {
    _finished = NO;
    for (ScheduleCourse *course in item.value) {
        NSRange layoutRange = [self.timeline layoutRangeWithOriginRange:course.period];
        
        ScheduleCollectionViewModel *viewModel = [self viewModelWithKey:item.identifier forCourse:course];
        [course.inSections enumerateIndexesUsingBlock:^(NSUInteger section, BOOL * __unused stop) {
            NSIndexPath *indexPath = ScheduleIndexPathNew(section, course.inWeek, layoutRange.location);
            
            [self _setViewModel:viewModel forIndexPath:indexPath];
        }];
        
        [self _setViewModel:viewModel forIndexPath:ScheduleIndexPathNew(0, course.inWeek, layoutRange.location)];
    }
}

- (ScheduleCollectionViewModel *)viewModelWithKey:(ScheduleIdentifier *)identifier forCourse:(ScheduleCourse *)course {
    ScheduleCollectionViewModel *viewModel = [[ScheduleCollectionViewModel alloc] initWithScheduleCourse:course];
    if (!self.sno || [self.sno isEqualToString:@""]) {
        return viewModel;
    }
    if ([identifier.sno isEqualToString:self.sno]) {
        if (identifier.type != ScheduleModelRequestCustom) {
            viewModel.kind = ScheduleBelongFistSystem;
            return viewModel;
        } else {
            viewModel.kind = ScheduleBelongFistCustom;
            return viewModel;
        }
    }
    viewModel.kind = ScheduleBelongSecondSystem;
    return viewModel;
}

- (void)clear {
    [_dayMap removeAllObjects];
    _finished = NO;
}

- (NSMapTable<NSIndexPath *,ScheduleCollectionViewModel *> *)mapTable {
    if (_finished == NO) {
        [self finishCombine];
    }
    return _mapTable;
}

- (ScheduleTimeline *)timelineWithSection:(NSUInteger)section {
    return self.timeline;
}

#pragma mark - private

#define _getVM_atAry(i) ((__bridge ScheduleCollectionViewModel *)[pointerAry pointerAtIndex:i])
#define _setVM_atAry(viewModel, i) [pointerAry replacePointerAtIndex:i withPointer:(__bridge void *)(viewModel)]

- (NSPointerArray *)_getAryAt:(NSIndexPath *)idx {
    NSPointerArray *pointerAry = [_dayMap objectForKey:idx];
    if (pointerAry) {
        return pointerAry;
    }
    
    pointerAry = NSPointerArray.strongObjectsPointerArray;
    [_dayMap setObject:pointerAry forKey:idx];
    return pointerAry;
}

- (void)_setViewModel:(ScheduleCollectionViewModel *)viewModel forIndexPath:(NSIndexPath *)indexPath {
    ScheduleCollectionViewModel *newVM = viewModel.copy;
    // 获取到同一天的课程表情况
    NSPointerArray *pointerAry = [self _getAryAt:indexPath];
    NSInteger count = indexPath.location + newVM.lenth;
    if (pointerAry.count < count) {
        pointerAry.count = count;
    }
    
    for (NSInteger i = indexPath.location; i < count; i++) {
        ScheduleCollectionViewModel *oldVM = _getVM_atAry(i);
        if (oldVM) {
            if (!(newVM.kind < oldVM.kind)) {
                if (newVM.kind != oldVM.kind) {
                    oldVM.hadMuti = YES;
                    continue;
                } else {
                    if (newVM.lenth < oldVM.lenth) {
                        oldVM.hadMuti = YES;
                        continue;
                    }
                }
            }
            newVM.hadMuti = YES;
        }
        _setVM_atAry(newVM, i);
    }
}

#pragma mark - I I I

- (void)finishCombine {
    _finished = YES;
    [_mapTable removeAllObjects];
    NSEnumerator <NSIndexPath *> *keyEnumerator = _dayMap.keyEnumerator;
    for (NSIndexPath *dayIdx = keyEnumerator.nextObject; dayIdx; dayIdx = keyEnumerator.nextObject) {
        
        NSPointerArray *pointerAry = [_dayMap objectForKey:dayIdx];
        if (pointerAry.count < 1) {
            continue;
        }
        ScheduleCollectionViewModel *beforeVM = _getVM_atAry(1);
        ScheduleCollectionViewModel *nextVM;
        ScheduleCollectionViewModel *copyVM = beforeVM.copy;
        (!copyVM) ?: (copyVM.lenth = 1);
        NSInteger location = 1;
        
        for (NSInteger idx = 2; idx < pointerAry.count; idx++, beforeVM = nextVM) {
            nextVM = _getVM_atAry(idx);
            if (nextVM != beforeVM) {
                if (copyVM) {
                    [_mapTable setObject:copyVM forKey:ScheduleIndexPathNew(dayIdx.section, dayIdx.week, location)];
                }
                copyVM = nextVM.copy;
                (!copyVM) ?: (copyVM.lenth = 1);
                location = idx;
                continue;
            }
            if (copyVM) {
                copyVM.lenth++;
            }
        }
        if (copyVM) {
            [_mapTable setObject:copyVM forKey:ScheduleIndexPathNew(dayIdx.section, dayIdx.week, location)];
        }
    }
}

@end
