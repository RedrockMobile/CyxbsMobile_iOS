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
    NSMutableArray <ScheduleIdentifier *> *unInMemIds = NSMutableArray.array;
    for (ScheduleIdentifier *key in keys) {
        if (NSDate.date.timeIntervalSince1970 - key.iat >= self.outRequestTime) {
            [unInMemIds addObject:key];
        } else {
            ScheduleCombineItem *cacheItem = [ScheduleShareCache.shareCache getItemForKey:key.key];
            if (cacheItem) {
                policy(cacheItem);
            } else {
                if (self.awakeable) {
                    ScheduleCombineItem *item = [ScheduleShareCache.shareCache awakeForIdentifier:key];
                    policy(item);
                } else {
                    [unInMemIds addObject:key];
                }
            }
        }
    }
    // if all in MEM, do nont request
    if (unInMemIds.count == 0) {
        return;
    }
    
    ScheduleRequestDictionary *dic = ScheduleRequestDictionaryFromScheduleIdentifiers(unInMemIds);
    [ScheduleNETRequest
     request:dic
     success:^(ScheduleCombineItem * _Nonnull item) {
        [ScheduleShareCache.shareCache cacheItem:item];
        if (policy) {
            policy(item);
        }
        if (self.awakeable) {
            [ScheduleShareCache.shareCache replaceForKey:item.identifier.key];
        }
    }
     failure:^(NSError * _Nonnull error, ScheduleIdentifier *errorID) {
        if (unpolicy) {
            unpolicy(errorID);
        }
    }];
}

@end
