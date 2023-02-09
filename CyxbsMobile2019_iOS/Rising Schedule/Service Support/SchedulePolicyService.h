//
//  SchedulePolicyService.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/1/26.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ScheduleCombineItemSupport.h"

NS_ASSUME_NONNULL_BEGIN

@interface SchedulePolicyService : NSObject

@property (nonatomic) NSTimeInterval outRequestTime;

- (void)requestDic:(ScheduleRequestDictionary *)dic
            policy:(void (^)(ScheduleCombineItem *item))policy
          unPolicy:(void (^)(ScheduleIdentifier *unpolicyKEY))unpolicy;

- (void)requestKeys:(NSArray <ScheduleIdentifier *> *)keys
             policy:(void (^)(ScheduleCombineItem *item))policy
           unPolicy:(void (^)(ScheduleIdentifier *unpolicyKEY))unpolicy;

@end

NS_ASSUME_NONNULL_END
