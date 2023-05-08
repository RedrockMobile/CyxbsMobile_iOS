//
//  ScheduleServiceGroup.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/5/2.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "ScheduleServiceGroup.h"

@interface ScheduleServiceGroup ()

@property (nonatomic, strong) NSArray <ScheduleIdentifier *> *groupKeys;

@end

@implementation ScheduleServiceGroup

- (NSArray<ScheduleIdentifier *> *)requestKeys {
    return self.groupKeys;
}

- (void)setWithFastGroup:(ScheduleRequestDictionary *)request {
    if (!request || request.count == 0) { return; }
    NSMutableArray *ary = NSMutableArray.array;
    for (ScheduleModelRequestType type in request) {
        for (NSString *sno in [request objectForKey:type]) {
            ScheduleIdentifier *fastKey = [ScheduleIdentifier identifierWithSno:sno type:type];
            [ary addObject:fastKey];
        }
    }
    self.groupKeys = ary.copy;
}

- (void)setWithIdentifiers:(NSArray<ScheduleIdentifier *> *)keys {
    if (!keys || keys.count == 0) { return; }
    self.groupKeys = keys;
}

@end
