//
//  ScheduleShareCache.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/12/22.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleShareCache.h"
#import "CyxbsWidgetSupport.h"

#import "ScheduleCourse+WCTTableCoding.h"
#import "ScheduleIdentifier+WCTTableCoding.h"

ScheduleWidgetCacheKeyName const ScheduleWidgetCacheKeyMain = @"ScheduleWidgetCacheKeyMain";
ScheduleWidgetCacheKeyName const ScheduleWidgetCacheKeyCustom = @"ScheduleWidgetCacheKeyCustom";
ScheduleWidgetCacheKeyName const ScheduleWidgetCacheKeyOther = @"ScheduleWidgetCacheKeyOther";

#pragma mark - ScheduleShareCache ()

@interface ScheduleShareCache () <NSCacheDelegate>

/**keyItemDic
 * 用于保存cacheKey的所有磁盘信息，以用来快速显示
 */
@property (nonatomic, strong) NSMapTable <ScheduleWidgetCacheKeyName, ScheduleIdentifier *> *keyMapTable;

/**itemCache
 * 用于保存非cacheKey的部分磁盘信息，以用来快速访问
 */
@property (nonatomic, strong) NSCache <ScheduleIdentifier *, ScheduleCombineItem *> *itemCache;
@property (nonatomic, strong) NSMutableSet <ScheduleIdentifier *> *keyCache;

@end

#pragma mark - ScheduleShareCache

@implementation ScheduleShareCache

RisingSingleClass_IMPLEMENTATION(Cache)

- (instancetype)init {
    self = [super init];
    if (self) {
        self.keyMapTable = NSMapTable.strongToStrongObjectsMapTable;
        
        self.itemCache = [[NSCache alloc] init];
        self.itemCache.countLimit = 10;
        self.itemCache.delegate = self;
    }
    return self;
}

#pragma mark - <NSCacheDelegate>

- (void)cache:(NSCache *)cache willEvictObject:(id)obj {
    ScheduleCombineItem *item = (ScheduleCombineItem *)obj;
    ScheduleIdentifier *key = [item.identifier moveFrom:[self.keyCache member:item.identifier]];
    
    // 原先就有这个key
    if ([self.keyCache containsObject:key]) {
        // 如果当前存储的个数超过，则说明这个item要消失了
        if (self.keyCache.count >= self.itemCache.countLimit) {
            [self.keyCache removeObject:key];
            // - 根据key的信息判断其他业务
            if (key.useWebView) {
                // 是否使用缓存
                [self.class memoryCacheItem:item forKeyName:nil];
            }
        } else { // 没有超过的话，则说明重置掉这个item了
            [self.keyCache addObject:key];
        }
    } else {
        // 如果没有了这个key，扔个错
        NSLog(@"为什么没有这个Item: %@", item);
    }
}

@end



#pragma mark - ScheduleShareCache (Disk)

@implementation ScheduleShareCache (Disk)

// Key disk

- (void)diskCacheKey:(ScheduleIdentifier *)key forKeyName:(ScheduleWidgetCacheKeyName)keyName {
    if (keyName) {
        [self.keyMapTable setObject:key forKey:keyName];
    } else {
        [self.keyCache addObject:key];
    }
}

- (nullable ScheduleIdentifier *)diskKeyForKey:(NSString *)key forKeyName:(nullable ScheduleWidgetCacheKeyName)keyName {
    if (keyName) {
        return [self.keyMapTable objectForKey:keyName];
    } else {
        return [self.keyCache member:(ScheduleIdentifier *)key];
    }
}

// Item disk

- (void)diskCacheItem:(nonnull ScheduleCombineItem *)anObject forKeyName:(nullable ScheduleWidgetCacheKeyName)keyName {
    [self diskCacheKey:anObject.identifier forKeyName:keyName];
    [self.itemCache setObject:anObject forKey:anObject.identifier];
}

- (nullable ScheduleCombineItem *)diskItemForKey:(nullable ScheduleIdentifier *)key forKeyName:(nullable ScheduleWidgetCacheKeyName)keyName {
    ScheduleIdentifier *iden = [self diskKeyForKey:key.key forKeyName:keyName];
    ScheduleCombineItem *item = [self.itemCache objectForKey:iden];
    return [ScheduleCombineItem combineItemWithIdentifier:[item.identifier moveFrom:key] value:item.value];
}

@end



#pragma mark - ScheduleShareCache (Memory)

@implementation ScheduleShareCache (Memory)

- (void)toMemory {
    for (ScheduleWidgetCacheKeyName keyName in self.keyMapTable.keyEnumerator.allObjects) {
        ScheduleIdentifier *key = [self.keyMapTable objectForKey:keyName];
        ScheduleCombineItem *item = [self.itemCache objectForKey:key];
        [self.class memoryCacheItem:item forKeyName:keyName];
    }
    for (ScheduleIdentifier *key in self.keyCache.allObjects) {
        ScheduleCombineItem *item = [self.itemCache objectForKey:key];
        [self.class memoryCacheItem:item forKeyName:nil];
    }
}

#ifdef WCDB_h // MARK: WCDB

+ (WCTDatabase *)dataBase {
    static WCTDatabase *db;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [fileUrlForSchedule() URLByAppendingPathComponent:@"schedule_WCDB"].path;
        db = [[WCTDatabase alloc] initWithPath:path];
        if (![db isTableExists:@"Cyxbs_key"]) {
            [db createTableAndIndexesOfName:@"Cyxbs_key" withClass:ScheduleIdentifier.class];
        }
    });
    return db;
}

// Key cache

+ (void)memoryCacheKey:(ScheduleIdentifier *)key forKeyName:(ScheduleWidgetCacheKeyName)keyName {
    if (keyName) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:key requiringSecureCoding:YES error:nil];
        [NSUserDefaults.schedule setObject:data forKey:keyName];
    } else {
        [self.dataBase insertOrReplaceObject:key into:@"Cyxbs_key"];
    }
}

+ (nullable ScheduleIdentifier *)memoryKeyForKey:(NSString *)key forKeyName:(nullable ScheduleWidgetCacheKeyName)keyName {
    if (keyName) {
        NSData *data = [NSUserDefaults.schedule objectForKey:keyName];
        if (!data) { return nil; }
        return [NSKeyedUnarchiver unarchivedObjectOfClass:ScheduleIdentifier.class fromData:data error:nil];
    } else {
        return [self.dataBase getObjectsOfClass:ScheduleIdentifier.class fromTable:@"Cyxbs_key" where:(ScheduleIdentifier.type + ScheduleIdentifier.sno) == key].firstObject;
    }
}

// Item cache

+ (void)memoryCacheItem:(ScheduleCombineItem *)anObject forKeyName:(ScheduleWidgetCacheKeyName)keyName {
    if (keyName) {
        [self memoryCacheKey:anObject.identifier forKeyName:keyName];
    }
    
    NSString *tableName = anObject.identifier.key;
    if (![self.dataBase isTableExists:anObject.identifier.key]) {
        [self.dataBase createVirtualTableOfName:tableName withClass:ScheduleCourse.class];
    }
    [self.dataBase deleteAllObjectsFromTable:tableName];
    [self.dataBase insertObjects:anObject.value into:tableName];
}

+ (nullable ScheduleCombineItem *)memoryItemForKey:(NSString *)key forKeyName:(nullable ScheduleWidgetCacheKeyName)keyName {
    ScheduleIdentifier *iden = [self memoryKeyForKey:key forKeyName:keyName];
    NSArray <ScheduleCourse *> *ary = [self.dataBase getAllObjectsOfClass:ScheduleCourse.class fromTable:iden.key];
    return [ScheduleCombineItem combineItemWithIdentifier:iden value:ary];
}

#else // MARK: Archive

+ (NSString *)fileForName:(NSString *)name {
    NSURL *url = [NSFileManager.defaultManager containerURLForSecurityApplicationGroupIdentifier:CyxbsWidgetAppGroups];
    NSString *base = [url URLByAppendingPathComponent:@"schedule_Archiver/"].path;
    return [base stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.data", name]];
}

// Key cache

+ (void)memoryCacheKey:(nullable ScheduleIdentifier *)key forKeyName:(nullable ScheduleWidgetCacheKeyName)keyName {
    if (keyName) {
        [NSUserDefaults.schedule setObject:key forKey:keyName];
    } else {
        NSMutableSet *set = [NSMutableSet setWithArray:[NSArray arrayWithContentsOfFile:[self fileForName:@"Cyxbs_key"]]];
        [set addObject:key];
        [set.allObjects writeToFile:[self fileForName:@"Cyxbs_key"] atomically:YES];
    }
}

+ (nullable ScheduleIdentifier *)memoryKeyForKey:(NSString *)key forKeyName:(nullable ScheduleWidgetCacheKeyName)keyName {
    if (keyName) {
        return [NSUserDefaults.schedule objectForKey:keyName];
    } else {
        NSArray *ary = [NSArray arrayWithContentsOfFile:[self fileForName:@"Cyxbs_key"]];
        for (ScheduleIdentifier *iden in ary) {
            if ([iden.key isEqualToString:key]) {
                return iden;
            }
        }
        return nil;
    }
}

// Item cache

+ (void)memoryCacheItem:(ScheduleCombineItem *)anObject forKeyName:(ScheduleWidgetCacheKeyName)keyName {
    if (keyName) {
        [self memoryCacheKey:anObject.identifier forKeyName:keyName];
    }
    NSString *tableName = anObject.identifier.key;
    [anObject.value writeToFile:tableName atomically:YES];
}

+ (nullable ScheduleCombineItem *)memoryItemForKey:(NSString *)key forKeyName:(nullable ScheduleWidgetCacheKeyName)keyName {
    ScheduleIdentifier *iden = [self memoryKeyForKey:key forKeyName:keyName];
    NSArray <ScheduleCourse *> *ary = [NSArray arrayWithContentsOfFile:iden.key];
    return [ScheduleCombineItem combineItemWithIdentifier:iden value:ary];
}

#endif

@end



#pragma mark - NSUserDefaults (schedule)

@implementation NSUserDefaults (schedule)

+ (NSUserDefaults *)schedule {
    return [[NSUserDefaults alloc] initWithSuiteName:CyxbsWidgetAppGroups];
}

@end

NSURL *fileUrlForSchedule(void) {
    return [NSFileManager.defaultManager containerURLForSecurityApplicationGroupIdentifier:CyxbsWidgetAppGroups];
}
