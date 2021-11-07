//
//  GroupItem.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/12/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "GroupItem.h"

@implementation GroupItem

MJCodingImplementation

- (instancetype)initWithDic:(NSDictionary *)dict {
    if ([super init]) {
        self.topic_id = dict[@"topic_id"];
        self.topic_logo = dict[@"topic_logo"];
        self.topic_name = dict[@"topic_name"];
        self.message_count = dict[@"new_mes_count"];
        self.is_follow = dict[@"is_follow"];
        self.introduction = dict[@"introduction"];
    }
    return self;
}

@end
