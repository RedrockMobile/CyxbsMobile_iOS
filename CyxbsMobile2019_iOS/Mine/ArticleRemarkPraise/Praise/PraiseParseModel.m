//
//  PraiseParseModel.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/3/7.
//  Copyright © 2021 Redrock. All rights reserved.
//  解析点赞页的网络请求数据

#import "PraiseParseModel.h"

@implementation PraiseParseModel
- (instancetype)initWithDict:(NSDictionary*)dict {
    if (self = [super init]) {
        self.avatar = dict[@"avatar"];
        self.from = dict[@"from"];
        self.ID = [NSString stringWithFormat:@"%@",dict[@"id"]];
        self.nick_name = dict[@"nick_name"];
        self.time = dict[@"time"];
        self.type = [NSString stringWithFormat:@"%@",dict[@"type"]];
        self.post_id = [NSString stringWithFormat:@"%@",dict[@"post_id"]];
    }
    return self;
}
@end
