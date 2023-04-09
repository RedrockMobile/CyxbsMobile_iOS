//
//  SchedulePolicyService.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/1/26.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "SchedulePolicyService.h"

#import "ScheduleNETRequest.h"
#import "ScheduleShareCache.h"

@implementation SchedulePolicyService

static SchedulePolicyService * _currentPolicy;
+ (SchedulePolicyService *)current {
    if (_currentPolicy == nil) {
        _currentPolicy = [[SchedulePolicyService alloc] init];
        _currentPolicy.outRequestTime = 45 * 60 * 60;
        _currentPolicy.awakeable = YES;
    }
    return _currentPolicy;
}

+ (void)setCurrent:(SchedulePolicyService *)current {
    _currentPolicy = current;
}

- (void)requestDic:(ScheduleRequestDictionary *)dic
            policy:(void (^)(ScheduleCombineItem *item))policy
          unPolicy:(void (^)(ScheduleIdentifier *unpolicyKEY))unpolicy {
    // if dic is empty or have nothing, return
    if (!dic || dic.count == 0) {
        return;
    }
    NSArray <ScheduleIdentifier *> *ids = ScheduleIdentifiersFromScheduleRequestDictionary(dic);
    [self requestKeys:ids policy:policy unPolicy:unpolicy];
    return;
}

- (void)requestKeys:(NSArray <ScheduleIdentifier *> *)keys
             policy:(void (^)(ScheduleCombineItem *item))policy
           unPolicy:(void (^)(ScheduleIdentifier *unpolicyKEY))unpolicy {
    
    NSMutableArray <ScheduleIdentifier *> *unknowKey = NSMutableArray.array;
    NSMutableDictionary <NSString *, ScheduleCombineItem *> *hadOutTime = NSMutableDictionary.dictionary;
    for (ScheduleIdentifier *key in keys) {
        // 先从磁盘取，取不出来从缓存取
        ScheduleCombineItem *item = [ScheduleShareCache.shareCache getItemForKey:key.key];
        if (!item) {
            item = [ScheduleShareCache.shareCache awakeForIdentifier:key];
        }
        // 有则判时间，无则直接unknow
        if (item) {
            if (item.identifier.type == ScheduleModelRequestCustom) {
                ScheduleNETRequest.current.customItem = item;
            }
            if (item.identifier.iat - NSDate.date.timeIntervalSince1970 >= self.outRequestTime) {
                hadOutTime[item.identifier.key] = item;
                [unknowKey addObject:item.identifier];
            } else {
                if (policy) {
                    policy(item);
                }
                continue;
            }
        } else {
            [unknowKey addObject:key];
        }
    }
    
    // if all in MEM, do nont request
    if (unknowKey.count == 0) {
        return;
    }
    
    ScheduleRequestDictionary *dic = ScheduleRequestDictionaryFromScheduleIdentifiers(unknowKey);
    [ScheduleNETRequest
     request:dic
     success:^(ScheduleCombineItem * _Nonnull item) {
        [ScheduleShareCache.shareCache cacheItem:item];
        if (policy) {
            policy(item);
        }
        if (self.awakeable || item.identifier.type == ScheduleModelRequestCustom) {
            [ScheduleShareCache.shareCache replaceForKey:item.identifier.key];
        }
    }
     failure:^(NSError * _Nonnull error, ScheduleIdentifier *errorID) {
        if (hadOutTime[errorID.key]) {
            if (policy) {
                policy(hadOutTime[errorID.key]);
            }
            return;
        }
        
        if (errorID.type == ScheduleModelRequestCustom) {
            ScheduleCombineItem *nilc = [ScheduleShareCache.shareCache awakeForIdentifier:errorID];
            if (nilc == nil || nilc.value.count == 0) {
                nilc = [ScheduleCombineItem combineItemWithIdentifier:errorID value:NSMutableArray.array];
            }
            if (![nilc.value isKindOfClass:NSMutableArray.class]) {
                nilc = [ScheduleCombineItem combineItemWithIdentifier:errorID value:nilc.value.mutableCopy];
            }
            ScheduleNETRequest.current.customItem = nilc;
            if (policy) {
                policy(nilc);
            }
            return;
        }
        
        if (unpolicy) {
            unpolicy(errorID);
        }
    }];
}

@end
