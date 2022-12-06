//
//  ScheduleMapModel.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/12/3.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleMapModel.h"

@implementation ScheduleMapModel {
    NSMapTable <NSIndexPath *, NSPointerArray *> *_dayMap;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _mapTable = [NSMapTable
                     mapTableWithKeyOptions:
                         NSPointerFunctionsStrongMemory |
                         NSPointerFunctionsObjectPersonality
                     valueOptions:
                         NSPointerFunctionsStrongMemory |
                         NSPointerFunctionsObjectPersonality];
        
        NSPointerFunctions *dayPointerFunctions =
        [NSPointerFunctions pointerFunctionsWithOptions:
         NSPointerFunctionsStrongMemory |
         NSPointerFunctionsObjectPersonality];
        dayPointerFunctions.hashFunction = schedule_section_week_hash;
        dayPointerFunctions.isEqualFunction = schedule_section_week_equal;
        _dayMap = [[NSMapTable alloc]
                   initWithKeyPointerFunctions:dayPointerFunctions
                   valuePointerFunctions:[NSPointerFunctions pointerFunctionsWithOptions:
                                          NSPointerFunctionsStrongMemory |
                                          NSPointerFunctionsObjectPersonality]
                   capacity:7];
    }
    return self;
}

#pragma mark - Method

- (void)combineModel:(ScheduleCombineModel *)model {
    RisingDetailLog(@"--- %@", model.sno, self.sno);
    for (ScheduleCourse *course in model.courseAry) {
        [course.inSections enumerateIndexesUsingBlock:^(NSUInteger section, BOOL * __unused stop) {
            NSIndexPath *indexPath = ScheduleIndexPath(section, course.inWeek, course.period.location);
            ScheduleCollectionViewModel *viewModel = [self _viewModelWithCourse:course];
            
//            [self _setViewModel:viewModel forIndexPath:indexPath];
            
            RisingDetailLog(@"ScheduleIndexPath(%ld, %ld, %ld) = LK(%ld, %ld)", indexPath.section, indexPath.week, indexPath.location, viewModel.lenth, viewModel.kind);
        }];
    }
    RisingDetailLog(@"%@", NSStringFromMapTable(_dayMap));
    
}

- (void)clear {
    [_mapTable removeAllObjects];
    [_dayMap removeAllObjects];
}

#pragma mark - private

- (ScheduleCollectionViewModel *)_viewModelWithCourse:(ScheduleCourse *)course {
    ScheduleCollectionViewModel *viewModel = [[ScheduleCollectionViewModel alloc] initWithScheduleCourse:course];
    if (!self.sno || [self.sno isEqualToString:@""]) {
        return viewModel;
    }
    if ([course.sno isEqualToString:self.sno]) {
        if (course.requestType == ScheduleModelRequestStudent) {
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
    NSPointerArray *pointerAry = [self _getAryAt:indexPath];
    NSInteger count = indexPath.location + viewModel.lenth - 1;
    if (pointerAry.count < count) {
        pointerAry.count = count;
    }

    for (NSInteger i = indexPath.location; i < indexPath.location + viewModel.lenth; i++) {
    #define replace [pointerAry replacePointerAtIndex:(i - 1) withPointer:(__bridge void *)(indexPath)]; \
        [_mapTable setObject:viewModel forKey:indexPath]
        
        void *pointer = [pointerAry pointerAtIndex:i - 1];
        if (pointer == NULL) {
            // 原来的为空，则直接替换
            replace;
        } else {
            // 获取以前的idx和viewModel
            NSIndexPath *oldIndexPath = (__bridge NSIndexPath *)pointer;
            ScheduleCollectionViewModel *oldViewModel = [_mapTable objectForKey:oldIndexPath];
            
            if (viewModel.kind < oldViewModel.kind) {
                // 如果新的优先级 高于 以前的优先级
                viewModel.hadMuti = YES;
                replace;
            } else if (viewModel.kind == oldViewModel.kind) {
                // 如果新的优先级 平于 以前的优先级
                if ([oldIndexPath compare:indexPath] != NSOrderedAscending) {
                    // 如果idx一样/比以前大，那么直接替换
                    replace;
                } else {
                    // 比以前小就算了
                    oldViewModel.hadMuti = YES;
                }
            } else {
                // 如果新的优先级 低于 以前的优先级
                oldViewModel.hadMuti = YES;
            }
        }
    }
}

- (void)_trunedToMap {
    NSEnumerator <NSPointerArray *> *enumerator = _dayMap.objectEnumerator;
    for (NSPointerArray *pointerAry = enumerator.nextObject; pointerAry; pointerAry = enumerator.nextObject) {
        if (pointerAry.count == 0) {
            continue;
        }
        NSIndexPath *obj = (__bridge NSIndexPath *)[pointerAry pointerAtIndex:0];
        for (NSInteger i = 1; i < pointerAry.count; i++) {
            NSIndexPath *nextObj = (__bridge NSIndexPath *)[pointerAry pointerAtIndex:i];
            if (![nextObj isEqual:obj]) {
                if (obj) {
                    
                }
            }
        }
    }
}

@end
