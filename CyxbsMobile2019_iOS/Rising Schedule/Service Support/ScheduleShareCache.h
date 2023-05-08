//
//  ScheduleShareCache.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/12/22.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScheduleCombineItemSupport.h"
#import "RisingSingleClass.h"
#import "ScheduleType.h"

NS_ASSUME_NONNULL_BEGIN

/**MARK: ScheduleShareCache
 * 根据`ScheduleWidgetCacheKeyName`存取一个`ScheduleIdentifier`
 * 或直接存取`ScheduleWidgetCacheKeyName`，取出时用`唯一标识符`
 */


#pragma mark - ScheduleShareCache

@interface ScheduleShareCache : NSObject

RisingSingleClass_PROPERTY(Cache)

@end



#pragma mark - ScheduleShareCache (Disk)

// 请看Rising的文档 (Disk)
@interface ScheduleShareCache (Disk)

- (void)diskCacheKey:(nonnull ScheduleIdentifier *)key forKeyName:(nullable ScheduleWidgetCacheKeyName)keyName;
- (nullable ScheduleIdentifier *)diskKeyForKey:(nullable ScheduleIdentifier *)key forKeyName:(nullable ScheduleWidgetCacheKeyName)keyName;

- (void)diskCacheItem:(nonnull ScheduleCombineItem *)anObject forKeyName:(nullable ScheduleWidgetCacheKeyName)keyName;
- (nullable ScheduleCombineItem *)diskItemForKey:(nullable ScheduleIdentifier *)key forKeyName:(nullable ScheduleWidgetCacheKeyName)keyName;

@end



#pragma mark - ScheduleShareCache (Memory)

// 请看Rising的文档 (Memory)
@interface ScheduleShareCache (Memory)

- (void)toMemory;

+ (void)memoryCacheKey:(nonnull ScheduleIdentifier *)key forKeyName:(nullable ScheduleWidgetCacheKeyName)keyName;
+ (nullable ScheduleIdentifier *)memoryKeyForKey:(nullable ScheduleIdentifier *)key forKeyName:(nullable ScheduleWidgetCacheKeyName)keyName;

+ (void)memoryCacheItem:(nonnull ScheduleCombineItem *)anObject forKeyName:(nullable ScheduleWidgetCacheKeyName)keyName;
+ (nullable ScheduleCombineItem *)memoryItemForKey:(nullable ScheduleIdentifier *)key forKeyName:(nullable ScheduleWidgetCacheKeyName)keyName;

@end



#pragma mark - NSUserDefaults (schedule)

@interface NSUserDefaults (schedule)

@property (nonatomic, class, readonly) NSUserDefaults *schedule;

@end

FOUNDATION_EXPORT NSURL *fileUrlForSchedule(void);

NS_ASSUME_NONNULL_END
