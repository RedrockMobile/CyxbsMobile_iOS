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

@interface ScheduleShareCache : NSObject

RisingSingleClass_PROPERTY(Cache)

- (void)cacheItem:(ScheduleCombineItem *)item;

- (nullable ScheduleCombineItem *)getItemForKey:(NSString *)key;

@end

#ifndef XXHB

@interface ScheduleShareCache (XXHB)

- (void)replaceForKey:(NSString *)key;

- (nullable ScheduleCombineItem *)awakeForIdentifier:(ScheduleIdentifier *)identifier;

@end

#endif

NS_ASSUME_NONNULL_END
