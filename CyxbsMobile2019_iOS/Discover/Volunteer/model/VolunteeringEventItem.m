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
        self.content = dict[@"content"];
        self.start_time = dict[@"start_time"];
        self.title = dict[@"title"];
        self.addWay = dict[@"addWay"];
        self.server_group = dict[@"server_group"];
        self.orgId = dict[@"orgId"];
    }
    return self;
}



@end
