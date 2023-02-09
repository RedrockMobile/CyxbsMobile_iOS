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
    for (ScheduleIdentifier *idsItem in keys) {
        if (NSDate.date.timeIntervalSince1970 - idsItem.iat >= self.outRequestTime) {
            [unInMemIds addObject:idsItem];
        } else {
            ScheduleCombineItem *cacheItem = [ScheduleShareCache.shareCache getItemForKey:idsItem.key];
            if (cacheItem) {
                policy(cacheItem);
            } else {
                [unInMemIds addObject:idsItem];
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
    }
     failure:^(NSError * _Nonnull error, ScheduleIdentifier *errorID) {
        if (unpolicy) {
            unpolicy(errorID);
        }
    }];
}

@end
