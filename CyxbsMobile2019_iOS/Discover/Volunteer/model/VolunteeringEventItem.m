//
//  QueryModel.m
//  MoblieCQUPT_iOS
//
//  Created by MaggieTang on 07/10/2017.
//  Copyright © 2017 Orange-W. All rights reserved.
//

#import "VolunteeringEventItem.h"

@implementation VolunteeringEventItem

- (instancetype)initWithDictinary: (NSDictionary *)dict {
    if (self = [self init]) {
        self.hour = dict[@"hour_num"];
        self.creatTime = dict[@"create_time"];
        self.eventName = dict[@"opp_name"];
        self.address = dict[@"opp_district"];
        self.orgName = dict[@"org_name"];
    }
    return self;
}

@end
