//
//  QueryModel.m
//  MoblieCQUPT_iOS
//
//  Created by MaggieTang on 07/10/2017.
//  Copyright © 2017 Orange-W. All rights reserved.
//

#import "VolunteeringEventItem.h"

@implementation VolunteeringEventItem

MJExtensionCodingImplementation

- (instancetype)initWithDictinary: (NSDictionary *)dict {
    if (self = [self init]) {
        self.hour = dict[@"hours"];
        self.creatTime = dict[@"start_time"];
        self.eventName = dict[@"title"];
        self.address = dict[@"addWay"];
        self.orgName = dict[@"server_group"];
    }
    return self;
}

@end
