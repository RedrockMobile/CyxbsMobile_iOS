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

NS_ASSUME_NONNULL_BEGIN

/**MARK: ScheduleShareCache
 * a `MemoryCache` use \c NSCache
 * up to \c 10
 */

@interface ScheduleShareCache : NSObject

RisingSingleClass_PROPERTY(Cache)

/// set to MemoryCache
/// - Parameter item: final item
- (void)cacheItem:(ScheduleCombineItem *)item;

/// get item From MemoryCache
/// - Parameter key: the key from ScheduleCombineItem
- (nullable ScheduleCombineItem *)getItemForKey:(NSString *)key;

@end

/****local cache**
 * if you have `WCDB`, we use them.
 * if not, we'll use `NSKeyedArchiver`
 */

#ifndef XXHB

@interface ScheduleShareCache (XXHB)

@property BOOL awakeable;

/// refresh local cache
/// use `- cacheItem:` before
/// - Parameter key: the key from ScheduleCombineItem
- (void)replaceForKey:(NSString *)key;

/// get a new ScheduleCombineItem from local cache
/// - Parameter identifier: must have a `identifier`
- (nullable ScheduleCombineItem *)awakeForIdentifier:(ScheduleIdentifier *)identifier;

@end

#endif

NS_ASSUME_NONNULL_END
