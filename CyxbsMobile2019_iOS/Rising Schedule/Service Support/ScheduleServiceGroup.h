//
//  ScheduleServiceGroup.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/5/2.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "ScheduleServiceSolve.h"
#import "ScheduleType.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScheduleServiceGroup : ScheduleServiceSolve

@property (nonatomic, copy) NSString *groupName;
@property (nonatomic) BOOL useMem;

- (void)setWithFastGroup:(ScheduleRequestDictionary *)request;
- (void)setWithIdentifiers:(NSArray <ScheduleIdentifier *> *)keys;

@end

NS_ASSUME_NONNULL_END
